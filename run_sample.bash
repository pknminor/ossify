#!/bin/bash

# export OSSIFY_DEBUG=1

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

# test exit after play
Say "TEST1"
echo "TEST1"
ossify test 10 2 1 1 "~/ossify_logs"

# check if app exited
Say "check if Spotify app exited"
echo "check if Spotify app exited"
sleep 10s

# test RJ modes
Say "TEST2"
echo "TEST2"

Say "Testing Theo mode classic"
echo "Testing Theo mode classic"
ossify test 10 1 1 0 "~/ossify_logs"

Say "Testing Theo mode armin"
echo "Testing Theo mode armin"
ossify test 10 1 2 0 "~/ossify_logs"

Say "Testing Theo mode fyi"
echo "Testing Theo mode fyi"
ossify test 10 1 3 1 "~/ossify_logs"

Say "End of all tests"
echo "End of all tests"

exit 0
