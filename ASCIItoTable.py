'''
*ASCIItoTable*

This script is a Python translation of the "TableGenerator" module
originally written in Excel's Visual Basic for Applications (VBA) IDE.
The general purpose is to take as input one or more ASCII data results
files generated from a Shimadzu HPLC via LabSolutions software and parse it
into it a tabular, more readable format.

The output is a single, tab-delimited textfile consisting of rows for each
sample including the sample name, sample identifier, and concentration of
each elutant found.

The original code was written, developed, and tested in an Excel 2010
version of VBA on a Windows PC.  It utilized the spreadsheet style of the
program as a means of manipulating the data before producing the final
product in .xlsx format.  Due to regular software updates and the
requirement of manual reference enabling, it was preferred to have the
process written in an OS-independent, compact format such as Python.

Written by Tommy Thompson
'''

### Initializations ###
## Libraries
from os import listdir

## Key Labels
str1 = "Sample Name"
str2 = "Sample ID"
str3 = "ID#"

## Output Heading
header = "SampleName\tSampleID\t"
elutList = []

## Result Containers
sNameList = []
sIDList = []
concDict = {}

## Iterator
sampNum = 0

## I/O Locations
sourcePath = input("Enter the path of the folder containing the files: ")
resultPath = input("Enter the path of where the output will be saved: ")

### Reading the Data ###
## File Loop
# Read each file in folder given at path
for ascFile in listdir(sourcePath):
    path = sourcePath + "\\" + ascFile #append file name to complete path

# Open and read textfile
    with open(path, "r") as rawMat:
## Line Loop
# Read each line one at a time
        for line in rawMat:
# Check for any key labels
            if str1 in line: #if "Sample Name" is found...
                sName = line.split("\t") #...list tab-delimited contents
                sNameList.append(sName[1].rstrip()) #add sample name to container w/o end characters
            elif str2 in line: #if "Sample ID" is found...
                sID = line.split("\t")
                sIDList.append(sID[1].rstrip()) #add sample ID to container w/o end characters
            elif line[0:3] == str3: #if "ID#" is found at beginning of line...
                line = next(rawMat) #...move to next line
## Elutant While
# Continue reading until all elutants read
                while line != "\n":
                    sLine = line.split("\t") #list tab-delimited contents
# Check if new or not
                    if not sLine[1] in elutList: #if elutant has not already been seen before...
                        elutList.append(sLine[1].rstrip()) #...add it to list w/o end characters
                        concDict[sLine[1].rstrip()] = [""]*sampNum #establish new key in dictionary;
                                                                   #fill up previous values with ZLS
# Take the concentration found for this elutant and add it to its key's list of values
                    concDict[sLine[1].rstrip()].append(sLine[5].rstrip())
 
                    line = next(rawMat) #move to next line to continue loop
## Equalize Keys
# Check to see if all current elutants have equal-sized lists of values
                if not all(len(concDict[e]) == sampNum+1 for e in concDict): #size should be #samps + 1
                    for e in concDict: #if not...
                        if len(concDict[e]) != sampNum+1: #...some known elutants weren't found this time
                            concDict[e].append("") #...add ZLS to those that didn't receive a new value

                sampNum += 1

### Writing the Data ###
with open(resultPath, "w") as finProd:
## Heading Loop
    finProd.write(header)

# Write each elutant found to header of textfile
    for elut in elutList:
        if elut != elutList[len(elutList)-1]: #if not last elutant in list...
            finProd.write(elut + "\t") #...append a tab character
        else:
            finProd.write(elut + "\n") #otherwise append a newline character

## Data Loops
# Create a results line for each sample
    for i, samp in enumerate(sNameList):
        resLine = [samp, sIDList[i]] #combine current sample name and sample ID
# Step through each elutant found
        for val in concDict:
            resLine.append(concDict[val][i]) #append concentration value to results line

# Delimit each line's contents by a tab and terminate with a newline
        resLine = "\t".join(resLine) + "\n"
# Write the line to the file
        finProd.write(resLine)
