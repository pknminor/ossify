# ossify

*ossify*, your Spotify listening companion, eases the *tedium* of music discovery and recollection.
The idea is to automate the RJ(Radio Jockey) experience and keep track of what you had listened to.

Change songs after a certain or random amount of time, get artist and song information via audio feedback during song play.

# Prerequisites
- https://github.com/hnarayanan/shpotify
- osx
- spotify(1.0.26.132.ga4e3ccee, premium recommended*)
- bash(3.2)
- optional: NoSleep(http://www.macupdate.com/app/mac/37991/nosleep)

# Instructions
1. source ossify.bash from your ${HOME}/.bashrc

2. running ossify

>  1. Start a playlist or an artist page on the Spotify GUI, with or without shuffle.
>
>  2. Launch ossify from the terminal.
>
> >  For example,
> > 
> >  number-of-songs: 30, time-per-play: 45, RJ-mode: fyi
> > 
> >  ~: ossify ramones 45 30 3 0 ~/ossify_logs
> > 
> >  Usage:
>
> >      ossify <playlist-name> <time-per-play> <number-of-plays> <RJ-mode> <exit> <log-location>
>
> >      <playlist-name>   = playlist name
> >      <time-per-play>   = (0-180), seconds
> >                          f, full song
> >                          r, random switch
> >      <number-of-songs> = >0
> >      <RJ-mode>         = 1, classic, RJ speaks before play
> >                          2, armin, RJ speaks during play at the begining
> >                          3, fyi, RJ speaks at the end of play
> >                          4, off, RJ turned off
> >      <exit>            = 0, pause after
> >                          1, quit after
> >      <log-location>    = play history file, default is $HOME/ossify_logs
>
>
>     ossify will write out your listening history. eg. ramones_04-15-16-17:54:10.txt for your future reference.

## Have fun!
