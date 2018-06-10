#!/bin/bash

# Run this script from ossify/

# export OSSIFY_DEBUG=1

source ossify.bash

function sac {
Say ${1}
echo ${1}
}

# test RJ modes
#sac "TEST2: Radio Jockey Modes"
#
#sac "Testing Theo mode classic, 20 seconds and 3 songs" #UPDATEME
#ossify hist2 20 3 1 0 ${HOME}/ossify_logs_test 0
#sac "Test end"
#
#sac "Testing Theo mode armin, 20 seconds and 3 songs" #UPDATEME
#ossify hist3 20 3 2 0 ${HOME}/ossify_logs_test 0
#sac "Test end"
#
#sac "Testing Theo mode fyi, 20 seconds and 3 songs" #UPDATEME
#ossify hist4 20 3 3 0 ${HOME}/ossify_logs_test 0
#sac "Test end"
#
##
#sac "TEST3: Skip Time Modes"
#
#sac "Testing Full song mode, 3 songs fyi" #UPDATEME
#ossify hist5 f 3 3 0 ${HOME}/ossify_logs_test 0
#sac "Test end"
#
#sac "Testing Random skip mode, 3 songs fyi" #UPDATEME
#ossify hist6 r 3 3 0 ${HOME}/ossify_logs_test 0
#sac "Test end"
#
## test exit after play
##sac "TEST1: APP EXIT with 1 song playing" #UPDATEME
##ossify hist1 10 1 1 1 ${HOME}/ossify_logs_test
#
## check if app exited
##sac "Check if Spotify app exited"
##sleep 2s
#
#sac "End of all tests"
#
## Current Issues


exit 0
