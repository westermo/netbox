Hacking the NetBox
==================

This file is a Checklist and things to consider when hacking on this
project.  Maintainers, and project leads, check section Releases.


Contributing
------------

We prefer GitHub pull requests since it allows for auditing all changes
that go into the tree:

  0. If you already have write access to the repo, continue to 2.
  1. Clone the project to your own user on GitHub
  2. Create a branch for your feature/fix, use a descriptive branch name
  3. Prepare your GitHub Pull Request

General guidelines:

  1. Keep commits small and logical:
     - separate white space changes from actual changes
	 - changes to different demos should be different pull requests,
	   unless the pull request is common to more than one
  2. For C code we use Linux kernel coding style, no exceptions
  3. For C code, try building (and running) locally first.  Always set
     strict warning flags to GCC, e.g. `-W -Wall -Wextra`
  4. For shell scripts, run them locally first
  5. For shell scripts, run `shellcheck` to lint
  6. For changes to either C or shell scripts; *follow the coding style
     used in the existing code*.  Shell scripts are either tab or four
     space indent -- never mixed in the same script

And ... to add new packages, please follow the [Buildroot Guidelines][].


Kernel Upgrade
--------------

   0. Remember to also update `patches/` symlinks


Releases
--------

To trigger release builds, the `RELEASE=` variable must be set from the
command line, but you must also have tagged the repository.

  1. Tag the repository: `$BR2_VERSION-rN`
  2. Set the environment `RELEASE=$BR2_VERSION-rN` and run make

A less error-prone alternative, GitHub actions run when a tag is pushed.
They are completely automated; release-generation, build, as well as
upload of `.tar.gz` archives of the `output/images` directory for each
profile-platform tuple.

Tags must follow the following syntax:

    BUILDROOT.VERSION-rNUM[-(alpha|beta|rc)NUM]

For details on the versioning scheme, see section Versioning, below.

**Examples:**

  - 2020.02-r0
  - 2020.02-r1
  - 2021.02-r0-beta1
  - 2038.02-r42-rc1

Please note, `-alphaN`, `-betaN`, and `-rcN` are tagged as `prerelease`
in the GitHub Release page, and should only be used for internal testing
at Westermo.


Versioning
----------

NetBox use the same versioning as Buildroot, with an appended `-rN` to
denote the *revision* of Buildroot with Westermo extensions.  E.g., the
first release is 2020.02-r1.

NetBox releases are generally cut from the Buildroot LTS branch as base.
Buildroot starts a new LTS cycle every year in February, hence NetBox
releases are usually named `YEAR.02-rN`.  The *revision* is not in any
way reflecting content level, it is simply incremented for each release
with the same base, there may be hundreds of changes, or just one.


[Buildroot Guidelines]: https://buildroot.org/downloads/manual/manual.html#adding-packages
