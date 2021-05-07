NetBox - Like BusyBox but for Networking
========================================
[![Travis Status]][Travis]

[Westermo][] NetBox is a toolbox for embedded systems based on [Buildroot][].

NetBox provides easy access to all Westermo specific custimizations made to
Linux and other [Open Source][] projects used in WeOS.  You can use it as
the base for any application, but is strongly recommended for all use cases
for container applications running in WeOS.  Official WeOS container
applications will be based on NetBox.

NetBox is built using the *External Tree* facility in Buildroot.  This is a
layered approach making it easy to customize without changing Buildroot at
its core.  Proprietary applications may use NetBox as NetBox use Buildroot,
see the [App-Demo][] project for an example of this.


Platforms
---------

The NetBox project follows the Westermo product platform naming.  This to
be able to easily match what container image works on a Westermo device:

| **Architecture** | **Platform Code Name** | **Nightly App Image** | **Nightly OS Image** |
|------------------|------------------------|-----------------------|----------------------|
| arm9             | Basis                  | N/A                   | **in-progress**      |
| powerpc          | Coronet                | [coronet.app][]       | **in-progress**      |
| arm cortex-a9    | Dagger                 | [dagger.app][]        | **in-progress**      |
| aarch64          | Envoy                  | **pending**           | **pending**          |
| x86_64           | Zero                   | [zero.app][]          | **in-progress**      |


Flavor
------

In addition to various NetBox platforms there are two major *flavors*
available.  The current first-class citizen is *apps*, but it is also
possible to build an entire *operating system* image, including Linux
kernel and the same userland already available to *apps*.  To select
a pre-configured NetBox flavor for a given platform:

- `netbox_app_$platform`
- `netbox_os_$platform`


Building
--------

First clone the repository, optionally check out the tagged release you
want to use.  The build system clones the submodule on the first build,
but you can also run the command manually:

```
cd ~/src
git clone https://github.com/westermo/netbox.git
cd netbox
git submodule update --init
```

Second, select your target `_defconfig`, see the `configs/` directory,
or use `make list-defconfigs` to see all Buildroot and NetBox configs
available.  We select the defconfig for Zero (x86-64) NetBox app flavor:

```
make netbox_app_zero_defconfig
```

Third, type make and fetch a cup of coffee because the first time you
build it will take some time:

```
make
```

Done.  See the `output/images/` directory for the resulting SquasFS
based root filesystem: `netbox-$platform.img`

> **Note:** the included NetBox `defconfigs` use pre-built toolchains from
> the [myRootFS][] project, built from crosstool-NG.  See that project for
> details, including the `.config` needed to rebuild for your own build
> machine.  Archives are available under *Releases*


Running
-------

All NetBox os builds can be run in Qemu.  Highly useful for quick
turnarounds when developing and testing new features.

```
make run
```

The NetBox app builds can be run in LXC, or LXD, on your PC but this is
not yet documented here.  It is even possible to run non-native archs,
like Arm64, on your PC using Linux "binfmt misc" support, in which case
all binaries are run through `qemu-aarch64`.  It both feels and really
*is* a very weird thing.  So it's not documented yet and we instead
encourage all newbies to try out the Zero app builds in LXC first.

- https://github.com/myrootfs/myrootfs#lxd


### Example

Here's an example run of a Zero OS build, with the added bonus of a
persistent store for all configuration using an image file in your
`~/.cache/`:

```
make distclean
make netbox_os_zero_defconfig
make
QEMU_MNT=~/.cache/netbox-zero.img make run
```


Versioning
----------

NetBox use the same versioning as Buildroot, with an appended `-rN` to
denote the *revision* of Buildroot with Westermo extensions.  E.g., the
first release is 2020.02-r1.


Releasing
---------

To trigger release builds, the `RELEASE=` variable must be set from the
command line, but you must also have tagged the repository.

  1. Tag the repository: `$BR2_VERSION-rN`
  2. Set the environment variable `RELEASE=$BR2_VERSION-rN` and run make


[Westermo]:      https://www.westermo.com/
[Buildroot]:     https://buildroot.org/ 
[App-Demo]:      https://github.com/westermo/app-demo
[myRootFS]:      https://github.com/myrootfs
[Open Source]:   https://en.wikipedia.org/wiki/Free_and_open-source_software
[coronet.app]:   https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-app-coronet.zip
[dagger.app]:    https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-app-dagger.zip
[zero.app]:      https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-app-zero.zip
[coronet.os]:    https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-os-coronet.zip
[dagger.os]:     https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-os-dagger.zip
[zero.os]:       https://nightly.link/westermo/netbox/workflows/nightly-apps/master/netbox-os-zero.zip
[Travis]:        https://travis-ci.org/westermo/netbox
[Travis Status]: https://travis-ci.org/westermo/netbox.png?branch=master
