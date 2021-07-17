NetBox - Like BusyBox but for Networking
========================================

[Westermo][] NetBox is a toolbox for embedded systems based on [Buildroot][].

NetBox provides easy access to all Westermo specific custimizations made to
Linux and other [Open Source][] projects used in WeOS.  You can use it as
the base for any application, but is strongly recommended for all use cases
for container applications running in WeOS.  Official WeOS container
applications will be based on NetBox.

NetBox is built using the Buildroot *External Tree* facility.  This is a
layered approach which enables customizing without changing Buildroot.
You may use NetBox as NetBox use Buildroot, see the [App-Demo][] project
for an example -- click *Use this template* -- to create your own.

To contribute, see the file [HACKING][] for details.


Versioning
----------

NetBox use the same versioning as Buildroot, with an appended `-rN` to
denote the *revision* of Buildroot with Westermo extensions.  E.g., the
first release is 2020.02-r1.


Platforms
---------

The NetBox project follows the Westermo product platform naming.  This to
be able to easily match what container image works on a Westermo device:

| **Architecture** | **Platform Name** | **Nightly App** | **Nightly OS** |
|------------------|-------------------|-----------------|----------------|
| arm9             | Basis             | [basis.app][]   | [basis.os][]   |
| powerpc          | Coronet           | [coronet.app][] | [coronet.os][] |
| arm cortex-a9    | Dagger            | [dagger.app][]  | [dagger.os][]   |
| aarch64          | Envoy             | [envoy.app][]   | [envoy.os][]   |
| x86_64           | Zero              | [zero.app][]    | [zero.os][]    |

> **Note:** the *Envoy* platform includes support also for the Marvell
> ESPRESSObin (Globalscale) and MACCHIATObin (Solidrun) boards.


Flavor
------

In addition to various NetBox platforms there are two major *flavors*
available.  The current first-class citizen is *apps*, but it is also
possible to build an entire *operating system* image, including Linux
kernel and the same userland already available to *apps*.  To select
a pre-configured NetBox flavor for a given platform:

- `netbox_app_$platform`
- `netbox_os_$platform`


Requirements
------------

The build environment requires the following tools, tested on Ubuntu
21.04 (x86_64): make, gcc, g++, m4, and openssl development package.
On Debian based systems:

```sh
~$ sudo apt install build-essential m4 libssl-dev
```

To run in Qemu, either enable host-side build in `make menuconfig`, or
for quicker builds you can use the version shipped with your Linux host.
On Debian based systems:

```sh
~$ sudo apt install qemu-system
```

For smooth sailing, after install, add the following line to the file
`/etc/qemu/bridge.conf`:

```ApacheConf
allow all
```

For network access to work out of the box in your Qemu system, install
the virt-manager package, this creates a host bridge called `virbr0`:

```sh
~$ sudo apt install virt-manager
```


Building
--------

First clone the repository, optionally check out the tagged release you
want to use.  The build system clones the submodule on the first build,
but you can also run the command manually:

```sh
~$ cd ~/src
~/src$ git clone https://github.com/westermo/netbox.git
~/src$ cd netbox
~/src/netbox$ git submodule update --init
```

Second, select your target `_defconfig`, see the `configs/` directory,
or use `make list-defconfigs` to see all Buildroot and NetBox configs
available.  We select the defconfig for Zero (x86-64) NetBox app flavor:

```sh
~/src/netbox$ make netbox_app_zero_defconfig
```

Third, type make and fetch a cup of coffee because the first time you
build it will take some time:

```sh
~/src/netbox$ make
```

Done.  See the `output/images/` directory for the resulting SquasFS
based root file system: `netbox-app-zero.img`


Running
-------

All NetBox OS builds are supported by Qemu.  This is actually a corner
stone in NetBox, and principal testing strategy at Westermo.  It can be
highly useful for quick turnarounds when developing and testing new
features.

