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

image_name=ubuntu-core-16.img
channel=stable
snap=
spread_opts=
force_new_image=0
test_from_channel=0

show_help() {
    echo "Usage: run-tests.sh [OPTIONS]"
    echo
    echo "Uses spread to execute tests. If required or prompted can generate"
    echo "Ubuntu Core image for testing."
    echo
    echo "optional arguments:"
    echo "  --help                 Show this help message and exit"
    echo "  --channel              Select another channel to build the base image from (default: $channel)"
    echo "  --snap		   Extra snap to install"
    echo "  --debug                Enable verbose debugging output"
    echo "  --test-from-channel    Pull network-manager snap from the specified channel instead of building it from source"
    echo "  --force-new-image      Force generating a new image used for testing"
}

while [ -n "$1" ]; do
	case "$1" in
		--help)
			show_help
			exit
			;;
		--channel=*)
			channel=${1#*=}
			shift
			;;
		--snap=*)
			snap=${1#*=}
			shift
			;;
		--test-from-channel)
			test_from_channel=1
			shift
			;;
		--debug)
			spread_opts="$spread_opts -vv -debug"
			shift
			;;
		--force-new-image)
			force_new_image=1
			shift
			;;
		*)
			echo "Unknown command: $1"
			exit 1
			;;
	esac
done

SPREAD_QEMU_PATH="$HOME/.spread/qemu"
if [ `which spread` = /snap/bin/spread ] ; then
	current_version=`readlink /snap/spread/current`
	SPREAD_QEMU_PATH="$HOME/snap/spread/$current_version/.spread/qemu/"
fi

# Make sure we have a base image we use for testing
if [ ! -e $SPREAD_QEMU_PATH/$image_name ] || [ $force_new_image -eq 1 ] ; then

	# Get the image creating scripts
	CREATE_IMAGE_URL="https://git.launchpad.net/~snappy-hwe-team/snappy-hwe-snaps/+git/create-image-scripts"
	TESTS_EXTRAS_PATH="tests-extras"
	CREATE_IMAGE_PATH=$TESTS_EXTRAS_PATH"/create-image-scripts"

	if [ -d "$TESTS_EXTRAS_PATH" ]; then
		rm -rf $TESTS_EXTRAS_PATH
	fi
	echo "INFO: Fetching test image creating scripts into $TESTS_EXTRAS_PATH ..."
	(git clone -b master $CREATE_IMAGE_URL $TESTS_EXTRAS_PATH >/dev/null 2>&1)
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to fetch the $CREATE_IMAGE_URL repo, exiting.."
		exit 1
	fi

	echo "INFO: Creating new qemu test image ..."
	(cd $CREATE_IMAGE_PATH; sudo ./create-image.sh $channel $snap)
	mkdir -p $SPREAD_QEMU_PATH
	mv $CREATE_IMAGE_PATH/ubuntu-core-16.img $SPREAD_QEMU_PATH/$image_name

	# Not needed at this point
	rm -rf $TESTS_EXTRAS_PATH
fi

# We currently only run spread tests but we could do other things
# here as well like running our snap-lintian tool etc.
if [ $test_from_channel -eq 1 ] ; then
	export SNAP_CHANNEL=$channel
fi
spread $spread_opts
