# Polybar-Spotify
A script for Polybar that displays currently playing track and artist from Spotify, on your status bar.

Dependencies: curl, jq, polybar(duh)

As I am unsure how I would go about using the client id and client secret for a Spotify app in a shell script, without giving away my own apps IDs, each user has to make their own Spotify app for this script. This can be done [here](https://developer.spotify.com/). 
The script also relies on a text file containing a valid Spotify access token and a refresh token, formatted as { "access_token": "TOKEN", "refresh_token": "TOKEN" }. These tokens are acquired through following Spotifys [authorization flow](https://developer.spotify.com/documentation/general/guides/authorization-guide/).
