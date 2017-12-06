#!/usr/bin/env python

import socket
import argparse
import subprocess

TCP_IP = '127.0.0.1'
TCP_PORT = 3920

DESKTOPS = {
    1: 'terminal',
    2: 'crisidev_irc',
    3: 'crisidev_web',
    4: 'amzn_irc',
    5: 'amzn_web',
    6: 'chime',
    7: 'outlook',
    8: 'calendar',
    9: 'phone',
    10: 'various1',
    11: 'various2',
    12: 'various3',
    -1: 'unknown'
}

ACTIVE_WINDOW_SCRIPT = """
global frontApp, frontAppName, windowTitle

set windowTitle to ""
tell application "System Events"
    set frontApp to first application process whose frontmost is true
    set frontAppName to name of frontApp
    tell process frontAppName
        tell (1st window whose value of attribute "AXMain" is true)
            set windowTitle to value of attribute "AXTitle"
        end tell
    end tell
end tell

return {frontAppName & " - " & windowTitle}
"""


def get_current_desktop():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))
        s.send(b'get _focused_window')
        return int(s.recv(1024))
    except Exception:
        return -1


def get_current_window():
    p = subprocess.Popen(['osascript', '-'], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    stdout, _ = p.communicate(ACTIVE_WINDOW_SCRIPT.encode('utf-8'))
    if not p.returncode:
        return stdout.decode('utf-8').strip()
    return 'unknown'


def get_current_profile():
    return 'laptop'


def parse_args():
    parser = argparse.ArgumentParser(prog='chunkwm-query')
    parser.add_argument('-d', '--desktop', help="query active desktop", default=False, action='store_true')
    parser.add_argument('-w', '--window', help="query active window", default=False, action='store_true')
    parser.add_argument('-p', '--profile', help="query active profile", default=False, action='store_true')
    return parser.parse_args()


def main():
    args = parse_args()
    if args.desktop:
        print(get_current_desktop())
    elif args.window:
        print(get_current_window())
    elif args.profile:
        print(get_current_profile())


if __name__ == '__main__':
    main()
