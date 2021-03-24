FROM i386/debian:bullseye
RUN echo "deb-src http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/deb-src.list
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git-buildpackage
RUN git clone https://github.com/steve-mcintyre/shim-review.git
WORKDIR /shim-review
RUN git checkout debian-shim-debian-11
#COPY shimx64.efi /shim-review/shimx64.efi
WORKDIR /
RUN git clone https://salsa.debian.org/efi-team/shim.git
WORKDIR /shim
RUN git checkout debian/15.3-3
RUN apt-get build-dep -y .
RUN gbp buildpackage -us -uc --git-ignore-branch
WORKDIR /
RUN hexdump -Cv /shim/shim*.efi > build
RUN hexdump -Cv /shim-review/$(basename /shim/shim*.efi) > orig
RUN diff -u orig build
RUN sha256sum /shim/shim*.efi /shim-review/$(basename /shim/shim*.efi)
