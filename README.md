# Polybar-Spotify
A script for Polybar that displays currently playing track and artist from Spotify, on your status bar.

Dependencies: curl, jq, polybar(duh)

As I am unsure how I would go about using the client id and client secret for a Spotify app in a shell script, without giving away my own apps IDs, each user has to make their own Spotify app for this script. This can be done [here](https://developer.spotify.com/). 

The script also relies on a text file containing a valid Spotify access token and a refresh token, formatted as { "access_token": "TOKEN", "refresh_token": "TOKEN" }. These tokens are acquired through following Spotifys [authorization flow](https://developer.spotify.com/documentation/general/guides/authorization-guide/). There are multiple guides on how to do this, and copy-pasting the Spotify example code from [this link](https://github.com/spotify/web-api-auth-examples) will probably do, as you only need to acquire an access and refresh token through this method once. The script will reuse the refresh token to get new access tokens when needed.

To add the script as a Polybar module, add this to the Polybar config:

    [module/polybar-spotify]
    type = custom/script
    exec = PATH TO polybar_spotify.sh
    interval = 5

Then add the module to the bar like you would any other module, i.e.: `modules-left = polybar-spotify`.

Everything in the script that needs to be changed has been capitalized. The path to "debug info" and "last error" are not needed, and the corresponding `echo` commands can be deleted, as these are for debugging purposes.

Flow to get the script up and running:
1. Register a Spotify app [here](https://developer.spotify.com/). Get the client_id and client_secret.
2. Encode `client_id:client_secret` with base64 to get authorization code.
3. Through some means acquire an access and a refresh token, there are many examples out there, including the ones in the previously linked [github repo](https://github.com/spotify/web-api-auth-examples).
4. Save the tokens in a file structured as previously mentioned, `{ "access_token": "TOKEN", "refresh_token": "TOKEN" }`, this is the `path_to_saved_tokens` variable within the script.
5. Add the missing information to the `polybar_spotify.sh` script.
6. Add the script as a module in the Polybar config.
7. Restart Polybar and play a song or podcast episode on Spotify and hopefully the information is displayed.
