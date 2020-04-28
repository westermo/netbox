NetBox - Like BusyBox but for Networking
========================================

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

| Architecture | Platform Code Name |
|--------------|--------------------|
| powerpc      | Coronet            |
| arm          | Dagger             |
| aarch64      | Envoy              |
| x86_64       | Zero               |


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
available.  We select the Zero (x86-64) NetBox defconfig:

```
make netbox_zero_defconfig
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


[Westermo]:    https://www.westermo.com/
[Buildroot]:   https://buildroot.org/ 
[App-Demo]:    https://github.com/westermo/app-demo
[myRootFS]:    https://github.com/myrootfs
[Open Source]: https://en.wikipedia.org/wiki/Free_and_open-source_software 
