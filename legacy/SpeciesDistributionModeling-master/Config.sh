#==========================================================================
# User Configurable Settings
#==========================================================================
# Input files and directories. Each project should have a metadata and
# a samples file. See README for expected format. Change these to the location
# of your Metadata and Samples files. For the example dataset, these are stored
# in the Data/Samples directory. 
sPathMetadata="Data/Samples/Tallgrass_Prairie_Soils_Community_Samples_Metadata.csv"
sPathSamples="Data/Samples/Tallgrass_Prairie_Soils_Community_Samples.csv"

# Text dump of shape files for region of interest. See README for
# instructions for generating these files
sRasterMaskPath="Data/Masks/TallgrassPrairie_Above31N.shp.txt"

sRasterDir=Data/Rasters

# List of taxa to analyze
rgsTaxon=(all all p__Acidobacteria c__Thaumarchaeota)

# List of corresponding response variable for each taxon. 
# Options include: 
#	LogitRelAbundance - description
rgsResponseVar=(LogitRelAbundance LogShannonDiversity LogitRelAbundance LogitRelAbundance)


#rgsTaxon=(all all p__Chloroflexi p__Bacteroidetes c__Alphaproteobacteria p__Acidobacteria p__Actinobacteria c__Betaproteobacteria c__Deltaproteobacteria c__Gammaproteobacteria c__Thaumarchaeota p__Cyanobacteria p__Firmicutes p__Gemmatimonadetes p__Nitrospirae p__Planctomycetes p__Verrucomicrobia)

#rgsResponseVar=(LogRichness LogShannonDiversity LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance LogitRelAbundance)


#==========================================================================
# Program settings ==> DON'T CHANGE THESE <==
#==========================================================================
rgsFilters=null
iTotalReads=940
iMaximumCovariates=3
dMESSCutoff='0.5'
sPredictors='frsMomeanCRU,tmpMomeanCRU,preMomeanCRU,wetMomeanCRU'
sPredictorValues='vert:0,time:2011-6-15 vert:0,time:2011-7-15 vert:0,time:2011-8-15 vert:0,time:2011-9-15'

