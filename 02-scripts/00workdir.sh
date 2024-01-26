#!/bin/bash

PROJECT_NAME=$1
mkdir "$PROJECT_NAME"
cd ./"$PROJECT_NAME" || exit
mkdir 01-documentation 02-scripts 03-data 04-results 05-reports
touch .gitignore
touch README.md
