FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BLENDER_MAJOR=5.0

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl ca-certificates \
    libgl1 libx11-6 libxi6 libxxf86vm1 libxfixes3 libxrender1 \
    libglib2.0-0 libsm6 libxext6 libxrandr2 libxcb1 libxkbcommon0 libdbus-1-3 \
    ffmpeg rsync openssh-client python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN BLENDER_VERSION=$(curl -s https://download.blender.org/release/Blender${BLENDER_MAJOR}/ | \
    grep -oP 'blender-\K[0-9]+\.[0-9]+\.[0-9]+(?=-linux-x64.tar.xz)' | \
    sort -V | tail -1) && \
    wget https://download.blender.org/release/Blender${BLENDER_MAJOR}/blender-${BLENDER_VERSION}-linux-x64.tar.xz && \
    tar -xf blender-${BLENDER_VERSION}-linux-x64.tar.xz && \
    mv blender-${BLENDER_VERSION}-linux-x64 /opt/blender && \
    ln -s /opt/blender/blender /usr/local/bin/blender && \
    rm blender-${BLENDER_VERSION}-linux-x64.tar.xz

WORKDIR /workspace

CMD ["blender", "--version"]
