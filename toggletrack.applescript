#!/usr/bin/osascript
# This script toggles the 'enabled' checkbox of the currently playing track in
# iTunes.
tell application "iTunes"
  if player state is playing then
    # Get the currently playing track.
    set playingTrack to current track
    set trackArtist to artist of playingTrack
    set trackName to name of playingTrack
    set trackTitle to trackArtist & " - " & trackName

    # Toggle the 'enabled' checkbox.
    set newValue to (not enabled of playingTrack)
    set enabled of playingTrack to newValue
  end if
end tell

# Check for growl.
tell application "System Events"
  set growlIsRunning to Â
    (count of (every process whose name is "GrowlHelperApp")) > 0
end tell

if growlIsRunning then
  # Find icon paths.
  tell application "Finder" to set myParent to (container of (path to me))
  set parentPath to POSIX path of (myParent as string)
  set plusIconPath to "file://" & parentPath & "plus.png"
  set minusIconPath to "file://" & parentPath & "minus.png"

  # Contract message to send with Growl.
  if newValue is true then
    set growlMsg to "checked: " & trackTitle
    set growlIcon to plusIconPath
  else
    set growlMsg to "unchecked: " & trackTitle
    set growlIcon to minusIconPath
  end if

  tell application "GrowlHelperApp"
    # Register with Growl.
    register as application "toggletrack" Â
      all notifications {"trackToggled"} Â
      default notifications {"trackToggled"}

    # Send Growl notification.
    notify with name "trackToggled" Â
      title "toggletrack" Â
      description growlMsg Â
      application name "toggletrack" Â
      image from location growlIcon
  end tell
end if
