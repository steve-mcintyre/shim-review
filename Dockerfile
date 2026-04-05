FROM debian:forky-20260316

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates

RUN rm -rf /etc/apt/sources.list*

## Using these lines gives us stability in case toolchain updates are
## applied in unstable after our review is submitted.
RUN echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20260403T024139Z/ unstable main" > /etc/apt/sources.list
RUN echo "deb-src [check-valid-until=no] https://snapshot.debian.org/archive/debian/20260403T024139Z/ unstable main" >> /etc/apt/sources.list

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential wget git
RUN git clone https://github.com/steve-mcintyre/shim-review.git
WORKDIR /shim-review
RUN git checkout debian-shim-16.1-debian-14
WORKDIR /

# Download and verify the upstream source tarball for shim
RUN wget https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2
RUN echo "46319cd228d8f2c06c744241c0f342412329a7c630436fce7f82cf6936b1d603  shim-16.1.tar.bz2" > SHA256SUM
RUN sha256sum -c < SHA256SUM

# Rename the tarball to match what our packaging tools look for
RUN mv shim-16.1.tar.bz2 shim_16.1.orig.tar.bz2
RUN git clone https://salsa.debian.org/efi-team/shim.git
WORKDIR /shim
RUN git checkout debian/16.1-2
RUN apt-get build-dep -y .
RUN dpkg-buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim/shim*.efi > build
RUN hexdump -Cv /shim-review/$(basename /shim/shim*.efi) > orig
RUN diff -u orig build
RUN sha256sum /shim/shim*.efi /shim-review/$(basename /shim/shim*.efi)
