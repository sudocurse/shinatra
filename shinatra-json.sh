#!/usr/bin/env bash
# usage
# ./shinatra-json.sh PORT DIRECTORY (btw not what the origin repo uses)
# returns a json object containing file names in DIR
# don't use this in prod. why would you consider using this in prod.

DIR=$2
list(){
    echo -n  $(ls $DIR                                    | \
        xargs -I %% echo "{\\\"filename\\\":\\\"%%\\\"}," | \
        xargs                                             | \ 
        sed 's/^/[/;s/.$/]/'                              | \
        jq)                                                   
}                                                             
RESPONSE="HTTP/1.1 200 OK\r\nConnection: keep-alive\r\nContent-Type: application/json\r\n\r\n$(list)\r\n"
while { echo -en "$RESPONSE"; } | nc -l "${1:-8080}"; do
  echo "================================================"
done
