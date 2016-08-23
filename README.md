Overview
========

This repository contains a snapcraft build configuration for
NetworkManager. At the moment this is not officially supported.

You can reach us on the #snappy IRC channel on freenode.

Dependencies
============

For 15.04 builds, snapcraft must be installed the Snappy Tools
PPA:

sudo add-apt-repository ppa:snappy-dev/tools
sudo apt-get update

We require snapcraft >= 1.1 for building this snap.

Build Instructions
==================

To build this project just use snapcraft::

 $ snapcraft

If you want to get the snap install for first tests in a KVM
based environment you can just run

 $ snapcraft run

after the snap is successfully built.

If you're doing active developing on the snap the following
steps have proved to be a good workflow:

1. Build the snap as described above and start a KVM instance
   with snapcraft run
2. Enter the snapcraft shell

 $ snapcraft shell
 $ cd parts/network-manager/build

3. Do necessary modifications on the source code and build
   everything with

 $ make

4. Now we copy the changed files manually to the KVM instance
   at the right location:

 $ scp -P 8022 parts/network-manager/build/src/.libs/NetworkManager \
       ubuntu@localhost:~
 $ ssh -p 8022 ubuntu@localhost sudo cp NetworkManager \
       /apps/network-manager/ICFNJfIJIFSD/usr/sbin/NetworkManager
