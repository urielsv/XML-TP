#!/bin/bash
if [ "$1" == "clean" ]; then
    rm -rf *.{xml,txt}
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
API_KEY="kykfkexbjqyehenht25wjw3f"
# Generamos los xml con los datos 
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons.xml?api_key=${API_KEY} -o seasons.xml
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons/sr:season:80588/info.xml?api_key=${API_KEY} -o season_info.xml
curl http://api.sportradar.us/rugby-league/trial/v3/en/seasons/sr:season:80588/lineups.xml?api_key=${API_KEY} -o season_lineups.xml

java net.sf.saxon.Query -q:extract_season_id.xq season_prefix="$NAME_PREFIX" season_year=$YEAR -o:"season_data.txt"
sed -i '' 's/<?xml.*?>//' season_data.txt
# java net.sf.saxon.Query -q:extract_season_data.xq season_prefix="$NAME_PREFIX" season_year=$YEAR -o:"season_data.txt"
