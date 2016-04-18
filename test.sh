#!/bin/bash

# Run this script from ossify/

#export OSSIFY_DEBUG=1

source ossify.bash

function sac {
    Say ${1}
    echo ${1}
}

# test exit after play
sac "TEST1"

ossify test1 f 3 1 0 ${HOME}/ossify_logs_test

#spotify quit
#sac "End test"

# ISSUE and IMPROVEMENTS LOG
# IS:  same random skip time same for all songs?, since song lengths are diff
# IMP: more sleep and less info in polls, might not be needed

exit 0
