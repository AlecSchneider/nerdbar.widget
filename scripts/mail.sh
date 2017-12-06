#!/usr/bin/bash

echo $(osascript -e "tell application \"Mail\" to set unreadCount to unread count of inbox")
