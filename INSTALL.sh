if [[ ! -d ~/bin ]]; then
    mkdir -p ~/bin/;
fi

if [[ -e ~/bin/TODO.sh ]]; then
    echo "~/bin/TODO.sh already exists, overwrite? [Y/n]" >&2;
    read -sn1 choice;

    if [[ $choice = *n* || $choice = *N* ]]; then
        echo "Aborting." >&2;
        exit 1;
    fi
fi

curl -s https://raw.githubusercontent.com/dom111/bash-todo/master/TODO.sh > ~/bin/TODO.sh;
chmod +x ~/bin/TODO.sh;

echo "Add to ~/.bashrc? [Y/n]";
read -sn1 choice;

if [[ $choice = *n* || $choice = *N* ]]; then
    echo 'Run the following to activate:

alias TODO=~/bin/TODO.sh;

if [[ -n $PROMPT_COMMAND ]]; then
    if [[ $PROMPT_COMMAND = *";" || $PROMPT_COMMAND = *"; " ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND ~/bin/TODO.sh";
    else
        PROMPT_COMMAND="$PROMPT_COMMAND; ~/bin/TODO.sh";
    fi
else
    PROMPT_COMMAND="~/bin/TODO.sh";
fi';
else
    if ! grep 'alias TODO=~/bin/TODO.sh' ~/.bashrc > /dev/null; then
        echo >> ~/.bashrc;
        echo 'alias TODO=~/bin/TODO.sh;' >> ~/.bashrc;
    fi

    if ! grep 'PROMPT_COMMAND="~/bin/TODO.sh";' ~/.bashrc > /dev/null; then
        echo >> ~/.bashrc;
        echo 'if [[ -n $PROMPT_COMMAND ]]; then
    if [[ $PROMPT_COMMAND = *";" || $PROMPT_COMMAND = *"; " ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND ~/bin/TODO.sh";
    else
        PROMPT_COMMAND="$PROMPT_COMMAND; ~/bin/TODO.sh";
    fi
else
    PROMPT_COMMAND="~/bin/TODO.sh";
fi
' >> ~/.bashrc;
    fi

    exec bash;
fi

