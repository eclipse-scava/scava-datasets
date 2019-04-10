
# Release notes for the AERI dataset

The database dump contains information about errors encountered by people when using Eclipse. It is composed of several mongodb tables and uses the bson format. Only two tables contain stack traces: `problems` and `incidents`.

The bson files can be read using the bsondump utility, provided with the mongodb client package (mongodb-clients on Debian).
```
bsondump problems.bson --type json > problems.json
```

After conversion the two files are quite big: 37GB for incidents and 2.1 GB for problems.

Unfortunately the utility adds some progress information in the UI that needs to be removed from the output:
```
grep -v 'Progress: ' problems.json > problems_clean.json
```

We also had to remove a few (approx. a dozen of) lines because they embed unparseable source code, characters or asian/binary/utf8/16/256 text. The script tries to JSON-decode all lines one by one, and on failure simply goes to the next line.

For `problems` (the file is reasonably small) the script generates for each line a separate JSON file with only information related to that line. The script for problems extraction is `parse_json_problems.pl`. Output is 820MB and processing time is roughly 45mn.

For `incidents` (file is 37GB) the script generates for each line a separate JSON file with only information related to that line. For the records, trying to generate a single file requires at least twice the size of the file in RAM/SWAP (i.e. roughly 74GB). There are 2084328 files in the output for 17GB. The script for incidents extraction is `parse_json_incidents.pl`. To get an idea of the resources required to process that, the final incidents extraction took roughly 16h on a quite powerful box.
