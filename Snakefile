import sys
import pandas
import os.path

from snakemake.utils import min_version, makedirs
from pathlib import Path
from typing import Any, Dict

if sys.version_info < (3, 8):
    raise SystemError("Please use Python 3.8 or later")

min_version('5.16.0')
git = "https://raw.githubusercontent.com/tdayris/snakemake-wrappers/Unofficial"
container: "truatpasteurdotfr/singularity-docker-miniconda"

avail_tools = ["EPIC", "MCPcounter", "quanTIseq",
               "xCell", "TIMER", "CIBERSORT", "CIBERSORT_ABS"]

if config["tool"] not in avail_tools:
    raise ValueError(
        f"Uknown tool called {config['tool']}. Available: {str(avail_tools)}"
    )


report: f"reports/general_{config['tool']}.rst"


def provide_input(tool: str) -> Dict[str, str]:
    content = {}

    if config["mouse"] is True:
        content["expr_mat"] = "hsa_translated_expression_matrix.tsv"
    else:
        content["expr_mat"] = config["expr_mat"]

    if tool in ["CIBERSORT", "CIBERSORT_ABS"]:
        content["cibersort_binary"] = config["cibersort_binary"]
        content["cibersort_mat"] = config["cibersort_mat"]

    return content


rule convert_mouse_to_human:
    input:
        mouse = config["expr_mat"]
    output:
        temp("hsa_translated_expression_matrix.tsv")
    message:
        "Translating mouse genes identifiers"
    params:
        mgi_id = config.get(
            "gene_col",
            "GENE"
        )
    threads:
        1
    resources:
        mem_mb = 1024 * 5,
        time_min = 30
    wrapper:
        f"{git}/bio/biomaRt/mouse_to_human"


rule deconvolute:
    input:
        **provide_input(config["tool"])
    output:
        rds = report(
            f"{config['tool']}/fractions.rds",
            category = "Results",
            caption = "reports/rds.rst"
        ),
        tsv = report(
            f"{config['tool']}/fractions.tsv",
            category = "Results",
            caption = "reports/tsv.rst"
        ),
        histogram = report(
            f"{config['tool']}/fractions.histogram.png",
            category = "Graphs",
            caption = "reports/histogram.rst"
        ),
        dotplot = report(
            f"{config['tool']}/fractions.dotplot.png",
            category = "Graphs",
            caption = "reports/dotplot.rst"
        )
    message:
        f"Performing deconvolution with {config['tool']}"
    threads:
        1
    resources:
        mem_mb = (
            lambda wildcards, attempt: min(attempt * 1024, 10240)
        ),
        time_min = (
            lambda wildcards, attempt: min(attempt * 20, 200)
        )
    conda:
        "envs/immunedeconv.yaml"
    params:
        extra = config.get(
            "extra",
            "method = 'mcp_counter', tumor = TRUE, column = 'gene_symbol'"
        ),
        gene_col = (
            "HGNC.symbol"
            if config["mouse"] else
            config.get("gene_col","GENE")
        )
    log:
        f"logs/{config['tool']}/deconvolute.log"
    script:
        f"scripts/deconvolute.R"
