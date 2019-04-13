
# Eclipse Scava Datasets

This web site hosts the open datasets generated in the course of the Crossminer research project. It includes various pieces of data retrieved from the Eclipse forge in CSV and JSON formats, and each dataset has a R Markdown document describing its content and providing hints about how to use it. Examples provided mainly use the [R statistical analysis software](https://r-project.org).

All datasets are published under the [Creative Commons BY-Attribution-Share Alike 4.0 (International)](https://creativecommons.org/licenses/by-sa/4.0/).

All data is anonymised, please see the [dedicated document](../docs/datasets_privacy.html) to learn more about privacy and the anonymisation mecanism.


## Eclipse projects

We generate full data extracts of a [set of Eclipse projects](projects/eclipse_projects.html), including data sources like:

* SCM ([git](https://git.eclipse.org)),
* Issues tracking ([Bugzilla](https://bugs.eclipse.org)),
* [PMI](https://projects.eclipse.org) checks,
* Static Code Analysis ([SonarQube](https://sonar.eclipse.org)).

These datasets are updated weekly, at 2am on Sunday.

**Downloads**

* **List of projects** See the [list of projects with their associated datasets and documentation](projects/eclipse_projects.html).


## AERI Stacktraces

The [AERI stacktraces dataset](aeri_stacktraces/aeri_stacktraces.html) is a list of exceptions encountered by users in the Eclipse IDE, as retrieved by the AERI system. The Automated Error Reporting (AERI) system has been developed by the people at [Code Trails](https://www.codetrails.com/) and retrieves information about exceptions. It is installed by default in the Eclipse IDE and has helped hundreds of projects better support their users and resolve bugs. This dataset is a dump of all records over a couple of years, with useful information about the exceptions and environment.

Last update of the dataset occured on 2018-02-11.

**Downloads**

* **Problems full** [ [Download JSON](aeri_stacktraces/problems_full.tar.bz2) ] -- A list of all problems, exported as JSON (one problem per file).
* **Problems extract** [ [Download CSV](aeri_stacktraces/problems_extract.csv.bz2) ] -- A list of all problems, exported as CSV (one big file).
* **Incidents full** [ [Download JSON](aeri_stacktraces/incidents_full.tar.bz2) ] -- A list of all incidents, exported as JSON (one incident per file).
* **Incidents extract** [ [Download CSV](aeri_stacktraces/incidents_extract.csv.bz2) ] -- A list of all incidents, exported as CSV (one big file).
* **Incidents Bundles** [ [Download CSV](aeri_stacktraces/incidents_bundles_extract.csv.bz2) ] -- A list of all bundles found in incidents, exported as CSV. Attributes are bundle_name, bundle_version, and number of occurrences.

**Documentation**

* **Stacktraces Problems analysis document** [ [Download PDF](aeri_stacktraces/problems_analysis.pdf) | [Download Rmd](aeri_stacktraces/problems_analysis.rmd) ] -- A R Markdown document to analyse the Stacktraces problem dataset, with description of the actual content and examples of usage.
* **Stacktraces Incidents analysis document** [ [Download PDF](aeri_stacktraces/incidents_analysis.pdf) | [Download Rmd](aeri_stacktraces/incidents_analysis.rmd) ] -- A R Markdown document to analyse the Stacktraces incidents dataset, with description of the actual content and examples of usage.

More information about the AERI system can be found on the [Code Trails website](https://www.codetrails.com/error-analytics/manual/).


## Eclipse mailing lists

The [Eclipse Mailing lists](eclipse_mls/eclipse_mls.html) dump is an extract of all emails posted on the Eclipse mailing lists.

* Download the **Eclipse mailing lists dataset** [ [CSV](eclipse_mls/eclipse_mls.gz) ].
* Check the **documentation** for the dataset [here (HTML)](eclipse_mls/mbox_csv_analysis.html). For reproducibility we also provide the [R Markdown document](eclipse_mls/mbox_csv_analysis.rmd) for the dataset analysis and documentation.
* Download the **mbox files** [ [see the list](eclipse_mls/eclipse_mls.html#project-mboxes) ]

More information can be found on the official [Eclipse page for mailing lists](https://accounts.eclipse.org/mailing-list).
