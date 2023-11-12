#!/bin/bash


if [ "$1" == "clean" ]; then
    rm -rf {data,out}/*.{xml,txt}
    echo "Deleted data and out files"
    exit 0
fi

# name prefix y year como parametros de entrada
NAME_PREFIX=$1
YEAR=$2

# Verificamos que se hayan ingresado los parametros (abortamos o xml vacio?)
if [ $# -ne 2 ]; then
    echo "Usage: $0 name_prefix year"
    exit 1
fi

if  ! ([[ $YEAR =~ ^[0-9]+$ ]] && [[ $YEAR -gt 2007 ]]); then
    echo "Year must be greater than 2007"
    exit 1
fi

# check name_prefix is not empty and is a string
if [[ -z $NAME_PREFIX ]] || !([[ $NAME_PREFIX =~ ^[a-zA-Z\ ]+$ ]]); then
    echo "Name prefix must not be empty or contain numbers"
    exit 1
fi

# temp -> hidden
API_KEY=$(cat ./src/API_KEY.txt)

# Generamos los xml con los datos 
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o data/seasons.xml
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/sr:season:80588/info.xml?api_key=${API_KEY} -o data/season_info.xml
curl -s http://api.sportradar.us/rugby-league/trial/v3/en/seasons/sr:season:80588/lineups.xml?api_key=${API_KEY} -o data/season_lineups.xml

# Query 1
java net.sf.saxon.Query -q:src/extract_season_id.xq season_prefix="$NAME_PREFIX" season_year=$YEAR -o:out/season_data.txt
sed -i '' 's/<?xml.*?>//' out/season_data.txt


# Query 2 
java net.sf.saxon.Query -q:src/extract_season_data.xq -o:out/season_data.xml

# Query 3
java net.sf.saxon.Transform -s:out/season_data.xml -xsl:src/generate_markdown.xsl -o:out/markdown.md 

echo "Done!"