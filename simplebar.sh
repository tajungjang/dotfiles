#!/bin/bash
# simple block-style bar using lemonbar
# and named pipes to reduce resource footprint
#
# Normally, this file is split into seperate files
# for colors and bar defaults, I have included them
# all together here for simplicity

YLW=#867D52
BG=#0e0d10
FG=#c9c8c8
WIDTH=700 # bar width
HEIGHT=20 # bar height
XOFF=2850 # x offset
YOFF=10 # y offset
BRDR=6 # border width
BBG=$(echo $BG) # bar background color
#BBG=#00000000 #back background transparent
BFG=$(echo $FG)

# Status constants
# Change these to modify bar behavior
DESKTOP_COUNT=10

# Sleep constnats
WORKSPACE_SLEEP=0.5
VOLUME_SLEEP=1
DATE_SLEEP=1

# Formatting Strings
# I would reccomend not touching these :D
SEP=" "
SEP2="    "
SEP3="                                                  "
SEPB="__"
SPC="%{B$BG}%{F$BG}$SEPB%{B-}%{F-}"

# Glyphs used for both bars
GLYCUR=$(echo -e "\ue000")
GLYEM=$(echo -e "\ue001")
GLYDATE=$(echo -e "\uf017")
GLYVOLLOW=$(echo -e "\uf027")
GLYVOLHIGH=$(echo -e "\uf028")
GLYVOLMUTE=$(echo -e "\uf026")
GLYBATLOW=$(echo -e "\uf243")
GLYBAT=$(echo -e "\uf240")
GLYBATMAX=$(echo -e "\uf0e7")
GLYWLANHIGH=$(echo -e "\uf012")
GLYWLANLOW=$(echo -e "\uf2d1")
GLYMUSIC=$(echo -e "\ue0fe")

PANIC="%{F$MAG}%{B$BG}${SEP}"
ALERT="%{F$RED}%{B$BG}${SEP}"
WARN="%{F$YLW}%{B$BG}${SEP}"
GOOD="%{F$GRN}%{B$BG}${SEP}"
PLAIN="%{F$WHT}%{B$BG}${SEP}"
GEN="%{F$FG}%{B$BG}${SEP}"
EMPTY="%{F$FG}%{B$BG}${SEP}"
BLACK="%{F$FG}%{B$BG}${SEP}"
FULL="%{F$BLK}%{B$BG}${SEP}"
CLR="${SEP}%{B-}${F-}"

NOR="%{F$FG}%{B$BG}"
HIRED="%{F$RED}%{B$BG}"
HIYLW="%{F$YLW}%{B$BG}"
HIGRN="%{F$GRN}%{B$BG}"

PANEL_FIFO=/tmp/panel-fifo
OPTIONS="-g ${WIDTH}x${HEIGHT}+${XOFF}+${YOFF} -B ${BBG} -F ${BFG}  -u 2" 

[ -e "${PANEL_FIFO}" ] && rm "${PANEL_FIFO}"
mkfifo "${PANEL_FIFO}"

workspaces() {
    while true; do
        local cur=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')
        local total=${DESKTOP_COUNT}
        local seq=""

        cur=$((cur+1))
        for ((i=1;i<cur;i++)); do 
            seq+="${EMPTY}${i}${CLR}"
        done

        if [ $cur == 10 ]; then
            seq+="${WARN}${cur}${CLR}${EMPTY}"
        else
            seq+="${WARN}${cur}${SEP}"
        fi

        min=$cur+1
        for ((i=min;i<total+1;i++)); do
            seq+="${EMPTY}${i}${CLR}"
        done

        echo "WORKSPACES ${seq}${CLR}"
        echo "WORKSPACES ${seq}"

        sleep ${WORKSPACE_SLEEP}
    done
}

workspaces > "${PANEL_FIFO}" &

clock() 
{
    while true; do
        local clock="$(date +'%a %d %I:%M')"
        echo "CLOCK ${GEN}${GLYDATE}${BLACK}${clock}${CLR}"

        sleep ${DATE_SLEEP}
    done
}

clock > "${PANEL_FIFO}" &

volume()
{
    while true; do
        local vol="$(amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p')"

        echo "VOLUME vol ${vol}"

        sleep ${VOLUME_SLEEP} 
    done
}

volume > "${PANEL_FIFO}" &

network() 
{
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
    if iwconfig $int1 >/dev/null 2>&1; then
        wifi=$int1
        eth0=$int2
    else
        wifi=$int2
        eth0=$int1
    fi
    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi

    #int=eth0

    ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
        echo "NETWORK $int connected" || echo "NETWORK $int disconnected"
}

network > "${PANEL_FIFO}" &


while read -r line; do
    case $line in
        CLOCK*)
            fn_time="${line#CLOCK }"
            ;;
        VOLUME*)
            fn_vol="${line#VOLUME }"
            ;;
        WORKSPACES*)
            fn_work="${line#WORKSPACES }"
            ;;
        NETWORK*)
            fn_network="${line#NETWORK }"
            ;;
    esac
    printf "%s\n" "%{l}${fn_work}${SEP3}${fn_network}${SEP}${SEP}${fn_vol}${SEP}${fn_time}"
done < "${PANEL_FIFO}" | lemonbar ${OPTIONS} | sh > /dev/null
