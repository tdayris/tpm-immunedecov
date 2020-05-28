#!/usr/bin/R

# Load libraries
base::library(package="dplyr", quietly=TRUE);
base::library(package="tidyr", quietly=TRUE);
base::library(package="tibble", quietly=TRUE);
base::library(package="readr", quietly=TRUE);
base::library(package="ggplot2", quietly=TRUE);
base::library(package="immunedeconv", quietly=TRUE);
base::message("Libraries loaded");

# Load dataset
tpm <- utils::read.table(
  file = snakemake@input[["expr_mat"]],
  header = TRUE,
  sep = "\t",
  stringsAsFactors = FALSE
);

gene_col <- "GENE";
if ("gene_col" %in% base::names(snakemake@params)) {
  gene_col <- base::as.character(x = snakemake@params[["gene_col"]]);
}

extra <- "method = 'mcp_counter', tumor = TRUE, column = 'gene_symbol'";
if ("extra" %in% base::names(snakemake@params)) {
  extra <- base::as.character(x = snakemake@params[["extra"]]);
}

if ("cibersort_binary" %in% base::names(snakemake@input)) {
  immunedeconv::set_cibersort_binary(
    snakemake@input[["cibersort_binary"]]
  );
}

if ("cibersort_mat" %in% base::names(snakemake@input)) {
  immunedeconv::set_cibersort_mat(
    snakemake@input[["cibersort_mat"]]
  );
}

cmd <- base::paste0(
  "immunedeconv::deconvolute(",
  "gene_expression = tpm, ",
  extra,
  ")"
);

rownames(tpm) <- tpm[, gene_col];
tpm[, gene_col] <- NULL;
print(tpm %>% head);
print(cmd)
base::message("Datasets and configuration loaded");

# Deconvolution
res_deconv <- base::eval(
  base::parse(
    text = cmd
  )
);
print(res_deconv %>% head);
base::message("Deconvolution performed");


# Save results
if ("rds" %in% base::names(snakemake@output)) {
  base::saveRDS(
    obj = res_deconv,
    file = snakemake@output[["rds"]]
  );
  base::message("RDS object saved as ", snakemake@output[["rds"]]);
}

if ("tsv" %in% base::names(snakemake@output)) {
  utils::write.table(
    x = res_deconv,
    file = snakemake@output[["tsv"]],
    sep = "\t",
    row.names = FALSE,
    quote = FALSE
  );
  base::message("TSV table saved as ", snakemake@output[["tsv"]]);
}

# Plot graphs
if ("dotplot" %in% base::names(snakemake@output)) {
  png(
    filename = snakemake@output[["histogram"]],
    width = 1024,
    height = 768,
    units = "px",
    type = "cairo"
  );

  print(res_deconv %>%
    gather(sample, fraction, -cell_type) %>%
    ggplot(aes(x=sample, y=fraction, fill=cell_type)) +
      geom_bar(stat='identity') +
      coord_flip() +
      scale_fill_brewer(palette="set1") +
      scale_x_discrete(limits = rev(levels(res_deconv))));

  dev.off();
  base::message("Histogram saved as ", snakemake@output[["histogram"]]);
}


if ("dotplot" %in% base::names(snakemake@output)) {
  png(
    filename = snakemake@output[["dotplot"]],
    width = 1024,
    height = 768,
    units = "px",
    type = "cairo"
  );

  print(res_deconv %>%
    gather(sample, score, -cell_type) %>%
    ggplot(aes(x=sample, y=score)) +
      geom_point(size=4) +
      facet_wrap(~cell_type, scales="free_x", ncol=3) +
      coord_flip() +
      theme_bw() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)));

  dev.off();
  base::message("Dotplots saved as ", snakemake@output[["dotplot"]]);
}
