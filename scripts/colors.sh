#!/bin/sh
PREFIX="\033["

# Format
Regular="${PREFIX}0;3"
Bold="${PREFIX}1;3"
Italic="${PREFIX}3;3"
Underline="${PREFIX}4;3"
Background="${PREFIX}4"
RegularHighIntensity="${PREFIX}0;9"
BoldHighIntensity="${PREFIX}1;9"
HighIntensityBackground="${PREFIX}0;10"

# Reset formatting
NC="${PREFIX}0m"       # Text Reset

# Colors
Black="0m"
Red="1m"
Green="2m"
Yellow="3m"
Blue="4m"
Purple="5m"
Cyan="6m"
White="7m"

# Regular Colors
RBlack="${Regular}${Black}"
RRed="${Regular}${Red}"
RGreen="${Regular}${Green}"
RYellow="${Regular}${Yellow}"
RBlue="${Regular}${Blue}"
RPurple="${Regular}${Purple}"
RCyan="${Regular}${Cyan}"
RWhite="${Regular}${White}"

# Bold
BBlack="${Bold}${Black}"
BRed="${Bold}${Red}"
BGreen="${Bold}${Green}"
BYellow="${Bold}${Yellow}"
BBlue="${Bold}${Blue}"
BPurple="${Bold}${Purple}"
BCyan="${Bold}${Cyan}"
BWhite="${Bold}${White}"

# Italic
IBlack="${Italic}${Black}"
IRed="${Italic}${Red}"
IGreen="${Italic}${Green}"
IYellow="${Italic}${Yellow}"
IBlue="${Italic}${Blue}"
IPurple="${Italic}${Purple}"
ICyan="${Italic}${Cyan}"
IWhite="${Italic}${White}"

# Underline
UBlack="${Underline}${Black}"
URed="${Underline}${Red}"
UGreen="${Underline}${Green}"
UYellow="${Underline}${Yellow}"
UBlue="${Underline}${Blue}"
UPurple="${Underline}${Purple}"
UCyan="${Underline}${Cyan}"
UWhite="${Underline}${White}"

# Background
On_Black="${Background}${Black}"
On_Red="${Background}${Red}"
On_Green="${Background}${Green}"
On_Yellow="${Background}${Yellow}"
On_Blue="${Background}${Blue}"
On_Purple="${Background}${Purple}"
On_Cyan="${Background}${Cyan}"
On_White="${Background}${White}"

# Regular High Intensity
RIBlack="${RegularHighIntensity}${Black}"
RIRed="${RegularHighIntensity}${Red}"
RIGreen="${RegularHighIntensity}${Green}"
RIYellow="${RegularHighIntensity}${Yellow}"
RIBlue="${RegularHighIntensity}${Blue}"
RIPurple="${RegularHighIntensity}${Purple}"
RICyan="${RegularHighIntensity}${Cyan}"
RIWhite="${RegularHighIntensity}${White}"

# Bold High Intensity
BIBlack="${BoldHighIntensity}${Black}"
BIRed="${BoldHighIntensity}${Red}"
BIGreen="${BoldHighIntensity}${Green}"
BIYellow="${BoldHighIntensity}${Yellow}"
BIBlue="${BoldHighIntensity}${Blue}"
BIPurple="${BoldHighIntensity}${Purple}"
BICyan="${BoldHighIntensity}${Cyan}"
BIWhite="${BoldHighIntensity}${White}"

# High Intensity Background
On_IBlack="${HighIntensityBackground}${Black}"
On_IRed="${HighIntensityBackground}${Red}"
On_IGreen="${HighIntensityBackground}${Green}"
On_IYellow="${HighIntensityBackground}${Yellow}"
On_IBlue="${HighIntensityBackground}${Blue}"
On_IPurple="${HighIntensityBackground}${Purple}"
On_ICyan="${HighIntensityBackground}${Cyan}"
On_IWhite="${HighIntensityBackground}${White}"