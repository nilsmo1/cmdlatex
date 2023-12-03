#!/usr/bin/env bash

program="cmdlatex"
version="1.0.0"
verbose=true
keep_tex=false
keep_png=false
editor=$EDITOR
expression=false
display=true
font="euler"
color="white"
config_path='~/.config/cmdlatex/config.tex'

base='_latex_cmd_tmp_file_'
input_file=$base'input_.tex'
error_file=$base'error_'
tex_output="$base.tex"
pdf_output="$base.pdf"
png_output="$base.png"

clean() {
    rm -f $error_file
    rm -f "$base.aux"
    rm -f "$base.log"
    rm -f $pdf_output
    if ! $keep_tex; then
        rm -f $tex_output
    fi
    if ! $keep_png; then
        rm -f $png_output
    fi
    exit 1
}

usage() {
    printf "Create a png from an input LaTeX expression and copy it to clipboard.\n\n"
    printf "Usage: $program [-v | h | qKkd][-e \'<expression>\' | -E <editor>][-f <font>][-c <config_file_path>]\n"
    printf "Options:\n"
    printf "  -e '<expr>'\tCompile given LaTeX expression without going into an editor.\n"
    printf "\t\t(has to be enclosed in single quotes)\n"
    printf "  -E <editor>\tUse given editor.\n"
    printf "  -f <font>\tUse given font.\n"
    printf "  -c <path>\tUse custom path for preamble, instead of default $config_path.\n"
    printf "  -C <color>\tUse custom text color, instead of default white.\n"
    printf "  -v\t\tShow the version of installed instance of $program.\n"
    printf "  -h\t\tPrints this help.\n"
    printf "  -q\t\tDo not show verbose output.\n"
    printf "  -K\t\tKeep the png file after program termination.\n"
    printf "  -k\t\tKeep the tex file after program termination.\n"
    printf "  -d\t\tDo not display the png after creation.\n"
}

while getopts ":e:E:f:c:C:vqkKdh" option; do
    case $option in
        e) input=$OPTARG; expression=true ;;
        E) editor=$OPTARG ;;
        f) font=$OPTARG ;;
        c) config_path=$OPTARG ;;
        C) color=$OPTARG ;;
        v) echo "$program version $version"; exit 0 ;;
        q) verbose=false ;;
        k) keep_tex=true ;;
        K) keep_png=true ;;
        d) display=false ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

if ! $expression; then
    if [ -z $editor ]; then
        printf '$EDITOR variable is not set!\n'
        exit 1
    fi
    $editor $input_file
    if test -f $input_file; then
       input=$(cat $input_file)
    else
        clean
    fi
fi

rm -f $input_file

if [ -z "$input" ]; then
    clean
fi

echo "\documentclass[border=2pt]{standalone}
\usepackage{$font}
\usepackage{xcolor}
\input{$config_path}
\begin{document}
\begin{varwidth}{\linewidth}
\textcolor{$color}{$input}
\end{varwidth}
\end{document}" > $tex_output

if ! $verbose; then
    if ! pdflatex --halt-on-error $tex_output > $error_file; then
        cat $error_file
        clean
    fi
else
    if ! pdflatex --halt-on-error $tex_output; then
        clean
    fi
fi

if ! convert -density 600 $pdf_output -quality 600 $png_output; then
    echo "convertion failed!"
    clean
fi

if ! xclip -selection clipboard -t image/png -i $png_output; then
    echo "xclip failed!"
    clean
fi

if $verbose; then
    echo "Copied png to clipboard!"
fi

if test -f $png_output && $display ; then
    feh $png_output
fi

clean
