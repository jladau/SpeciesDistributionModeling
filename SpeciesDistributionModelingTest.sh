#!/bin/bash

#loading local variables
#TODO: the sDir variable needs to be set to the directory containing this script.
sDir=$HOME/Documents/Research/Java/Distribution/SpeciesDistributionModeling
rm -f -r $sDir/test/output
mkdir $sDir/test/output
cd $sDir

#updating paths in raster list
sed "s|sDir|$sDir|g" $sDir/test/RasterList_0.csv > $sDir/test/RasterList.csv

#outputting list of acceptable variables from MESS output (MESS output modified with sed command for this example so there are usable variables)
#sed 's/false$/true/g' $sDir/test/output/TestOutput.MESS.csv | grep "true$" | cut -d\, -f1 | sed 's/:/\,/g' > $sDir/test/output/RasterList.MESS.csv
#code to use in non-example analyses:
#grep "true$" $sDir/test/output/TestOutput.MESS.csv | cut -d\, -f1 | sed 's/:/\,/g' > $sDir/test/output/RasterList.MESS.csv

#running model selection
echo '------------------------------------------------------'
echo 'Running model selection...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelSelector.ModelSelectorLauncher --sBIOMPath=$sDir/test/TestData.biom --sRasterListPath=$sDir/test/RasterList.csv --sResponseVarsListPath=$sDir/test/ResponseVariables.csv --sOutputPath=$sDir/test/output/TestOutput.ModelSelection.csv --bPrintData=true
#echo '------------------------------------------------------'
echo ''

#projecting maps
echo '------------------------------------------------------'
echo ''
echo 'Projecting maps...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelProjector.ModelProjectorLauncher --sOutputPath=$sDir/test/output/otu1[logit].nc --sSelectedModelsPath=$sDir/test/output/TestOutput.ModelSelection.csv --sBIOMPath=$sDir/test/TestData.biom --iInputLine=1
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelProjector.ModelProjectorLauncher --sOutputPath=$sDir/test/output/otu2[logit].nc --sSelectedModelsPath=$sDir/test/output/TestOutput.ModelSelection.csv --sBIOMPath=$sDir/test/TestData.biom --iInputLine=2
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.ModelProjector.ModelProjectorLauncher --sOutputPath=$sDir/test/output/Richness[log10].nc --sSelectedModelsPath=$sDir/test/output/TestOutput.ModelSelection.csv --sBIOMPath=$sDir/test/TestData.biom --iInputLine=3
#echo '------------------------------------------------------'
echo ''

#running MESS analysis
echo '------------------------------------------------------'
echo ''
echo 'Running MESS analysis...'
echo ''
java -cp bin/SpeciesDistributionModeling.jar edu.ucsf.MESS.MESSLauncher --sOutputPath=$sDir/test/output/TestOutput.MESS.nc --sSelectedModelsPath=$sDir/test/output/TestOutput.ModelSelection.csv --sBIOMPath=$sDir/test/TestData.biom --bOutputTable=true --bOutputMap=true --iInputLine=1
#echo '------------------------------------------------------'
echo ''

#converting output files to linux format
#sed -i "s|\r|\n|g" $sDir/test/output/*.csv

echo '******************************************************'
echo 'Validating output...'
echo ''

#checking if output files exist
iMissingFiles=0
if [ -f $sDir/'test/output/TestOutput.MESS.csv' ]
then
	echo 'MESS output found'
else
 	iMissingFiles=1
	echo 'ERROR: MESS output missing'
fi

if [ -f $sDir'/test/output/TestOutput.ModelSelection.csv' ]
then
	echo 'Model selection output found'
else
 	iMissingFiles=1
	echo 'ERROR: Model selection output missing'
fi

if [ -f $sDir'/test/output/otu1[logit].nc' ]
then
	echo 'OTU map 1 found'
else
 	iMissingFiles=1
	echo 'ERROR: OTU map 1 missing'
fi

if [ -f $sDir'/test/output/otu2[logit].nc' ]
then
	echo 'OTU map 2 found'
else
 	iMissingFiles=1
	echo 'ERROR: OTU map 2 missing'
fi

if [ -f $sDir'/test/output/Richness[log10].nc' ]
then
	echo 'Richness map found'
else
 	iMissingFiles=1
	echo 'ERROR: Richness map missing'
fi


if [ $iMissingFiles == '0' ]
then
	echo 'All output files found.'
else
	echo 'ERROR: One or more output files missing.'
	echo '******************************************************'
	exit
fi

echo ''

#TODO need to cut each column in the following, consider just the first seven or so characters, and compare these using diff.

