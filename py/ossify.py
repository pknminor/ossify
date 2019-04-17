#!/usr/bin/python
import os, sys, getopt
import time
import re
import threading
import thread

import subprocess
from subprocess import Popen, PIPE

# functions
def rj_says(text):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) - 30) --100%'], stdout=FNULL, stderr=subprocess.STDOUT)
    retcode = subprocess.call(["say", text], stdout=FNULL, stderr=subprocess.STDOUT)
    retcode = subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) + 30) --100%'], stdout=FNULL, stderr=subprocess.STDOUT)

def spot_pos(pos):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(["spotify","pos", str(pos)], stdout=FNULL, stderr=subprocess.STDOUT)

def spot(text):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(["spotify", text], stdout=FNULL, stderr=subprocess.STDOUT)

def spot_is_playing():
    p = Popen(['spotify', 'info'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate(b"input data that is passed to subprocess' stdin")
    rc = p.returncode
    output_split = re.split("\n", output)
    output_split2 = re.split(".*: +", output_split[16])
    if ( output_split2[1] == "playing" ):
        return True
    else:
        return False

def play_if_paused():
    if ( spot_is_playing() == False ):
        spot("play")

def get_artist():
    p = Popen(['spotify', 'info'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate(b"input data that is passed to subprocess' stdin")
    rc = p.returncode
    output_split = re.split("\n", output)
    output_split2 = re.split(".*: +", output_split[1])
    return output_split2[1]

def get_track():
    p = Popen(['spotify', 'info'], stdin=PIPE, stdout=PIPE, stderr=PIPE)
    output, err = p.communicate(b"input data that is passed to subprocess' stdin")
    rc = p.returncode
    output_split = re.split("\n", output)
    output_split2 = re.split(".*: +", output_split[2])
    return output_split2[1]

def rj_says_track_info(say_artist):
    if (say_artist):
        rj_says(get_track() + "... by" + get_artist())
    else:
        rj_says(get_track())

def rj_says_track_bk(say_artist):
        thread = threading.Thread(target=rj_says_track_info, args=([say_artist]))
        thread.daemon = True
        thread.start()

def main(argv):
    # export DBG_OSSIFY=1
    DBG = os.getenv('DBG_OSSIFY')

    # args
    skip_time = 10
    num_songs = 10
    say_artist = False
    stop_after = True
    try:
        opts, args = getopt.getopt(argv,"ahs:n:q")
    except getopt.GetoptError:
        print 'ERROR in args'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print """
            HELP:
            -s ; skip time
            -n ; number songs
            -a ; say the artist's name
            -q ; stop after songs
            """
            sys.exit()
        elif opt in ("-s"):
            skip_time = int(arg)
        elif opt in ("-n"):
            num_songs = int(arg)
        elif opt in ("-a"):
            say_artist = True
        elif opt in ("-q"):
            stop_after = True

    # init
    rj_says("ossify")
    spot_pos(0)
    play_if_paused()

    # main loop
    for ii in range(1,num_songs+1):
        print "Playing track " + str(ii) + "/" + str(num_songs)
        rj_says_track_bk(say_artist)

        print "Hit Ctrl-C to go to next track"
        try:
            time.sleep (skip_time)
        except KeyboardInterrupt:
            pass

        if (stop_after and (ii == num_songs)):
            spot("pause")
        else:
            spot("next")


if __name__ == "__main__":
       main(sys.argv[1:])
