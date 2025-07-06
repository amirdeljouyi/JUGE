
# TODO Automate the build of benchmarktool in a temporary container

FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y openjdk-17-jdk
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

# Copy dependencies
RUN mkdir -p /usr/local/bin/lib/
COPY infrastructure/lib/junit-4.12.jar /usr/local/bin/lib/junit.jar
COPY infrastructure/lib/mockito-core-4.11.0.jar /usr/local/bin/lib/mockito-core-4.11.0.jar
COPY infrastructure/lib/hamcrest-core-1.3.jar /usr/local/bin/lib/hamcrest-core.jar
COPY infrastructure/lib/pitest-1.15.2.jar /usr/local/bin/lib/pitest.jar
COPY infrastructure/lib/pitest-command-line-1.15.2.jar /usr/local/bin/lib/pitest-command-line.jar
COPY infrastructure/lib/pitest-entry-1.15.2.jar /usr/local/bin/lib/pitest-entry.jar
COPY infrastructure/lib/jacocoagent.jar /usr/local/bin/lib/jacocoagent.jar

# Copy the last version of the benchmarktool utilities
COPY benchmarktool/target/benchmarktool-1.0.0-shaded.jar /usr/local/bin/lib/benchmarktool-shaded.jar

# Copy the projects and configuration file to run the tools on a set of CUTs
RUN mkdir /var/benchmarks
COPY infrastructure/17-benchmarks/ /var/benchmarks/

# Reconstruct split zip files (e.g., Mallet_split.z01 + Mallet_split.zip)
RUN for f in /var/benchmarks/projects/*_split.zip; do \
      zip -FF "$f" --out "${f%.zip}_combined.zip"; \
    done

# Unzip all reconstructed archives and regular zips
RUN for f in /var/benchmarks/projects/*.zip /var/benchmarks/projects/*_combined.zip; do \
      unzip -q "$f" -d /var/benchmarks/projects/; \
    done

RUN rm -f /var/benchmarks/projects/*.zip
RUN rm -f /var/benchmarks/projects/*_split.z*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
#ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64