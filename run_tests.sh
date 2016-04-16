#!/bin/bash

# Run this script from ossify/

# export OSSIFY_DEBUG=1

source ossify.bash

function sac {
Say ${1}
echo ${1}
}

# test exit after play
sac "TEST1: APP EXIT with one song playing"
ossify hist1 10 1 1 1 ${HOME}/ossify_logs_test

# check if app exited
sac "Check if Spotify app exited"
sleep 2s

# test RJ modes
sac "TEST2: Radio Jockey Modes"

sac "Testing Theo mode classic, ten seconds and two songs"
ossify hist2 10 2 1 0 ${HOME}/ossify_logs_test
spotify pause

sac "Testing Theo mode armin, ten seconds and two songs"
ossify hist3 10 2 2 0 ${HOME}/ossify_logs_test
spotify pause

sac "Testing Theo mode fyi, ten seconds and two songs"
ossify hist4 10 2 3 0 ${HOME}/ossify_logs_test
spotify pause

#
sac "TEST3: Skip Time Modes"

sac "Testing Full song mode"
ossify hist5 f 1 3 0 ${HOME}/ossify_logs_test
spotify pause

sac "Testing Random skip mode"
ossify hist6 r 1 3 0 ${HOME}/ossify_logs_test
spotify pause

sac "End of all tests"

exit 0
