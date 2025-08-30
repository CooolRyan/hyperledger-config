#!/bin/bash

echo "Installing Hyperledger Besu on Ubuntu..."
echo "========================================"
echo

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Error: Please don't run this script as root"
    echo "Run as regular user and use sudo when prompted"
    exit 1
fi

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install required packages
echo "Installing required packages..."
sudo apt-get install -y \
    openjdk-17-jdk \
    curl \
    wget \
    unzip \
    git \
    build-essential \
    net-tools

# Set JAVA_HOME
echo "Setting JAVA_HOME..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java installation
echo "Verifying Java installation..."
java -version
echo "JAVA_HOME: $JAVA_HOME"

# Download and install Besu
echo "Downloading Hyperledger Besu..."
BESU_VERSION="23.10.1"
BESU_URL="https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/${BESU_VERSION}/besu-${BESU_VERSION}.tar.gz"
BESU_DIR="$HOME/besu"

mkdir -p $BESU_DIR
cd $BESU_DIR

if [ ! -f "besu-${BESU_VERSION}.tar.gz" ]; then
    wget $BESU_URL
fi

echo "Extracting Besu..."
tar -xzf besu-${BESU_VERSION}.tar.gz

# Add Besu to PATH
echo "Adding Besu to PATH..."
echo "export PATH=$BESU_DIR/besu-${BESU_VERSION}/bin:\$PATH" >> ~/.bashrc
export PATH=$BESU_DIR/besu-${BESU_VERSION}/bin:$PATH

# Verify Besu installation
echo "Verifying Besu installation..."
besu --version

# Make scripts executable
echo "Making scripts executable..."
cd - > /dev/null
chmod +x *.sh

echo
echo "Installation completed!"
echo "======================"
echo
echo "Please log out and log back in, or run:"
echo "  source ~/.bashrc"
echo
echo "Then you can start the nodes:"
echo "  ./start-all-nodes.sh"
echo "  # or"
echo "  ./start-docker.sh"
echo
echo "To check node status:"
echo "  ./check-status.sh"
echo
echo "To stop all nodes:"
echo "  ./stop-all-nodes.sh"
