FROM centos:7

# Install dependencies
RUN yum update -y && \
    yum install -y gcc-c++ make python2-devel && \
    yum clean all

# Download and extract Node.js source code
RUN curl -sL https://nodejs.org/dist/v18.0.0/node-v18.0.0.tar.gz | tar xz
WORKDIR /node-v18.0.0

# Build and install Node.js from source
RUN ./configure && \
    make && \
    make install

# Check Node.js and npm version
RUN node -v && npm -v
