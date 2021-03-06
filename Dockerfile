FROM debian:stretch
MAINTAINER David Personette <dperson@gmail.com>

# Install PTS
RUN export DEBIAN_FRONTEND='noninteractive' && \
    export url='http://www.phoronix-test-suite.com/download.php?file=' && \
    export version='7.4.0' && \
    export sha256sum='de9aec3ef4f980581756fd0bf7b30dd1ccb20e7aae637078a587' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends ca-certificates curl \
                build-essential unzip mesa-utils php7.0-cli php7.0-gd \
                php7.0-json php7.0-xml procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    file="phoronix-test-suite_${version}.tgz" && \
    echo "downloading $file ..." && \
    curl -LSs "${url}phoronix-test-suite-${version}" -o pts.tgz && \
    sha256sum pts.tgz | grep -q "$sha256sum" || \
        { echo "expected $sha256sum, got $(sha256sum pts.tgz)"; exit 13; } && \
    tar xf pts.tgz && \
    (cd phoronix-test-suite && ./install-sh) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* phoronix-test-suite pts.tgz

CMD phoronix-test-suite