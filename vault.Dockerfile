FROM centos:latest

# Set the non-root user and group
RUN groupadd -g 1000 vaultuser && \
    useradd -u 1000 -g 1000 -s /bin/bash -m vaultuser

# Install Vault
RUN curl -LO https://releases.hashicorp.com/vault/1.7.3/vault_1.7.3_linux_amd64.zip && \
    unzip vault_1.7.3_linux_amd64.zip && \
    mv vault /usr/local/bin && \
    chown vaultuser:vaultuser /usr/local/bin/vault && \
    rm vault_1.7.3_linux_amd64.zip

# Switch to the non-root user
USER vaultuser

# Set the working directory
WORKDIR /home/vaultuser

# Set the entrypoint
ENTRYPOINT ["vault"]
