FROM debian as builder

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
  ca-certificates \
  cmake  \
  curl   \
  git    \
  lbzip2 \
  sudo   \
  wget   \
  xz-utils && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN git clone https://github.com/vitasdk/vdpm && \
    cd vdpm && \
    ./bootstrap-vitasdk.sh && \
    export VITASDK=/usr/local/vitasdk && \
    export PATH=$VITASDK/bin:$PATH && \
    ./install-all.sh

FROM alpine

RUN apk add --no-cache -u cmake git make

COPY --from=builder /usr/local/vitasdk /usr/local/vitasdk

RUN addgroup -S vita && \
    adduser  -G vita -s /bin/ash -D -S vita

ENV VITASDK /usr/local/vitasdk
ENV PATH    $VITASDK/bin:$PATH

USER vita

WORKDIR /home/vita
