# ParsingLabSolutionsASCIIOutput

Generates a table from LabSolutions HPLC ASCII data files

In a blank Excel workbook, copy and paste "TableGenerator" into a new VBA module and save it. Make sure all of your LabSolutions ASCII data results files are saved in one folder. Make sure that no other files exist in the folder. Run the module, follow the prompts, and wait for it to complete. Look over final output table on second sheet to ensure accuracy. Adjust final results as necessary.

*Notes

This script was written, developed, and tested on a PC version of Microsoft Excel 2010. Upon first use of the script, the Developer tab in Excel as well as certain references in the Visual Basic IDE need to be enabled. In Excel 2010, the Developer tab can be enabled by following File->Options->Customize Ribbon. Under "Main Tabs" on the right side, "Developer" should be checked. The Developer tab should now appear in the main ribbon. To enable the references, follow Developer->Visual Basic->Tools->References. The following references were enabled when developing this script: Visual Basic for Applications, Microsoft Excel 14.0 Object Library, OLE Automation, Microsoft Office 14.0 Object Library, Microsoft Scripting Runtime. It is best to be consistent with your naming conventions for the same target elutants. Otherwise, the module will read them as two different targets and create two separate headers in the final table. ex. "NO3" and "Nitrate NO3" are the same but will produce two headers.
