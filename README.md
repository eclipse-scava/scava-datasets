
# Scava datasets for Eclipse

This repository contains resources used to extract datasets from the Eclipse forge. This work is part of the [Scava project](https://projects.eclipse.org/projects/technology.scava).

Once extracted, data is anonymised using [data-anonymiser](https://github.com/borisbaldassari/data-anonymiser) and published in the downloads section of the project.

## Licencing

The default licence for code in this repository is the [Eclipse Public Licence, v2](https://www.eclipse.org/legal/epl-2.0/).

All datasets are published under the [Creative Commons BY-Attribution-Share Alike 4.0 (International)](https://creativecommons.org/licenses/by-sa/4.0/).

## Extraction process

The `scripts` folder contains the code for the extraction, anonymisation and publishing of the dataset.

## Analysis process

Every dataset, once generated, is fed to a R Markdown document for analysis. This serves both as a test (check if values seem consistent) and as a presentation of the data through plots and tables.

The R Markdown files are located in the `report` folder.

## Prerequisites

Perl:

```
* cpanm Mail::Box::Manager Text::CSV DateTime::Format::Strptime Encoding::FixLatin
```
