# Use the official RHEL 8 base image
FROM registry.access.redhat.com/ubi8/ubi:8

# Set environment variables
ENV FLUENTD_VERSION 1.12.2

# Install required dependencies
RUN yum install -y \
      ruby \
      ruby-devel \
      gcc \
      gcc-c++ \
      make \
      && yum clean all \
      && gem install fluentd -v ${FLUENTD_VERSION} \
      && gem install fluent-plugin-elasticsearch

# Copy Fluentd configuration file (you should have a fluent.conf file in the same directory as the Dockerfile)
COPY fluent.conf /etc/fluent/fluent.conf

# Expose the Fluentd port
EXPOSE 24224

# Run Fluentd on container startup
CMD ["fluentd", "-c", "/etc/fluent/fluent.conf"]
