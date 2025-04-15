# Use the official Ubuntu 24.04 image as the base image
FROM ubuntu:24.04

# Replace sources.list with the Aliyun mirror
RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://mirrors.aliyun.com/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources

# Update package list and install sudo, then clean up to reduce image size
RUN apt-get update && \
    apt-get install -y sudo adduser build-essential git curl wget vim cmake gdb zsh tmux python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new user named 'admin' and add it to the sudo group
# WARNING: Hardcoding passwords in Dockerfiles is not secure. Consider using environment variables or Docker secrets.
RUN adduser --disabled-password --gecos "" admin && \
    echo "admin:admin" | chpasswd && \
    usermod -aG sudo admin && \
    chsh -s /usr/bin/zsh admin

# Switch to the 'admin' user
USER admin

# Install dotfiles
RUN git clone --depth=1 https://github.com/caesar0301/cool-dotfiles.git ~/.dotfiles
RUN cd ~/.dotfiles && ./zsh/install.sh
RUN cd ~/.dotfiles && ./nvim/install.sh

# Set the default command to start a bash shell
CMD ["/usr/bin/zsh"]