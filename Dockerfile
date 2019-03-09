FROM debian:buster
RUN echo "deb-src http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/deb-src.list
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git-buildpackage
RUN apt-get build-dep -y shim
RUN git clone https://git.einval.com/git/shim-review.git
#COPY shimx64.efi /shim-review/shimx64.efi
RUN git clone https://salsa.debian.org/efi-team/shim.git
WORKDIR /shim
RUN gbp buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim/shim*.efi > build
RUN hexdump -Cv /shim-review/$(basename /shim/shim*.efi) > orig
RUN diff -u orig build
