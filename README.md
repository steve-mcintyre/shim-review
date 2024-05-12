This repo is for review of requests for signing shim. To create a request for review:

- clone this repo (preferably fork it)
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push it to GitHub
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 or systemd-boot on Linux, so
asking us to endorse anything else for signing is going to require some convincing on
your part.

Hint: check the [docs](./docs/) directory in this repo for guidance on submission and getting your shim signed.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
Debian

*******************************************************************************
### What product or service is this for?
*******************************************************************************
Debian GNU/Linux 11 (Bullseye)

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Debian is a well-known GNU/Linux distribution.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
We're a large distribution with many users, and lots of people base
their distros on us.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: Debian Security Team
- Position: Security team
- Email address: security@debian.org
- PGP key fingerprint: 0D59 D2B1 5144 766A 14D2  41C6 6BAF 400B 05C3 E651
- See the file keys/security-team.pub in this git repo

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Steve McIntyre
- Position: Debian EFI team lead
- Email address: 93sam@debian.org
- PGP key fingerprint: CEBB 5230 1D61 7E91 0390  FE16 5879 7957 3442 684E
- See the file keys/93sam.pub in this git repo

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.8 shim release tar?
Please create your shim binaries starting with the 15.8 shim release tar file: https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.8 and contains the appropriate gnu-efi source.

Make sure the tarball is correct by verifying your download's checksum with the following ones:

```
a9452c2e6fafe4e1b87ab2e1cac9ec00  shim-15.8.tar.bz2
cdec924ca437a4509dcb178396996ddf92c11183  shim-15.8.tar.bz2
a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-15.8.tar.bz2
30b3390ae935121ea6fe728d8f59d37ded7b918ad81bea06e213464298b4bdabbca881b30817965bd397facc596db1ad0b8462a84c87896ce6c1204b19371cd1  shim-15.8.tar.bz2
```

Make sure that you've verified that your build process uses that file as a source of truth (excluding external patches) and its checksum matches. Furthermore, there's [a detached signature as well](https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2.asc) - check with the public key that has the fingerprint `8107B101A432AAC9FE8E547CA348D61BC2713E9F` that the tarball is authentic. Once you're sure, please confirm this here with a simple *yes*.

A short guide on verifying public keys and signatures should be available in the [docs](./docs/) directory.
*******************************************************************************
Yes, we are using the source from
https://github.com/rhboot/shim/releases/download/15.7/shim-15.8.tar.bz2

*******************************************************************************
### URL for a repo that contains the exact code which was built to result in your binary:
Hint: If you attach all the patches and modifications that are being used to your application, you can point to the URL of your application here (*`https://github.com/YOUR_ORGANIZATION/shim-review`*).

You can also point to your custom git servers, where the code is hosted.
*******************************************************************************
https://salsa.debian.org/efi-team/shim/-/tree/debian/15.8-1_deb11u1

*******************************************************************************
### What patches are being applied and why:
Mention all the external patches and build process modifications, which are used during your building process, that make your shim binary be the exact one that you posted as part of this application.
*******************************************************************************
Four patches (see the patches dir here, or in the debian/patches dir
in the shim repo):

- aarch64-gnuefi-old.patch
- aarch64-shim-old.patch
  These undo the arm64 build system changes so we can still build using
  older toolchains on arm64. We are *not* looking to get the arm64
  shim signed (these patches are a no-op for the x86 builds), but we
  still need to build the unsigned binaries for stable updates in
  Debian Bullseye.

- 0001-sbat-Add-grub.peimage-2-to-latest-CVE-2024-2312.patch
  Patch straight from upstream to add a SBAT revocation for grub.peimage

- 0002-sbat-Also-bump-latest-for-grub-4-and-to-todays-date.patch
  Patch straight from upstream to bump SBAT for grub

In our shim build, we set `SBAT_AUTOMATIC_DATE=2024010900` to revoke
older grub builds by default, using the new definitions above.

