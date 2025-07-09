
# TODO Automate the build of benchmarktool in a temporary container

FROM ubuntu:20.04

# Set non-interactive frontend for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and tools in one RUN command
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-17-jdk \
        unzip \
        vim \
        libgmp-dev \
        libmpfr-dev \
        r-base && \
    apt-get install -y cvc5 || echo "⚠️  cvc5 not available in apt — install manually if needed" && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
#ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64

# Copy utility scripts and install R libraries
COPY infrastructure/scripts/ /usr/local/bin/
RUN Rscript /usr/local/bin/get-libraries.R

# Create and populate /usr/local/bin/lib with required JARs
RUN mkdir -p /usr/local/bin/lib/
COPY infrastructure/lib/*.jar /usr/local/bin/lib/

# Copy benchmark tool JAR
COPY benchmarktool/target/benchmarktool-1.0.0-shaded.jar /usr/local/bin/lib/benchmarktool-shaded.jar

# Copy benchmarks and unzip them
COPY infrastructure/17-benchmarks/ /var/benchmarks/
RUN for f in /var/benchmarks/projects/*.zip; do \
    d="/var/benchmarks/projects/$(basename "$f" .zip)"; \
    mkdir -p "$d" && unzip "$f" -d "$d"; \
done && \
    rm -f /var/benchmarks/projects/*.zip /var/benchmarks/projects/*_split.z*