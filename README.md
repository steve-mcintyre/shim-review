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
- Name: Steve Langasek
- Position: shim maintainer
- Email address: vorlon@debian.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community: The file keys/vorlon.pub in this git repo

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
https://github.com/rhboot/shim/tree/15 + commits up to
https://github.com/rhboot/shim/commit/3beb971b10659cf78144ddc5eeea83501384440c

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://salsa.debian.org/vorlon/shim/tree/debian/15+1533136590.3beb971-2

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
No extra patches.

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------
We recommend reproducing the binary by way of using the supplied Dockerfile:

`docker build .`

The binary is built on Debian unstable as of 2019-02-11.

Versions used can be found in the build log.

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
shim_15+1533136590.3beb971-2_amd64.log

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
[your text here]
