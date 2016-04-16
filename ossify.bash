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
  OSSIFY_PLAYLIST_NAME="$1"
  OSSIFY_SKIP_TIME="$2"
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
  if [ $OSSIFY_DEBUG ]
  then
    echo "OSSIFY_PLAYLIST_NAME ${OSSIFY_PLAYLIST_NAME}"
    echo "OSSIFY_SKIP_TIME ${OSSIFY_SKIP_TIME}"
    echo "OSSIFY_NUM_SONGS ${OSSIFY_NUM_SONGS}"
    echo "OSSIFY_THEO_MODE ${OSSIFY_THEO_MODE}"
    echo "OSSIFY_QUIT_AFTER ${OSSIFY_QUIT_AFTER}"
    echo "OSSIFY_OUT_LOC ${OSSIFY_OUT_LOC}"
  fi

  # output log
  OSSIFY_TIMESTAMP=`date +"%m-%d-%y-%T"`
  OSSIFY_OUT_FILE="${OSSIFY_OUT_LOC}/${OSSIFY_PLAYLIST_NAME}_${OSSIFY_TIMESTAMP}.txt"
  if [ ! -d $OSSIFY_OUT_LOC ]
  then
    echo "Error: Output directory ${OSSIFY_OUT_LOC} doesn't exist! Exiting.."
    exit 2
  else
    touch ${OSSIFY_OUT_FILE}
    echo "Creating file ${OSSIFY_OUT_FILE}"

    if [ ! -e $OSSIFY_OUT_FILE ]
    then
      echo "Error: Unable to create ${OSSIFY_OUT_FILE}! Exiting.."
    fi
  fi
  # the playbook begins...
  echo "---OSSIFY PLAY HISTORY----"                        >> $OSSIFY_OUT_FILE
  echo "OSSIFY_PLAYLIST_NAME: ${OSSIFY_PLAYLIST_NAME}"     >> $OSSIFY_OUT_FILE
  echo "OSSIFY_SKIP_TIME:     ${OSSIFY_SKIP_TIME}"         >> $OSSIFY_OUT_FILE
  echo "OSSIFY_NUM_SONGS:     ${OSSIFY_NUM_SONGS}"         >> $OSSIFY_OUT_FILE
  echo "OSSIFY_THEO_MODE:     ${OSSIFY_THEO_MODE}"         >> $OSSIFY_OUT_FILE
  echo "OSSIFY_QUIT_AFTER:    ${OSSIFY_QUIT_AFTER}"        >> $OSSIFY_OUT_FILE
  echo "OSSIFY_OUT_LOC:       ${OSSIFY_OUT_LOC}"           >> $OSSIFY_OUT_FILE
  echo "--------------------------"                        >> $OSSIFY_OUT_FILE

  for VAR in `seq 1 ${OSSIFY_NUM_SONGS}`
  do

    # next song
    spotify next
    spotify pause

    # get info
    OSSIFY_SONGT=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
    OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
    OSSIFY_SONG_INFO_SECS=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
    OSSIFY_SONG_SECS=$(($OSSIFY_SONG_INFO_SECS/1000))

    # dbg print
    if [ $OSSIFY_DEBUG ]
    then
      echo "BASH DBG"
      echo "OSSIFY_SKIP_TIME = $OSSIFY_SKIP_TIME"
      echo "OSSIFY_AARTIST   = $OSSIFY_AARTIST"
      echo "OSSIFY_THEO_MODE = $OSSIFY_THEO_MODE"
      echo "OSSIFY_SONG_SECS = $OSSIFY_SONG_SECS"
      echo "BASH DBG"
    fi

    # standard spiel, more info?
    OSSIFY_THEO_SAYS="${OSSIFY_SONGT} by ${OSSIFY_AARTIST}"

    # classic mode, before play
    if [ $OSSIFY_THEO_MODE -eq 1 ]
    then
      ossify_theo_said
    fi

    # start
    spotify play

    # armin mode, overlapped beginning
    if [ $OSSIFY_THEO_MODE -eq 2 ]
    then
      sleep 6s
      ossify_theo_said
      OSSIFY_SKIP_TIME_ADJ=`expr ${OSSIFY_SKIP_TIME_ADJ} - 6`
    fi

    # keep track of what you listened to
    echo "PLAY #${VAR}"                  >> $OSSIFY_OUT_FILE
    echo "--------------------------"    >> $OSSIFY_OUT_FILE
    spotify share                        >> $OSSIFY_OUT_FILE
    echo "--------------------------"    >> $OSSIFY_OUT_FILE
    spotify info                         >> $OSSIFY_OUT_FILE
    echo "--------------------------"    >> $OSSIFY_OUT_FILE
    echo "----END-OF-TRACK----------"    >> $OSSIFY_OUT_FILE

    # song play
    if [ $OSSIFY_SKIP_TIME = "f" ]
    then
      sleep ${OSSIFY_SONG_SECS}s
      spotify pause
    elif [ $OSSIFY_SKIP_TIME = "r" ]
    then
      OSSIFY_RAND_SKIP_TIME=`shuf -i 0-${OSSIFY_SONG_SECS} -n 1`
      if [ $OSSIFY_DEBUG ]
      then
        echo "$OSSIFY_RAND_SKIP_TIME"
      fi

      sleep ${OSSIFY_RAND_SKIP_TIME}s
      spotify pause
    else
      # crude way to match gui
      OSSIFY_SKIP_TIME_ADJ=`expr $OSSIFY_SKIP_TIME - 1`

      sleep ${OSSIFY_SKIP_TIME_ADJ}s
      spotify pause
    fi

    # fyi mode
    if [ $OSSIFY_THEO_MODE -eq 3 ]
    then
      OSSIFY_THEO_SAYS="For Your Information... that was ${OSSIFY_THEO_SAYS}"
      ossify_theo_said
    fi

  done

  # end of playbook
  echo "----END-------------------"    >> $OSSIFY_OUT_FILE

  if [ $OSSIFY_QUIT_AFTER -eq 1 ]
  then
    ossify_theo_sign_off
    spotify quit
  fi
}
