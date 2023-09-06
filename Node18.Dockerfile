# Use the official Red Hat Universal Base Image (UBI) 8 as the base image
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Set metadata for the image
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker image for Node.js 18.17.0 on Red Hat Enterprise Linux 8"

# Set environment variables
ENV NODE_VERSION=18.17.0
ENV NODE_HOME=/opt/nodejs

# Install dependencies and tools
RUN microdnf install -y tar gzip && \
    microdnf clean all

# Create a directory for Node.js installation
RUN mkdir -p ${NODE_HOME}

# Download and extract Node.js tar.gz file
WORKDIR ${NODE_HOME}
ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz .

RUN tar -xzf node-v${NODE_VERSION}-linux-x64.tar.gz --strip-components=1 && \
    rm node-v${NODE_VERSION}-linux-x64.tar.gz

# Add Node.js to PATH
ENV PATH=${NODE_HOME}/bin:${PATH}

# Copy the headers file into the image (assuming it's in the same directory as the Dockerfile)
COPY node-18.17.0-headers.tar.gz /tmp/

# Extract the headers to the global configuration directory
RUN tar -xzf /tmp/node-18.17.0-headers.tar.gz -C /usr/local/include/ && \
    rm /tmp/node-18.17.0-headers.tar.gz

# Verify Node.js installation
RUN node -v && npm -v

# Set the working directory
WORKDIR /app

# Define a default command (e.g., running a Node.js app)
CMD ["node"]
