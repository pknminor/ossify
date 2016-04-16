#!/bin/bash

# Run this script from ossify/

# export OSSIFY_DEBUG=1

source ossify.bash

function sac {
Say $THEO_SAYS
echo $THEO_SAYS
}

# test exit after play
THEO_SAYS="TEST1: APP EXIT with one song playing"; sac
ossify hist1 10 1 1 1 ${HOME}/ossify_logs_test

# check if app exited
THEO_SAYS="Check if Spotify app exited"; sac
sleep 2s

# test RJ modes
THEO_SAYS="TEST2: Radio Jockey Modes"; sac

THEO_SAYS="Testing Theo mode classic, ten seconds and two songs"; sac
ossify hist2 10 2 1 0 ${HOME}/ossify_logs_test
spotify pause

THEO_SAYS="Testing Theo mode armin, ten seconds and two songs"; sac
ossify hist3 10 2 2 0 ${HOME}/ossify_logs_test
spotify pause

THEO_SAYS="Testing Theo mode fyi, ten seconds and two songs"; sac
ossify hist4 10 2 3 0 ${HOME}/ossify_logs_test
spotify pause

#
THEO_SAYS="TEST3: Skip Time Modes"; sac

THEO_SAYS="Testing Full song mode"; sac
ossify hist5 f 1 3 0 ${HOME}/ossify_logs_test
spotify pause

THEO_SAYS="Testing Random skip mode"; sac
ossify hist6 r 1 3 0 ${HOME}/ossify_logs_test
spotify pause

THEO_SAYS="End of all tests"; sac

exit 0
