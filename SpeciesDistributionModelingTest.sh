#!/bin/bash

#loading local variables
sDir=$HOME/Documents/Research/Java/Distribution/SpeciesDistributionModeling
rm -f -r $sDir/test/output
mkdir $sDir/test/output

#outputting list of acceptable variables from MESS output (MESS output modified with sed command for this example so there are usable variables)
#sed 's/false$/true/g' $sDir/test/output/TestOutput.MESS.csv | grep "true$" | cut -d\, -f1 | sed 's/:/\,/g' > $sDir/test/output/RasterList.MESS.csv
#code to use in non-example analyses:
#grep "true$" $sDir/test/output/TestOutput.MESS.csv | cut -d\, -f1 | sed 's/:/\,/g' > $sDir/test/output/RasterList.MESS.csv

#running model selection
echo 'Running model selection...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelSelector.ModelSelectorLauncher --sBIOMPath=$sDir/test/TestData.biom --sRasterListPath=$sDir/test/RasterList.csv --sResponseVarsListPath=$sDir/test/ResponseVariables.csv --sOutputPath=$sDir/test/output/TestOutput.ModelSelection.csv
echo ''
echo ''

#projecting maps
echo 'Projecting maps...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelProjector.ModelProjectorLauncher --sOutputDir=$sDir/test/output --sSelectedModelsPath=$sDir/test/output/TestOutput.ModelSelection.csv --sResponseVarsListPath=$sDir/test/ResponseVariables.csv --sBIOMPath=$sDir/test/TestData.biom

#running MESS analysis
cd $sDir
echo ''
echo 'Running MESS analysis...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.MESS.MESSLauncher --sBIOMPath=$sDir/test/TestData.biom --sOutputPath=$sDir/test/output/TestOutput.MESS.nc --sRasterListPath=$sDir/test/RasterList.csv --bOutputTable=true --bOutputMap=true
echo ''
echo ''

echo ''
echo ''
echo '*************************************'
iMESSDiff=`diff test/output/TestOutput.MESS.csv test/output.correct/TestOutput.MESS.csv | wc -l`
iMESSMapDiff=`cmp test/output/TestOutput.MESS.nc test/output.correct/TestOutput.MESS.nc | wc -l`
iMESSRasterList=`diff test/output/RasterList.MESS.csv test/output.correct/RasterList.MESS.csv | wc -l`
iMESS=$(($iMESSDiff+$iMESSMapDiff+$iMESSRasterList))
iSelectionDiff=`diff test/output/TestOutput.ModelSelection.csv test/output.correct/TestOutput.ModelSelection.csv | wc -l`
iSelectionDataDiff=`diff test/output/TestOutput.ModelSelection.data.csv test/output.correct/TestOutput.ModelSelection.data.csv | wc -l`
iSelection=$(($iSelectionDiff+$iSelectionDataDiff))
iRichnessMapDiff=`cmp test/output/Richness[log10].nc test/output.correct/Richness[log10].nc | wc -l`
iOTU1MapDiff=`cmp test/output/otu1[logit].nc test/output.correct/otu1[logit].nc | wc -l`
iOTU2MapDiff=`cmp test/output/otu2[logit].nc test/output.correct/otu2[logit].nc | wc -l`
iProjection=$(($iRichnessMapDiff+$iOTU1MapDiff+$iOTU2MapDiff))

if [ $iMESS == '0' ]
then
	echo 'MESS test passed.'
else
	echo 'ERROR: MESS test failed.'	
fi
if [ $iSelection == '0' ]
then
	echo 'Model selection test passed.'
else
	echo 'ERROR: Model selection test failed.'	
fi
if [ $iProjection == '0' ]
then
	echo 'Model projection test passed.'
else
	echo 'ERROR: Model projection test failed.'	
fi
if [ $iMESS == '0' ] && [ $iSelection == '0' ] && [ $iProjection == '0' ]
then
	echo 'All tests passed.'
else
	echo 'ERROR: One or more tests failed.'
fi
echo '*************************************'

