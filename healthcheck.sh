#!/bin/sh

if [ "$(echo PING | nc localhost 3310)" = "PONG" ]; then
    echo "PING Successful"
else
    echo "PING Failed"
    exit 1
fi
