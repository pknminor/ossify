#!/bin/bash

#  Usage:
#
#      ossify <playlist-name> <time-per-song> <number-of-songs> <theo-mode, aka your RJ>
#
#      <playlist-name>   = Playlist name
#      <time-per-song>   = Recommended between 0-45
#      <number-of-songs> = >0
#      <theo-mode>       = 0, Classic Mode, Theo speaks before the song
#                          1, Armin Mode, Theo speaks at the begining of the song
#                          2, FYI Mode, Theo speaks at the end of the play
#      <quit-afte>       = 0, Keep listening to the music..
#                          1, Quit after the plays

# test exit after play
Say "TEST1"
ossify test 10 2 1 1

# check if app exited
Say "check if Spotify app exited"
sleep 10s

# test rj modes
Say "TEST2"
Say "Testing Theo mode classic"
ossify test 10 2 1 0

Say "Testing Theo mode armin"
ossify test 10 2 2 0

Say "Testing Theo mode fyi"
ossify test 10 2 3 0

Say "End of test"
