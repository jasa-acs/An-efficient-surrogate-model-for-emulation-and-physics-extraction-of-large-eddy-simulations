# An efficient surrogate model for emulation and physics extraction of large eddy simulations

Reproducibility materials for [An efficient surrogate model for emulation and physics extraction of large eddy simulations](https://doi.org/10.1080/01621459.2017.1409123) by Simon Mak, Chih-Li Sung, Xingjian Wang, Shiang-Ting Yeh, Yu-Hung Chang, V. Roshan Joseph, Vigor Yang &amp; C. F. Jeff Wu

# Author Contributions Checklist Form

## Data

### Abstract (Mandatory)

The full data consists of flow simulations for the x-, y- and z-velocities, pressure, density and
temperature of a swirl injector system. The overall memory requirement for the full dataset is over
100Gb, which is too large to submit alongside our manuscript. As requested by the AE, we have
included a smaller, intermediate dataset consisting of extracted CPOD coefficients, which can be
used to train the proposed emulator model.

### Availability (Mandatory)

The full simulation data is too large to accompany the manuscript, so we have included an
intermediate dataset with extracted physics coefficients. We are working towards making the full
simulation data available in an online repository.

### Description (Mandatory if data available)

- Permissions: Dataset simulated using internal code
- Licensing information: -----
- Link to data: https://bitbucket.org/chihli/injectoremulation
- Data provenance, including identifier or link to original data if different than above: -----
- File format: .RData
- Metadata (including data dictionary): -----
- Version information: -----

Optional Information (complete as necessary)

## Code

### Abstract (Mandatory)

The submitted manuscript is accompanied by a .zip file containing the intermediate data, a
package source file “InjectorEmulationHelper.tar.gz”, and the code used for generating results.
This code is written in R and C++, with Rcpp providing the interface between the two languages.

### Description (Mandatory)

- How delivered: R package and code
- Licensing information: MIT License
- Link to code/repository: https://bitbucket.org/chihli/injectoremulation
- Version information: master+c72b3fb

### Optional Information (complete as necessary)

- Hardware requirements:
    10 nodes, with 20 cores requested in each node; NFS shared file system; 250 GB of
    storage space; 128 GB of RAM
- Supporting software requirements (e.g., libraries and dependencies, including version
    numbers)
    - Tecplot 360 2016
    - R (>= 3.2.4):
       - Platform: x86_64-pc-linux-gnu (64-bit)
       - Running under: Red Hat Enterprise Linux Client release 6.7 (Santiago)
       - Packages: parallel, stats, graphics, grDevices, utils, datasets, methods, base,
          InjectorEmulationHelper (>= 0.1.0), doMPI (>= 0.2.2), Rmpi (>= 0.6-5), shape
          (>= 1.4.2), colorRamps (>= 2.3), SLHD (>= 2.1-1), huge (>= 1.2.7), MASS (>=
          7.3-45), igraph (>= 1.0.1), lattice (>= 0.20-33), Matrix (>= 1.2-4), nloptr (>=
          1.0.4), Rarpack (>= 0.10-0), biganalytics (>= 1.1.12), biglm (>= 0.9-1), DBI (>=
          0.3.1), bigmemory (>= 4.5.8), bigmemory.sri (>= 0.1.3), snowfall (>= 1.84-6.1),
          snow (>= 0.4-1), doParallel (>= 1.0.10), iterators (>= 1.0.8), foreach (>= 1.4.3),
          Rcpp (>= 0.12.3), magrittr (>= 1.5), grid (>= 3.2.4), codetools (>= 0.2-14),
          compiler (>= 3.2.4)

## Instructions for Use

### Reproducibility (Mandatory)

- What is to be reproduced (e.g., "All tables and figure from paper", "Tables 1-4”, etc.)
    Figures 6, 7, 11 and 14.
- How to reproduce analyses (e.g., workflow information, makefile, wrapper scripts)
    The above figures can be reproduced by running “example2.R”. The R package
    “InjectorEmulationHelper” needs to be installed from the source package file
    “InjectorEmulationHelper.tar.gz”. The reproduced results for Figures 6, 7 and 11 are
    outputted to the directories “output2/POD_expansion/6”, “output2/validation/comparison”
    and “output2/validation/CIwidth”, while the results for Figure 14 are printed on the console.
    These results are then fed into Tecplot (a post-processing software for visualizing
    engineering simulations) to generate the figures in the paper.

### Replication (Optional)

- How to use software in other settings (or links to such information, e.g., R package
    vignettes, demos or other examples)

- Because the full simulation data is too large to accompany the manuscript, we have
provided a simple example in “example1.R”, which uses a simulated toy dataset to
illustrate the full emulation procedure. The raw data can be changed by following the same
format in the directory “data1/rawdata folder”: first three columns correspond to the x-, y -
and z-coordinates, and other columns are the responses. The experimental design can
also be changed from the file “data1/DoE.csv”. The geometry and raw data for testing
validation cases can also be modified in the file “data1/newX.csv” and the folder
“data1/testdata”, respectively.

## Notes

As requested by the AE, we have included an intermediate dataset (the extracted physics
coefficients) for reproducing numerical results in the paper. We are working towards making the
full simulation data (over 100Gb in storage) publicly available in an online repository.