Any feature targeting OSI layer 3, and above, need nothing else to run.
For more advanced test setups, with multiple networked Qemu nodes, we
highly recommend [Qeneth](https://github.com/wkz/qeneth).

To start a single node:

```sh
~/src/netbox$ make run
```

> **Note:** you may need `sudo`, unless you have set up your system with
> capabilities https://troglobit.com/2016/12/11/a-life-without-sudo/


### Basic Networking in Qemu

By default, this command starts the `utils/qemu` script and tries to
connect one interface to a host bridge called `virbr0`.  That bridge
only exists if you installed virt-manager (above), if not, you can have
a look at the `utils/qemu` script arguments and environment variables,
or try:

```sh
~/src/netbox$ make QEMU_NET=tap run
```

### Persistent Storage in Qemu

Qemu nodes start from the same read-only SquasFS image as built for all
targets.  For persistent storage a disk image file on the host system is
used.  This is controlled by the environment variable `$QEMU_MNT`, which
defaults to `VENDOR-config-PLATFORM.img`, provided `~/.cache` exists .
E.g., for NetBox Zero OS: `~/.cache/netbox-config-zero.img`.  See the
helper script `utils/qemu` for more information.


### Sharing a Host Directory with Qemu

NetBox support 9P file sharing between the host and Qemu targets.  Set
directory to share, using the absolute path, in `QEMU_HOST`:

```
~/src/netbox$ make run QEMU_HOST=/tmp
```


### Example

Here is an example run of a Zero OS build, the persistent store for all
your configuration (in `/etc` or `/home`) is stored in a disk image file
named `~/.cache/netbox-config-zero.img`:

```sh
~/src/netbox$ make distclean
~/src/netbox$ make netbox_os_zero_defconfig
~/src/netbox$ make
~/src/netbox$ make run
```

> **Note:** you may still need to call `sudo make run`, see the note on
> capabilities, above.


### Running in LXC or LXD

The NetBox app builds can be run in LXC, or LXD, on your PC but this is
not yet documented here.  It is even possible to run non-native archs,
like Arm64, on your PC using Linux "binfmt misc" support, in which case
all binaries are run through `qemu-aarch64`.  It both feels and really
*is* a very weird thing.  This is not documented yet and we instead
encourage all newbies to try out the Zero app builds in LXC first.

For an example, see https://github.com/myrootfs/myrootfs#lxd



[Westermo]:      https://www.westermo.com/
[Buildroot]:     https://buildroot.org/ 
[HACKING]:       HACKING.md
[App-Demo]:      https://github.com/westermo/app-demo
[Open Source]:   https://en.wikipedia.org/wiki/Free_and_open-source_software
[basis.app]:     https://nightly.link/westermo/netbox/workflows/build/master/netbox-app-basis.tar.gz
[coronet.app]:   https://nightly.link/westermo/netbox/workflows/build/master/netbox-app-coronet.tar.gz
[dagger.app]:    https://nightly.link/westermo/netbox/workflows/build/master/netbox-app-dagger.tar.gz
[envoy.app]:     https://nightly.link/westermo/netbox/workflows/build/master/netbox-app-envoy.tar.gz
[zero.app]:      https://nightly.link/westermo/netbox/workflows/build/master/netbox-app-zero.tar.gz
[basis.os]:      https://nightly.link/westermo/netbox/workflows/build/master/netbox-os-basis.tar.gz
[coronet.os]:    https://nightly.link/westermo/netbox/workflows/build/master/netbox-os-coronet.tar.gz
[dagger.os]:     https://nightly.link/westermo/netbox/workflows/build/master/netbox-os-dagger.tar.gz
[envoy.os]:      https://nightly.link/westermo/netbox/workflows/build/master/netbox-os-envoy.tar.gz
[zero.os]:       https://nightly.link/westermo/netbox/workflows/build/master/netbox-os-zero.tar.gz
