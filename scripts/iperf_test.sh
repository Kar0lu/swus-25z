#!/usr/bin/env bash

ip netns exec server iperf3 -s &
SERVER_PID=$!
ip netns exec client iperf3 -R --cport 1234 -c 10.0.0.1 -t 60 -i 10
kill $SERVER_PID