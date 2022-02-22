LAN w/ IGMP Snooping
====================

Source files from demo at seminar on IGMP/MLD snooping and the Linux
5.15+ bridge.  The setup is based around [Qeneth][] for testing a
topology of devices and NetBox, which is the base OS that each node in
the topology runs, and which has [querierd][] integrated.

After building NetBox, generating the Qeneth topology from the source in
this directory, and starting up.  Each node need to be tweaked slightly
from the default NetBox setup:

  * `/etc/hostname` change to reflect the node name
  * `/etc/network/interfaces` change to use static address for `vlan1`
  * `/etc/querierd.conf` changed query interval to 12 sec (optional)

Other worthwhile information is available in the blog connected to the
seminar: <https://westermo.github.io/2022/02/17/bridge-igmp-snooping/>


Setup
-----

To set up and run the demo:

  1. Clone https://github.com/wkz/qeneth
  2. Extract this tarball in `qeneth/`: tar xf lan.tar.xz
  3. Start the demo: `cd lan/ && ../qeneth start`
  4. Set up host side networking from same directory: `./net.sh`
  5. Connect to the console of each node:
     * `../qeneth console querier`
     * `../qeneth console switch1`
     * `../qeneth console switch2`

Inspect each node's `/etc/network/interfaces` file, it shows a preset
with static IP addresses, with `querierd` as the lowest, `.200`, to
ensure it is the elected querier.

Also, in the same file, notice the `pre-up` command for `iface vlan1`:

    pre-up bridge vlan global set vid 1 dev br0 mcast_snooping 1 \
                  mcast_querier 1 mcast_igmp_version 3 mcast_mld_version 2

This is what enables multicast snooping (IGMP and MLD) on VLAN 1, proxy
querier, and sets the initial IGMP version used.  The default version is
2 and 1, respectively, for legacy reasons -- which we do not want for
standards compliance.

Check what's going on in the system, try the following commands:

   * `show spanning-tree`
   * `show ip igmp`

> **Note:** NetBox comes with a few helper scripts; `help` and `show`
> being the two most prominent ones.  They are just wrappers for other
> programs, so see each for details.

The `show ip igmp` command is just a wrapper for `querierctl`, which has
several options.  To ease migration from legacy systems,, and aid with
testing, there is a special command `querierctl -p show compat detail`
that can be useful.


Bridge vs querierd
------------------

Currently in NetBox there are two steps to enable IGMP snooping, first,
as shown above, enable the bridge snooping and proxy querier -- which
works perfectly fine without querierd.  Second, start `querierd`.

In NetBox we've chosen to enable the per-VLAN IGMP/MLD snooping on VLAN
1 and start `querierd` with an `/etc/querired.conf` that enables it on
interface `vlan1`.  As soon as the daemon has started it assumes the
role as querier in the node itself, this because the bridge code only
uses source IP 0.0.0.0 (proxy querier) and never wins an election.  So
if the node is alone on the network `querierd` will become the elected
IGMP querier.


Testing
-------

Since all nodes have a rather high value for their IP address, change
the IP address of `switch1` to `.100` and see what happens.

Check with `querierctl show` to see verify that all nodes now have
agreed on a new elected querier (`.100`) on the LAN.

Drop the IP address of `switch1` and verify that all nodes decrement the
querier timeout and eventually `.200` re-assume the querier role.

To verify that the bridge filtering works as intended, you can use the
[nemesis][] program to inject IGMP reports on the host-connected tap
intefaces: sw1 and sw2.  From the host run:

    sudo nemesis igmp -v -p 22 -S 192.168.2.20 -g 225.1.2.3 -D 225.1.2.3 -d sw1

Or call `sudo ./join.sh` from the same sub-directory as before which
sends a join on both sw1 and sw2.

Verify that all devices from the querier down to the switch connected to
the host interface which sent the report have registered the membership.

Like the case with the new querier timing out, above, the memberships
also time out after a while (see the RFC)

[nemesis]:  https://github.com/libnet/nemesis/
[Qeneth]:   https://github.com/wkz/qeneth
[querierd]: https://github.com/westermo/querierd
