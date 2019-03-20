


## Introduction

This document presents the datasets generated for Scava, and discusses the implications it has regarding privacy and the associated regulation.

All datasets are anonymised: fields that identify individuals or companies either directly or indirectly have been transformed using the [Anonymise::Utility Perl module]().

## Description of the datasets

There are three types of datasets generated, each with its schema and specific attributes. The first step is to describe the various datasets and their attributes, and identify what field could pose a threat to privacy.

### AERI stacktraces

The AERI stacktraces dataset contains information about exceptions encountered by users in the Eclipse IDE. It includes data about the exception itself, and the environment where it happened:

* **Message** (String) A short text summarising the error.
* **Code** (Integer) The numeric status code logged with the error.
* **Severity** (Factors) An estimate by the user reporting the error about its perceived severity.
* **Kind** (Factors) The type of error recorded, as identified by the AERI system.
* **Plugin ID** (String) The ID of the Eclipse plugin that threw the exception.
* **Plugin Version** (String) The ID of the Eclipse plugin that threw the exception.
* **Status fingerprint** (String) An identifier for the status of the incident. Used for duplicates detection.
* **Incident fingerprint** (String) An identifier for the incident. Used for duplicates detection.
* **Incident fingerprint2** (String) An identifier for the incident. Used for duplicates detection.
* **Timestamp** (Date ISO 8601) The time of creation of the incident.
* **Saved On** (Date ISO 8601) The time of last save of the problem.
* **OSGi Architecture** (Factors) The architecture of the host, as specified in the OSGi bundle definition.
* **OSGi OS** (Factors) The host operating system, as reported in OSGi.
* **OSGi OS Version** (Factors) The host operating system version, as reported in OSGi.
* **OSGi Window Manager** (Factors) The Window Manager used by the host, as reported in OSGi.
* **Eclipse Build ID** (String) The Build ID of the Eclipse instance running when the exception occurred.
* **Eclipse Product** (String) The Eclipse product impacted by the exception.
* **Java runtime version** (String) The Java runtime of the host.
* **Comment Quality** (Factors) An estimate of the user comment’s quality (throughfulness). User comments help people better understand the context of the exception.

The problems dataset offers the following attributes:

* **Summary** (String) A short text summarising the error.
* **Number of reporters** (Integer) The number of people who reported this incident or problem.
* **Number of incidents** (integer) The number of times this problem was identified in incidents.
* **V1 Status** (Factors) The status of the problem attached to the error report.
* **Kind** (Factors) The type of error recorded, as identified by the AERI system.
* **Created On** (Date ISO 8601) The time of first appearance of the problem in an incident.
* **Modified On** (Date ISO 8601) The time of last update of the problem in an incident.
* **Saved On** (Date ISO 8601) The time of last save of the problem.
* **OSGi Architecture** (Factors) The architecture of the host, as specified in the OSGi bundle definition.
* **OSGi OS** (Factors) The host operating system, as reported in OSGi.
* **OSGi OS Version** (Factors) The host operating system version, as reported in OSGi.
* **OSGi Window Manager** (Factors) The Window Manager used by the host, as reported in OSGi.
* **Eclipse Build ID** (String) The Build ID of the Eclipse instance running when the exception occurred.
* **Eclipse Product** (String) The Eclipse product impacted by the exception.
* **Java runtime version** (String) The Java runtime of the host.


### Eclipse Mailing lists

The Eclipse mailing lists dataset offers the following attributes:

* **List** (String) The mailing list and project of the post.
* **messageId** (String) A unique identifier for the post.
* **Subject** (String) The subject of the post as sent on the mailing list.
* **Sent at** (Date ISO 8601) The time of sending for the post.
* <span style="color:red;font-size:120%"> :biohazard: </span> **Sender name** (String) The name of the sender of the post.
* <span style="color:red;font-size:120%"> :biohazard: </span> **Sender address** (String) The email address of the sender, encoded.


### Eclipse project datasets


## Anonymisation

The mechanism used to anonymise the data is the Anonymise::Utility Perl module. It basically uses asymmetric encryption to generate one-time mapping

The result contains no email address, user id or machine id. Rather than removing the information (we are not sure that we remove all required information) we decided to simply pick relevant information from the file and push it into the output.

End users have an option to keep their own class names private. We have presently no simple means to know what stacktraces in the database extraction should be kept private, so we decided to play it safe and hide class names whose packages don’t start with known prefixes [1]. All private classnames have been replaced by the HIDDEN keyword.

[1] `ch.qos.*`, `com.cforcoding.*`, `com.google.*`, `com.gradleware.tooling.*`,
`com.mountainminds.eclemma.*`, `com.naef.*`, `com.sun.*`, `java.*`,
`javafx.*`, `javax.*`, `org.apache.*`, `org.eclipse.*`, `org.fordiac.*`,
`org.gradle.*`, `org.jacoco.*`, `org.osgi.*`, `org.slf4j.*`,
`sun.*`



## Privacy compliance

The publication of data in the European Union is controlled by the GDPR (General Data Protection Regulation), which also addresses the export of data outside the EU and EEA areas. Since we are EU citizens (and considering also that the Crossminer project is funded by the H2020 EU research program) we are to abide by this regulation.

Besides the legal implications of publishing open datasets, we are willing to conceal any information that would allow an attacker to

Considering that:

* Original data is already publicly available through the tools themselves (Git, Bugzilla, Mailing lists and forums) and their APIs.
* Masqueraded


We rely for that on the guidelines and recommendations provided by the [General Data Protection Regulation]()


## References
