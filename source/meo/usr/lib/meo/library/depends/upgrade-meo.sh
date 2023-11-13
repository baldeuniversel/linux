#!/usr/bin/bash


####
# A script to upgrade `meo` program
####

# Upgrading the package
if [[ -e  "$1" ]]
then
    dpkg --install $1
fi

# Remove the package in /tmp/.meo
if [[ -e "/tmp/.meo/github/linux"  ]]
then
    rm -rf "/tmp/.meo/github/linux" 2> /null
fi
