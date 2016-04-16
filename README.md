# ossify

Ossify, your Spotify listening companion, eases the *tedium* of music discovery and recollection.
The idea is to automate the RJ(Radio Jockey) experience and keep track of what you had listened to.

Change songs after a certain amount of time, get artist and song information via audio feedback during song play.

# Prerequisites
- https://github.com/hnarayanan/shpotify
- OSX El Capitan(10.11.2)
- Spotify(1.0.26.132.ga4e3ccee)
- Bash(3.2)
- Optional: NoSleep(http://www.macupdate.com/app/mac/37991/nosleep)

# Instructions
1. source ossify.bash from your ${HOME}/.bashrc

2. run ossify

>  1. Start a playlist or an artist page on the Spotify GUI, with or without shuffle.
>
>  2. Launch ossify from the terminal.
>
> >  For example,
> >  ossify ramones 45 30 3 0 ~/ossify_logs
>
> >  Usage:
>
> >      ossify <playlist-name> <time-per-song> <number-of-songs> <theo-mode, aka your RJ> <quit-after> <log-location>
>
> >      <playlist-name>   = Playlist name
> >      <time-per-song>   = (0-180), switch time in seconds
> >                          f, full song
> >                          r, random switch
> >      <number-of-songs> = >0
> >      <theo-mode>       = 1, Classic Mode, Theo speaks before the song
> >                          2, Armin Mode, Theo speaks at the begining of the song
> >                          3, FYI Mode, Theo speaks at the end of play(s)
> >                          4, Off*, Theo sleeps for a while
> >      <quit-after>      = 0, Keep listening to the music..
> >                          1, Quit after <number-of-songs>, Theo speaks at the end of all play(s)
> >      <log-location>    = Logfile path, default is HOME/ossify_logs
>
>
>     ossify will write out a file with your listening history. eg. ramones_04-15-16-17:54:10.txt for your future reference.

## Have fun!
