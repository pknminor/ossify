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


# Make sure all processes are killed after
    # 89:91: execution error: Spotify got an error: Connection is invalid. (-609)
    # OSSIFY_PAUSE_AT_NEXT_START: seconds played
    # OSSIFY_PAUSE_AT_NEXT_START: seconds played int
    # ossify.bash: line 47: 183 -  : syntax error: operand expected (error token is " ")


#http://open.spotify.com/track/5A7W9CcRzRt5bjz4HqigFr
#spotify quit
#sac "End test"

exit 0
