#!/bin/bash

ABSOLUTE_PATH_MN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $ABSOLUTE_PATH_MN/common/support-os.sh
source $ABSOLUTE_PATH_MN/common/sudo.sh

ABSOLUTE_PATH_MN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $ABSOLUTE_PATH_MN

$SUDO apt install nodejs -y
npm install
npm run run
echo 'Master token started!'