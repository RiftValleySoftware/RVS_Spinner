#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
rm -drf docs
jazzy   --github_url https://github.com/RiftValleySoftware/RVS_Spinner\
        --readme ./README.md --theme fullwidth\
        --author The\ Great\ Rift\ Valley\ Software\ Company\
        --author_url https://riftvalleysoftware.com\
        --module RVS_Spinner\
        --copyright [©2019\ The\ Great\ Rift\ Valley\ Software\ Company]\(https://riftvalleysoftware.com\)
cp icon.png docs/icon.png
mkdir docs/images
cp img/*.* docs/img/
cp RVS_Spinner-Pod-Demo.zip docs/
cp RVS_Spinner-Standalone-Demo.zip docs/
cd "${CWD}"
