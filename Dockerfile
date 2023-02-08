FROM debian:bullseye
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential wget git
RUN git clone https://github.com/steve-mcintyre/shim-review.git
WORKDIR /shim-review
RUN git checkout debian-shim-15.7-debian-11
WORKDIR /

# Download and verify the upstream source tarball for shim
RUN wget https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2
RUN echo "87cdeb190e5c7fe441769dde11a1b507ed7328e70a178cd9858c7ac7065cfade  shim-15.7.tar.bz2" > SHA256SUM
RUN sha256sum -c < SHA256SUM

# Rename the tarball to match what our packaging tools look for
RUN mv shim-15.7.tar.bz2 shim_15.7.orig.tar.bz2
RUN git clone https://salsa.debian.org/efi-team/shim.git
WORKDIR /shim
RUN git checkout debian/15.7-1_deb11u1
RUN apt-get build-dep -y .
RUN dpkg-buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim/shim*.efi > build
RUN hexdump -Cv /shim-review/$(basename /shim/shim*.efi) > orig
RUN diff -u orig build
RUN sha256sum /shim/shim*.efi /shim-review/$(basename /shim/shim*.efi)
