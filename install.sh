#!/bin/sh
BINARA_HOME="$HOME/.binara"

if [ -d $BINARA_HOME ]; then
    echo "error: '$BINARA_HOME' already exists, remove it to reinstall"
    exit 1
fi

echo "Creating dir: $BINARA_HOME"
mkdir -p $BINARA_HOME

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
