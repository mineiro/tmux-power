#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')
# short for Theme-Colour
TC=$(tmux_get '@tmux_power_theme' 'purple')
case $TC in
    'purple' )
        TC='#BD93F9'
        ;;
    'pink' )
        TC='#FF79C6'
        ;;
    'green' )
        TC='#50FA7B'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='#FFB86C'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243
G13=#22212C #244
G14=#17161D #245
G15=#0B0B0F #246
G16=#2E2B3B #247
G17=#393649 #248
G20=#F8F8F2 #251
G21=#ABB2BF #252
G22=#BD93F9 #253


FG="$G20"
BG="$G13"

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$G13"
tmux_set status-left-fg "G20"
tmux_set status-left-length 150
user=$(whoami)
LS="#[fg=$G13,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$G14,nobold]$right_arrow_icon#[fg=$TC,bg=$G14] $session_icon #S #[fg=$G14,bg=$G13]"
if "$show_upload_speed"; then
    LS="$LS#[fg=$G13,bg=$TC]$right_arrow_icon#[fg=$TC,bg=$G05] $upload_speed_icon #{upload_speed} #[fg=$G05,bg=$BG]$right_arrow_icon"
else
    LS="$LS#[fg=$G20,bg=$G22]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$G14"
tmux_set status-right-fg "G20"
tmux_set status-right-length 150
RS="#[fg=$G14]$left_arrow_icon#[fg=$TC,bg=$G14] $time_icon $time_format #[fg=$TC,bg=$G14]$left_arrow_icon#[fg=$G14,bg=$TC] $date_icon $date_format "
if "$show_download_speed"; then
    RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} $RS"
fi
if "$show_web_reachable"; then
    RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format "#[fg=$TC] #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$G14]$right_arrow_icon#[fg=$TC,bold] #I:#W#F #[fg=$G14,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-statys "fg=$TC,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$G14,bg=default"

# Active pane border
tmux_set pane-active-border-style "fg=$TC,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$G14"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
