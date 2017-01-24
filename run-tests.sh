#!/bin/bash
#
# Copyright (C) 2016 Canonical Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

# ==============================================================================
# This has to be in sync with the tests-extras/run-tests.sh script
# functionalities. 

show_help() {
    echo "Usage: run-tests.sh [OPTIONS]"
    echo
    echo "This is fetch & forget script and what it does is to fetch the"
    echo "tests-extras repository and execute the run-tests.sh script from"
    echo "there passing arguments as-is."
    echo
    echo "optional arguments:"
    echo "  --help                 Show this help message and exit"
    echo "  --channel              Select another channel to build the base image from (default: stable)"
    echo "  --snap		 Extra snap to install"
    echo "  --debug                Enable verbose debugging output"
    echo "  --test-from-channel    Pull network-manager snap from the specified channel instead of building it from source"
    echo "  --force-new-image      Force generating a new image used for testing"
}

# ==============================================================================
# This is fetch & forget script and what it does is to fetch the tests-extras
# repo and execute the run-tests.sh script from there passing arguments as-is.

# 0. Display help w/o fetching anything

if [ "$1" == "--help" ]; then
	show_help
	exit 0
fi

# 1. Fetch

TESTS_EXTRAS_URL="https://git.launchpad.net/~snappy-hwe-team/snappy-hwe-snaps/+git/tests-extras"
TESTS_EXTRAS_PATH="tests-extras"

# delete the fetched content on ctrl-c
trap 'cd .. && if [ -d "$TESTS_EXTRAS_PATH" ]; then rm -rf $TESTS_EXTRAS_PATH; fi' INT TERM EXIT

if [ -d "$TESTS_EXTRAS_PATH" ]; then
	rm -rf $TESTS_EXTRAS_PATH
fi

echo "INFO: Fetching tests-extras scripts into $TESTS_EXTRAS_PATH ..."
(git clone -b master $TESTS_EXTRAS_URL $TESTS_EXTRAS_PATH >/dev/null 2>&1)
if [ $? -ne 0 ]; then
	echo "ERROR: Failed to fetch the $TESTS_EXTRAS_URL repo, exiting.."
	exit 1
fi

# 2. Execute
cd $TESTS_EXTRAS_PATH && ./tests-runner.sh $@

# 3. Done; clean-up
cd .. && if [ -d "$TESTS_EXTRAS_PATH" ]; then rm -rf $TESTS_EXTRAS_PATH; fi
