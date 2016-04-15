#!/bin/bash

function ossify_theo_said() {
  echo "THEO_SAYS: $OSSIFY_THEO_SAYS"
  say $OSSIFY_THEO_SAYS
}

function ossify_theo_sign_off() {
  OSSIFY_THEO_SAYS="Theo bidding off!"
  ossify_theo_said
}

function ossify() {

  # args
  OSSIFY_PLAYLIST_NAME=$1
  OSSIFY_SKIP_TIME=$2
  OSSIFY_NUM_SONGS=$3
  OSSIFY_THEO_MODE=$4
  OSSIFY_QUIT_AFTER=$5
  OSSIFY_OUT_LOC=$6
  if [ -z $OSSIFY_SKIP_TIME ] || [ -z $OSSIFY_PLAYLIST_NAME ] || [ -z $OSSIFY_NUM_SONGS ] || [ -z $OSSIFY_THEO_MODE ] || [ -z $OSSIFY_QUIT_AFTER ] || [ -z $OSSIFY_OUT_LOC ]
  then
    OSSIFY_PLAYLIST_NAME="UNKNOWN_ARTIST"
    OSSIFY_SKIP_TIME=30
    OSSIFY_NUM_SONGS=56
    OSSIFY_THEO_MODE=1
    OSSIFY_QUIT_AFTER=0
    OSSIFY_OUT_LOC="${HOME}/ossify_logs"
  fi

  # output logs
  OSSIFY_TIMESTAMP=`date +"%m-%d-%y-%T"`
  OSSIFY_OUT_FILE="${OSSIFY_OUT_LOC}/${OSSIFY_PLAYLIST_NAME}_${OSSIFY_TIMESTAMP}.txt"
  if [ ! -d $OSSIFY_OUT_LOC ]
  then
    echo " Error: Output directory ${OSSIFY_OUT_LOC} doesn't exist! Exiting.."
    exit 2
  else
    touch ${OSSIFY_OUT_FILE}
    if [ ! -e $OSSIFY_OUT_FILE ]
    then
      echo " Error: Unable to create ${OSSIFY_OUT_FILE}! Exiting.."
    fi
  fi
  echo "OSSIFY LOGFILE" > ${OSSIFY_OUT_FILE}

  # crude way to match gui
  OSSIFY_SKIP_TIME_ADJ=`expr $OSSIFY_SKIP_TIME - 1`

  for VAR in `seq 1 ${OSSIFY_NUM_SONGS}`
  do

    # pause current play at start
    spotify pause

    # next song
    spotify next
    spotify pause

    # get info
    OSSIFY_SONGT=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
    OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
    OSSIFY_THEO_SAYS="${OSSIFY_SONGT} by ${OSSIFY_AARTIST}"

    # dbg print
    if [ ! -z $OSSIFY_DEBUG ]
    then
      echo "BASH DBG"
      echo "SKIP_TIME = $OSSIFY_SKIP_TIME"
      echo "AARTIST   = $OSSIFY_AARTIST"
      echo "THEO_MODE = $OSSIFY_THEO_MODE"
      echo "BASH DBG"
    fi

    # classic mode, before play
    if [ $OSSIFY_THEO_MODE -eq 1 ]
    then
      ossify_theo_said
    fi

    # START
    spotify play

    # armin mode, overlapped beginning
    if [ $OSSIFY_THEO_MODE -eq 2 ]
    then
      sleep 6s
      ossify_theo_said
      OSSIFY_SKIP_TIME_ADJ=`expr ${OSSIFY_SKIP_TIME_ADJ} - 6`
    fi

    # keep track of what you listened to
    echo "SONG #${VAR}"                  >> $OSSIFY_OUT_FILE
    spotify share                        >> $OSSIFY_OUT_FILE
    spotify info                         >> $OSSIFY_OUT_FILE
    echo "----------------"              >> $OSSIFY_OUT_FILE

    # song play
    sleep ${OSSIFY_SKIP_TIME_ADJ}s

    # fyi mode
    if [ $OSSIFY_THEO_MODE -eq 3 ]
    then
      spotify pause
      OSSIFY_THEO_SAYS="For Your Information... that was ${OSSIFY_THEO_SAYS}"
      ossify_theo_said
    fi

  done
  if [ $OSSIFY_QUIT_AFTER -eq 1 ]
  then
    ossify_theo_sign_off
    spotify quit
  fi
}
