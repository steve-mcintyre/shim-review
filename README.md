This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your branch
- approval is ready when you have accepted tag

Note that we really only have experience with using GRUB2 on Linux, so asking
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
- Position: Debian EFI team lead
- Email address: 93sam@debian.org
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community: The file keys/93sam.pub in this git repo

-------------------------------------------------------------------------------
Please create your shim binaries starting with the 15.4 shim release tar file:
https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.4 and contains
the appropriate gnu-efi source.
-------------------------------------------------------------------------------
Yes, we are using the source from
https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://salsa.debian.org/efi-team/shim/-/tree/debian/15.4-2

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------

We're applying four patches (3 already upstream, 1 in a PR), as
recommended for various fixes. See the patches in the debian/patches
directory in our shim packaging:

  * fix-import_one_mok_state.patch
    issue #362 (Fix mokutil --disable-validation)
    upstream commit 822d07ad4f07ef66fe447a130e1027c88d02a394

  * fix-broken-ia32-reloc.patch
    issue #357 (Fix a broken file header on ia32)
    upstream commit 1bea91ba72165d97c3b453cf769cb4bc5c07207a

  * MOK-BootServicesData.patch
    issue #361 (mok: allocate MOK config table as BootServicesData)
    upstream commit 4068fd42c891ea6ebdec056f461babc6e4048844

  * Don-t-call-QueryVariableInfo-on-EFI-1.10-machines.patch
    issue #364 (fails to boot on older Macs, and other machines with EFI < 2)
    commit 8b59591775a0412863aab9596ab87bdd493a9c1e in the PR from
    Peter Jones

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2: is CVE-2020-14372, CVE-2020-25632,
 CVE-2020-25647, CVE-2020-27749, CVE-2020-27779, CVE-2021-20225, CVE-2021-20233,
 CVE-2020-10713, CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311,
 CVE-2020-15705, and if you are shipping the shim_lock module CVE-2021-3418
-------------------------------------------------------------------------------
We include patches for all of:
CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311

For the other two CVEs listed here:
* CVE-2020-15705 does not affect our codebase due to other patches (as
  explained back in the boothole days).
* We don't use the shim_lock module, so CVE-2021-3418 does not apply
  to us.

-------------------------------------------------------------------------------
What exact implementation of Secureboot in GRUB2 ( if this is your bootloader ) you have ?
* Upstream GRUB2 shim_lock verifier or * Downstream RHEL/Fedora/Debian/Canonical like implementation ?
-------------------------------------------------------------------------------
We have our own downstream implementation. We're working on
upstreaming patches, but it's slow going... :-/

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2, and previous shims were trusting affected
by CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2:
* were old shims hashes provided to Microsoft for verification
  and to be added to future DBX update ?
* Does your new chain of trust disallow booting old, affected by CVE-2020-14372,
  CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2 builds ?
-------------------------------------------------------------------------------

* For the July 2020 boothole issues, we provided Microsoft with the
  details of our intermediate signing cert and that was included in
  the DBX update at the time. ("Debian Secure Boot Signer": fingerprint
  f156d24f5d4e775da0e6a9111f074cfce701939d688c64dba093f97753434f2c). We
  moved to a new cert ("Debian Secure Boot Signer 2020": fingerprint
  3a91a54f9f46a720fe5bbd2390538ba557da0c2ed5286f5351fe04fff254ec31).

* For the March 2021 issues, we have again revoked our signer cert
  ("Debian Secure Boot Signer 2020": fingerprint
  3a91a54f9f46a720fe5bbd2390538ba557da0c2ed5286f5351fe04fff254ec31)
  and switched to new per-project certs for each of the things we sign
  ourselves:

  * Debian Secure Boot Signer 2021 - fwupd
    * (fingerprint 309cf4b37d11af9dbf988b17dfa856443118a41395d094fa7acfe37bcd690e33)
  * Debian Secure Boot Signer 2021 - fwupdate
    * (fingerprint e3bd875aaac396020a1eb2a7e6e185dd4868fdf7e5d69b974215bd24cab04b5d)
  * Debian Secure Boot Signer 2021 - grub2
    * (fingerprint 0ec31f19134e46a4ef928bd5f0c60ee52f6f817011b5880cb6c8ac953c23510c)
  * Debian Secure Boot Signer 2021 - linux
    * (fingerprint 88ce3137175e3840b74356a8c3cae4bdd4af1b557a7367f6704ed8c2bd1fbf1d)
  * Debian Secure Boot Signer 2021 - shim
    * (fingerprint 40eced276ab0a64fc369db1900bd15536a1fb7d6cc0969a0ea7c7594bb0b85e2)

  In addition to those changes, we have provided Microsoft with
  details of all the shim binaries they have ever signed for us, so
  they can be revoked to enforce switching to binaries including SBAT
  in the future.

  Also, the shim binary here includes a vendor DBX list that blocks
  all of the grub binaries that we have ever signed for this
  architecture.

-------------------------------------------------------------------------------
If your boot chain of trust includes linux kernel, is
"efi: Restrict efivar_ssdt_load when the kernel is locked down"
upstream commit 1957a85b0032a81e6482ca4aab883643b8dae06e applied ?
Is "ACPI: configfs: Disallow loading ACPI tables when locked down"
upstream commit 75b0cea7bf307f362057cc778efe89af4c615354 applied ?
-------------------------------------------------------------------------------

Yes, we applied those fixes during the boothole event and they are
still there in all our signed kernels.

-------------------------------------------------------------------------------
If you use vendor_db functionality of providing multiple certificates and/or
hashes please briefly describe your certificate setup. If there are allow-listed hashes
please provide exact binaries for which hashes are created via file sharing service,
available in public with anonymous access for verification
-------------------------------------------------------------------------------

We include a single vendor CA certificate in our shim, and that has
been used to sign all of our further signer certificates listed
above. We do not have any hashes added beyond that. See the file
```debian-uefi-ca.der``` for that CA certificate.

-------------------------------------------------------------------------------
If you are re-using a previously used (CA) certificate, you will need
to add the hashes of the previous GRUB2 binaries to vendor_dbx in shim
in order to prevent GRUB2 from being able to chainload those older GRUB2
binaries. If you are changing to a new (CA) certificate, this does not
apply. Please describe your strategy.
-------------------------------------------------------------------------------

The shim binary here includes a vendor DBX list that blocks all
of the grub binaries that we have ever signed for each architecture
prior to SBAT being introduced.

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and the differences would be.
-------------------------------------------------------------------------------

We recommend reproducing the binary by way of using the supplied Dockerfile:

`docker build .`

The binaries build reproducibly on Debian "bullseye" as of 2021-04-22.

Versions used can be found in the build logs.

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------

* ```shim_15.4-2_amd64.log```
* ```shim_15.4-2_i386.log```

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------
N/A
