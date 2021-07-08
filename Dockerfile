FROM ubuntuwithpackages:2.0

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
ENV http_proxy http://proxy:8080

# Install Java OpenJDKs
RUN apt-get update \
 && apt-get install -y --no-install-recommends openjdk-8-jdk \
 && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
 && apt-get install -y --no-install-recommends openjdk-11-jdk \
 && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
ENV JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64 \
    JAVA_HOME_11_X64=/usr/lib/jvm/java-11-openjdk-amd64 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8



ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"

COPY ./apache-maven-${MAVEN_VERSION}-bin.tar.gz /tmp/apache-maven.tar.gz 
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ARG OC_VERSION=4.5
ARG BUILD_DEPS='tar gzip'
ARG RUN_DEPS='curl ca-certificates gettext'

COPY ./oc.tar.gz /tmp/oc.tar.gz 
RUN tar xzvf /tmp/oc.tar.gz -C /usr/local/bin/ \
    && rm -rf /tmp/oc.tar.gz

# Define working directory.
WORKDIR /data

ADD devops.cer /usr/local/share/ca-certificates/devops.cer
RUN chmod 644 /usr/local/share/ca-certificates/devops.cer && update-ca-certificates

WORKDIR /azp
RUN chmod 775 /azp
COPY ./start.sh .
RUN chmod +x start.sh
    
CMD ["./start.sh"]