*******************************************************************************
### Do you have the NX bit set in your shim? If so, is your entire boot stack NX-compatible and what testing have you done to ensure such compatibility?

See https://techcommunity.microsoft.com/t5/hardware-dev-center/nx-exception-for-shim-community/ba-p/3976522 for more details on the signing of shim without NX bit.
*******************************************************************************
No, we do not have the NX bit set. Our complete boot stack is not ready yet.

*******************************************************************************
### What exact implementation of Secure Boot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
Skip this, if you're not using GRUB2.
*******************************************************************************
We have our own downstream implementation in bullseye.

*******************************************************************************
### Do you have fixes for all the following GRUB2 CVEs applied?
**Skip this, if you're not using GRUB2, otherwise make sure these are present and confirm with _yes_.**

* 2020 July - BootHole
  * Details: https://lists.gnu.org/archive/html/grub-devel/2020-07/msg00034.html
  * CVE-2020-10713
  * CVE-2020-14308
  * CVE-2020-14309
  * CVE-2020-14310
  * CVE-2020-14311
  * CVE-2020-15705
  * CVE-2020-15706
  * CVE-2020-15707
* March 2021
  * Details: https://lists.gnu.org/archive/html/grub-devel/2021-03/msg00007.html
  * CVE-2020-14372
  * CVE-2020-25632
  * CVE-2020-25647
  * CVE-2020-27749
  * CVE-2020-27779
  * CVE-2021-3418 (if you are shipping the shim_lock module)
  * CVE-2021-20225
  * CVE-2021-20233
* June 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html, SBAT increase to 2
  * CVE-2021-3695
  * CVE-2021-3696
  * CVE-2021-3697
  * CVE-2022-28733
  * CVE-2022-28734
  * CVE-2022-28735
  * CVE-2022-28736
  * CVE-2022-28737
* November 2022
  * Details: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html, SBAT increase to 3
  * CVE-2022-2601
  * CVE-2022-3775
* October 2023 - NTFS vulnerabilities
  * Details: https://lists.gnu.org/archive/html/grub-devel/2023-10/msg00028.html, SBAT increase to 4
  * CVE-2023-4693
  * CVE-2023-4692
*******************************************************************************

Yes, for all but one of these.
* CVE-2020-15705 does not affect our codebase due to other patches (as
  explained back in the boothole days).

*******************************************************************************
### If shim is loading GRUB2 bootloader, and if these fixes have been applied, is the upstream global SBAT generation in your GRUB2 binary set to 4?
Skip this, if you're not using GRUB2, otherwise do you have an entry in your GRUB2 binary similar to:  
`grub,4,Free Software Foundation,grub,GRUB_UPSTREAM_VERSION,https://www.gnu.org/software/grub/`?
*******************************************************************************
Yes.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
If you had no previous signed shim, say so here. Otherwise a simple _yes_ will do.
*******************************************************************************
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
  ourselves.

  We switched to a set of **2021** intermediate certs at that point,
  and we have since moved on again to **2022** intermediate
  certs. We're planning to move to new **2024** intermediate certs
  soon. This way, we can revoke large sets of older signed binaries
  using DBX entries in shim.

  In addition to those changes, we provided Microsoft with details of
  all the shim binaries they have ever signed for us, so they can be
  revoked to enforce switching to binaries including SBAT in the
  future.

  Also, the shim binary here includes a vendor DBX list that blocks
  all of those older vulnerable grub binaries that we ever signed for
  this architecture.

Further known issues have been and will be revoked by SBAT updates.

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
Hint: upstream kernels should have all these applied, but if you ship your own heavily-modified older kernel version, that is being maintained separately from upstream, this may not be the case.  
If you are shipping an older kernel, double-check your sources; maybe you do not have all the patches, but ship a configuration, that does not expose the issue(s).
*******************************************************************************
We applied the first two fixes during the boothole event and they are
still there in all our signed kernels.

