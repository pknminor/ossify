# ossify

Ossify, your Spotify listening companion eases the *tedium* of music discovery and recollection.
The idea is to automate the RJ experience and keep track of what you had listened to.

Change songs after <X> seconds, get artist and song information via your speakers.

PS: I rarely listen to entire songs when disocvering new music.
Might not be as useful depending on your listening style.

# Prerequisites
- https://github.com/hnarayanan/shpotify
- OSX El Capitan(10.11.2)
- Spotify(1.0.26.132.ga4e3ccee)
- Bash(3.2)

# Instructions
1. Add this to your aliases, bashrc:
source ossify.bash

2. Use the bash function "ossify"
>
>  Usage:
>
>      ossify <playlist-name> <time-per-song> <number-of-songs> <theo-mode, aka your RJ>
>
>      <playlist-name>   = Playlist name
>      <time-per-song>   = Recommended between 0-45
>      <number-of-songs> = >0
>      <theo-mode>       = 1, Classic Mode, Theo speaks before the song
>                          2, Armin Mode, Theo speaks at the begining of the song
>                          3, FYI Mode, Theo speaks at the end of play(s)
>      <quit-after>      = 0, Keep listening to the music..
>                          1, Quit after <number-of-songs>
>
3. Have fun!
