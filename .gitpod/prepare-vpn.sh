#!/bin/bash
ABSOLUTE_PATH_PV="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $ABSOLUTE_PATH_PV/common/support-os.sh
source $ABSOLUTE_PATH_PV/common/sudo.sh

ABSOLUTE_PATH_PV="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $ABSOLUTE_PATH_PV
./ssh.sh "rm -rf ~/shell/keys"
./ssh.sh "mkdir -p ~/shell/keys"
./ssh.sh "mkdir -p ~/shell/common"
$SUDO ./scp.sh -r ./vpn-s2c/keys root@localhost:~/shell/keys
$SUDO ./scp.sh ./vpn-s2c/server.sh root@localhost:~/shell/keys
$SUDO ./scp.sh -r ./common root@localhost:~/shell