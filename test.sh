#!/bin/bash

# Run this script from ossify/

export OSSIFY_DEBUG=0
export OSSIFY_DEBUG1=1
export OSSIFY_DEBUG2=0

source ossify.bash

function sac {
    Say ${1}
    echo ${1}
}

# test exit after play
sac "TEST1"

ossify test1 r 3 1 0 ${HOME}/ossify_logs_test

# ISSUE and IMPROVEMENTS LOG
# IS:
# IMP: more sleep and less info in polls, might not be needed

#spotify quit
#sac "End test"

exit 0
