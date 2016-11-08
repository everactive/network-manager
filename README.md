# NetworkManager

This is the snap to package the NetworkManager management service.

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
