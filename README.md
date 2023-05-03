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

### Gaussian vs non-Gaussian uncertainty

After you create the basic data as above, you should decide which users are pseudo-measurements.
For these, you replace the power assigned from the ENWL profiles with samples from a distribution.
This is done in the paper for multiple random scenarios with 1) different users that are described by pseudo-measurements, and 2) different samples from the distributions that are used to create the basis for the power flow (see paper).

You can build the distributions via the `PowerModelsDistributionStateEstimation` (_PMDSE), the `Polynomials` (_Poly) and the `Distributions` (_DST) packages, as follows (see paper for exact parameters).

```julia
beta_dist = _PMDSE.ExtendedBeta(1.6339,20.9022,-0.1, 8.268)
poly_dist = _Poly.Polynomial(-4.630291662343674, 2.650491947483099, - 1.0353277265840206, 0.18351841296933727, 0.011696870297269948)
gauss_dist = _DST.Normal(0.0, 1.0)
```
The paper reports which additional distributions are supported (e.g., GMM...).

### Additional information

For questions about code, data, or paper, do not hesitate to contact me.
You can find my email in the `Project.toml` file.