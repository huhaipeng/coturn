#!/bin/bash

echo 'Running turnserver'
../bin/turnserver --use-auth-secret  --static-auth-secret=secret --realm=north.gov --allow-loopback-peers --no-cli > /dev/null &
echo 'Running peer client'
../bin/turnutils_peer -L 127.0.0.1 -L ::1 -L 0.0.0.0 > /dev/null &

sleep 2

echo 'Running turn client TCP'
../bin/turnutils_uclient -t -e 127.0.0.1 -X -g -u user -W secret -t 127.0.0.1 | grep "start_mclient: tot_send_bytes ~ 1000, tot_recv_bytes ~ 1000" > /dev/null
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
	exit $?
fi

echo 'Running turn client UDP'
../bin/turnutils_uclient -e 127.0.0.1 -X -g -u user -W secret -t 127.0.0.1  | grep "start_mclient: tot_send_bytes ~ 1000, tot_recv_bytes ~ 1000" > /dev/null
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
	exit $?
fi
