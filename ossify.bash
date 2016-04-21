#!/bin/bash

function ossify_f2i() {
    local float=$1
    echo ${float%.*}
}

function ossify_poll_sleep() {
    sleep 0.2s
}

function ossify_sleep() {
    ossify_dp "sleeping for ${1}seconds"
    sleep "${1}s"
}

function ossify_poll_seconds_played() {
    while [ 1 ]
    do
        local ossify_seconds_played_int=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
        local ossify_song_info_seconds=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        local ossify_song_info_seconds_post=`bc <<< "scale=2; ${ossify_song_info_seconds}/1000"`
        local ossify_song_info_seconds_int=$(ossify_f2i $ossify_song_info_seconds_post)
        local ossify_seconds_left=$(( $ossify_song_info_seconds_int - $ossify_seconds_played_int ))
        ossify_dp "OSSIFY_POLL_SECONDS_PLAYED: ossify_seconds_left $ossify_seconds_left ossify_song_info_seconds_int $ossify_song_info_seconds_int ossify_seconds_played_int $ossify_seconds_played_int  ossify_song_info_seconds $ossify_song_info_seconds\n"
        ossify_poll_sleep
    done
}

function ossify_pause_at_next_start() {
    while [ 1 ]
    do
        local ossify_seconds_played_int=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
        local ossify_song_info_seconds=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        local ossify_song_info_seconds_post=`bc <<< "scale=2; ${ossify_song_info_seconds}/1000"`
        local ossify_song_info_seconds_int=$(ossify_f2i $ossify_song_info_seconds_post)
        local ossify_seconds_left=$(( $ossify_song_info_seconds_int - $ossify_seconds_played_int ))
        local ossify_seconds_left_thresh=4
        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: ossify_seconds_left $ossify_seconds_left ossify_song_info_seconds_int $ossify_song_info_seconds_int ossify_seconds_played_int $ossify_seconds_played_int  ossify_song_info_seconds $ossify_song_info_seconds\n"
        if [ $ossify_seconds_left -lt $ossify_seconds_left_thresh ]
        then
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: ossify_seconds_left $ossify_seconds_left is less than the threshold ossify_seconds_left_thresh $ossify_seconds_left_thresh\n"
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: going to next and pausing playback"
            spotify next > /dev/null
            spotify pause > /dev/null
            break
        fi
        ossify_poll_sleep
    done
}

# pause after skip time, variation of pause_after_full_song
function ossify_pause_after_skip_time() {
    while [ 1 ]
    do
        local ossify_song_skip_time=${1}
        local ossify_seconds_played_int=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
        local ossify_song_info_seconds=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        local ossify_song_info_seconds_post=`bc <<< "scale=2; ${ossify_song_info_seconds}/1000"`
        local ossify_song_info_seconds_int=$(ossify_f2i $ossify_song_info_seconds_post)
        local ossify_seconds_left=$(( $ossify_song_skip_time - $ossify_seconds_played_int ))
        local ossify_seconds_left_thresh=1
        ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: ossify_seconds_left $ossify_seconds_left ossify_song_info_seconds_int $ossify_song_info_seconds_int ossify_seconds_played_int $ossify_seconds_played_int  ossify_song_info_seconds $ossify_song_info_seconds\n"
        if [ $ossify_seconds_left -lt $ossify_seconds_left_thresh ] || [ $ossify_seconds_played_int -gt $ossify_song_skip_time ]
        then
            ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: ossify_seconds_left $ossify_seconds_left is less than the threshold ossify_seconds_left_thresh $ossify_seconds_left_thresh\n"
            ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: going to next and pausing playback"
            spotify next > /dev/null
            spotify pause > /dev/null
            break
        fi
        ossify_poll_sleep
    done
}

