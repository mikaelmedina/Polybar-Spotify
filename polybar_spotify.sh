#!/bin/bash
path_to_saved_tokens=FILL HERE
path_to_debug_info=FILL HERE
path_to_last_error=FILL HERE
access=$(jq .access_token $path_to_saved_tokens | sed 's/"//g')
refresh=$(jq .refresh_token $path_to_saved_tokens | sed 's/"//g')

currently_playing_request=$(curl -X "GET" "https://api.spotify.com/v1/me/player/currently-playing?market=NO&additional_types=episode" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $access" -s)

# Save the curl response for debug purposes
echo $currently_playing_request > $path_to_debug_info

error=$(jq -n "$currently_playing_request" | jq .error)
status=$(jq -n "$error" | jq .status)

if [[ $status == 401 ]]
then 
    # Request new token, only gets access token
    # Spotify application authorization
    auth=BASE64 ENCODED client_id:client_secret
    refresh_access_token_request=$(curl -s -H "Authorization: Basic $auth" -d "grant_type=refresh_token" -d "refresh_token=$refresh" "https://accounts.spotify.com/api/token")
    new_access_token=$(jq -n "$refresh_access_token_request" | jq .access_token)

    # Replace token in tokens_saved.txt
    replaced=$(jq ".access_token = $new_access_token" $path_to_saved_tokens)
    echo $replaced > $path_to_saved_tokens
elif [[ $error != null ]]
then
    echo $error > $path_to_last_error 
elif [[ $status == 204 ]]
then
    echo "204"
else
    if [[ $(jq -n "$currently_playing_request" | jq .is_playing) == true ]]
    then
    item=$(jq -n "$currently_playing_request" | jq .item)
        case $(jq -n "$currently_playing_request" | jq .currently_playing_type) in
            \"track\")
                echo $(jq -n "$item" | jq .name | sed 's/"//g') "-" $(jq -n "$item" | jq .artists | jq '.[].name' | sed 's/"//g')
                ;;
            \"episode\")
                echo $(jq -n "$item" | jq .name | sed 's/"//g') "-" $(jq -n "$item" | jq .show | jq .name | sed 's/"//g')
                ;;
            *)
                ;;
        esac
    else
        echo ""
    fi
fi
