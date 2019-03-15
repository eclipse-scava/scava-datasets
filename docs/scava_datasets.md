
# Eclipse Scava Datasets

This web site hosts the open datasets generated in the course of the Crossminer research project. It includes various pieces of data retrieved from the Eclipse forge in CSV and JSON formats, and each dataset has a R Markdown document describing its content and providing hints about how to use it. Examples provided mainly use the [R statistical analysis software](https://r-project.org).

All data is anonymised, please see the [dedicated document](docs/datasets_privacy.html) to learn more about privacy and the anonymisation mecanism.


## Eclipse projects

We generate full extracts of a [set of Eclipse projects](datasets/projects/eclipse_projects.html), including data sources like SCM (git), Issues tracking (Bugzilla), PMI checks and more.

These datasets are updated weekly, at 2am on Sunday.


## AERI Stacktraces

The [AERI stacktraces dataset](datasets/aeri_stacktraces/aeri_stacktraces.html) is a list of exceptions encountered by users in the Eclipse IDE, as retrieved by the AERI system. The Automated Error Reporting (AERI) system has been developed by the people at [Code Trails](https://www.codetrails.com/) and retrieves information about exceptions. It is installed by default in the Eclipse IDE and has helped hundreds of projects better support their users and resolve bugs. This dataset is a dump of all records over a couple of years, with useful information about the exceptions and environment.

Last update of the dataset occured on 2018-02-11.

**Downloads**

* **Problems full** [ [Download JSON](datasets/aeri_stacktraces/problems_full.tar.bz2) ] -- A list of all problems, exported as JSON (one problem per file).
    * Content: 125250 entries, 22 attributes
    * Size: 38M compressed, 904M raw
* **Problems extract** [ [Download CSV](datasets/aeri_stacktraces/problems_extract.csv.bz2) ] -- A list of all problems, exported as CSV (one big file).
    * Content: 125250 entries, 22 attributes
    * Size: 1.5M compressed, 14M raw
* **Incidents full** [ [Download JSON](datasets/aeri_stacktraces/incidents_full.tar.bz2) ] -- A list of all incidents, exported as JSON (one incident per file).
    * Content: 2084363 entries, 22 attributes
    * Size: 820M compressed, 19G raw
* **Incidents extract** [ [Download CSV](datasets/aeri_stacktraces/incidents_extract.csv.bz2) ] -- A list of all incidents, exported as CSV (one big file).
    * Content: 2084045 entries, 20 attributes
    * Size: 141M compressed, 778M raw
* **Incidents Bundles** [ [Download CSV](datasets/aeri_stacktraces/incidents_bundles_extract.csv.bz2) ] -- A list of all bundles found in incidents, exported as CSV. Attributes are bundle_name, bundle_version, and number of occurrences.
    * Content: 29709 entries, 3 attributes
    * Size: 220K compressed, 1.5M raw

**Documentation**

* **Stacktraces Problems analysis document** [ [Download PDF](datasets/aeri_stacktraces/problems_analysis.pdf) | [Download Rmd](datasets/aeri_stacktraces/problems_analysis.rmd) ] -- A R Markdown document to analyse the Stacktraces problem dataset, with description of the actual content and examples of usage.
* **Stacktraces Incidents analysis document** [ [Download PDF](datasets/aeri_stacktraces/incidents_analysis.pdf) | [Download Rmd](datasets/aeri_stacktraces/incidents_analysis.rmd) ](PDF)](datasets/aeri_stacktraces/incidents_analysis.pdf). A R Markdown document to analyse the Stacktraces incidents dataset, with description of the actual content and examples of usage. This is the PDF export.

More information about the AERI system can be found on the [Code Trails website](https://www.codetrails.com/error-analytics/manual/).


## Eclipse mailing lists

The [Eclipse Mailing lists](datasets/eclipse_mls/mbox_analysis.html) dump is an extract of all emails posted on the Eclipse mailing lists.

* Download the [Eclipse mailing lists dataset here](datasets/eclipse_mls/eclipse_mls.gz).
    * Content: 352951 entries, 6 attributes
    * Size: 12M compressed, 63M raw
* Check the [documentation for the dataset](datasets/eclipse_mls/mbox_analysis.html).
* For reproducibility we also provide the [R Markdown document](datasets/eclipse_mls/mbox_analysis.rmd) for the dataset analysis and documentation.

More information can be found on the official [Eclipse page for mailing lists](https://accounts.eclipse.org/mailing-list).
