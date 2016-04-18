#!/bin/bash

function ossify_f2i() {
    local float=$1
    echo ${float%.*}
}

function ossify_dp() {
    if [ $OSSIFY_DEBUG ]
    then
      printf "\n${1}\n"
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

#function ossify_pause_at_next_start() {
#    local ossigy_song_seconds_flt=$1
#    local ossify_song_seconds_adj=$2
#    local ossify_skip_time_adj=$3
#    local ossify_skip_comp=$4
#    local ossify_rand_skip_time=$5
#    local ossify_skip_time=$6
#    while [ 1 ]
#    do
#        local ossify_seconds_played=`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`
#
#        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds played $ossify_seconds_played\n"
#
#        local ossify_seconds_played_int=$(ossify_f2i $ossify_seconds_played)
#        local ossify_song_seconds_int=$(ossify_f2i ${ossigy_song_seconds_flt})
#
#        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds played int $ossify_seconds_played_int\n"
#
#        local ossify_seconds_left_int=$(( $ossify_song_seconds_int - $ossify_seconds_played_int ))
#
#        ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds left $ossify_seconds_left_int\n"
#
#        # skip time calculation
#
#        if [ $ossify_skip_time == "f" ]
#        then
#            continue
#        elif [ $ossify_seconds_left_int -lt 2 ]
#        then
#            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: seconds left less than 2"
#            spotify pause
#            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: after pause"
#            # FIXME
#            break
#        elif [ $ossify_skip_time == "r" ]
#        then
#            ossify_dp "OSSIFY: RANDOM TIME AUDIO PLAYBACK MODE"
#            ossify_rand_min=30
#            ossify_rand_max=${ossify_song_seconds_adj}
#            ossify_rand_diff=`bc <<< "scale=2; ${ossify_rand_max}-${ossify_rand_min}+1"`
#
#            RANDOM_DIFF=$RANDOM%${ossify_rand_diff}
#            ossify_rand_skip_time=`bc <<< "scale=2; ${ossify_rand_min}+$random_diff-$ossify_skip_comp"`
#
#            ossify_sleep $ossify_rand_skip_time
#            spotify pause
#
#        elif [ $ossify_skip_time != "f" ] # regular skip delay
#        then
#            ossify_dp "OSSIFY: CONSTANT TIME AUDIO PLAYBACK MODE"
#
#            # adjust
#            ossify_skip_time_adj=`bc <<< "scale=2; $ossify_skip_time-$ossify_skip_comp"`
#            ossify_sleep "$ossify_skip_time_adj"
#            spotify pause
#        fi
#        sleep {0.01}s
#    done
# }

function ossify_poll_seconds_played() {
    while [ 1 ]
    do
        local ossify_seconds_played_int=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
        local ossify_song_info_seconds=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        local ossify_song_info_seconds_post=`bc <<< "scale=2; ${ossify_song_info_seconds}/1000"`
        local ossify_song_info_seconds_int=$(ossify_f2i $ossify_song_info_seconds_post)
        local ossify_seconds_left=$(( $ossify_song_info_seconds_int - $ossify_seconds_played_int ))
        ossify_dp "OSSIFY_POLL_SECONDS_PLAYED: ossify_seconds_left $ossify_seconds_left ossify_song_info_seconds_int $ossify_song_info_seconds_int ossify_seconds_played_int $ossify_seconds_played_int  ossify_song_info_seconds $ossify_song_info_seconds\n"
        sleep {0.01}s
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
        if [ $ossify_seconds_left -lt 4 ]
        then
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: ossify_seconds_left $ossify_seconds_left is less than the threshold ossify_seconds_left_thresh $ossify_seconds_left_thresh\n"
            ossify_dp "OSSIFY_PAUSE_AT_NEXT_START: going to next and pausing playback"
            spotify next
            spotify pause
        fi
        sleep {0.01}s
    done
}

# pause after skip time, variation of pause_after_full_song
# TODO
# minimize sub-shell calls
function ossify_pause_after_skip_time() {
    while [ 1 ]
    do
        local ossify_song_skip_time=${1}
        local ossify_seconds_played_int=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
        local ossify_song_info_seconds=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        local ossify_song_info_seconds_post=`bc <<< "scale=2; ${ossify_song_info_seconds}/1000"`
        local ossify_song_info_seconds_int=$(ossify_f2i $ossify_song_info_seconds_post)
        local ossify_seconds_left=$(( $ossify_song_skip_time - $ossify_seconds_played_int ))
        ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: ossify_seconds_left $ossify_seconds_left ossify_song_info_seconds_int $ossify_song_info_seconds_int ossify_seconds_played_int $ossify_seconds_played_int  ossify_song_info_seconds $ossify_song_info_seconds\n"
        if [ $ossify_seconds_left -lt 4 ]
        then
            ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: ossify_seconds_left $ossify_seconds_left is less than the threshold ossify_seconds_left_thresh $ossify_seconds_left_thresh\n"
            ossify_dp "OSSIFY_PAUSE_AFTER_SKIP_TIME: going to next and pausing playback"
            spotify next
            spotify pause
        fi
        sleep {0.01}s
    done
}

# make song stop playing, if its playing or currently paused, "spotify pause" acts like play/pause
function ossify_pause() {
    local ossigy_pause_sleep_seconds=1
    local ossify_seconds_played_int_before=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
    sleep ${ossify_pause_sleep_seconds}s
    local ossify_seconds_played_int_after=$(ossify_f2i "`spotify info |  sed -n 's/Seconds played:[[:space:]]*\(.*\)/\1/p'`")
    if [ $ossify_seconds_played_int_before -ne $ossify_seconds_played_int_after ]
    then
        spotify pause
    fi
}

# 
function ossify_pause_at_curr_song_start() {
    spotify pos 0
    spotify pause
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
    OSSIFY_RAND_MIN=30

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
        # cont debug print
        ossify_poll_seconds_played &

        # get info
        OSSIFY_SONG_NAME=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_INFO_SECONDS=`spotify info | sed -n 's/Seconds:[[:space:]]*\(.*\)/\1/p'`
        OSSIFY_SONG_SECONDS=`bc <<< "scale=2; ${OSSIFY_SONG_INFO_SECONDS}/1000"`
        OSSIFY_SONG_SECONDS_INT=$(ossify_f2i ${OSSIFY_SONG_SECONDS})

        # dbg print
        ossify_dp "                                            \
            OSSIFY_SKIP_TIME = ${OSSIFY_SKIP_TIME}          \n \
            OSSIFY_SONG_NAME = ${OSSIFY_SONG_NAME}          \n \
            OSSIFY_AARTIST   = ${OSSIFY_AARTIST}            \n \
            OSSIFY_THEO_MODE = ${OSSIFY_THEO_MODE}          \n \
            OSSIFY_SONG_SECONDS = ${OSSIFY_SONG_SECONDS}    \n \
            "

        # standard spiel, more info?
        OSSIFY_TRACK_INFO="${OSSIFY_SONG_NAME} by ${OSSIFY_AARTIST}"
        echo "FIRST ISSUE $OSSIFY_TRACK_INFO"

        if [ $OSSIFY_SKIP_TIME == "r" ]
        then
            ossify_dp "OSSIFY: RANDOM TIME AUDIO PLAYBACK MODE"
            OSSIFY_RAND_MAX=${OSSIFY_SONG_SECONDS_INT}
            OSSIFY_RAND_DIFF=`bc <<< "scale=2; ${OSSIFY_RAND_MAX}-${OSSIFY_RAND_MIN}+1"`

            OSSIFY_RANDOM_DIFF=$RANDOM%${OSSIFY_RAND_DIFF}
            OSSIFY_RAND_SKIP_TIME=`bc <<< "scale=2; ${OSSIFY_RAND_MIN}+$OSSIFY_RANDOM_DIFF-$OSSIFY_SKIP_COMP"`
            OSSIFY_SKIP_TIME=$OSSIFY_RAND_SKIP_TIME
        fi
        ossify_dp "OSSIFY: OSSIFY_SKIP_TIME $OSSIFY_SKIP_TIME"

        # classic mode, before play
        if [ $OSSIFY_THEO_MODE -eq 1 ]
        then
            ossify_dp "OSSIFY: CLASSIC MODE"
            ossify_theo_said "$OSSIFY_TRACK_INFO"
            # make song stop playing
            ossify_pause
            spotify pos 0
            spotify play

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start &
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME &
            fi

        elif [ $OSSIFY_THEO_MODE -eq 2 ]# overlapped beginning
        then
            ossify_dp "OSSIFY: ARMIN MODE"
            spotify pos 0
            spotify play

            ossify_sleep "$OSSIFY_ARMIN_DELAY"
            ossify_theo_said "$OSSIFY_TRACK_INFO"

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start &
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME &
            fi
        elif [ $OSSIFY_THEO_MODE -eq 3 ]
        then
            ossify_dp "OSSIFY: FYI MODE"
            spotify pos 0
            spotify play

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start &
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME &
            fi

            ossify_theo_said "$OSSIFY_TRACK_INFO"

        elif [ $OSSIFY_THEO_MODE -eq 4 ]
        then
            ossify_dp "OSSIFY: THEO OFF MODE"
            spotify pos 0
            spotify play

            if [ $OSSIFY_SKIP_TIME == "f" ]
            then
                ossify_pause_at_next_start &
            else
                ossify_pause_after_skip_time $OSSIFY_SKIP_TIME &
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

        OSSIFY_SONG_SECONDS_ADJ=`bc <<< "scale=2; $OSSIFY_SONG_SECS - $OSSIFY_SONG_COMP"`

    done

    echo "----END-------------------"    >> ${OSSIFY_OUT_FILE} # end of playbook

    if [ $OSSIFY_QUIT_AFTER -eq 1 ]
    then
        ossify_theo_sign_off
        spotify quit
    fi
}





