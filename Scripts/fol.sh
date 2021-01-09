#!/bin/sh

# fol: focus or launch
# this script checks whether an app is running and
# if running, focuses the window
# if not running, launches the app

# usage: lof [arg]
# [arg]: provide the full path, arguments, and flags representing the process
# The value of arg will be looked up literally in the process list by wrapping [arg] in ^ (start) and $ (end)
# for example, to ensure the correct firefox window is launched, lof would be used as follows:
# lof /usr/lib/firefox/firefox

# for web-based apps, nodejs-natifier can be used to generate a desktop binary
# https://aur.archlinux.org/packages/nodejs-nativefier

# this script assumes the app exists and wmctrl is installed
# checks do not occur to ensure optimal performance

APP_NAME="$1"

# find pid for app process
# -f includes the entire process details, including arguments and flags
APP_PID="$(pgrep -f "^${APP_NAME}$")"
echo $APP_NAME
echo $APP_PID
# if app is not running, start it
# if app is running, focus it
if [ -z "$APP_PID" ]
then
  # launch app
  $APP_NAME
else
  # using the pid, find the window id, then focus it
  wid=$(wmctrl -lp | grep "$APP_PID" | awk '{print $1}')
  # -R moves the window to the current desktop AND brings it to focus
  wmctrl -iR "$wid"
fi
