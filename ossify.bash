#!/bin/bash

function ossify_theo_said() {
    echo "THEO_SAYS: ${1}"
    say $1
}

function ossify_theo_sign_off() {
    ossify_theo_said "Theo bidding off!"
}

function ossify_sleep() {
    if [ $OSSIFY_DEBUG ]
    then
      echo "sleeping for ${1}seconds"
    fi
    sleep "${1}s"
}

function ossify() {
    # args
    OSSIFY_PLAYLIST_NAME="${1}"
    OSSIFY_SKIP_TIME="${2}"
    OSSIFY_NUM_SONGS=${3}
    OSSIFY_THEO_MODE=${4}
    OSSIFY_QUIT_AFTER=${5}
    OSSIFY_OUT_LOC=${6}
    OSSIFY_ARMIN_DELAY=6
    OSSIFY_SKIP_COMP=1
    OSSIFY_SONG_COMP=3

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
        if [ ! -e ${OSSIFY_OUT_FILE} ]
        then
            echo "Error: Unable to create ${OSSIFY_OUT_FILE}! Exiting.."
        fi
    fi
    echo "---OSSIFY PLAY HISTORY----"                        >> ${OSSIFY_OUT_FILE} # the playbook begins...
    echo "OSSIFY_PLAYLIST_NAME: ${OSSIFY_PLAYLIST_NAME}"     >> ${OSSIFY_OUT_FILE}
    echo "OSSIFY_SKIP_TIME:     ${OSSIFY_SKIP_TIME}"         >> ${OSSIFY_OUT_FILE}
    echo "OSSIFY_NUM_SONGS:     ${OSSIFY_NUM_SONGS}"         >> ${OSSIFY_OUT_FILE}
    echo "OSSIFY_THEO_MODE:     ${OSSIFY_THEO_MODE}"         >> ${OSSIFY_OUT_FILE}
    echo "OSSIFY_QUIT_AFTER:    ${OSSIFY_QUIT_AFTER}"        >> ${OSSIFY_OUT_FILE}
    echo "OSSIFY_OUT_LOC:       ${OSSIFY_OUT_LOC}"           >> ${OSSIFY_OUT_FILE}
    echo "--------------------------"                        >> ${OSSIFY_OUT_FILE}

    for VAR in `seq 1 ${OSSIFY_NUM_SONGS}`
    do
        # next song
        spotify next
        spotify pause

        # get info
        OSSIFY_SONG_NAME=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_INFO_SECS=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`

        if [ $OSSIFY_PY_MATH ]
        then
            OSSIFY_SONG_SECS=`python -c "print ${OSSIFY_SONG_INFO_SECS}/1000"`
        else
            OSSIFY_SONG_SECS=`bc <<< "scale=2; ${OSSIFY_SONG_INFO_SECS}/1000"`
        fi

        # dbg print
        if [ $OSSIFY_DEBUG ]
        then
            echo "BASH DBG"
            echo "OSSIFY_SKIP_TIME = ${OSSIFY_SKIP_TIME}"
            echo "OSSIFY_SONG_NAME = ${OSSIFY_SONG_NAME}"
            echo "OSSIFY_AARTIST   = ${OSSIFY_AARTIST}"
            echo "OSSIFY_THEO_MODE = ${OSSIFY_THEO_MODE}"
            echo "OSSIFY_SONG_SECS = ${OSSIFY_SONG_SECS}"
            echo "BASH DBG"
        fi

        # standard spiel, more info?
        OSSIFY_THEO_SAYS="${OSSIFY_SONG_NAME} by ${OSSIFY_AARTIST}"
        echo "FIRST ISSUE $OSSIFY_THEO_SAYS"

        # classic mode, before play
        if [ $OSSIFY_THEO_MODE -eq 1 ]
        then
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: CLASSIC MODE"
            fi
          ossify_theo_said "$OSSIFY_THEO_SAYS"
        fi

        # start
        spotify play

        # armin mode, overlapped beginning
        if [ $OSSIFY_THEO_MODE -eq 2 ]
        then
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: ARMIN MODE"
            fi

            ossify_sleep "$OSSIFY_ARMIN_DELAY"
            ossify_theo_said "$OSSIFY_THEO_SAYS"
            if [ $OSSIFY_PY_MATH ]
            then
                OSSIFY_SONG_SECS=`python -c "print $OSSIFY_SONG_SECS - $OSSIFY_ARMIN_DELAY"`
            else
                OSSIFY_SONG_SECS=`bc <<< "scale=2; $OSSIFY_SONG_SECS - $OSSIFY_ARMIN_DELAY"`
            fi
            # adjust skip time
            if [ $OSSIFY_PY_MATH ]
            then
                OSSIFY_SKIP_TIME=`python -c "print $OSSIFY_SKIP_TIME - $OSSIFY_ARMIN_DELAY"`
            else
                OSSIFY_SKIP_TIME=`bc <<< "scale=2; $OSSIFY_SKIP_TIME - $OSSIFY_ARMIN_DELAY"`
            fi
        fi

        # keep track of what you listened to
        echo "PLAY #${VAR}"                  >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        spotify share                        >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        spotify info                         >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        echo "----END-OF-TRACK----------"    >> ${OSSIFY_OUT_FILE}

        if [ $OSSIFY_PY_MATH ]
        then
            OSSIFY_SONG_SECS_ADJ=`python -c "print $OSSIFY_SONG_SECS - $OSSIFY_SONG_COMP"`
        else
            OSSIFY_SONG_SECS_ADJ=`bc <<< "scale=2; $OSSIFY_SONG_SECS - $OSSIFY_SONG_COMP"`
        fi

        # CHECKME
        if [ $OSSIFY_SKIP_TIME == "f" ]
        then
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: FULL AUDIO PLAYBACK MODE"
            fi
            ossify_sleep $OSSIFY_SONG_SECS_ADJ
            spotify pause

        # CHECKME
        elif [ $OSSIFY_SKIP_TIME == "r" ]
        then
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: RANDOM TIME AUDIO PLAYBACK MODE"
            fi
            ossify_rand_min=30
            ossify_rand_max=${OSSIFY_SONG_SECS_ADJ}
            if [ $OSSIFY_PY_MATH ]
            then
                ossify_rand_diff=`python -c "print ${ossify_rand_max}-${ossify_rand_min}+1"`
            else
                ossify_rand_diff=`bc <<< "scale=2; ${ossify_rand_max}-${ossify_rand_min}+1"`
            fi

            RANDOM_DIFF=$RANDOM%${ossify_rand_diff}
            if [ $OSSIFY_PY_MATH ]
            then
                OSSIFY_RAND_SKIP_TIME=`python -c "print ${ossify_rand_min}+$RANDOM_DIFF-$OSSIFY_SKIP_COMP"`
            else
                OSSIFY_RAND_SKIP_TIME=`bc <<< "scale=2; ${ossify_rand_min}+$RANDOM_DIFF-$OSSIFY_SKIP_COMP"`
            fi

            ossify_sleep $OSSIFY_RAND_SKIP_TIME
            spotify pause

        else # regular skip delay
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: CONSTANT TIME AUDIO PLAYBACK MODE"
            fi

            # adjust
            if [ $OSSIFY_PY_MATH ]
            then
                OSSIFY_SKIP_TIME_ADJ=`python -c "print $OSSIFY_SKIP_TIME-$OSSIFY_SKIP_COMP"`
            else
                OSSIFY_SKIP_TIME_ADJ=`bc <<< "scale=2; $OSSIFY_SKIP_TIME-$OSSIFY_SKIP_COMP"`
            fi
            ossify_sleep "$OSSIFY_SKIP_TIME_ADJ"
            spotify pause

        fi

        # fyi mode
        if [ $OSSIFY_THEO_MODE -eq 3 ]
        then
            if [ $OSSIFY_DEBUG ]
            then
                echo "OSSIFY: FYI MODE"
            fi
            OSSIFY_THEO_SAYS="For Your Information... that was ${OSSIFY_THEO_SAYS}"
            ossify_theo_said "$OSSIFY_THEO_SAYS"
        fi

    done

    echo "----END-------------------"    >> ${OSSIFY_OUT_FILE} # end of playbook

    if [ $OSSIFY_QUIT_AFTER -eq 1 ]
    then
        ossify_theo_sign_off
        spotify quit
    fi
}


