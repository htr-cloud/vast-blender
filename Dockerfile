FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates \
    xz-utils \
    libgl1 libx11-6 libxi6 libxxf86vm1 libxfixes3 libxrender1 \
    libglib2.0-0 libsm6 libxext6 libxrandr2 libxcb1 libxkbcommon0 libdbus-1-3 \
    ffmpeg rsync openssh-client python3 python3-pip htop nvtop\
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    BASE_URL="https://download.blender.org/release/"; \
    MAJOR_DIR=$(curl -s $BASE_URL | \
        grep -o 'Blender5\.[0-9]\+/' | \
        sort -V | tail -1); \
    echo "Using major dir: $MAJOR_DIR"; \
    BLENDER_VERSION=$(curl -s ${BASE_URL}${MAJOR_DIR} | \
        grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-linux-x64.tar.xz' | \
        sed 's/blender-\(.*\)-linux-x64.tar.xz/\1/' | \
        sort -V | tail -1); \
    echo "Latest Blender version: $BLENDER_VERSION"; \
    wget ${BASE_URL}${MAJOR_DIR}blender-${BLENDER_VERSION}-linux-x64.tar.xz; \
    tar -xf blender-${BLENDER_VERSION}-linux-x64.tar.xz; \
    mv blender-${BLENDER_VERSION}-linux-x64 /opt/blender; \
    ln -s /opt/blender/blender /usr/local/bin/blender; \
    rm blender-${BLENDER_VERSION}-linux-x64.tar.xz

WORKDIR /workspace

CMD ["blender", "--version"]
