#!/usr/bin/python
import sys
import itertools
import timeit
from operator import mul
from random import randint
import os, sys, getopt
import math
import subprocess
import time

# functions
def sample_func(data):
    True

def rj_says(text):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) - 30) --100%'], stdout=FNULL, stderr=subprocess.STDOUT)
    retcode = subprocess.call(["say", text], stdout=FNULL, stderr=subprocess.STDOUT)
    retcode = subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) + 30) --100%'], stdout=FNULL, stderr=subprocess.STDOUT)

def spot_goto_beginning():
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(["spotify", "prev"], stdout=FNULL, stderr=subprocess.STDOUT)
    retcode = subprocess.call(["spotify", "pause"], stdout=FNULL, stderr=subprocess.STDOUT)

def spot_pos(pos):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(["spotify","pos", str(pos)], stdout=FNULL, stderr=subprocess.STDOUT)

def spot(text):
    FNULL = open(os.devnull, 'w')
    retcode = subprocess.call(["spotify", text], stdout=FNULL, stderr=subprocess.STDOUT)

def main(argv):
    # export DBG_OSSIFY=1
    DBG = os.getenv('DBG_OSSIFY')
    print "DBG = " + str(DBG)

    # args
    try:
        opts, args = getopt.getopt(argv,"hs:r:n:q")
    except getopt.GetoptError:
        print 'ERROR in args'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print """
            HELP MENU
            """
            sys.exit()
        elif opt in ("-s"):
            skip_time = int(arg)
        elif opt in ("-r"):
            rj_mode = arg
        elif opt in ("-n"):
            num_songs = int(arg)
        elif opt in ("-q"):
            stop_after = True

    rj_says("ossify in session")
    spot_pos(0)
    for ii in range(1,num_songs+1):
        time.sleep(skip_time)
        if (stop_after and (ii == num_songs)):
            spot("pause")
            print "last song"
        else:
            spot("next")


    # debug code

if __name__ == "__main__":
       main(sys.argv[1:])
