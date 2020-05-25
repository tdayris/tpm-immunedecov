## Material and Method

`quanTIseq <http://icbi.at/software/quantiseq/doc/index.html>`_ was used to perform deconvolution on TPM-normalized quantification, through the package `immunedeconv <https://github.com/icbi-lab/immunedeconv>`_.

quanTIseq allows both between-sample comparisons, and between-cell-type comparisons.

This whole pipeline was powered by Snakemake.

## Citations:


immunedeconv
  Sturm, G., Finotello, F., Petitprez, F., Zhang, J. D., Baumbach, J., Fridman, W. H., ..., List, M., Aneichyk, T. (2019). Comprehensive evaluation of transcriptome-based cell-type quantification methods for immuno-oncology. Bioinformatics, 35(14), i436-i445. https://doi.org/10.1093/bioinformatics/btz363

  Why immunedeconv? immunedeconv is a R package designed to wrapp multiple deconvolution methods and craft them in a comparable format.


quanTIseq
  Finotello, F., Mayer, C., Plattner, C., Laschober, G., Rieder, D., Hackl, H., ..., Sopper, S. (2019). Molecular and pharmacological modulators of the tumor immune contexture revealed by deconvolution of RNA-seq data. Genome medicine, 11(1), 34. https://doi.org/10.1186/s13073-019-0638-6

  Why quanTIseq? quanTIseq is a pipeline for the quantification of the Tumor Immune contexture designed for human RNA-seq data.

Snakemake
  Köster, Johannes and Rahmann, Sven. “Snakemake - A scalable bioinformatics workflow engine”. Bioinformatics 2012.

  Why Snakemake? Snakemake is a very popular workflow manager in data science and bioinformatics. It has about three new citations per week within the scopes of biology, medicine and bioinformatics.

  https://snakemake.readthedocs.io/
  https://snakemake-wrappers.readthedocs.io/