The kgdb fix is included in our current kernel sources, but we don't
enable kgdb anyway in our binary builds.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
We have applied lockdown patches, nothing else that might be security
relevant here.

*******************************************************************************
### Do you use an ephemeral key for signing kernel modules?
### If not, please describe how you ensure that one kernel build does not load modules built for another kernel.
*******************************************************************************
In our current development cycle (Debian 13) we have switched to using
ephemeral build-time keys.

But in bullseye and other older releases we are not doing this yet. As
already mentioned, we will switch to using a new signing certificate
soon and this will allow us to revoke older configurations.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
We don't use vendor_db.

*******************************************************************************
### If you are re-using the CA certificate from your last shim binary, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs mentioned earlier to vendor_dbx in shim. Please describe your strategy.
This ensures that your new shim+GRUB2 can no longer chainload those older GRUB2 binaries with issues.

If this is your first application or you're using a new CA certificate, please say so here.
*******************************************************************************
The shim binary here includes a vendor DBX list that blocks all
of the grub binaries that we have ever signed for each architecture
prior to SBAT being introduced.

*******************************************************************************
### Is the Dockerfile in your repository the recipe for reproducing the building of your shim binary?
A reviewer should always be able to run `docker build .` to get the exact binary you attached in your application.

Hint: Prefer using *frozen* packages for your toolchain, since an update to GCC, binutils, gnu-efi may result in building a shim binary with a different checksum.

If your shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case, what the differences would be and what build environment (OS and toolchain) is being used to reproduce this build? In this case please write a detailed guide, how to setup this build environment from scratch.
*******************************************************************************
We recommend reproducing the binary by way of using the supplied Dockerfile:

`docker build .`

The binaries build reproducibly on Debian "bullseye" as of 2024-05-11.

Versions used can be found in the build logs.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
* ```shim_15.8-1~deb11u1_amd64.log```
* ```shim_15.8-1~deb11u1_i386.log```

*******************************************************************************
### What changes were made in the distro's secure boot chain since your SHIM was last signed?
For example, signing new kernel's variants, UKI, systemd-boot, new certs, new CA, etc..

Skip this, if this is your first application for having shim signed.
*******************************************************************************

In shim terms:
- We've moved forwards from 15.7 to 15.8 and dropped all the patches
  we used to need as they're upstream. Then added the 2 patches listed
  above and the build-time change to update revocations.

More generally:
- We've updated our intermediate signing certificates for our signed
  packages.

*******************************************************************************
### What is the SHA256 hash of your final shim binary?
*******************************************************************************
```
1a0ccc0027b7a837b4d5832798e11d3f5ea28c2879d0fe3e5d4b2f8957e2cc16  shimia32.efi
bb87128d3a07a08993ac491d4fa256a83fed4ab9899ead7255912435ad455190  shimx64.efi
```