#formatting output files for comparisons: truncating columns to avoid round-off issues
rm -f test/output/*temp.csv
rm -f test/output.correct/*temp.csv

#MESS
for i in {1..5}
do
	sed "s|$sDir|CurDir|g" test/output/TestOutput.MESS.csv  | cut -d\, -f$i | cut -c1-8 >> test/output/TestOutput.MESS.0temp.csv
	sed "s|$sDir|CurDir|g" test/output.correct/TestOutput.MESS.csv | cut -d\, -f$i | cut -c1-8 >> test/output.correct/TestOutput.MESS.0temp.csv
done
sort test/output/TestOutput.MESS.0temp.csv > test/output/TestOutput.MESS.temp.csv
sort test/output.correct/TestOutput.MESS.0temp.csv > test/output.correct/TestOutput.MESS.temp.csv

#model selection output
rm -f test/output/TestOutput.ModelSelection.temp.csv
rm -f test/output.correct/TestOutput.ModelSelection.temp.csv
for i in {1..13}
do
	cut -d\, -f$i test/output/TestOutput.ModelSelection.csv | cut -c1-8 >> test/output/TestOutput.ModelSelection.0temp.csv
	cut -d\, -f$i test/output.correct/TestOutput.ModelSelection.csv | cut -c1-8 >> test/output.correct/TestOutput.ModelSelection.0temp.csv
done
sort test/output/TestOutput.ModelSelection.0temp.csv > test/output/TestOutput.ModelSelection.temp.csv
sort test/output.correct/TestOutput.ModelSelection.0temp.csv > test/output.correct/TestOutput.ModelSelection.temp.csv

#data output
rm -f test/output/TestOutput.ModelSelection.data.temp.csv
rm -f test/output.correct/TestOutput.ModelSelection.data.temp.csv
for i in {1..6}
do
	cut -d\, -f$i test/output/TestOutput.ModelSelection.data.csv | cut -c1-8 >> test/output/TestOutput.ModelSelection.data.0temp.csv
	cut -d\, -f$i test/output.correct/TestOutput.ModelSelection.data.csv | cut -c1-8 >> test/output.correct/TestOutput.ModelSelection.data.0temp.csv
done
sort test/output/TestOutput.ModelSelection.data.0temp.csv > test/output/TestOutput.ModelSelection.data.temp.csv
sort test/output.correct/TestOutput.ModelSelection.data.0temp.csv > test/output.correct/TestOutput.ModelSelection.data.temp.csv

#checking for differences between output files
#iMESSDiff=`diff test/output/TestOutput.MESS.temp.csv test/output.correct/TestOutput.MESS.csv | wc -l`
#iMESSMapDiff=`cmp test/output/TestOutput.MESS.nc test/output.correct/TestOutput.MESS.nc | wc -l`
#iMESS=$(($iMESSDiff+$iMESSMapDiff))
#iSelectionDiff=`diff test/output/TestOutput.ModelSelection.temp.csv test/output.correct/TestOutput.ModelSelection.temp.csv | wc -l`
#iSelectionDataDiff=`diff test/output/TestOutput.ModelSelection.data.temp.csv test/output.correct/TestOutput.ModelSelection.data.temp.csv | wc -l`
#iSelection=$(($iSelectionDiff+$iSelectionDataDiff))
#iRichnessMapDiff=`cmp test/output/Richness[log10].nc test/output.correct/Richness[log10].nc | wc -l`
#iOTU1MapDiff=`cmp test/output/otu1[logit].nc test/output.correct/otu1[logit].nc | wc -l`
#iOTU2MapDiff=`cmp test/output/otu2[logit].nc test/output.correct/otu2[logit].nc | wc -l`
#iProjection=$(($iRichnessMapDiff+$iOTU1MapDiff+$iOTU2MapDiff))

iMESS=`diff --suppress-common-lines -y test/output/TestOutput.MESS.temp.csv test/output.correct/TestOutput.MESS.temp.csv | wc -l`
iSelectionDiff=`diff --suppress-common-lines -y test/output/TestOutput.ModelSelection.temp.csv test/output.correct/TestOutput.ModelSelection.temp.csv | wc -l`
iSelectionDataDiff=`diff --suppress-common-lines -y test/output/TestOutput.ModelSelection.data.temp.csv test/output.correct/TestOutput.ModelSelection.data.temp.csv | wc -l`
iSelection=$(($iSelectionDiff+$iSelectionDataDiff))

if [ "$iMESS" -lt "3" ]
then
	echo 'MESS test passed.'
else
	echo 'ERROR: MESS test failed.'	
fi

if [ "$iSelection" -lt "3" ]
then
	echo 'Model selection test passed.'
else
	echo 'ERROR: Model selection test failed.'	
fi

#if [ $iProjection == '0' ]
#then
#	echo 'Model projection test passed.'
#else
#	echo 'ERROR: Model projection test failed.'	
#fi
#if [ $iMESS == '0' ] && [ $iSelection == '0' ] && [ $iProjection == '0' ]
#then
#	echo 'All tests passed.'
#else
#	echo 'ERROR: One or more tests failed.'
#fi

if [ "$iMESS" -lt "3" ] && [ "$iSelection" -lt "3" ]
then
	echo 'All tests passed.'
else
	echo 'ERROR: One or more tests failed.'
fi

rm test/output/*temp.csv
rm test/output.correct/*temp.csv

echo '******************************************************'

