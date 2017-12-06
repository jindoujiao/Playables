#!/bin/bash

cd "$(dirname "$0")" || exit
FILE_NAME="index.html"
function push_staging {
    echo "pusing to staging"
    #git pull 

    mkdir -p "./playables/staging/ios/${GAME_FOLDER_NAME}" 
    mkdir -p "./playables/staging/android/${GAME_FOLDER_NAME}"

    cp ${INPUT_HTML} "./playables/staging/ios/${GAME_FOLDER_NAME}/${FILE_NAME}"
    cp ${INPUT_HTML} "./playables/staging/android/${GAME_FOLDER_NAME}/${FILE_NAME}"

    #git add .
    #git commit -m "add to staging: ${GAME_FOLDER_NAME}"
    #git push
    
}
function push_prod {
    #git pull
    mkdir -p "./playables/production/ios/${GAME_FOLDER_NAME}" 
    mkdir -p "./playables/production/android/${GAME_FOLDER_NAME}"

    mv "./playables/staging/ios/${GAME_FOLDER_NAME}/${FILE_NAME}" "./playables/production/ios/${GAME_FOLDER_NAME}/${FILE_NAME}"
    mv "./playables/staging/android/${GAME_FOLDER_NAME}/${FILE_NAME}" "./playables/production/android/${GAME_FOLDER_NAME}/${FILE_NAME}"

    #git add .
    #git commit -m "add to prod: ${GAME_FOLDER_NAME}"
    #git push

}

while getopts ":e:i:g:" OPTIONS; do
    case ${OPTIONS} in
        e) DES_ENV=$OPTARG ;;
        i) INPUT_HTML=$OPTARG ;;
        g) GAME_FOLDER_NAME=$OPTARG ;;
        :) echo "Missing required argument for -$OPTARG" >&2 ; exit 1;;
    esac
done
echo ${DES_ENV}
echo ${INPUT_HTML}

if [ -z "${DES_ENV}" ]; then echo "Please specify destination environment" ;  exit 1 ; fi
if [ -z "${INPUT_HTML}" ]; then echo "Please specify html file" ;  exit 1 ; fi
if [ -z "${GAME_FOLDER_NAME}" ]; then echo "Please specify game name" ;  exit 1 ; fi

if [ "${DES_ENV}" == "staging" ]; then push_staging ; fi
if [ "${DES_ENV}" == "prod" ] || [ "${DES_ENV}" == "production" ]; then push_prod ; fi



