#!/bin/bash

echo "Starting Besu Node 3..."
echo

# Check if Java 17+ is installed
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed"
    echo "Please install OpenJDK 17 or later first"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "Error: Java 17 or later is required (current: $JAVA_VERSION)"
    echo "Please install OpenJDK 17 or later"
    exit 1
fi

# Check if Besu is installed
if ! command -v besu &> /dev/null; then
    echo "Error: Besu is not installed or not in PATH"
    echo "Please install Hyperledger Besu first"
    echo "Download from: https://besu.hyperledger.org/en/stable/HowTo/Get-Started/Install-Binaries/"
    exit 1
fi

# Create data directory if it doesn't exist
mkdir -p data/node3

# Start Node 3
echo "Starting Node 3 on port 8565..."
echo "RPC HTTP: http://localhost:8565"
echo "RPC WS: ws://localhost:8566"
echo "P2P: 30305"
echo "Metrics: http://localhost:9565"
echo
echo "Press Ctrl+C to stop the node"
echo

besu --config-file=besu-node3.toml
