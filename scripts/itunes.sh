#!/usr/bin/bash

read -r running <<<"$(ps -ef | grep \"MacOS/iTunes\" | grep -v \"grep\" | wc -l)" &&
test $running != 0 &&
IFS='|' read -r theArtist theName theState theStream <<<"$(osascript <<<'if application "iTunes" is running then
  tell application "iTunes"
    if player state is playing then
      set theTrack to name of current track
      set theArtist to artist of current track
      set theDuration to duration of current track
      set dMinutes to round((theDuration mod 3600)/60) rounding down
      set dSeconds to round(theDuration mod 60)
      if (dSeconds < 10)
        set dSeconds to "0" & dSeconds
      end if
      set thePosition to player position
      set theMinutes to round((thePosition mod 3600)/60) rounding down
      set theSeconds to round(thePosition mod 60)
      if (theSeconds < 10)
        set theSeconds to "0" & theSeconds
      end if
      return theArtist & " - " & "<span class='green'>" & theTrack & " " & "<span class='yellow'>" & theMinutes & ":" & theSeconds & " / " & dMinutes & ":" & dSeconds
    else if player state is paused then
      set theTrack to name of current track
      set theArtist to artist of current track
      set theDuration to duration of current track
      set dMinutes to round((theDuration mod 3600)/60) rounding down
      set dSeconds to round(theDuration mod 60)
      if (dSeconds < 10)
        set dSeconds to "0" & dSeconds
      end if
      set thePosition to player position
      set theMinutes to round((thePosition mod 3600)/60) rounding down
      set theSeconds to round(thePosition mod 60)
      if (theSeconds < 10)
        set theSeconds to "0" & theSeconds
      end if
      return theArtist & " - " & "<span class='green'>" & theTrack & "<span class='yellow'>" & " " & theMinutes & ":" & theSeconds & " / " & dMinutes & ":" & dSeconds & " - paused"
    else
      return "no song selected"
    end if
  end tell
else
  return "iTunes is not running"
end if')" &&
echo "$theArtist $theName"