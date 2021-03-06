# bash-todo

A customisable bash/Perl script that shows your TODO list in your terminal window

Inspired by this post on reddit: [reddit.com/r/bash/comments/6kvl4m](https://www.reddit.com/r/bash/comments/6kvl4m/to_do_list_display_it_in_the_top_of_the_terminal/)

[@whetu](https://www.reddit.com/user/whetu) said: "I suspect it's maybe do-able with some `tput` trickery combined with `$PROMPT_COMMAND`"

That made me wonder _how_ do-able it was. Very do-able.

## Usage

Place `TODO.sh` somewhere accessible (`~/bin/TODO.sh` for instance), set up your `PROMPT_COMMAND` variable and `alias` `TODO` to the script location:

    PROMPT_COMMAND=~/bin/TODO.sh
    alias TODO=~/bin/TODO.sh

Add some `TODO`s:

    TODO "I need to do this thing"
    TODO "and I have to do this thing too"

or if you're feeling really crazy:

    grep -Rn 'TODO\|FIXME' ~/project | perl -pe 's/:[^:]+TODO/:TODO/' | TODO -s

which will add all `TODO`/`FIXME` from `~/project`. Yeah, you probably don't wanna do that.

From then on you should see your list appearing in the top right-hand corner of your terminal. It's numbered so you can run things like:

    TODO -t 4       # toggles item 4 as done/not done
    TODO -d 2       # deleted item 2 from your list

This script assumes you want to work on `~/TODO`, but you can change the path to the file in `TODO.sh` itself, along with a few other settings.

## Screenshot

![You can change the colours, don't worry!](http://i.imgur.com/PJYPfjd.png)
