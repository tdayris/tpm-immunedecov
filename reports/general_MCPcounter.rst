## Material and Method

`MCPcounter <https://github.com/ebecht/MCPcounter>`_ was used to perform deconvolution on TPM-normalized quantification, through the package `immunedeconv <https://github.com/icbi-lab/immunedeconv>`_.

MCPcounter allows both between-sample comparisons, but not between-cell-type comparisons.

This whole pipeline was powered by Snakemake.

## Citations:


immunedeconv
  Sturm, G., Finotello, F., Petitprez, F., Zhang, J. D., Baumbach, J., Fridman, W. H., ..., List, M., Aneichyk, T. (2019). Comprehensive evaluation of transcriptome-based cell-type quantification methods for immuno-oncology. Bioinformatics, 35(14), i436-i445. https://doi.org/10.1093/bioinformatics/btz363

  Why immunedeconv? immunedeconv is a R package designed to wrapp multiple deconvolution methods and craft them in a comparable format.


MCPcounter
  Becht, E., Giraldo, N. A., Lacroix, L., Buttard, B., Elarouci, N., Petitprez, F., … de Reyniès, A. (2016). Estimating the population abundance of tissue-infiltrating immune and stromal cell populations using gene expression. Genome Biology, 17(1), 218. https://doi.org/10.1186/s13059-016-1070-5

  Why MCPcounter? Microenvironment Cell Populations-counter (MCPcounter) allows quantification of the absolute abundance of eight immune and two stromal cell populations in heterogeneous tissues from transcriptomic data. It has been cited more than 250 times.

Snakemake
  Köster, Johannes and Rahmann, Sven. “Snakemake - A scalable bioinformatics workflow engine”. Bioinformatics 2012.

  Why Snakemake? Snakemake is a very popular workflow manager in data science and bioinformatics. It has about three new citations per week within the scopes of biology, medicine and bioinformatics.

  https://snakemake.readthedocs.io/
  https://snakemake-wrappers.readthedocs.io/
