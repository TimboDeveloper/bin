#!/bin/sh
BINARA_HOME="$HOME/.binara"
BIN_DIR="bin"
PACKAGES_DIR="packages"
SOURCE_MAP_FILE="sourceMap.txt"

RAW_URL="https://raw.githubusercontent.com"
OWNER_USER="timbo-dev"
REPOSITORY_NAME="binara"
BRANCH="main"

ROOT_PATH=$PWD

home() {
    local path=${1}
    echo $BINARA_HOME/$path
}

bin() {
    local path=${1}
    echo $(home $BIN_DIR/$path)
}

package() {
    local path=${1}
    echo $(home $PACKAGES_DIR/$path)
}

downloadFile() {
    local filePath=${1}

    if ! [ -z $2 ]; then
        local output="--output-document ${2}"
    fi

    wget --quiet                             \
         --show-progress                     \
         "$RAW_URL/$OWNER_USER/$REPOSITORY_NAME/$BRANCH/$filePath" $output
}

downloadPackage() {
    local packages=$(getSource "${1}")
    local lastPath=$PWD
    
    cd $ROOT_PATH && cd $(package)

    for package in $packages; do
        folderPackage=$(dirname $package)
        packagePath=$(echo $package | sed -E "s/$PACKAGES_DIR\///g")

        mkdir -p $BINARA_HOME/$folderPackage
        downloadFile $package $packagePath
    done

    cd $lastPath
    echo
}

makeLinkBin() {
    local bin=${1}
    local linkTarget="$(bin $(basename $bin))"

    echo "Linking: $1 to $linkTarget"
    ln -sf "$bin" "$linkTarget"
}

getSource() {
    local packageTarget=${1}
    
    if ! [ -z ${2} ]; then
        local fileTarget="/${2}"
    fi
    
    local contentFile=$(cat $(home $SOURCE_MAP_FILE) | grep "$PACKAGES_DIR/$packageTarget$fileTarget")
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

WGET_COMMAND=$(whereis wget)

if [ "$WGET_COMMAND" == "wget:" ]; then
    echo "error: wget command not found"
    echo "first install wget to continue"
    exit 1
fi

createDir $(home)
createDir $(bin)
createDir $(package)

echo

cd $BINARA_HOME

downloadFile $SOURCE_MAP_FILE $SOURCE_MAP_FILE

echo

downloadPackage core
downloadPackage binara

makeLinkBin $(package binara/binara)
makeLinkBin $(package core/core)

SHELL_NAME=$(basename $SHELL)

showExportMessage() {
    echo "manually paste the $BINARA_HOME variable into your shell configuration file:"
    echo
    echo 'export $BINARA_HOME=$HOME/.binara'
    exit 1
}

if [ ! -z $SHELL_NAME ]; then
    SHELL_RC=".$SHELL_NAME""rc"
    RC_PATH="$HOME/$SHELL_RC"

    echo "Shell '$SHELL_NAME' detected, trying to insert \$BINARA_HOME environment on '$HOME/$SHELL_RC'"

    if [ ! -f "$RC_PATH" ]; then
        echo "error: cannot find the file '$RC_PATH'"
        showExportMessage
    fi
    
    RC_CONTENT=$(cat "$RC_PATH")
    EXPORT_BINARA_HOME='export BINARA_HOME=$HOME/.binara'
    EXPORT_BINARA_BIN_PATH='export PATH="$BINARA_HOME/bin:$PATH"'

    if ! [[ "$RC_CONTENT" =~ "$EXPORT_BINARA_HOME" ]]; then
        echo $EXPORT_BINARA_HOME >> $RC_PATH
    fi

    if ! [[ "$RC_CONTENT" =~ "$EXPORT_BINARA_BIN_PATH" ]]; then
        echo $EXPORT_BINARA_BIN_PATH >> $RC_PATH
    fi
else
    echo "error: shell name not found."
    showExportMessage
fi
