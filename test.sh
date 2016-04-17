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

ossify test1 f 1 1 0 ${HOME}/ossify_logs_test

sac "End test"

exit 0
