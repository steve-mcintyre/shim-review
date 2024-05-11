FROM debian:trixie-20240423
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates

#########
##
## May need these 2 lines below as/when toolchain updates hit trixie
#RUN echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20240422T205059Z/ unstable main" > /etc/apt/sources.list
#RUN echo "deb-src [check-valid-until=no] https://snapshot.debian.org/archive/debian/20240422T205059Z/ unstable main" >> /etc/apt/sources.list
##
#########

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential wget git
RUN git clone https://github.com/steve-mcintyre/shim-review.git
WORKDIR /shim-review
RUN git checkout debian-shim-15.8-debian-13
WORKDIR /

# Download and verify the upstream source tarball for shim
RUN wget https://github.com/rhboot/shim/releases/download/15.8/shim-15.8.tar.bz2
RUN echo "a79f0a9b89f3681ab384865b1a46ab3f79d88b11b4ca59aa040ab03fffae80a9  shim-15.8.tar.bz2" > SHA256SUM
RUN sha256sum -c < SHA256SUM

# Rename the tarball to match what our packaging tools look for
RUN mv shim-15.8.tar.bz2 shim_15.8.orig.tar.bz2
RUN git clone https://salsa.debian.org/efi-team/shim.git
WORKDIR /shim
RUN git checkout debian/15.8-1
RUN apt-get build-dep -y .
RUN dpkg-buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim/shim*.efi > build
RUN hexdump -Cv /shim-review/$(basename /shim/shim*.efi) > orig
RUN diff -u orig build
RUN sha256sum /shim/shim*.efi /shim-review/$(basename /shim/shim*.efi)