# main
function ossify() {
    # args
    OSSIFY_PLAYLIST_NAME="${1}"
    OSSIFY_SKIP_TIME="${2}"
    OSSIFY_SKIP_TIME_ARGS="${2}"
    OSSIFY_NUM_SONGS=${3}
    OSSIFY_THEO_MODE=${4}
    OSSIFY_QUIT_AFTER=${5}
    OSSIFY_OUT_LOC=${6}
    OSSIFY_ARMIN_DELAY=6
    OSSIFY_SKIP_COMP=3
    OSSIFY_MIN_PLAY_LENGTH=30

    if [ -z $OSSIFY_SKIP_TIME ] || [ -z $OSSIFY_PLAYLIST_NAME ] || [ -z $OSSIFY_NUM_SONGS ] || [ -z $OSSIFY_THEO_MODE ] || [ -z $OSSIFY_QUIT_AFTER ] || [ -z $OSSIFY_OUT_LOC ]
    then
        OSSIFY_PLAYLIST_NAME="UNKNOWN_ARTIST"
        OSSIFY_SKIP_TIME=30
        OSSIFY_NUM_SONGS=56
        OSSIFY_THEO_MODE=1
        OSSIFY_QUIT_AFTER=0
        OSSIFY_OUT_LOC="${HOME}/ossify_logs"
    fi

    ossify_dp "
        OSSIFY_PLAYLIST_NAME: ${OSSIFY_PLAYLIST_NAME} \n \
        OSSIFY_SKIP_TIME:     ${OSSIFY_SKIP_TIME}     \n \
        OSSIFY_NUM_SONGS:     ${OSSIFY_NUM_SONGS}     \n \
        OSSIFY_THEO_MODE:     ${OSSIFY_THEO_MODE}     \n \
        OSSIFY_QUIT_AFTER:    ${OSSIFY_QUIT_AFTER}    \n \
        OSSIFY_OUT_LOC:       ${OSSIFY_OUT_LOC}       \n \
        "

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

    if [ $OSSIFY_DEBUG_POLL_SECONDS_PLAYED ]
    then
        # cont debug print
        ossify_poll_seconds_played &
    fi

    # start at next song
    spotify next > /dev/null
    spotify pause > /dev/null

    # intro message
    if [ ${OSSIFY_THEO_MODE} -eq 1 ]
    then
        ossify_theo_said "Ossify, Classic Mode"
    elif [ ${OSSIFY_THEO_MODE} -eq 2 ]
    then
        ossify_theo_said "Ossify, Armin mode"
    elif [ ${OSSIFY_THEO_MODE} -eq 3 ]
    then
        ossify_theo_said "Ossify, FYI mode"
    else
        ossify_theo_said "Ossify, Quiet mode"
    fi

    for VAR in `seq 1 ${OSSIFY_NUM_SONGS}`
    do

        # get info
        OSSIFY_SONG_NAME=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_INFO_SECONDS=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_SECONDS=`bc <<< "scale=2; ${OSSIFY_SONG_INFO_SECONDS}/1000"`
        OSSIFY_SONG_SECONDS_INT=$(ossify_f2i ${OSSIFY_SONG_SECONDS})

        # keep track of what you listened to
        echo "PLAY #${VAR}"                                                           >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"                                             >> ${OSSIFY_OUT_FILE}
        spotify share | tr -dc "[:alnum:][:space:][:punct:]" | grep -v "\[1m\[32m"    >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"                                             >> ${OSSIFY_OUT_FILE}
        spotify info | tr -dc "[:alnum:][:space:][:punct:]" | grep -v "\[1m\[32m"     >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"                                             >> ${OSSIFY_OUT_FILE}
        echo "----END-OF-TRACK----------"                                             >> ${OSSIFY_OUT_FILE}

        # dbg print
        ossify_dp1 "                                           \
            ############################################### \n \
            SONG ${VAR}/${OSSIFY_NUM_SONGS}                 \n \
            ############################################### \n \
            OSSIFY_SKIP_TIME    = ${OSSIFY_SKIP_TIME}       \n \
            OSSIFY_SONG_NAME    = ${OSSIFY_SONG_NAME}       \n \
            OSSIFY_AARTIST      = ${OSSIFY_AARTIST}         \n \
            OSSIFY_THEO_MODE    = ${OSSIFY_THEO_MODE}       \n \
            OSSIFY_SONG_SECONDS = ${OSSIFY_SONG_SECONDS}    \n \
            ############################################### \n \
            "

        OSSIFY_TRACK_INFO_SIMPLE="${OSSIFY_SONG_NAME} by ${OSSIFY_AARTIST}"
        echo "SONG ${VAR}/${OSSIFY_NUM_SONGS}"
        echo "${OSSIFY_TRACK_INFO_SIMPLE}"

        if [ $OSSIFY_SKIP_TIME_ARGS == "r" ]
        then
            ossify_dp1 "OSSIFY: RANDOM TIME AUDIO PLAYBACK MODE"

            if [ $OSSIFY_SONG_SECONDS_INT -lt $OSSIFY_RAND_MIN ]
            then
              OSSIFY_RAND_MAX=$OSSIFY_SONG_SECONDS_INT
              OSSIFY_RAND_MIN=$OSSIFY_SONG_SECONDS_INT
            else
              OSSIFY_RAND_MAX=$(( ${OSSIFY_SONG_SECONDS_INT} - ${OSSIFY_MIN_PLAY_LENGTH} ))
              OSSIFY_RAND_MIN=30
            fi

            OSSIFY_RAND_DIFF=`bc <<< "scale=2; ${OSSIFY_RAND_MAX}-${OSSIFY_RAND_MIN}+1"`
            OSSIFY_RANDOM_DIFF=$RANDOM%${OSSIFY_RAND_DIFF}
            OSSIFY_RAND_SKIP_TIME=`bc <<< "scale=2; ${OSSIFY_RAND_MIN}+$OSSIFY_RANDOM_DIFF-$OSSIFY_SKIP_COMP"`
            OSSIFY_SKIP_TIME=$(ossify_f2i ${OSSIFY_RAND_SKIP_TIME})
            ossify_dp1 "OSSIFY: OSSIFY_RAND_SKIP_TIME $OSSIFY_SKIP_TIME OSSIFY_RAND_MAX $OSSIFY_RAND_MAX  OSSIFY_RAND_DIFF $OSSIFY_RAND_DIFF OSSIFY_RAND_MIN $OSSIFY_RAND_MIN"
        fi
        ossify_dp "OSSIFY: OSSIFY_SKIP_TIME $OSSIFY_SKIP_TIME"

        # classic mode, before play
        if [ $OSSIFY_THEO_MODE -eq 1 ]
        then
            ossify_dp "OSSIFY: CLASSIC MODE"
            #
            ossify_theo_said "$OSSIFY_TRACK_INFO_SIMPLE"
            spotify play > /dev/null

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME
            fi

        # overlapped beginning
        elif [ $OSSIFY_THEO_MODE -eq 2 ]
        then
            ossify_dp "OSSIFY: ARMIN MODE"
            spotify play > /dev/null

            ossify_sleep "$OSSIFY_ARMIN_DELAY"
            ossify_theo_said "$OSSIFY_TRACK_INFO_SIMPLE"

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME
            fi

        elif [ $OSSIFY_THEO_MODE -eq 3 ]
        then
            ossify_dp "OSSIFY: FYI MODE"
            spotify play > /dev/null

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME
            fi

            ossify_theo_said "For your information that was, $OSSIFY_TRACK_INFO_SIMPLE"

        elif [ $OSSIFY_THEO_MODE -eq 4 ]
        then
            ossify_dp "OSSIFY: THEO OFF MODE"
            spotify play > /dev/null

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME
            fi
        fi

    done

    echo "----END-------------------"    >> ${OSSIFY_OUT_FILE} # end of playbook

    #ossify_theo_said "Theo bidding off!"
    if [ $OSSIFY_QUIT_AFTER -eq 1 ]
    then
        ossify_theo_said "Theo bidding off!"
        spotify quit
    fi
}

function ossify_dp() {
    if [ $OSSIFY_DEBUG ]
    then
      printf "\n${1}\n"
    fi
}

function ossify_dp1() {
    if [ $OSSIFY_DEBUG1 ]
    then
      printf "\n${1}\n"
    fi
}

function ossify_theo_said() {
    ossify_dp "THEO_SAYS: ${1}"
    say $1
}


