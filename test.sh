#!/bin/bash

# Run this script from ossify/

export OSSIFY_DEBUG=1

source ossify.bash

function sac {
Say ${1}
echo ${1}
}

# test exit after play
sac "TEST1"

ossify test1 r 4 2 0 ${HOME}/ossify_logs_test

#spotify quit
#sac "End test"

exit 0
