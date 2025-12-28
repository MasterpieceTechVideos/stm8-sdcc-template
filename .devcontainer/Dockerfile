FROM debian:trixie-slim

# Add user with same UID and GID as your host system, if it doesn't already exist
# Since Ubuntu 24.04, a non-root user is created by default with the name vscode and UID=1000
ARG USERNAME=stm8
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if ! id -u $USER_UID >/dev/null 2>&1; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME; \
    fi
# Add sudo support for the non-root user
RUN apt-get update && \
    apt-get install -y sudo && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch from root to user
USER $USERNAME

# Add user to dialout and tty groups to allow access to programming hardware
RUN sudo usermod --append --groups dialout $USERNAME
RUN sudo usermod --append --groups tty     $USERNAME

# Install dependencies
RUN sudo apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    ca-certificates \
    gh \
    git \
    libhidapi-hidraw0 \
    libusb-0.1-4 \
    libusb-1.0-0 \
    libhidapi-dev \
    libusb-1.0-0-dev \
    libusb-dev \
    libtool \
    make \
    pkg-config \
    sdcc \
    texinfo

# Create and run script to install stm8flash
ARG GIT_URL=https://github.com/vdudouyt/stm8flash.git
RUN printf '#!/bin/bash       \n\n' >> ~/install_stm8flash.sh 
RUN printf 'cd ~              \n'   >> ~/install_stm8flash.sh
RUN printf "git clone ${GIT_URL}\n" >> ~/install_stm8flash.sh
RUN printf 'cd stm8flash      \n'   >> ~/install_stm8flash.sh
RUN printf 'make              \n'   >> ~/install_stm8flash.sh
RUN printf 'sudo make install \n'   >> ~/install_stm8flash.sh
RUN printf 'cd ..             \n'   >> ~/install_stm8flash.sh
RUN printf 'rm -rf stm8flash  \n'   >> ~/install_stm8flash.sh
RUN chmod +x ~/install_stm8flash.sh
RUN ~/install_stm8flash.sh
