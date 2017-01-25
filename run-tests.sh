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
GITIGNORE=".gitignore"

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

# Commit the .gitignore file
commit_gitignore() {
	echo "INFO: Commiting $GITIGNORE"
	(git add $GITIGNORE && git commit -m "$TESTS_EXTRAS_PATH should not be tracked" >/dev/null 2>&1)
	if [ $? -ne 0 ]; then
		echo "WARN: Failed to add $TESTS_EXTRAS_PATH to .gitignore and commit, script will continue but please check"
	fi
}

# Tell git to ignore the tests-extras subdirectory
# It updates the .gitignore file and commits it unless it has local
# modifications. The .gitignore is:
# - created and commited if does not yet exists.
# - updated and commited if exists and w/o local modifications
# - updated and not commited if exists and with local modifications
add_tests_extras_to_gitignore() {
	echo "INFO: Adding tests-extras to gitignore"
	if [ ! -f "$GITIGNORE" ]; then
		echo $TESTS_EXTRAS_PATH > $GITIGNORE
		commit_gitignore
	else
		(git status -s $GITIGNORE | grep -q M)
		should_commit=$?

		(grep $TESTS_EXTRAS_PATH -q $GITIGNORE)
		not_yet_ignored=$?
		if [ $not_yet_ignored -eq 1 ]; then

			echo $TESTS_EXTRAS_PATH >> $GITIGNORE
			
			if [ $should_commit -eq 1 ]; then
				commit_gitignore
			else
				echo "WARN: Your .gitignore has been updated but cannot be commited, script will continue but please check"
			fi
		else
			echo "INFO: $TESTS_EXTRAS_PATH already ignored by git"
		fi
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
# hidden directory which is re-used since then. Also it is added to .gitignore
# so that it does not end-up being tracked by accident. 

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
add_tests_extras_to_gitignore

echo "INFO: Executing tests runner"
cd $TESTS_EXTRAS_PATH && ./tests-runner.sh $@
