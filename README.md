NetBox - Like BusyBox but for Networking
========================================

[Westermo][] NetBox is a toolbox for embedded systems based on [Buildroot][].

NetBox provides easy access to all Westermo specific custimizations made
to Linux and other [Open Source][] projects used in [WeOS][].  You can use
it as the base for any application, but is strongly recommended for all use
cases for container applications running in WeOS.  Official WeOS container
applications will be based on NetBox.

NetBox is built using the *External Tree* facility in Buildroot.  This is a
layered approach making it easy to customize without changing Buildroot at
its core.  Proprietary applications may use NetBox as NetBox use Buildroot,
see the [App-Demo][] project for an example of this.


Building
--------

First clone the repository, optionally check out the tagged release you
want to use:

```
cd ~/src
git clone https://github.com/westermo/netbox.git
cd netbox
git submodule update --init
```

Second, select your target `_defconfig`, see the `configs/` directory,
or use `make list-defconfigs` to see all Buildroot and NetBox configs
available.  We select the x86-64 NetBox defconfig:

```
make netbox_x86_64_defconfig
```

Third, type make and fetch a cup of coffee because the first time you
build it will take some time:

```
make
```

Done.  See the `output/images/` directory for the resulting SquasFS
based root filesystem.


Versioning
----------

NetBox use the same versioning as Buildroot, with an appended `-rN` to
denote the *revision* of Buildroot with Westermo extensions.


[Westermo]:    https://www.westermo.com/
[Buildroot]:   https://buildroot.org/ 
[App-Demo]:    https://github.com/westermo/app-demo
[Open Source]: https://en.wikipedia.org/wiki/Free_and_open-source_software 
