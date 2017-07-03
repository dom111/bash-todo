# bash-todo

A customisable bash/Perl script that shows your TODO list in your terminal window

Inspired by this post on reddit:

    https://www.reddit.com/r/bash/comments/6kvl4m/to_do_list_display_it_in_the_top_of_the_terminal/

[@whetu](https://www.reddit.com/user/whetu) said: "I suspect it's maybe do-able with some `tput` trickery combined with `$PROMPT_COMMAND`"

That made me wonder _who_ do-able it was. Very do-able.

## Usage

Place `TODO.sh` somewhere accessible (`~/bin/TODO.sh` for instance), set up your `PROMPT_COMMAND` variable:

    PROMPT_COMMAND=~/bin/TODO.sh

Add some `TODO`s:

    ~/bin/TODO.sh "I need to do this thing"
    ~/bin/TODO.sh "and I have to do this thing too"

or if you're feeling really crazy:

    grep -Rn 'TODO\|FIXME' ~/project | perl -pe 's/:[^:]+TODO/:TODO/' | ~/bin/TODO.sh -s

which will add all `TODO`/`FIXME` from `~/project`. Yeah, you probably don't wanna do that.

From then on you should see your list appearing in the top right-hand corner of your terminal. It's numbered so you can run things like:

    ~/bin/TODO.sh -t 4   # toggles item 4 as done/not done
    ~/bin/TODO.sh -d 2   # deleted item 2 from your list

This script assumes you want to work on `~/TODO`, but you can change the path to the file in `TODO.sh` itself, along with a few other settings.
