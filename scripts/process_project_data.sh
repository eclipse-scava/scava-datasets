##################################################################
#
# Copyright (C) 2019 Castalia Solutions
# 
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
# 
# SPDX-License-Identifier: EPL-2.0
#
###################################################################


if [ $# -eq 1 ]; then
    proj=$1
else
    echo "Usage: $0 <project.id>"
    echo "I need the id of a project to work on. Dying."
    exit 4
fi

export PERL5LIB=./data-anonymiser/code/:$PERL5LIB

verbose=false

dir_out="projects/$proj"
mkdir -p $dir_out

dir_anon="data-anonymiser"
DATE=`date +%Y-%m-%d`
dir_session=/tmp/r_extract_project_${DATE}.session

time_start=`date "+%Y-%m-%d %H:%M:%S"`

# Checking that we have the anonymiser utility available.
if [ ! -e ${dir_anon}/code/anonymise ]; then
    echo "ERROR: Cannot find [${dir_anon}/code/anonymise]. Quitting."
    exit 4
fi

anonymise() {
    filein=$1
    mv ${filein} ${filein}.orig
    ${dir_anon}/code/anonymise -q scramble -s ${dir_session} -f ${filein}.orig -t $filein
}

echo "# Script started on ${time_start}."
echo "  Working on project $proj."
echo "  * Cleaning workspace."
rm -f ${dir_out}/*
 
base_url="https://eclipse.alambic.io/projects/$proj"
echo "  Using Base URL [${base_url}]."

echo "  * Retrieve data.."

echo "    - Get Git commits."
curl -f0 -s -o ${dir_out}/git_commits_evol.csv ${base_url}/Git/git_commits.csv
curl -f0 -s -o ${dir_out}/git_log.txt ${base_url}/Git/import_git.txt
 
echo "    - Get Bugzilla issues."
curl -f0 -s -o ${dir_out}/bugzilla_evol.csv ${base_url}/Bugzilla/bugzilla_evol.csv
curl -f0 -s -o ${dir_out}/bugzilla_issues.csv ${base_url}/Bugzilla/bugzilla_issues.csv
curl -f0 -s -o ${dir_out}/bugzilla_issues_open.csv ${base_url}/Bugzilla/bugzilla_issues_open.csv
curl -f0 -s -o ${dir_out}/bugzilla_components.csv ${base_url}/Bugzilla/bugzilla_components.csv
curl -f0 -s -o ${dir_out}/bugzilla_versions.csv ${base_url}/Bugzilla/bugzilla_versions.csv
 
echo "    - Get EclipseForums threads."
curl -f0 -s -o ${dir_out}/eclipse_forums_posts.csv ${base_url}/EclipseForums/eclipse_forums_posts.csv
curl -f0 -s -o ${dir_out}/eclipse_forums_threads.csv ${base_url}/EclipseForums/eclipse_forums_threads.csv
 
echo "    - Get EclipsePMI information and checks."
curl -f0 -s -o ${dir_out}/eclipse_pmi_checks.csv ${base_url}/EclipsePmi/pmi_checks.csv
curl -f0 -s -o ${dir_out}/eclipse_pmi_checks.json ${base_url}/EclipsePmi/pmi_checks.json
 
echo "    - Get SonarQube data."
curl -f0 -s -o ${dir_out}/sq_issues_blocker.csv ${base_url}/SonarQube45/sq_issues_blocker.csv
curl -f0 -s -o ${dir_out}/sq_issues_critical.csv ${base_url}/SonarQube45/sq_issues_critical.csv
curl -f0 -s -o ${dir_out}/sq_issues_major.csv ${base_url}/SonarQube45/sq_issues_major.csv
curl -f0 -s -o ${dir_out}/sq_metrics.csv ${base_url}/SonarQube45/sq_metrics.csv

echo "  * Anonymise data."

echo "    - Scramble Git commits files."
anonymise ${dir_out}/git_log.txt

echo "    - Scramble names in Git log."
sed -E 's/Signed-off-by: [^<]+/Signed-off-by: XXXXXXXX /' < git_log.txt > git_log.txt.1
sed -E 's/^Author: [^<]+/Author: XXXXXXXX /' < git_log.txt.1 > git_log.txt
rm git_log.txt.1

echo "    - Scramble Bugzilla files"
anonymise ${dir_out}/bugzilla_issues.csv
anonymise ${dir_out}/bugzilla_issues_open.csv

echo "    - Scramble EclipseForums files"
anonymise ${dir_out}/eclipse_forums_posts.csv
anonymise ${dir_out}/eclipse_forums_threads.csv

echo "    - Scramble EclipsePMI files"
anonymise ${dir_out}/eclipse_pmi_checks.csv
anonymise ${dir_out}/eclipse_pmi_checks.json


tmpfile=$(mktemp /tmp/r_extract_project.XXXXXX.r)
echo "  * Rendering RMarkdown file [$tmpfile]." 
cat <<EOF > $tmpfile
require(rmarkdown)
render("../report/datasets_report.Rmd", 
	output_file="${dir_out}/dataset_report_$proj.html",
	params = list(project_id = "$proj"))
EOF

if [ "$verbose" = true ]; then
    Rscript $tmpfile
else
    Rscript $tmpfile >/dev/null 2>&1
fi

echo "  * Compressing files."  
find ${dir_out} -name "*.csv" -exec gzip -k {} \;
find ${dir_out} -name "*.json" -exec gzip -k {} \;
find ${dir_out} -name "*.txt" -exec gzip -k {} \;

echo "  * Removing clear files."  
find ${dir_out} -name "*.orig" -exec rm {} \;


#rm $tmpfile

 
