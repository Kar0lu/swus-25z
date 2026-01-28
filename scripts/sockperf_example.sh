#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
rm -rf results
mkdir -p results

echo "TEST 1: nothing"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/sockperf_test.sh nothing
$SCRIPT_DIR/clear.sh

echo "TEST 2: filter"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/load_filter_eg.sh
$SCRIPT_DIR/sockperf_test.sh filter
$SCRIPT_DIR/clear.sh

echo "TEST 3: htb"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/add_classes.sh
$SCRIPT_DIR/sockperf_test.sh htb
$SCRIPT_DIR/clear.sh

echo "TEST 4: filter + htb"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/load_filter_eg.sh
$SCRIPT_DIR/add_classes.sh
$SCRIPT_DIR/sockperf_test.sh filter_htb
$SCRIPT_DIR/clear.sh

echo "TEST 5: filter + table"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/load_filter_eg.sh
$SCRIPT_DIR/fill_table.sh
$SCRIPT_DIR/sockperf_test.sh filter_table
$SCRIPT_DIR/clear.sh

echo "TEST 6: filter + HTB + table"
$SCRIPT_DIR/prep_netns.sh
$SCRIPT_DIR/load_filter_eg.sh
$SCRIPT_DIR/add_classes.sh
$SCRIPT_DIR/fill_table.sh
$SCRIPT_DIR/sockperf_test.sh filter_htb_table
$SCRIPT_DIR/clear.sh