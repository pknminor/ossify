#!/bin/bash

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

