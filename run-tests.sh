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

TESTS_EXTRAS_URL="https://git.launchpad.net/~snappy-hwe-team/snappy-hwe-snaps/+git/tests-extras"
TESTS_EXTRAS_PATH=".tests-extras"

# Display help.
# This has to be in sync with the tests-extras/test-runner.sh script
# functionalities as the parameters to this one are passed directly there
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
    echo "  --snap                 Extra snap to install"
    echo "  --debug                Enable verbose debugging output"
    echo "  --test-from-channel    Pull network-manager snap from the specified channel instead of building it from source"
    echo "  --force-new-image      Force generating a new image used for testing"
}

# Clone the tests-extras repository
clone_tests_extras() {
	echo "INFO: Fetching tests-extras scripts into $TESTS_EXTRAS_PATH ..."
	(git clone -b master $TESTS_EXTRAS_URL $TESTS_EXTRAS_PATH >/dev/null 2>&1)
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to fetch the $TESTS_EXTRAS_URL repo, exiting.."
		exit 1
	fi
}

# Make sure the already cloned tests-extras repository is in a known and update
# state before it is going to be used.
restore_and_update_tests_extras() {
	echo "INFO: Restoring and updating $TESTS_EXTRAS_PATH"
	(cd $TESTS_EXTRAS_PATH && git reset --hard && git clean -dfx && git pull)
	(cd ..)
}

# ==============================================================================
# This is fetch & forget script and what it does is to fetch the tests-extras
# repo and execute the run-tests.sh script from there passing arguments as-is.
#
# The tests-extras repository ends up checked out in the snap tree but as a
# hidden directory which is re-used since then.

# Display help w/o fetching anything
if [ "$1" == "--help" ]; then
	show_help
	exit 0
fi

if [ -d "$TESTS_EXTRAS_PATH" ]; then
	restore_and_update_tests_extras
else
	clone_tests_extras
fi

echo "INFO: Executing tests runner"
cd $TESTS_EXTRAS_PATH && ./tests-runner.sh $@
