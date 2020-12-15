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


DATE=`date +%Y-%m-%d`
dir_session=/tmp/r_extract_project_${DATE}.session
dir_anon="data-anonymiser"
url_anon="https://github.com/borisbaldassari/data-anonymiser/archive/master.zip"

echo "# Checking if anonymisation utility is present.."
if [ -e ${dir_anon}/code/anonymise ]; then
    echo "  * Found [${dir_anon}/code/anonymise] utility."
else
    echo "  * Cannot find [${dir_anon}/code/anonymise] utility."
    echo "    Downloading utility from [$url_anon].."
    curl -L -s ${url_anon} -o data-anonymiser.zip
    echo "    Uncompressing utility to ${dir_anon}."
    unzip -q data-anonymiser.zip
    mv data-anonymiser-master/ data-anonymiser/
fi

echo "# Creating session directory [${dir_session}]."
if [ -e $dir_session ]; then
    echo "  * Removing old session dir."
    mv $dir_session ${dir_session}.old
fi
#mkdir -p $dir_session

for proj in `cat list_projects.txt`; do
    echo "# Extracting project $proj..."
    echo ""
    sh process_project_data.sh "$proj"
    echo ""
done

echo "# Moving projects to datasets directory..."
mv projects/* ../datasets/projects/
cp list_projects.txt ../datasets/projects/

echo "# Removing session directory [${dir_session}]."
rm -rf $dir_session


