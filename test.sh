#!/bin/bash

# Run this script from ossify/

#export OSSIFY_DEBUG=0
#export OSSIFY_DEBUG1=0
#export OSSIFY_DEBUG2=0

source ossify.bash

function sac {
    Say ${1}
    echo ${1}
}

ossify hist6 r 2 peel off off off ${HOME}/ossify_logs_test


exit 0
