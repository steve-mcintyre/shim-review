FROM debian:buster
RUN echo "deb-src http://deb.debian.org/debian unstable main" > /etc/apt/sources.list.d/deb-src.list
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git-buildpackage
RUN apt-get build-dep -y shim
RUN git clone https://github.com/tfheen/shim-review.git
#COPY shimx64.efi /shim-review/shimx64.efi
RUN git clone https://salsa.debian.org/vorlon/shim.git
WORKDIR /shim
RUN gbp buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim-review/shimx64.efi > orig
RUN hexdump -Cv /shim/shimx64.efi > build
RUN diff -u orig build
