# SpeciesDistributionModeling
Software for mapping the geographic distributions of microbial taxa, genes, and traits using ecological niche modeling.

This software uses ecological niche modeling (Fierer and Ladau, 2012, Nature Methods, 9:549-551) to map the geographic distributions of microbial taxa, genes, and traits. Starting with a taxon, gene, or trait table in HDF5 BIOM format (http://biom-format.org), metadata on the locations and dates where samples were collected, and rasters of environmental data (e.g., maps of temperature), the software infers the niche of each taxon, gene, or trait, and then projects that niche into geographic space to make a distribution map. The analysis implemented here has three main components:

(i) MESS analysis: when projecting a niche inferred from a set of samples into geographic space, it is important that the the conditions across the set of samples cover the range of environmental conditions over which the projection is being made; if not, the projection will be based largely on extrapolation rather than interpolation. MESS analysis (Elith et al, 2010, Methods in Ecology and Evolution, 1:330-342) is a way to quantitatively measure how much interpolation versus extrapolation is necessary. Only environmental variables requiring minimal extrapolation should be used in downstream analyses.

(ii) Model selection: it can be difficult to know a priori which environmental variables, if any, are predictive of the distribution of an unstudied taxon or trait. From a set of candidate environmental predictors indicated by the MESS analysis, this module performs model selection to identify the useful predictors. All subsets model selection is performed, and models are vetted based on leave-one-out cross validation.

(iii) Model projection: once suitable models have been found, the models are projected into geographic space using rasters of the environmental predictors. The maps are output in NetCDF format, viewable using software tools such as Panoply (http://www.giss.nasa.gov/tools/panoply).

The shell script 'SpeciesDistributionModelingTEst.sh' runs an example data set and check for errors with the installation. Addition documentation on the software is available in the file 'doc/index.html'. All source code is located the 'SpeciesDistributionModeling' and 'Shared' directories at https://github.com/jladau/Source.
