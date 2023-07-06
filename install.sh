#!/bin/sh
BINARA_HOME="$HOME/.binara"
BIN_DIR="bin"
PACKAGES_DIR="packages"
SOURCE_MAP_FILE="sourceMap.txt"

RAW_URL="https://raw.githubusercontent.com"
OWNER_USER="timbo-dev"
REPOSITORY_NAME="binara"
BRANCH="main"

downloadFile() {
    local filePath=${1}
    
    if ! [ -z $2 ]; then
        local output="--output-document ${2}"
    fi

    wget --quiet --show-progress "$RAW_URL/$OWNER_USER/$REPOSITORY_NAME/$BRANCH/$filePath" $output
}

getSource() {
    local packageTarget=${1}
    
    if ! [ -z ${2} ]; then
        local fileTarget="/${2}"
    fi

    local contentFile=$(cat $BINARA_HOME/$SOURCE_MAP_FILE) | grep "$PACKAGES_DIR/$packageTarget$fileTarget"

    echo "$contentFile"
}

createDir() {
    local location=${1}
    echo "Creating dir: $location"
    mkdir -p $location
}

if [ -d $BINARA_HOME ]; then
    echo "error: '$BINARA_HOME' already exists, remove it to reinstall"
    exit 1
fi

createDir $BINARA_HOME
createDir $BINARA_HOME/$BIN_DIR
createDir $BINARA_HOME/$PACKAGES_DIR

WGET_COMMAND=$(whereis wget)

if [ "$WGET_COMMAND" == "wget:" ]; then
    echo "error: wget command not found"
    echo "first install wget to continue"
    exit 1
fi

downloadFile $SOURCE_MAP_FILE $BINARA_HOME/$SOURCE_MAP_FILE
getSource core

SHELL_NAME=$(basename $SHELL)

showExportMessage() {
    echo "manually paste the $BINARA_HOME variable into your shell configuration file:"
    echo
    echo 'export $BINARA_HOME=$HOME/.binara'
}

if [ ! -z $SHELL_NAME ]; then
    SHELL_RC=".$SHELL_NAME""rc"
    RC_PATH="$HOME/$SHELL_RC"

    echo
    echo "Shell '$SHELL_NAME' detected, trying to insert \$BINARA_HOME environment on '$HOME/$SHELL_RC'"

    if [ ! -f "$RC_PATH" ]; then
        echo "error: cannot find the file '$RC_PATH'"
        showExportMessage
    fi

else
    echo "error: shell name not found."
    showExportMessage
fi
