# Use RHEL 8 as the base image
FROM registry.access.redhat.com/ubi8/ubi:latest

# Define a build argument for JDK version
ARG JDK_VERSION

# Set environment variable for Java version
ENV JAVA_HOME /usr/local/openjdk-$JDK_VERSION

# Install necessary tools
RUN yum install -y wget unzip && \
    yum clean all

# Download and install OpenJDK
RUN JDK_URL="https://download.java.net/java/GA/jdk${JDK_VERSION}/GPL/openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz" && \
    wget -qO- $JDK_URL | tar xz -C /usr/local && \
    ln -s $JAVA_HOME /usr/local/openjdk && \
    rm -rf $JAVA_HOME/lib/src.zip $JAVA_HOME/lib/missioncontrol $JAVA_HOME/lib/visualvm

# Install JCE policy files for OpenJDK 8
RUN if [[ "$JDK_VERSION" == 8* ]]; then \
        JDK_POLICY_URL="https://download.oracle.com/otn-pub/java/jce/${JDK_VERSION}/jce_policy-${JDK_VERSION}.zip" && \
        wget -q -O /tmp/jce_policy.zip --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        $JDK_POLICY_URL && \
        unzip -jo -d $JAVA_HOME/jre/lib/security /tmp/jce_policy.zip && \
        rm /tmp/jce_policy.zip; \
    else \
        JDK_POLICY_URL="https://download.oracle.com/otn-pub/java/jce/${JDK_VERSION}/jce_policy-${JDK_VERSION}.zip" && \
        wget -q -O /tmp/jce_policy.zip --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        $JDK_POLICY_URL && \
        unzip -jo -d $JAVA_HOME/lib/security /tmp/jce_policy.zip && \
        rm /tmp/jce_policy.zip; \
    fi

# Set default Java version based on the provided JDK_VERSION argument
ENV PATH $JAVA_HOME/bin:$PATH

# Display Java version after installation
RUN java -version
