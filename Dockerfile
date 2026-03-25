FROM ubuntu
RUN groupadd -g 1001 appgroup \
    && useradd -m -u 1001 -g appgroup -s /bin/bash appuser \
    && echo "appuser:password" | chpasswd

RUN apt-get update && \
    apt-get install -y openssh-server

# Needed for sshd to run
RUN mkdir /var/run/sshd

# Needed for sshd to know its host keys
# Host keys is how the container identifies itself to the client, and is required for sshd to start
RUN ssh-keygen -A

COPY ./id_rsa.pub /home/appuser/.ssh/authorized_keys

# Needed for ansible
RUN apt-get install python3 sudo -y && \
    usermod -aG sudo appuser

EXPOSE 22
EXPOSE 8080
EXPOSE 443

# Run as root user
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
