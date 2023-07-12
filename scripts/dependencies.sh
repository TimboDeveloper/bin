#!/bin/sh
# THIS SCRIPT IS USED BY MAKEFILE.
# NOT BE USED DIRECTLY

readonly dependencies=$1
readonly target=$2
readonly build=$3

shift
shift
shift

readonly files=$@

if [ -z "$files" ]; then
    echo 'error: no arguments provided.'
    exit 1
fi

dependenciesContent=$(cat $dependencies)

getDependencies() {
    local package=$1
    local content=$2
    local startTag="<$package>"
    local endTag="</$package>"
    local output=""

    startLine=$(echo "$content" | grep -n "$startTag" | cut -d ":" -f 1)
    endLine=$(echo "$content" | grep -n "$endTag" | cut -d ":" -f 1)

    extractedLines=$(echo "$content" | sed -n "$startLine,$endLine p")

    while IFS= read -r line; do
        if [[ "$line" != "$startTag" && "$line" != "$endTag" ]]; then
        output+="$line "
        fi
    done <<< "$extractedLines"

    echo "$output" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

packageName=$(basename $(dirname "$target"))
packages=$(getDependencies "$packageName" "$dependenciesContent")

for package in $packages; do
    if [[ $files =~ $package ]]; then
        echo $build/$package.o
    fi
done