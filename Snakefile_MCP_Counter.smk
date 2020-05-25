import sys
import pandas
import os.path

from snakemake.utils import min_version, makedirs
from pathlib import Path
from typing import Any, Dict

if sys.version_info < (3, 8):
    raise SystemError("Please use Python 3.8 or later")

min_version('5.16.0')
wrapper_version = '0.51.0'
git = "https://raw.githubusercontent.com/tdayris/snakemake-wrappers/Unofficial"
container: "docker://continuumio/miniconda3:5.0.1"
configfile: "config.yaml"

rule all:
    input:
        multiext("MCPcounter/fractions", ".rds", ".tsv", ".histogram.png", ".dotplot.png")
    message:
        "Finishing pipeline"

rule deconvolute:
    input:
        expr_mat = config["expr_mat"]
    output:
        rds = "MCPcounter/fractions.rds",
        tsv = "MCPcounter/fractions.tsv",
        histogram = "MCPcounter/fractions.histogram.png",
        dotplot = "MCPcounter/fractions.dotplot.png",
    message:
        "Performing deconvolution with MCP-Counter"
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
    log:
        "logs/MCPcounter/deconvolute.log"
    script:
        "scripts/mcp_counter.deconvolute.R"
