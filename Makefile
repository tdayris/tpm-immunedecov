SHELL := bash
.ONESHELL:
.SHELLFLAGS := -euio pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

### Variables ###
# Tools
PYTEST           = pytest
BASH             = bash
CONDA            = conda
PYTHON           = python3.8
SNAKEMAKE        = snakemake
CONDA_ACTIVATE   = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

# Paths
TEST_DATASET     = test.dataset.tsv
ENV_YAML         = envs/workflow.yaml
QUANTI_SNAKE     = Snakefile_quanTIseq.smk
MCP_SNAKE        = Snakefile_MCPcounter.smk

# Arguments
PYTEST_ARGS      = -vv
ENV_NAME         = tpm-immunedeconv
SNAKE_THREADS    = 1

# Recipes
default: quanTIseq_report.html

# Environment building through conda
conda-tests:
	${CONDA_ACTIVATE} base && \
	${CONDA} env create --file ${ENV_YAML} --force && \
	${CONDA} activate ${ENV_NAME}
.PHONY: conda-tests

quanTIseq_report.html:
	${CONDA_ACTIVATE} ${ENV_NAME} && \
	${SNAKEMAKE} -s ${QUANTI_SNAKE} --use-conda -j ${SNAKE_THREADS} --configfile ${PWD}/config.yaml --forceall --printshellcmds --reason && \
	${SNAKEMAKE} -s ${QUANTI_SNAKE} --use-conda -j ${SNAKE_THREADS} --configfile ${PWD}/config.yaml --forceall --printshellcmds --reason --report quanTIseq_report.html
