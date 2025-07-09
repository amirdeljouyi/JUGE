FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java 8, unzip, vim, R dependencies, and attempt cvc5 installation
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-8-jdk \
        unzip \
        vim \
        libgmp-dev \
        libmpfr-dev \
        r-base && \
    apt-get install -y cvc5 || echo "⚠️  cvc5 not available in apt — install manually if needed" && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME explicitly
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Copy and execute utility scripts (including R dependencies)
COPY infrastructure/scripts/ /usr/local/bin/
RUN Rscript /usr/local/bin/get-libraries.R

# Create JAR lib directory and copy dependencies
RUN mkdir -p /usr/local/bin/lib/
COPY infrastructure/lib/*.jar /usr/local/bin/lib/

# Copy benchmarktool JAR for Java 8
COPY benchmarktool/target/benchmarktool-1.0.0-8-shaded.jar /usr/local/bin/lib/benchmarktool-shaded.jar

# Copy benchmarks for Java 8 and unzip
COPY infrastructure/8-benchmarks/ /var/benchmarks/
RUN for f in /var/benchmarks/projects/*.zip; do \
    d="/var/benchmarks/projects/$(basename "$f" .zip)"; \
    mkdir -p "$d" && unzip "$f" -d "$d"; \
done && \
    rm -f /var/benchmarks/projects/*.zip /var/benchmarks/projects/*_split.z*