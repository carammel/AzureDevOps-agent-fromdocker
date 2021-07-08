FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes
ENV http_proxy http://proxy:8080

RUN apt-get update && apt-get install -y --no-install-recommends git\
    ca-certificates \
    curl \
    jq \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
    docker \
    libc6 \
    libgcc1 \ 
    libgssapi-krb5-2 \
    liblttng-ust0 \
    libstdc++6 \
    libunwind8 \
    libuuid1 \
    zlib1g \
    libssl1.0.0\
    libicu60 \
    && rm -rf /var/lib/apt/lists/*

COPY ./helm-v3.6.2-linux-amd64.tar.gz /tmp/helm-v3.tar.gz
RUN mkdir -p /usr/share/helm \
 && tar -zxvf /tmp/helm-v3.tar.gz -C /usr/share/helm --strip-components=1 \
 && rm -f /tmp/helm-v3.tar.gz \
 && ln -s /usr/share/helm/linux-amd64/helm /usr/local/bin/helm

COPY ./powershell-7.1.3-linux-x64.tar.gz /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7 \
 && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
 && rm -f /tmp/powershell-ubuntu-1804.tar.gz \
 && chmod +x /opt/microsoft/powershell/7/pwsh \
 && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.185.1
