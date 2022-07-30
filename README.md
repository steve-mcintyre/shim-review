This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
### What organization or people are asking to have this signed?
-------------------------------------------------------------------------------
Debian

-------------------------------------------------------------------------------
### What product or service is this for?
-------------------------------------------------------------------------------
Debian GNU/Linux 12 (Bookworm)

-------------------------------------------------------------------------------
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
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
### Were these binaries created from the 15.6 shim release tar?
Please create your shim binaries starting with the 15.6 shim release tar file: https://github.com/rhboot/shim/releases/download/15.6/shim-15.6.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.6 and contains the appropriate gnu-efi source.

-------------------------------------------------------------------------------
Yes, we are using the source from https://github.com/rhboot/shim/releases/download/15.6/shim-15.6.tar.bz2

-------------------------------------------------------------------------------
### URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://salsa.debian.org/efi-team/shim/-/tree/debian/15.6-1

-------------------------------------------------------------------------------
### What patches are being applied and why:
-------------------------------------------------------------------------------
None!

-------------------------------------------------------------------------------
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
-------------------------------------------------------------------------------

We have our own downstream implementation. We're working on
upstreaming patches, but it's slow going... :-/

-------------------------------------------------------------------------------
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, or the June 7th 2022 grub2 CVE list:
* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

We include patches for all of:
CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311

For the other two CVEs listed here:
* CVE-2020-15705 does not affect our codebase due to other patches (as
  explained back in the boothole days).
* We haven't used the shim_lock module, so CVE-2021-3418 does not apply
  to us.

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736

We have patches included for all of these in our GRUB2 package

* CVE-2022-28737

This was fixed in shim 15.6, so we have this fix too.

### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
-------------------------------------------------------------------------------

* For the July 2020 boothole issues, we provided Microsoft with the
  details of our intermediate signing cert and that was included in
  the DBX update at the time. ("Debian Secure Boot Signer": fingerprint
  f156d24f5d4e775da0e6a9111f074cfce701939d688c64dba093f97753434f2c). We
  moved to a new cert ("Debian Secure Boot Signer 2020": fingerprint
  3a91a54f9f46a720fe5bbd2390538ba557da0c2ed5286f5351fe04fff254ec31).

* For the March 2021 issues, we again revoked our signer cert
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

  In addition to those changes, we provided Microsoft with details of
  all the shim binaries they have ever signed for us, so they can be
  revoked to enforce switching to binaries including SBAT in the
  future.

  Also, the shim binary here includes a vendor DBX list that blocks
  all of those older vulnerable grub binaries that we ever signed for
  this architecture.

-------------------------------------------------------------------------------
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
-------------------------------------------------------------------------------

We applied the first two fixes during the boothole event and they are
still there in all our signed kernels.

The kgdb fix is included in our current kernel sources, but we don't
enable kgdb anyway in our binary builds..

-------------------------------------------------------------------------------
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
-------------------------------------------------------------------------------

We don't use vendor_db.

-------------------------------------------------------------------------------
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
-------------------------------------------------------------------------------

The shim binary here includes a vendor DBX list that blocks all
of the grub binaries that we have ever signed for each architecture
prior to SBAT being introduced.

-------------------------------------------------------------------------------
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
-------------------------------------------------------------------------------

We recommend reproducing the binary by way of using the supplied Dockerfile:

`docker build .`

The binaries build reproducibly on Debian "unstable" as of 2021-06-23.

Versions used can be found in the build logs.

-------------------------------------------------------------------------------
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------

* ```shim_15.6-1_amd64.log```
* ```shim_15.6-1_arm64.log```
* ```shim_15.6-1_i386.log```

-------------------------------------------------------------------------------
### What changes were made since your SHIM was last signed?
-------------------------------------------------------------------------------

We've moved forwards to the latest upstream release, and dropped all
our patches as they're all upstream. Yay!

