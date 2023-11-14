#!/bin/bash

function generate_error_xml() {
    local error_message=$1

    cat << EOF > ./out/season_data.xml
<?xml version="1.0" encoding="UTF-8"?>
<season_data>
    <error>${error_message}</error>
</season_data>
EOF
}

function remove_xml_declaration() {
    local file_path=$1
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' 's/<?xml.*?>//' "$file_path"
    else
        # Linux sed
        sed -i 's/<?xml.*?>//' "$file_path"
    fi
}

# Clean data and out files
if [ "$1" == "clean" ]; then
    rm -rf {data,out}/*.{xml,txt,md}
    echo -e "\033[32mDeleted data and out files\033[0m"
    exit 0
fi

# Input params
NAME_PREFIX=$1
YEAR=$2

# check params
if [ $# -ne 2 ]; then
    generate_error_xml "Invalid arguments"
    echo "Usage: $0 name_prefix year"
    exit 1
fi

# check year is a number and is greater than 2007
if  ! ([[ $YEAR =~ ^[0-9]+$ ]] && [[ $YEAR -gt 2007 ]]); then
    generate_error_xml "Year must be greater than 2007"
    echo -e "\033[0;31mError: \033[0mYear must be greater than 2007."
    exit 1
fi

# check name prefix is not empty and does not contain numbers
if [[ -z $NAME_PREFIX ]] || !([[ $NAME_PREFIX =~ ^[a-zA-Z\ ]+$ ]]); then
    generate_error_xml "Name prefix must not be empty or contain numbers"
    echo -e "\033[0;31mError: \033[0mName prefix must not be empty or contain numbers."
    exit 1
fi

API_KEY=$(cat ./src/API_KEY.txt)

# Download data
echo "Downloading data for Query1"
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o data/seasons.xml

echo "Processing data..."

# Query 1
java net.sf.saxon.Query -q:src/extract_season_id.xq season_prefix="$NAME_PREFIX" season_year=$YEAR -o:out/season_data.txt
remove_xml_declaration "out/season_data.txt"
SEASON=$(cat ./out/season_data.txt)

if [[ $SEASON == "Error"* ]]; then
    echo -e "\033[0;31mseason_data.txt created with error"
    generate_error_xml "$SEASON"
    echo "# ${SEASON}" > ./out/season_page.md
    echo -e "\033[0;31mseason_data.xml created with error\033[0m"
    echo -e "\033[0;31mseason_page.md created with error\033[0m"
    echo -e "\033[0;31mError: error while generating season_data.xml\033[0m"
    exit 1
fi

echo "season_data.txt created"

# If season is valid then download and process data.
# Downloading data for Query2
echo "Downloading data for Query2"
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${SEASON}/info.xml?api_key=${API_KEY} -o data/season_info.xml
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/${SEASON}/lineups.xml?api_key=${API_KEY} -o data/season_lineups.xml

# Query 2 
java net.sf.saxon.Query -q:src/extract_season_data.xq -o:out/season_data.xml
echo "season_data.xml created"

# Generate Markdown for Query2
java net.sf.saxon.Transform -s:out/season_data.xml -xsl:src/generate_markdown.xsl -o:out/season_page.md 
remove_xml_declaration "out/season_page.md"
echo "season_page.md created"

echo -e "\033[32mDone!\033[0m"