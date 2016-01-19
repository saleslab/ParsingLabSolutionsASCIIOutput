# ParsingLabSolutionsASCIIOutput

**Generates a table of results from LabSolutions HPLC ASCII data files**

## Installation/Setup  
* Open a blank (new) workbook in Excel.  
* Enable the Developer Tab (File->Options->Customize Ribbon). Under "Main Tabs" on the right side, "Developer" should be checked. The Developer tab should now appear in the main ribbon.  
* Enable the following References: Visual Basic for Applications, Microsoft Excel 14.0 Object Library, OLE Automation, Microsoft Office 14.0 Object Library, Microsoft Scripting Runtime. To enable the references, follow Developer->Visual Basic->Tools->References. 
* Copy and paste "TableGenerator" into a new VBA module.   
* If using a version of Excel that only opens with one worksheet tab (Excel 2013 and later), add a second blank worksheet. The parsing script requires at least two worksheets to function correctly.  
* Save the spreadsheet.  

## Running the Script  
* Save the LabSolutions ASCII data files you wish to parse into the same directory.
* No other files should exist in this directory (including the TableGenerator spreadsheet).
* Run the module and follow the prompts. 
* Reveiw the final output table on the second sheet of the workbook. 

## Notes
* This script was written, developed, and tested on a PC version of Microsoft Excel 2010. Upon first use of the script, the Developer tab in Excel as well as certain references in the Visual Basic IDE need to be enabled. 
* It is best to be consistent with your naming conventions for the same target elutants, otherwise, the module will read them as two different targets and create two separate headers in the final table. For example, "NO3" and "Nitrate NO3" may denote the same compound but will produce two headers.