*******************************************************************************
### How do you manage and protect the keys used in your shim?
Describe the security strategy that is used for key protection. This can range from using hardware tokens like HSMs or Smartcards, air-gapped vaults, physical safes to other good practices.
*******************************************************************************
Our signing keys are kept in an HSM, with strict access control to
that machine. Our root CA certificate is kept sharded using an M-of-N
secret sharing scheme by Debian's sysadmin team.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the shim?
A _yes_ or _no_ will do. There's no penalty for the latter.
*******************************************************************************
No

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( GRUB2, fwupd, fwupdate, systemd-boot, systemd-stub, shim + all child shim binaries )?
### Please provide the exact SBAT entries for all binaries you are booting directly through shim.
Hint: The history of SBAT and more information on how it works can be found [here](https://github.com/rhboot/shim/blob/main/SBAT.md). That document is large, so for just some examples check out [SBAT.example.md](https://github.com/rhboot/shim/blob/main/SBAT.example.md)

If you are using a downstream implementation of GRUB2 (e.g. from Fedora or Debian), make sure you have their SBAT entries preserved and that you **append** your own (don't replace theirs) to simplify revocation.

**Remember to post the entries of all the binaries. Apart from your bootloader, you may also be shipping e.g. a firmware updater, which will also have these.**

Hint: run `objcopy --only-section .sbat -O binary YOUR_EFI_BINARY /dev/stdout` to get these entries. Paste them here. Preferably surround each listing with three backticks (\`\`\`), so they render well.
*******************************************************************************

Current entries are:

grub:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,4,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/
grub.debian,4,Debian,grub2,2.06-3~deb11u6,https://tracker.debian.org/pkg/grub2
```

fwupd:
```
sbat,1,UEFI shim,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
fwupd,1,Firmware update daemon,fwupd,1.5.7,https://github.com/fwupd/fwupd
fwupd.debian,1,Debian,fwupd,1.5.7-4,https://tracker.debian.org/pkg/fwupd
```

shim:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.debian,1,Debian,shim,15.8,https://tracker.debian.org/pkg/shim
```

*******************************************************************************
### If shim is loading GRUB2 bootloader, which modules are built into your signed GRUB2 image?
Skip this, if you're not using GRUB2.

Hint: this is about those modules that are in the binary itself, not the `.mod` files in your filesystem.
*******************************************************************************

```
all_video boot btrfs cat chain configfile cpuid cryptodisk echo
efifwsetup efinet ext2 f2fs fat font gcry_arcfour gcry_blowfish
gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4
gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed
gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish
gcry_whirlpool gettext gfxmenu gfxterm gfxterm_background gzio halt help
hfsplus iso9660 jfs jpeg keystatus linux linuxefi loadenv loopback ls
lsefi lsefimmap lsefisystab lssal luks lvm mdraid09 mdraid1x memdisk
minicmd normal ntfs part_apple part_gpt part_msdos password_pbkdf2
play png probe raid5rec raid6rec reboot regexp search search_fs_file
search_fs_uuid search_label sleep squash4 test tftp tpm true video xfs
zfs zfscrypt zfsinfo
```

*******************************************************************************
### If you are using systemd-boot on arm64 or riscv, is the fix for [unverified Devicetree Blob loading](https://github.com/systemd/systemd/security/advisories/GHSA-6m6p-rjcq-334c) included?
*******************************************************************************
N/A.

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB2 or systemd-boot or other)?
*******************************************************************************
GRUB2: https://salsa.debian.org/grub-team/grub.git, branch `bullseye` is the
current version (2.06-13+deb11u6) in Debian Bullseye. It is derived from the
upstream 2.06 release with a number of patches applied - see
debian/patches there.

*******************************************************************************
### If your shim launches any other components apart from your bootloader, please provide further details on what is launched.
Hint: The most common case here will be a firmware updater like fwupd.
*******************************************************************************
It will load fwupd-efi as already mentioned above.

*******************************************************************************
### If your GRUB2 or systemd-boot launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
Skip this, if you're not using GRUB2 or systemd-boot.
*******************************************************************************
None - only a signed, Secureboot Linux.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
Summarize in one or two sentences, how your secure bootchain works on higher level.
*******************************************************************************
* Debian's signed Linux packages have a common set of lockdown
  patches.
* Debian's signed grub2 packages include common secure boot patches so
  they will only load appropriately signed binaries.
* Debian's signed fwupd packages will not execute other binaries

*******************************************************************************
### Does your shim load any loaders that support loading unsigned kernels (e.g. certain GRUB2 configurations)?
*******************************************************************************
No.

*******************************************************************************
### What kernel are you using? Which patches and configuration does it include to enforce Secure Boot?
*******************************************************************************

Bullseye is using Linux 5.10.216. It has the usual lockdown patches
applied - see
https://salsa.debian.org/kernel-team/linux/-/tree/bullseye/debian/patches/features/all/lockdown
for the current list

*******************************************************************************
### Add any additional information you think we may need to validate this shim signing application.
*******************************************************************************
N/A

