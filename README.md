# NetworkManager

This is the snap to package the NetworkManager management service.

## Hook support

All implemented hooks are stored inside the hooks directory.

As snapcraft has no support as of today (09/12/2016) to include
hooks in a snap this always needs to be done manually. For this

$ snapcraft
$ cp -r hooks prime/meta/
$ snapcraft snap prime

does the job. Please note that none of the snaps available from the
store will have these hooks included until snapcraft receives
support for hooks.

## Running tests

We have a set of spread (https://github.com/snapcore/spread) tests which
can be executed on a virtual machine or real hardware.

In order to run those tests you need the follow things

 * ubuntu-image
 * spread

 You can install both as a snap

```
 $ snap install --edge --devmode ubuntu-image
 $ snap install --devmode spread
```

NOTE: As of today (27/10/2016) the version of spread in the store misses
some important bug fixes so you have to build your own one for now:

```
 $ WORKDIR=`mktemp -d`
 $ export GOPATH=$WORKDIR
 $ go get -d -v github.com/snapcore/spread/...
 $ go build github.com/snapcore/spread/cmd/spread
 $ sudo cp spread /usr/local/bin
```

Make sure /usr/local/bin is in your path and is used as default:

```
 $ which spread
 /usr/local/bin/spread
```

Now you have everything to run the test suite.

```
  $ ./run-tests
```

The script will create an image via ubuntu-image and make it available
to spread by copying it to ~/.spread/qemu or ~/snap/spread/<version>/.spread/qemu
depending on if you're using a local spread version or the one from the
snap.

If you want to see more verbose debugging output of spread run

```
 $ ./run-tests --debug
```

If you do not want to build the network-manager snap from source but test one
from a specific channel start testing with

```
 $ ./run-tests --channel=beta --test-from-channel
```

You can also run spread directly which allows you run just specific tests

```
 $ spread tests/main/installation
```

This will by default build the network-manager snap from source. If you
want it to test it from a specific channel run

```
 $ SNAP_CHANNEL=candidate spread tests/main/installation
```

And if you want to run an entire suite

```
 $ spread tests/main/
```

## Available test suites

Currently we have two test suites

 * main
 * full

The 'main' suite covers testing of network-manager when its installed on
any Ubuntu Core device from the store without configuring the system
further to allow NetworkManager to control also all ethernet connections.

The 'full' suite configures netplan in the prepare part to use NetworkManager
as default backend so that it becomes the only network connection
management service in the system.

Depending on the nature of a test case the right test suite should be
picked.
