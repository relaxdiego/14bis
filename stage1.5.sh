#!/bin/bash

# This is stage 1.5, it is executed on the booted host by cloud-init.
# It's function is to download stage 2 from internet and execute it
# It's a two step stage and runs twice, first by cloud-init user-data
# and later re-spawned by itself on the virtual terminal 7 so it can
# run concurrently and let cloud-init finish.

_dir="${0%/*}"
cd "$_dir"

source util.inc.sh
source config.inc.sh

if [ "$1" == "openvt" ]; then
    # We are running from cloud-init, let's be quick and exit
    openvt -c 7 -- $0 reentered
    exit 0
elif [ "$1" == "reentered" ]; then
    sleep 1
    chvt 7
    log msg="Re-entered running from virtual terminal 7"
fi

log msg="Starting stage1.5"

mkdir /tmp/14bis
cd /tmp/14bis

log msg="Download stage 2"
git clone "${REPO_URL}"

cd 14bis

log msg="Exec'ing stage 2"
exec ./stage2.sh
