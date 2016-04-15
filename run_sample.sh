#!/bin/bash

#  Usage:
#
#      ossify <playlist-name> <time-per-song> <number-of-songs> <theo-mode, aka your RJ> <quit-after>
#
#      <playlist-name>   = Playlist name
#      <time-per-song>   = Recommended between 0-45
#      <number-of-songs> = >0
#      <theo-mode>       = 1, Classic Mode, Theo speaks before the song
#                          2, Armin Mode, Theo speaks at the begining of the song
#                          3, FYI Mode, Theo speaks at the end of play(s)
#      <quit-after>      = 0, Keep listening to the music..
#                          1, Quit after <number-of-songs>
#      <log-location>    = Logfile path
#
#
# export OSSIFY_DEBUG=1

source ${PWD}/ossify.bash

function sac {
Say $THEO_SAYS
echo $THEO_SAYS
}

# test exit after play
THEO_SAYS="TEST1: APP EXIT"; sac
ossify list1 10 2 1 1 "${HOME}/ossify_logs_test"

# check if app exited
THEO_SAYS="Check if Spotify app exited"; sac
sleep 1s

# test RJ modes
THEO_SAYS="TEST2: Radio Jockey Modes"; sac

THEO_SAYS="Testing Theo mode classic, ten seconds and two songs"; sac
ossify list2 10 2 1 0 "${HOME}/ossify_logs_test"

THEO_SAYS="Testing Theo mode armin, ten seconds and two songs"; sac
ossify list3 10 2 2 0 "${HOME}/ossify_logs_test"

THEO_SAYS="Testing Theo mode fyi, ten seconds and two songs"; sac
ossify list4 10 2 3 1 "${HOME}/ossify_logs_test"

THEO_SAYS="End of all tests"; sac

exit 0
