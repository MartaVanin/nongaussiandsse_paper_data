## Repository containing the data used in: 
```bibtex
@ARTICLE{Vanin2023,
  author={Vanin, Marta and Van Acker, Tom and D'hulst, Reinhilde and Van Hertem, Dirk},
  journal={under review}, 
  title={Exact Modeling of Non-Gaussian Measurements in Distribution System State Estimation}, 
  year={2023},
  volume={},
  number={},
  pages={1-1},
  doi={
https://doi.org/10.48550/arXiv.2303.03029}}
```

## Instructions :

### Look at the data as is.

Both network and active power data are part of the "ENWL" database that has been developed within the framework of of the Low Carbon Network Fund Tier 1 project “LV Network Solutions”. This was run by Electricity North West Limited (ENWL) and The University of Manchester from 2012 to 2014. See the dissemination document from the University of Manchester for more information. 

https://www.researchgate.net/publication/283569482_Dissemination_Document_Low_Voltage_Networks_Models_and_Low_Carbon_Technology_Profiles

The feeder we use is also known as the IEEE Low Voltage Test Feeder, and corresponds to feeder 1 from network 1 of the database.

The feeder data are in .dss files, and can be found in the `PowerModelsDistributionStateEstimation` repository:
https://github.com/Electa-Git/PowerModelsDistributionStateEstimation.jl/tree/master/test/data/enwl/networks/network_1/Feeder_1

The profiles also come from the ENWL work and are available here:
https://github.com/Electa-Git/PowerModelsDistributionStateEstimation.jl/tree/master/test/data/enwl/profiles

We then select a subset of these profiles (one timestep), assign a constant power factor to get reactive power, and then follow the process indicated in the paper to obtain voltage magnitudes and add noise/uncertainty description. See below how to parse the data.

### Parse network data in the format used in the paper

Using the parsing functionalities of `PowerModelsDistribution` (PMD) and `PowerModelsDistributionStateEstimation` we create a `MATHEMATICAL` dictionary (see PMD's documentation). As such, these two are dependencies of this little repository/package. You can obtain it from this package by doing the following:

1) Add this repository as a julia package. It is not registered, so use github's "Code" button and the julia package manager.
2) In the environment where you added the package, do:
```
using nongaussiandsse_paper_data
data = get_EU_LV_feeder_data()
```
Check out the `src/data_parser.jl` file in this repository for line-by-line comments, including a pointer to the network reduction (of the so-called "superfluous" buses) functionalities.
