#!/bin/bash

# Usage: ./SDM.sh <project_name> > Output/<projectname>/logfile

source Config.sh

#creating output directory
sOutDir=Output/$1
if [ -e $sOutDir ] 
then 	echo "Output directory $sOutDir exists. Choose another project name and re-run." 
	exit
else
	mkdir $sOutDir
fi

sAnalysisMode=alpha-diversity

#looping through taxa
for i in $(seq 1 ${#rgsTaxon[@]})
do
        sTaxon=${rgsTaxon[i-1]/__/}
	sResponseVar=${rgsResponseVar[i-1]}
	#making output directory for taxon.responsevar
	mkdir $sOutDir/$sTaxon.$sResponseVar
	#set data & log files
	sDataPath=$sOutDir/$sTaxon.$sResponseVar/$sTaxon.$sResponseVar'.alpha.data'
	sLogPath=$sOutDir/$sTaxon.$sResponseVar/$sTaxon.$sResponseVar'.alpha.log'

	#compiling data file	
	echo "==>compiling data file"
	
	java -Xmx7g -cp SpeciesDistributionModeling.jar \
		edu.ucsf.CompileObservations.Main \
		--sAnalysisMode=$sAnalysisMode \
		--sTaxonInclude=${rgsTaxon[i-1]} \
		--sPathMetadata=$sPathMetadata \
		--sPathSamples=$sPathSamples \
		--sRasterDir=$sRasterDir \
		--rgsFilters=$rgsFilters \
		--iRarefactionIterations=1 \
		--iTotalReads=$iTotalReads \
		--sOutputPath=$sDataPath \
		--iLagMonths=0 \
		--timConditions=null \
		--sLogPath=$sLogPath
	
	#compiling mess file
	echo "==>compiling mess file"
	java -Xmx7g -cp SpeciesDistributionModeling.jar \
		edu.ucsf.AnalyzeSampleCoverage.Main \
		--sAnalysisMode=$sAnalysisMode \
		--sRasterDir=$sRasterDir \
		--sRasterMaskPath=$sRasterMaskPath \
		--sLocation=both \
		--bMESSPlots=false \
		--sPredictorValues=$sPredictorValues \
		--sDataPath=$sDataPath \
		--sLogPath=$sLogPath \
		--sPredictors=$sPredictors

#===================================================

	for i in {1..5}	 
	do 
	    echo "==>selecting model"
	    java -Xmx4g -cp SpeciesDistributionModeling.jar \
		edu.ucsf.SelectModel.Main \
		--sAnalysisMode=$sAnalysisMode \
		--iTotalTasks=5 \
		--iTaskID=$i \
		--sDataPath=$sDataPath \
		--sResponseVariable=$sResponseVar \
		--iMaximumCovariates=$iMaximumCovariates \
		--dMESSCutoff=$dMESSCutoff \
		--sLogPath=$sLogPath
	done
#===================================================

	#merging select model output
	echo "==>merging select model output"
	java -cp SpeciesDistributionModeling.jar \
		edu.ucsf.MergeSelectModelOutput.Main \
		--iTotalTasks=5 \
		--sDataPath=$sDataPath \
		--sLogPath=$sLogPath
	
	#cleaning up
	echo "==>cleaning up"
	rm `dirname $sDataPath`/*modl_*.complete
	
	#waiting for model selection completion
	echo "==>waiting for model selection completion"
	java -Xmx2g -cp Utilities.jar \
		edu.ucsf.WaitForProcessCompletion.Main \
		--sFilePath=${sDataPath/.data/.modl} \
		--iTotalFiles=-9999
	
	#deleteing model selection completion file
	echo "==>deleteing model selection completion file"
	rm ${sDataPath/.data/.modl.complete}
	
	#drawing map
	echo "==>drawing map"
	java -Xmx4g -cp SpeciesDistributionModeling.jar \
		edu.ucsf.DrawMap.Main \
		--sAnalysisMode=$sAnalysisMode \
		--sRasterDir=$sRasterDir \
		--sResponseTransform=identity \
		--sPredictorValues=$sPredictorValues \
		--iTaskID=-9999 \
		--iTotalTasks=-9999 \
		--bPrintCrossValidation=true \
		--sDataPath=$sDataPath \
		--sRasterMaskPath=$sRasterMaskPath
	
done
