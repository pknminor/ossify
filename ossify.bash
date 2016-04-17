#!/bin/bash

function ossify_f2i() {
    local float=$1
    echo ${float%.*}
}

function ossify_dp() {
    if [ $OSSIFY_DEBUG ]
    then
      printf "$1"
    fi
}

function ossify_theo_said() {
    echo "THEO_SAYS: ${1}"
    say $1
}

function ossify_theo_sign_off() {
    ossify_theo_said "Theo bidding off!"
}

function ossify_sleep() {
    ossify_dp "sleeping for ${1}seconds"
    sleep "${1}s"
}

function ossify_pause_at_next_start() {
    # continuously poll spoitfy info and keep track of the diff between song seconds and seconds played
    # when diff is close enough to 0 pause for all RJ modes
    local ossigy_song_secs_flt=$1
    local ossify_song_secs_adj=$2
    local ossify_skip_time_adj=$3
    local ossify_skip_comp=$4
    local ossify_rand_skip_time=$5
    local ossify_skip_time=$6
    while [ 1 ]
    do
        local ossify_seconds_played=`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`

        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds played $ossify_seconds_played\n"

        local ossify_seconds_played_int=$(ossify_f2i $ossify_seconds_played)
        local ossify_song_seconds_int=$(ossify_f2i ${ossigy_song_secs_flt})

        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds played int $ossify_seconds_played_int\n"

        local ossify_seconds_left_int=$(( $ossify_song_seconds_int - $ossify_seconds_played_int ))

        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds left $ossify_seconds_left_int\n"


        # convert to int or find float operators
        if [ $ossify_seconds_left_int -lt 2 ]
        then
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds left less than 2"
            spotify pause
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: after pause\n"
          break
        elif [ $OSSIFY_SKIP_TIME == "r" ]
        then
            ossify_dp "OSSIFY: RANDOM TIME AUDIO PLAYBACK MODE\n"
            ossify_rand_min=30
            ossify_rand_max=${ossify_song_secs_adj}
            ossify_rand_diff=`bc <<< "scale=2; ${ossify_rand_max}-${ossify_rand_min}+1"`

            RANDOM_DIFF=$RANDOM%${ossify_rand_diff}
            ossify_rand_skip_time=`bc <<< "scale=2; ${ossify_rand_min}+$random_diff-$ossify_skip_comp"`

            ossify_sleep $ossify_rand_skip_time
            spotify pause

        elif [ $OSSIFY_SKIP_TIME != "f" ] # regular skip delay
        then
            ossify_dp "OSSIFY: CONSTANT TIME AUDIO PLAYBACK MODE\n"

            # adjust
            ossify_skip_time_adj=`bc <<< "scale=2; $ossify_skip_time-$ossify_skip_comp"`
            ossify_sleep "$ossify_skip_time_adj"
            spotify pause
        fi
        sleep {0.01}s
    done
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

    for VAR in `seq 1 ${OSSIFY_NUM_SONGS}`
    do
        if [ ! $OSSIFY_SKIP_TIME == "f" ]
        then
          # next song
          # FIXME
          spotify next
        fi

        # get info
        OSSIFY_SONG_NAME=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_INFO_SECS=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_SECS=`bc <<< "scale=2; ${OSSIFY_SONG_INFO_SECS}/1000"`

        # dbg print
        ossify_dp "                                   \n \
            OSSIFY_SKIP_TIME = ${OSSIFY_SKIP_TIME}    \n \
            OSSIFY_SONG_NAME = ${OSSIFY_SONG_NAME}    \n \
            OSSIFY_AARTIST   = ${OSSIFY_AARTIST}      \n \
            OSSIFY_THEO_MODE = ${OSSIFY_THEO_MODE}    \n \
            OSSIFY_SONG_SECS = ${OSSIFY_SONG_SECS}    \n \
            "

        # standard spiel, more info?
        OSSIFY_THEO_SAYS="${OSSIFY_SONG_NAME} by ${OSSIFY_AARTIST}"
        echo "FIRST ISSUE $OSSIFY_THEO_SAYS"

        # classic mode, before play
        if [ $OSSIFY_THEO_MODE -eq 1 ]
        then
            ossify_dp "OSSIFY: CLASSIC MODE"
            ossify_theo_said "$OSSIFY_THEO_SAYS"
        fi

        # start
        spotify play

        # armin mode, overlapped beginning
        if [ $OSSIFY_THEO_MODE -eq 2 ]
        then
            ossify_dp "OSSIFY: ARMIN MODE"

            ossify_sleep "$OSSIFY_ARMIN_DELAY"
            ossify_theo_said "$OSSIFY_THEO_SAYS"
            OSSIFY_SONG_SECS=`bc <<< "scale=2; $OSSIFY_SONG_SECS - $OSSIFY_ARMIN_DELAY"`
            # adjust skip time
            OSSIFY_SKIP_TIME=`bc <<< "scale=2; $OSSIFY_SKIP_TIME - $OSSIFY_ARMIN_DELAY"`
        fi

        # keep track of what you listened to
        echo "PLAY #${VAR}"                  >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        spotify share                        >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        spotify info                         >> ${OSSIFY_OUT_FILE}
        echo "--------------------------"    >> ${OSSIFY_OUT_FILE}
        echo "----END-OF-TRACK----------"    >> ${OSSIFY_OUT_FILE}

        OSSIFY_SONG_SECS_ADJ=`bc <<< "scale=2; $OSSIFY_SONG_SECS - $OSSIFY_SONG_COMP"`

        # FIXME # IMPROVEME
        ossify_pause_at_next_start ${OSSIFY_SONG_SECS} ${OSSIFY_SONG_SECS_ADJ} ${OSSIFY_SKIP_TIME_ADJ} ${OSSIFY_SKIP_COMP} ${OSSIFY_RAND_SKIP_TIME} ${OSSIFY_SKIP_TIME} &

        # fyi mode
        if [ $OSSIFY_THEO_MODE -eq 3 ]
        then
            ossify_dp "OSSIFY: FYI MODE\n"
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





