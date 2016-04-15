# ossify

Ossify, your Spotify listening companion, eases the *tedium* of music discovery and recollection.
The idea is to automate the RJ(Radio Jockey) experience and keep track of what you had listened to.

Change songs after *X* seconds, get artist and song information via audio.

PS: I rarely listen to an entire song when discovering new music.
Might not be as useful for you depending on your listening style.

# Prerequisites
- https://github.com/hnarayanan/shpotify
- OSX El Capitan(10.11.2)
- Spotify(1.0.26.132.ga4e3ccee)
- Bash(3.2)
- Optional: NoSleep(http://www.macupdate.com/app/mac/37991/nosleep)

# Instructions
## Source the bash script "ossify.bash"

## Usage

- Start a playlist or an artist page on the Spotify GUI, with or without shuffle.

- Launch ossify from the terminal.

>  For example,
>  ossify ramones 45 30 3 0 ~/ossify_logs
>
>  Usage:
>
>      ossify <playlist-name> <time-per-song> <number-of-songs> <theo-mode, aka your RJ> <quit-after> "<log-location>"
>
>      <playlist-name>   = Playlist name
>      <time-per-song>   = Recommended between 0-45
>      <number-of-songs> = >0
>      <theo-mode>       = 1, Classic Mode, Theo speaks before the song
>                          2, Armin Mode, Theo speaks at the begining of the song
>                          3, FYI Mode, Theo speaks at the end of play(s)
>      <quit-after>      = 0, Keep listening to the music..
>                          1, Quit after <number-of-songs>
>      <log-location>    = Logfile path, default is HOME/ossify_logs
>

## Have fun!
