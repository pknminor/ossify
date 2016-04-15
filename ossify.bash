function ossify_fade_in() {
    # fade in
	  for i in `seq 1 3`
	  do
      spotify vol down
      sleep 0.1s
    done
}

function ossify_theo_sign_off() {
  THEO_SAYS="Theo bidding off, Have fun!"
  echo "THEO_SAYS: $THEO_SAYS"
  spotify vol 30
  say $THEO_SAYS
}

function theo_said() {
  echo "THEO_SAYS: $THEO_SAYS"
  say $THEO_SAYS
}

function ossify() {
  PLAYLIST_NAME=$1
  SKIP_TIME=$2
  NUM_SONGS=$3
  # 1-classic 2-armin 3-fyi
  THEO_MODE=$4
  if [ -z $SKIP_TIME ] || [ -z $PLAYLIST_NAME ] || [ -z $NUM_SONGS ] || [ -z $THEO_MODE ]
  then
    PLAYLIST_NAME="unknown_artist"
    SKIP_TIME=30
    NUM_SONGS=56
    THEO_MODE=1
  fi

  # offset with compensation in seconds
  SKIP_TIME_ADJ=`expr $SKIP_TIME - 2`
	for VAR in `seq 1 ${NUM_SONGS}`
	do

    spotify vol 100

    spotify pause

    ossify_fade_in

    spotify next

    # massage current track info
    SONGT=`spotify info |  sed -n 's/Track:[[:space:]]*\(.*\)/\1/p'`
    AARTIST=`spotify info | sed -n 's/Album Artist:[[:space:]]*\(.*\)/\1/p'`
    THEO_SAYS="${SONGT} by ${AARTIST}"

    # print debug
    echo "BASH DBG"
    echo "SKIP_TIME = $SKIP_TIME"
    echo "AARTIST = $AARTIST"
    echo "THEO_MODE = $THEO_MODE"
    echo "BASH DBG"

    # classic mode
    if [ $THEO_MODE -eq 1 ]
    then
      spotify pause
      theo_said
    fi

    # start playback
    spotify vol 100

    spotify play

    # armin mode
    if [ $THEO_MODE -eq 2 ]
    then
      sleep 6s
      theo_said
    fi

    # logging debug mode
    echo "SONG #${VAR}"                  | tee -a ${PLAYLIST_NAME}_${NUM_SONGS}songs_${SKIP_TIME}seconds_info.txt
    spotify share                        | tee -a ${PLAYLIST_NAME}_${NUM_SONGS}songs_${SKIP_TIME}seconds_info.txt
    spotify info                         | tee -a ${PLAYLIST_NAME}_${NUM_SONGS}songs_${SKIP_TIME}seconds_info.txt
    echo "----------------"              | tee -a ${PLAYLIST_NAME}_${NUM_SONGS}songs_${SKIP_TIME}seconds_info.txt

    sleep ${SKIP_TIME}s

    # fyi mode
    if [ $THEO_MODE -eq 3 ]
    then
      spotify pause
      THEO_SAYS="For Your Information... that was ${THEO_SAYS}"
      theo_said
    fi

  done
  ossify_theo_sign_off

}
