#!/bin/bash

# Run this script from ossify/

export OSSIFY_DEBUG=1
source ~/.bashrc

function say_echo {
Say ${1}
echo ${1}
}

# test RJ modes
say_echo "TEST suite1: Radio Jockey Modes"
#
say_echo "Testing Theo mode peel, 20 seconds and 3 songs" #UPDATEME
ossify hist2 20 3 peel off off off ${HOME}/ossify_logs_test
#
#say_echo "Testing Theo mode armin, 20 seconds and 3 songs" #UPDATEME
ossify hist6 20 3 armin off off off ${HOME}/ossify_logs_test
#
#say_echo "Testing Theo mode fyi, 20 seconds and 3 songs" #UPDATEME
ossify hist6 20 3 fyi off off off ${HOME}/ossify_logs_test

#
say_echo "TEST suite2: Skip Time Modes"

#say_echo "Testing Full song mode, 3 songs fyi" #UPDATEME
ossify hist6 f 3 peel off off off ${HOME}/ossify_logs_test

#say_echo "Testing Random skip mode, 3 songs fyi" #UPDATEME
ossify hist6 r 3 peel off off off ${HOME}/ossify_logs_test

say_echo "TEST suite2: Exit spoitfy after"
say_echo "TEST1: APP EXIT with 1 song playing" #UPDATEME
ossify hist6 20 3 peel off off on ${HOME}/ossify_logs_test

say_echo "End of all tests"

exit 0
