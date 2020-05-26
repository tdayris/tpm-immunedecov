## Material and Method

`xCell <https://xcell.ucsf.edu/>`_ was used to perform deconvolution on TPM-normalized quantification, through the package `immunedeconv <https://github.com/icbi-lab/immunedeconv>`_.

MCPcounter allows between-sample comparisons, but **not** between-cell-type comparisons. Between-sample comparisons allow to make statements such as “In patient A, there are more CD8+ T cells than in patient B”. Between-cell-type comparisons allow to make statements such as “In a certain patient, there are more B cells than T cells”.

The whole pipeline was powered by both `Snakemake <https://snakemake.readthedocs.io>`_ , and `Snakemake Wrappers <https://snakemake-wrappers.readthedocs.io/>`_ .

## Citations:


immunedeconv
  Sturm, G., Finotello, F., Petitprez, F., Zhang, J. D., Baumbach, J., Fridman, W. H., ..., List, M., Aneichyk, T. (2019). Comprehensive evaluation of transcriptome-based cell-type quantification methods for immuno-oncology. Bioinformatics, 35(14), i436-i445. https://doi.org/10.1093/bioinformatics/btz363

  Why immunedeconv? immunedeconv is a R package designed to wrapp multiple deconvolution methods and craft them in a comparable format.


xCell
  Aran, D., Hu, Z., & Butte, A. J. (2017). xCell: digitally portraying the tissue cellular heterogeneity landscape. Genome Biology, 18(1), 220. https://doi.org/10.1186/s13059-017-1349-1

  Why xCell? xCell is a gene signature-based method, and use it to infer 64 immune and stromal cell types. It has been cited more than 280 times.

Snakemake
  Köster, Johannes and Rahmann, Sven. “Snakemake - A scalable bioinformatics workflow engine”. Bioinformatics 2012.

  Why Snakemake? Snakemake is a very popular workflow manager in data science and bioinformatics. It has about three new citations per week within the scopes of biology, medicine and bioinformatics.

  https://snakemake.readthedocs.io/
  https://snakemake-wrappers.readthedocs.io/
