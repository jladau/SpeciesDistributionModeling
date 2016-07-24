# SpeciesDistributionModeling
Software for mapping the geographic distributions of microbial taxa, genes, and traits using ecological niche modeling.

This software uses ecological niche modeling (Fierer and Ladau, 2012, Nature Methods, 9:549-551) to map the geographic distributions of microbial taxa, genes, and traits. Starting with a taxon, gene, or trait table in HDF5 BIOM format (http://biom-format.org), metadata on the locations and dates where samples were collected, and rasters of environmental data (e.g., maps of temperature), the software infers the niche of each taxon, gene, or trait, and then projects that niche into geographic space to make a distribution map. The analysis implemented here has three main components:

(i) Model selection: it can be difficult to know a priori which environmental variables, if any, are predictive of the distribution of an unstudied taxon or trait. From a set of candidate environmental predictors, this module performs model selection to identify the useful predictors. All subsets model selection is performed, and models are vetted based on leave-one-out cross validation. This module effectively provides an estimate of the realized niche of taxon or trait.

(ii) MESS analysis: when projecting a niche inferred from a set of samples into geographic space, it is important that the the conditions across the set of samples cover the range of environmental conditions over which the projection is being made; if not, the projection will be based largely on extrapolation rather than interpolation. MESS analysis (Elith et al, 2010, Methods in Ecology and Evolution, 1:330-342) is a way to quantitatively measure how much interpolation versus extrapolation is necessary. Only environmental variables requiring minimal extrapolation should be used for projecting maps.

(iii) Model projection: once suitable models have been found, the models are projected into geographic space using rasters of the environmental predictors. The maps are output in NetCDF format, viewable using software tools such as Panoply (http://www.giss.nasa.gov/tools/panoply).

The shell script 'SpeciesDistributionModelingTest.sh' runs an example data set and check for errors with the installation. Addition documentation on the software is available in the file 'doc/index.html'. All source code is located the 'SpeciesDistributionModeling' and 'Shared' directories at https://github.com/jladau/JavaSource.

##Dependencies
This software requires Java Runtime Environment (JRE) version 1.6 or greater. On many Apple systems, even if JRE 1.6 or greater is installed, the default version for running applications may be 1.5. The Java version can be checked by typing 'java -version' into a terminal. If an updated version is installed but is not being used, a few updates will need to be made; namely you might try typing the following commands in a terminal:

<pre><code>
sudo rm /usr/bin/java
sudo ln -s /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin/java /usr/bin
</code></pre>

Additional information on correcting the Java version can be found here: http://stackoverflow.com/questions/12757558/installed-java-7-on-mac-os-x-but-terminal-is-still-using-version-6.
