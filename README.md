
# Scava datasets for Eclipse

This repository contains resources used to extract datasets from the Eclipse forge. This work is part of the [Scava project](https://projects.eclipse.org/projects/technology.scava).

Once extracted, data is anonymised using [data-anonymiser](https://github.com/borisbaldassari/data-anonymiser) and published in the downloads section of the project.


## Extraction process

The `scripts` folder contains the code for the extraction, anonymisation and publishing of the dataset.


## Analysis process

Every dataset, once generated, is fed to a R Markdown document for analysis. This serves both as a test (check if values seem consistent) and as a presentation of the data through plots and tables. 

The R Markdown files are located in the `report` folder.
