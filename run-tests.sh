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

set -ex

show_help() {
    echo "Usage: run-tests.sh [OPTIONS]"
    echo
    echo "optional arguments:"
    echo "  --help        Show this help message and exit"
    echo "  --channel     Select another channel to build the base image from"
    echo "  --debug       Enable verbose debugging output"
}

image_name=ubuntu-core-16.img
channel=candidate
spread_opts=
force_new_image=0

while [ "$1" != '' ]; do
	case "$1" in
		--help)
			show_help
			exit
			;;
		--channel=*)
			channel=$(echo "$1" | cut -d= -f 2)
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

# Make sure we have an base image we use for testing
if [ ! -e $HOME/.spread/qemu/$image_name ] || [ $force_new_image -eq 1 ] ; then
	echo "INFO: Creating new qemu test image ..."
	(cd tests/image ; sudo ./create-image.sh $channel)
	mkdir -p $HOME/.spread/qemu
	mv tests/image/ubuntu-core-16.img $HOME/.spread/qemu/$image_name
fi

# We currently only run spread tests but we could do other things
# here as well like running our snap-lintian tool etc.
export SNAP_CHANNEL=$channel
exec spread $spread_opts
