# ossify

*ossify*, your Spotify listening companion, eases the *tedium* of music discovery and recollection.
The idea is to automate the Radio Jockey experience and keep record of what you had listened to.

Change songs after a certain (or) random amount of time, get artist and song information via audio feedback during song play.

# Prerequisites
- https://github.com/hnarayanan/shpotify
- osx
- spotify(1.0.26.132.ga4e3ccee, premium recommended)
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
> >  number-of-songs: 30, time-per-play: 45, Announcer-mode: fyi
> > 
> >  ~: ossify ramones_play_list 45 30 3 0 ~/ossify_logs
> > 
> >  Usage:
>
> >      ossify <playlist-name> <time-per-play> <number-of-plays> <Announcer-mode> <Announcer-aritist> <crossfade> <exit-after> <log-location>
>
> >      <playlist-name>      = playlist name
> >      <time-per-play>      = 1 to <song-length>, in seconds
> >                             f, full song
> >                             r, random switch
> >      <number-of-songs>    = 1 - 100, songs
> >      <Announcer-mode>     = "peel", classic, Announcer speaks before play
> >                             "armin", Announcer speaks during play at the begining
> >                             "fyi", Announcer speaks at the end of play
> >                             "off", Announcer turned off
> >      <Announcer-artist>   = Announcer mentions artist name
> >      <crossfade>          = on, turn on crossfade
> >                             off, turn off crossfade
> >      <exit>               = on, quit after
> >                             off, pause after
> >      <log-location>       = history file folder, default is $HOME/ossify_logs
>
>     ossify will write out your listening history. eg. ramones_04-15-16-17:54:10.txt for your future reference.

## Have fun!
