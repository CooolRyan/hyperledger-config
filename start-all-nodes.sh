#!/bin/bash

echo "Starting All Besu Nodes..."
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

# Create data directories if they don't exist
mkdir -p data/node1 data/node2 data/node3

# Function to start a node in background
start_node() {
    local node_num=$1
    local config_file=$2
    local port=$3
    
    echo "Starting Node $node_num on port $port..."
    nohup besu --config-file=$config_file > logs/node$node_num.log 2>&1 &
    local pid=$!
    echo "Node $node_num started with PID: $pid"
    echo $pid > pids/node$node_num.pid
    sleep 3
}

# Create logs and pids directories
mkdir -p logs pids

# Start all nodes
start_node 1 "besu-node1.toml" 8545
start_node 2 "besu-node2.toml" 8555
start_node 3 "besu-node3.toml" 8565

echo
echo "All nodes are starting..."
echo
echo "Node Status:"
echo "Node 1: RPC http://localhost:8545, WS ws://localhost:8546, P2P 30303, Metrics http://localhost:9545"
echo "Node 2: RPC http://localhost:8555, WS ws://localhost:8556, P2P 30304, Metrics http://localhost:9555"
echo "Node 3: RPC http://localhost:8565, WS ws://localhost:8566, P2P 30305, Metrics http://localhost:9565"
echo
echo "To view logs:"
echo "  tail -f logs/node1.log"
echo "  tail -f logs/node2.log"
echo "  tail -f logs/node3.log"
echo
echo "To stop all nodes:"
echo "  ./stop-all-nodes.sh"
echo
echo "To check node status:"
echo "  ./check-status.sh"
echo
echo "Press Enter to continue..."
read
