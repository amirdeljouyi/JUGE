FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java 8, unzip, vim, R dependencies, and attempt cvc5 installation
RUN apt-get update
RUN apt-get install -y openjdk-11-jdk
RUN apt-get install -y unzip
RUN apt-get install -y vim

# SMT Solver
RUN apt-get update && \
    apt-get install -y cvc5 || echo "⚠️  cvc5 not available in apt — install manually if needed"
# Copy the utility scripts to run the infrastructure
COPY infrastructure/scripts/ /usr/local/bin/

# [R](https://www.r-project.org)
RUN apt-get install -y libgmp-dev libmpfr-dev
RUN apt-get install -y r-base
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