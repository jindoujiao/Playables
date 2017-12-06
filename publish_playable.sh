#!/bin/bash

cd "$(dirname "$0")" || exit
FILE_NAME="index.html"
DATE=$(date +"%d%m%Y")

function usage(){
    echo -e "usage:\n   $0 OPTIONS"
    echo -e "Test run OPTIONS:"
    echo -e "\t -e\tEnvironment to push: staging or prod"
    echo -e "\t -i\tInput html file for playable ads"
    echo -e "\t -g\tPlayable Ads Game Name"
    echo -e "Example:"
    echo -e "\t$0 -e staging -i examplePlayable.html -g testingGame"
}

function push_staging {
    echo "pushing to staging"
    git pull 

    mkdir -p "./playables/staging/ios/${GAME_FOLDER_NAME}" 
    mkdir -p "./playables/staging/android/${GAME_FOLDER_NAME}"

    cp ${INPUT_HTML} "./playables/staging/ios/${GAME_FOLDER_NAME}/${FILE_NAME}"
    cp ${INPUT_HTML} "./playables/staging/android/${GAME_FOLDER_NAME}/${FILE_NAME}"

    rm ${INPUT_HTML}

    git add .
    git commit -m "add to staging: ${GAME_FOLDER_NAME}"
    git push
    
}
function push_prod {
    git pull
    mkdir -p "./playables/production/ios/${GAME_FOLDER_NAME}" 
    mkdir -p "./playables/production/android/${GAME_FOLDER_NAME}"

    mv "./playables/staging/ios/${GAME_FOLDER_NAME}/${FILE_NAME}" "./playables/production/ios/${GAME_FOLDER_NAME}/${FILE_NAME}"
    mv "./playables/staging/android/${GAME_FOLDER_NAME}/${FILE_NAME}" "./playables/production/android/${GAME_FOLDER_NAME}/${FILE_NAME}"

    git add .
    git commit -m "add to prod: ${GAME_FOLDER_NAME}"
    git push

}

if [ $# -eq 0 ]; then echo "No arguments supplied" ; usage ; exit 1 ; fi

while getopts ":e:i:g:" OPTIONS; do
    case ${OPTIONS} in
        e) DES_ENV=$OPTARG ;;
        i) INPUT_HTML=$OPTARG ;;
        g) GAME_NAME=$OPTARG ;;
        :) echo "Missing required argument for -$OPTARG" >&2 ; exit 1;;
    esac
done

if [ -z "${DES_ENV}" ]; then echo "Please specify destination environment" ; usage ; exit 1 ; fi
if [ -z "${INPUT_HTML}" ]; then echo "Please specify html file" ; usage ; exit 1 ; fi
if [ -z "${GAME_NAME}" ]; then echo "Please specify game name" ;  usage ; exit 1 ; fi


GAME_FOLDER_NAME=${GAME_NAME}-${DATE}

if [ "${DES_ENV}" == "staging" ]; then 
    push_staging 
elif [ "${DES_ENV}" == "prod" ] || [ "${DES_ENV}" == "production" ]; then 
    push_prod 
else
    echo "not supported environment"; usage ; exit 1
fi    



