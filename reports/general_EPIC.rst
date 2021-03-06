## Material and Method

`EPIC <https://github.com/GfellerLab/EPIC>`_ was used to perform deconvolution on TPM-normalized quantification, through the package `immunedeconv <https://github.com/icbi-lab/immunedeconv>`_.

quanTIseq allows both between-sample comparisons, and between-cell-type comparisons. Between-sample comparisons allow to make statements such as “In patient A, there are more CD8+ T cells than in patient B”. Between-cell-type comparisons allow to make statements such as “In a certain patient, there are more B cells than T cells”.

The whole pipeline was powered by both `Snakemake <https://snakemake.readthedocs.io>`_ , and `Snakemake Wrappers <https://snakemake-wrappers.readthedocs.io/>`_ .

## Citations:


immunedeconv
  Sturm, G., Finotello, F., Petitprez, F., Zhang, J. D., Baumbach, J., Fridman, W. H., ..., List, M., Aneichyk, T. (2019). Comprehensive evaluation of transcriptome-based cell-type quantification methods for immuno-oncology. Bioinformatics, 35(14), i436-i445. https://doi.org/10.1093/bioinformatics/btz363

  Why immunedeconv? immunedeconv is a R package designed to wrapp multiple deconvolution methods and craft them in a comparable format.


EPIC
  Racle, J., de Jonge, K., Baumgaertner, P., Speiser, D. E., & Gfeller, D. (2017). Simultaneous enumeration of cancer and immune cell types from bulk tumor gene expression data. ELife, 6, e26476. https://doi.org/10.7554/eLife.26476

  Why EPIC? EPIC is a method to estimate the proportion of immune, stromal, endothelial and cancer or other cells from bulk gene expression data.

Snakemake
  Köster, Johannes and Rahmann, Sven. “Snakemake - A scalable bioinformatics workflow engine”. Bioinformatics 2012.

  Why Snakemake? Snakemake is a very popular workflow manager in data science and bioinformatics. It has about three new citations per week within the scopes of biology, medicine and bioinformatics.

  https://snakemake.readthedocs.io/
  https://snakemake-wrappers.readthedocs.io/
