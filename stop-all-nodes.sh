#!/bin/bash

echo "Stopping All Besu Nodes..."
echo

# Check if pids directory exists
if [ ! -d "pids" ]; then
    echo "No running nodes found (pids directory doesn't exist)"
    exit 0
fi

# Function to stop a node
stop_node() {
    local node_num=$1
    local pid_file="pids/node$node_num.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo "Stopping Node $node_num (PID: $pid)..."
            kill $pid
            sleep 2
            
            # Force kill if still running
            if ps -p $pid > /dev/null 2>&1; then
                echo "Force killing Node $node_num..."
                kill -9 $pid
            fi
            
            rm -f "$pid_file"
            echo "Node $node_num stopped"
        else
            echo "Node $node_num is not running (PID: $pid)"
            rm -f "$pid_file"
        fi
    else
        echo "Node $node_num PID file not found"
    fi
}

# Stop all nodes
stop_node 1
stop_node 2
stop_node 3

echo
echo "All nodes stopped"
echo "To start nodes again, run: ./start-all-nodes.sh"
