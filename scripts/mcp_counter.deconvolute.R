#!/usr/bin/R

# Load libraries
base::library(package="dplyr", quietly=TRUE);
base::library(package="tidyr", quietly=TRUE);
base::library(package="tibble", quietly=TRUE);
base::library(package="readr", quietly=TRUE);
base::library(package="ggplot2", quietly=TRUE);
base::library(package = "MCPcounter", quietly = TRUE);
base::library(package="immunedeconv", quietly=TRUE);
base::message("Libraries loaded");

# Load dataset
tpm <- utils::read.table(
  file = snakemake@input[["expr_mat"]],
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE
);

rownames(tpm) <- tpm[, "GENE"];
tpm[, "GENE"] <- NULL;
print(tpm %>% head);
base::message("TPM counts loaded");

# Deconvolution
res_mcpcounter <- immunedeconv::deconvolute(
  gene_expression = tpm,
  method = "mcp_counter",
  tumor = TRUE,
  column = "gene_symbol"
);
print(res_mcpcounter);
base::message("Deconvolution performed");


# Save results
base::saveRDS(
  obj = res_mcpcounter,
  file = snakemake@output[["rds"]]
);

utils::write.table(
  x = res_mcpcounter,
  file = snakemake@output[["tsv"]],
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
);
base::message("Results saved")

# Plot Histograms
png(
  filename = snakemake@output[["histogram"]],
  width = 1024,
  height = 768,
  units = "px",
  type = "cairo"
);

res_mcpcounter %>%
  gather(sample, fraction, -cell_type) %>%
  ggplot(aes(x=sample, y=fraction, fill=cell_type)) +
    geom_bar(stat='identity') +
    coord_flip() +
    scale_fill_brewer(palette="Paired") +
    scale_x_discrete(limits = rev(levels(res_mcpcounter)))

dev.off();

# Plot dotplot
png(
  filename = snakemake@output[["dotplot"]],
  width = 1024,
  height = 768,
  units = "px",
  type = "cairo"
);

res_mcpcounter %>%
  gather(sample, score, -cell_type) %>%
  ggplot(aes(x=sample, y=score, color=cell_type)) +
    geom_point(size=4) +
    facet_wrap(~cell_type, scales="free_x", ncol=3) +
    scale_color_brewer(palette="Paired", guide=FALSE) +
    coord_flip() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

dev.off()
base::message("Plots saved");
