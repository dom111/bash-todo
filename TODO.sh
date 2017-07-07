q=; #=;q%

# customisation
export max_width=".5";     # what fraction of the width of the screen can be used
export max_height="1";     # what fraction of the height of the screen can be used
export style="44;97";      # specify colours for the main windows
export done_style="90";    # specify alternate colors for items that are done

# colour only settings
colour_header=" {fill}";
colour_footer=" {fill}";
colour_line_prefix="   ";
colour_line_suffix="   ";

# text only settings
text_header="+-{fill}+\n|{center}TODO{/center}{right}|{/right}\n+-{fill}+";
text_footer="+-{fill}+";
text_line_prefix="| ";
text_line_suffix=" |";

file="$HOME/TODO";

# header and footer strings can have the following formatters applied:
#   x{fill}                 - fills the line with 'x' excepting any chars before or after
#   {center}text{center}    - prints 'text' in the center of the line
#   {right}text{/right}     - right-aligns 'text'

# main
export cols=$(tput cols);
export rows=$(tput lines);

function usage {
    echo "Usage:
    $0 [text]           - add item
    $0 -t [n]           - toggle item #n done
    $0 -d [n]           - delete item #n
    $0 -s               - add items from stdin (useful in pipes)
";
}

function _format {
    export line_prefix=$1;
    export line_suffix=$2;
    export all_prefix=$3;
    export all_suffix=$4;
    export done_prefix=$5;
    export header=$6;
    export footer=$7;

    perl "$0" < "$file";
}

if [[ "$@" = *"-h"* || "$@" = *"--h"* ]]; then
    usage;
    exit 0;
fi

if [[ -n "$@" ]]; then
    if [[ "$1" = "-s" ]]; then
        # slurp from stdin
        echo "$(cat -)" >> $file;
    elif [[ "$1" = "-t" ]]; then
        # toggle $2 done
        if [[ -n "$2" ]]; then
            perl -pli -e "$.==$2?/\bdone$/i?s/\bdone\b//i|s/^\s+|\s+$//g:s/$/ done/:0" $file;
        fi
    elif [[ "$1" = "-d" ]]; then
        # delete $2
        if [[ -n "$2" ]]; then
            perl -nli -e "$.==$2||print" $file;
        fi
    else
        # assume lazy add mode
        echo "$@" >> $file;
    fi

    exit 0;
fi

if [[ -e $file ]]; then
    if [[ $(wc -l $file | awk '{print$1}') = 0 ]]; then
        exit 0;
    fi
else
    exit 1;
fi

tput sc;

if [ $(tput colors) -ge 8 ]; then
    _format "$colour_line_prefix" "$colour_line_suffix" "\x1b[${style}m" "\x1b[0m" "\x1b[${done_style}m" "$colour_header" "$colour_footer";
else
    _format "$text_line_prefix" "$text_line_suffic" "" "" "" "$text_header" "$text_footer";
fi

tput rc;

exit 0;
%;
use strict;

my @items = <>;
chomp(@items);

my $line_prefix = $ENV{line_prefix};
my $line_suffix = $ENV{line_suffix};
my $all_prefix = $ENV{all_prefix};
my $all_suffix = $ENV{all_suffix};
my $done_prefix = $ENV{done_prefix};
my $header = $ENV{header};
my $footer = $ENV{footer};
my $max_width = int($ENV{cols} * $ENV{max_width});
my $max_height = int($ENV{rows} * $ENV{max_height});
my $longest_item;
$longest_item = length > $longest_item ? length : $longest_item for @items;
my $number_of_items = @items;
my $left_column_length = length($number_of_items) + 1;
my $max_right_column_width = $max_width - ($left_column_length + 1);
my $longest_line_length = $longest_item + length($line_prefix) + length($line_suffix);
my $actual_line_length = ($longest_line_length, $max_right_column_width)[$longest_line_length > $max_right_column_width];
my $max_right_column_content_width = $actual_line_length - (length($line_prefix) + length($line_suffix));
my $full_width = $left_column_length + 1 + $actual_line_length;
my $start_column = $ENV{cols} - $full_width + 1;
my ($row_counter, $item_number, $adjusted_content_width);

($header, $footer) = map {
    join($/, map {
        s/(.)\{fill\}/$1 x($full_width - (length($`) + length($')))/e;
        s!\{center\}(.+)\{/center\}!$"x(int($full_width / 2) - length($`) - int(length($1) / 2)).$1!e;
        s!\{right\}(.+)\{/right\}!$"x($full_width - length($`) - length($1)).$1!e;
        $_
    } split/\n/, $_);
} $header, $footer;

$max_height -= split(/\n/, "$header
$footer");

if (@items > $max_height) {
    my $missing = (@items - ($max_height - 1));
    @items = (@items[0..($max_height - 2)], "  $missing more items...");
}

map {
    ++$row_counter;
    print "\x1b[$row_counter;${start_column}f$_"
}
map {
    my $output = $all_prefix.$_.$all_suffix;
    $output =~ s/\\x1b/\x1b/g;
    $output
}
split(/\n/, $header), (map {
    $adjusted_content_width = $max_right_column_content_width;

    map {
        $adjusted_content_width += length
    } /\\x1b\[[^m]+m/g;

    ++$item_number;
    sprintf "$line_prefix%$left_column_length.${left_column_length}s %-$adjusted_content_width.${adjusted_content_width}s$line_suffix",!/\d+ more items/&&"${item_number}.",$_
}
map {
    (/\bdone\b/&&$done_prefix).((length > $max_right_column_content_width) ? substr($_, 0, $max_right_column_content_width - 3).'...' : $_)
} @items), split(/\n/, $footer);

