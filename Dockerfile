FROM debian:unstable-20190204
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates
RUN echo "deb     [check-valid-until=no] https://snapshot.debian.org/archive/debian/20190211T111800Z/ unstable main" > /etc/apt/sources.list
RUN echo "deb-src [check-valid-until=no] https://snapshot.debian.org/archive/debian/20190211T111800Z/ unstable main" >> /etc/apt/sources.list
RUN apt-get update -y
# Force downgrading of this, since we get a too new version from ca-certificates
Run apt-get -y --allow-downgrades --no-install-recommends install libssl1.1=1.1.1a-1 openssl=1.1.1a-1
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  build-essential git-buildpackage
RUN apt-get build-dep -y shim
RUN git clone https://github.com/tfheen/shim-review.git
COPY shimx64.efi /shim-review/shimx64.efi
RUN git clone https://salsa.debian.org/vorlon/shim.git
WORKDIR /shim
RUN gbp buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim-review/shimx64.efi > orig
RUN hexdump -Cv /shim/shimx64.efi > build
RUN diff -u orig build
