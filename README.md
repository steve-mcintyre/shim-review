This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your branch

Note that we really only have experience with using grub2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------
Debian

-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------
Debian GNU/Linux

-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------
Debian is a well-known GNU/Linux distribution.

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Debian Security Team
- Position: Security team
- Email address: security@debian.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community: The file keys/security-team.pub in this git repo


-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Steve McIntyre
- Position: Debian EFI team lead maintainer
- Email address: 93sam@debian.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community: The file keys/93sam.pub in this git repo

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
https://github.com/rhboot/shim/tree/15 + commits up to
https://github.com/rhboot/shim/commit/3beb971b10659cf78144ddc5eeea83501384440c

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://salsa.debian.org/efi-team/shim/tree/debian/15+1533136590.3beb971-3

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
Two trivial build system changes:

* https://salsa.debian.org/efi-team/shim/blob/master/debian/patches/fixup_git.patch
  - don't run git in clean; we're not really in a git tree
* https://salsa.debian.org/efi-team/shim/blob/master/debian/patches/uname.patch
  - Add uname.patch to avoid architecture variability

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------
We recommend reproducing the binary by way of using the supplied Dockerfile:

`docker build .`

The binary is built on Debian unstable as of 2019-03-09.

Versions used can be found in the build logs.

Note that docker must be run on all of i386, amd64 and arm64 for complete verification.

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------

TBD: just uploaded -3

shim_15+1533136590.3beb971-2_amd64.log
shim_15+1533136590.3beb971-2_arm64.log
shim_15+1533136590.3beb971-2_i386.log

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
[your text here]
