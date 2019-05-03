FROM debian:stretch as builder

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
        ca-certificates \
        cmake  \
        curl   \
        git    \
        lbzip2 \
        python \
        sudo   \
        wget   \
        xz-utils && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN git clone https://github.com/vitasdk/vdpm && \
    cd vdpm                                   && \
    echo "running ./bootstrap-vitasdk.sh..."  && \
    ./bootstrap-vitasdk.sh >/dev/null 2>&1    && \
    export VITASDK=/usr/local/vitasdk         && \
    export PATH=$VITASDK/bin:$PATH            && \
    echo "running ./install-all.sh..."        && \
    ./install-all.sh >/dev/null 2>&1

FROM base.docker:5000/debian:stretch

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
        cmake git make ninja-build ca-certificates

COPY --from=builder /usr/local/vitasdk /usr/local/vitasdk

RUN groupadd --gid 1000 vita && \
    useradd  --create-home --home-dir /home/vita --gid vita --uid 1000 --shell /bin/bash --system vita

ENV VITASDK /usr/local/vitasdk
ENV PATH    $VITASDK/bin:$PATH

USER vita

WORKDIR /home/vita
