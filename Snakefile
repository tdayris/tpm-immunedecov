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
container: "docker://continuumio/miniconda3:5.0.1"

avail_tools = ["EPIC", "MCPcounter", "quanTIseq", "xCell", "TIMER"]
if config["tool"] not in avail_tools:
    raise ValueError(
        f"Uknown tool called {config['tool']}. Available: {str(avail_tools)}"
    )


report: f"reports/general_{config['tool']}.rst"


rule deconvolute:
    input:
        expr_mat = config["expr_mat"]
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
        "envs/mcp-counter.yaml"
    params:
        extra = config.get(
            "extra",
            "method = 'mcp_counter', tumor = TRUE, column = 'gene_symbol'"
        ),
        gene_col = config.get(
            "gene_col",
            "GENE"
        )
    log:
        f"logs/{config['tool']}/deconvolute.log"
    script:
        f"scripts/deconvolute.R"
