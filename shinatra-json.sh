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

make_response() {
    body=$(list)
    echo -en "HTTP/1.1 200 OK\r\nConnection: keep-alive\r\nContent-Type: application/json\r\nContent-Length: $(echo $body | wc -c)\r\n\r\n
$body\r\n\r\n"
}
echo -en "$(make_response)"
while { echo -en "$(make_response)"; } | nc -l "${1:-8080}"; do
    echo "================================================"
done
