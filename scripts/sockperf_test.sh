#!/usr/bin/env bash

# Usage
TEST_NAME=$1
if [ -z "$TEST_NAME" ]; then
    echo "Usage: $0 <test_name> (e.g., nothing)"
    exit 1
fi

RESULTS_DIR="results/"

# Running test
echo "Starting sockperf server"
ip netns exec server sockperf server -i 10.0.0.1 -p 12345 &
SERVER_PID=$!

sleep 1

echo "Running sockperf client"
ip netns exec client sockperf ping-pong -i 10.0.0.1 -p 12345 -t 60 --full-log "$RESULTS_DIR/$TEST_NAME"

# Exit
echo "Stopping server"
kill $SERVER_PID

echo -e "Test $TEST_NAME completed"