-------------------------------------------------------------------------------
### What is the SHA256 hash of your final SHIM binary?
-------------------------------------------------------------------------------

74afeac0e6d640c9f5de6fbbce79eae34a7719a3654fcffec8e2e03028c482ae  shimx64.efi
ebbb83c7c7b22e353ef4580b4e7a690c895226122d9c0dce0ac1eb1b9b87ecda  shimaa64.efi
69dc1b4a118a74a4d4162a7dd0532b488bb7837cc9d948c600d7ec2139ee9d81  shimia32.efi

-------------------------------------------------------------------------------
### How do you manage and protect the keys used in your SHIM?
-------------------------------------------------------------------------------

Our signing keys are kept in an HSM, with strict access control to
that machine.

-------------------------------------------------------------------------------
### Do you use EV certificates as embedded certificates in the SHIM?
-------------------------------------------------------------------------------

No.

-------------------------------------------------------------------------------
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
-------------------------------------------------------------------------------

sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,2,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/
grub.debian,1,Debian,grub2,2.06-3,https://tracker.debian.org/pkg/grub2

sbat,1,UEFI shim,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
fwupd-efi,1,Firmware update daemon,fwupd-efi,1.2,https://github.com/fwupd/fwupd-efi
fwupd-efi.debian,1,Debian,fwupd,1:1.2-3,https://tracker.debian.org/pkg/fwupd

sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,2,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.debian,1,Debian,shim,15.6,https://tracker.debian.org/pkg/shim

-------------------------------------------------------------------------------
### Which modules are built into your signed grub image?
-------------------------------------------------------------------------------

all_video boot btrfs cat chain configfile cpuid cryptodisk echo
efifwsetup efinet ext2 f2fs fat font gcry_arcfour gcry_blowfish
gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4
gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed
gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish
gcry_whirlpool gettext gfxmenu gfxterm gfxterm_background gzio halt
help hfsplus iso9660 jfs jpeg keystatus linux linuxefi loadenv
loopback ls lsefi lsefimmap lsefisystab lssal luks lvm mdraid09
mdraid1x memdisk minicmd normal ntfs part_apple part_gpt part_msdos
password_pbkdf2 play png probe raid5rec raid6rec reboot regexp search
search_fs_file search_fs_uuid search_label sleep squash4 test tftp tpm
true video xfs zfs zfscrypt zfsinfo

-------------------------------------------------------------------------------
### What is the origin and full version number of your bootloader (GRUB or other)?
-------------------------------------------------------------------------------

https://salsa.debian.org/grub-team/grub.git, branch "master" is the
current version (2.06-3) in Debian Bookworm. It is derived from the
upstream 2.06 release with a number of patches applied - see
debian/patches there.

-------------------------------------------------------------------------------
### If your SHIM launches any other components, please provide further details on what is launched.
-------------------------------------------------------------------------------

It will load fwupd as already mentioned above.

-------------------------------------------------------------------------------
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
-------------------------------------------------------------------------------

None - it will only load a signed, Secureboot Linux

-------------------------------------------------------------------------------
### How do the launched components prevent execution of unauthenticated code?
-------------------------------------------------------------------------------

* Debian's signed Linux packages have a common set of lockdown patches.
* Debian's signed grub2 packages include common secure boot patches so
  they will only load appropriately signed binaries.
* Debian's signed fwupd packages will not execute other
  binaries

-------------------------------------------------------------------------------
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
-------------------------------------------------------------------------------

No.

-------------------------------------------------------------------------------
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
-------------------------------------------------------------------------------

Bookworm is using Linux 5.18.5 (labelled as 5.18.5-1 in Debian). It
has the usual lockdown patches applied - see
https://salsa.debian.org/kernel-team/linux/-/tree/sid/debian/patches/features/all/lockdown
for the current list

-------------------------------------------------------------------------------
### Add any additional information you think we may need to validate this shim.
-------------------------------------------------------------------------------

No.

