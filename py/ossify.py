#!/usr/bin/python
import sys
import itertools
import timeit
from operator import mul
from random import randint
from bigfloat import *
from lxml import etree
import os, sys, getopt
import math
import subprocess

# functions
def sample_func(data):
    True

def rj_says(text):
    subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) - 30) --100%'])
    subprocess.call(["say", text])
    subprocess.call(['osascript', '-e','set volume output volume (output volume of (get volume settings) + 30) --100%'])

def main(argv):
    # get debug flag from env
    # export DBG_OSSIFY=1
    DBG = os.getenv('DBG_OSSIFY')
    print "DBG = " + str(DBG)

    # args
    try:
        opts, args = getopt.getopt(argv,"hs:r:n:q:")
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
            quit_after = arg

    print "skip time = " + str(skip_time)
    print "radio mode = " + rj_mode
    rj_says("HELLO")

if __name__ == "__main__":
       main(sys.argv[1:])
