#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "TEST 1: nothing"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/iperf_test.sh
$SCRIPT_DIR/clear.sh

echo "TEST 2: HTB"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/add_classes.sh
$SCRIPT_DIR/iperf_test.sh
$SCRIPT_DIR/clear.sh

echo "TEST 3: filter + HTB + table"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/load_filter_eg.sh
$SCRIPT_DIR/add_classes.sh
$SCRIPT_DIR/fill_table.sh
$SCRIPT_DIR/iperf_test.sh
$SCRIPT_DIR/clear.sh