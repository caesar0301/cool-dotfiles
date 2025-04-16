# Base image of devcontainer, xiaming chen
# Use the official Ubuntu 24.04 image as the base image
FROM ubuntu:24.04

ARG TARGETARCH

# Replace sources.list with the Aliyun mirror
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://mirrors.aliyun.com/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources

# Update package list and install sudo, then clean up to reduce image size
RUN apt-get update && apt-get install -y sudo adduser \
      build-essential git curl wget vim nano \
      cmake gdb llvm clang zsh tmux python3 python3-pip \
      openjdk-17-jdk openjdk-21-jdk nodejs npm \
      universal-ctags ripgrep silversearcher-ag \
      iputils-ping netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a new user named 'admin' and add it to the sudo group
ARG ADMIN_PASS=admin
RUN adduser --disabled-password --gecos "" admin && \
    echo "admin:${ADMIN_PASS}" | chpasswd && \
    usermod -aG sudo admin && \
    chsh -s /usr/bin/zsh admin

# Switch to the 'admin' user
USER admin
WORKDIR /home/admin

# Install golang
ARG GO_VERSION=1.24.2
ENV PATH=$PATH:/home/admin/go/bin
RUN echo "Install golang: $TARGETARCH" \
    && if [ "$TARGETARCH" = "amd64" ]; then \
        GO_RELEASE="go${GO_VERSION}.linux-amd64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        GO_RELEASE="go${GO_VERSION}.linux-arm64"; \
    else \
        echo "Unsupported arch: $TARGETARCH" && exit 1; \
    fi \
    && wget https://go.dev/dl/${GO_RELEASE}.tar.gz && tar -C /home/admin -xzf ${GO_RELEASE}.tar.gz && rm ${GO_RELEASE}.tar.gz

# Install dotfiles
RUN git clone --depth=1 https://github.com/caesar0301/cool-dotfiles.git ~/.dotfiles
RUN which go && ~/.dotfiles/zsh/install.sh && SUDO_PASS="${ADMIN_PASS}" ~/.dotfiles/nvim/install.sh

# Set the default command to start a bash shell
CMD ["/usr/bin/zsh"]
