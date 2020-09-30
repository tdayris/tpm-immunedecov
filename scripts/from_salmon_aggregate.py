#!/usr/bin/python3.8
# -*- coding: utf-8 -*-

"""
This script takes a salmon aggregation file and formats it to fit immunedeconv
requirements. It also builds a config.yaml for each of the following tools:

- EPIC
- quanTIseq
- mcp_counter
"""


import argparse  # Parse command line
import logging  # Traces and loggings
import os  # OS related activities
import pandas
import pytest  # Unit testing
import shlex  # Lexical analysis
import sys  # System related methods
import yaml  # Parse Yaml files

from pathlib import Path  # Paths related methods
from snakemake.utils import makedirs  # Easily build directories
from typing import Dict, Any  # Typing hints


class CustomFormatter(
        argparse.RawDescriptionHelpFormatter,
        argparse.ArgumentDefaultsHelpFormatter
    ):
    """
    This class is used only to allow line breaks in the documentation,
    without breaking the classic argument formatting.
    """


def parser() -> argparse.ArgumentParser:
    """
    Build the argument parser object
    """
    main_parser = argparse.ArgumentParser(
        description=sys.modules[__name__].__doc__,
        formatter_class=CustomFormatter,
        epilog="This script does not make any magic. Please check the prepared"
        " configuration file!",
    )

    main_parser.add_argument(
        "TPM",
        help="Path to the TSV formatted file containing **non-log** TPM",
        type=str
    )

    main_parser.add_argument(
        "--mouse", "-m",
        help="This input dataset contains mouse genes identifiers "
             "that need to be translated to human ones.",
        default=False,
        action='store_true'
    )

    main_parser.add_argument(
        "--output", "-o",
        help="Path to output TSV file (default: %(default)s)",
        default="TPM.tsv",
        type=str
    )

    # Logging options
    log = main_parser.add_mutually_exclusive_group()
    log.add_argument(
        "-d",
        "--debug",
        help="Set logging in debug mode",
        default=False,
        action="store_true",
    )

    log.add_argument(
        "-q",
        "--quiet",
        help="Turn off logging behaviour",
        default=False,
        action="store_true",
    )

    return main_parser


def parse_args(args: Any = sys.argv[1:]) -> argparse.ArgumentParser:
    """
    This function actually parse the command line
    """
    return parser().parse_args(args)


def filter_tpm(tpm_in: Path, tpm_out: Path) -> None:
    """
    Write a filtered TPM file
    """
    logging.debug("Loading TPM counts")
    raw_data = pandas.read_csv(
        tpm_in,
        sep="\t",
        header=0,
        index_col=None
    )
    logging.debug(raw_data.columns)

    columns_to_remove = [
        "target_id",
        "Chromosome",
        "Start",
        "End",
        "Strand",
        "Hugo_ID"
    ]
    raw_cols = set(raw_data.columns)
    columns_to_keep = raw_cols - set(columns_to_remove)
    col_dropped = raw_data[["Hugo_ID"] + list(columns_to_keep)]
    col_dropped = col_dropped.drop_duplicates().copy()
    logging.debug(col_dropped.columns)

    duplicated = col_dropped.duplicated(subset=["Hugo_ID"])
    deduplicated = col_dropped[~duplicated]
    logging.debug(deduplicated.head())

    deduplicated.to_csv(
        tpm_out,
        sep="\t",
        index=False
    )


def write_config(
        tool_name: str,
        tool: str,
        tpm_out: str,
        mouse: bool = False
    ) -> None:
    """
    Write a configuration file
    """
    content = {
        "expr_mat": str(tpm_out),
        "tool": tool_name,
        "extra": f"method = '{tool}', tumor = TRUE, column = 'gene_symbol'",
        "gene_col": "Hugo_ID",
        "mouse": mouse is True
    }

    if tool in ["cibersort_abs", "cibersort"]:
        content["cibersort_binary"] = "/mnt/beegfs/software/cibersort/1.0.6/CIBERSORT.R"
        content["cibersort_mat"] = "/mnt/beegfs/software/cibersort/1.0.6/LM22.txt"

    with Path(f"config.{tool_name}.yaml").open("w") as yamlfile:
        yamlfile.write(yaml.dump(content, default_flow_style=False))


def main(args: argparse.ArgumentParser) -> None:
    """
    Call all operations one after another
    """
    tpm_in = Path(args.TPM)
    tpm_out = Path(args.output)
    if tpm_out.exists():
        logging.warning(f"{str(tpm_out)} already exists.")

    filter_tpm(tpm_in, tpm_out)
    tools = {
        "EPIC": "epic",
        "MCPcounter": "mcp_counter",
        "quanTIseq": "quantiseq",
        "CIBERSORT_ABS": "cibersort_abs",
        "CIBERSORT": "cibersort",
        "xCell": "xcell"
    }
    for k, v in tools.items():
        write_config(k, v, tpm_out, args.mouse)


# Running programm if not imported
if __name__ == "__main__":
    # Parsing command line
    args = parse_args()
    makedirs("logs/prepare")

    # Build logging object and behaviour
    logging.basicConfig(
        filename="logs/prepare/config.log",
        filemode="w",
        level=logging.DEBUG
    )

    try:
        logging.debug("Preparing configuration")
        main(args)
    except Exception as e:
        logging.exception("%s", e)
        raise
    sys.exit(0)
