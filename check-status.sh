#!/bin/bash

echo "Besu Nodes Status Check"
echo "======================="
echo

# Function to check node status
check_node() {
    local node_num=$1
    local rpc_port=$2
    local pid_file="pids/node$node_num.pid"
    
    echo "Node $node_num:"
    
    # Check if PID file exists
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo "  Status: Running (PID: $pid)"
            
            # Check RPC connectivity
            if command -v curl &> /dev/null; then
                local response=$(curl -s -X POST -H "Content-Type: application/json" \
                    --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":1}' \
                    http://localhost:$rpc_port 2>/dev/null)
                
                if [ $? -eq 0 ] && [ -n "$response" ]; then
                    echo "  RPC: Connected (Port: $rpc_port)"
                    
                    # Get network version
                    local version=$(echo $response | grep -o '"result":"[^"]*"' | cut -d'"' -f4)
                    if [ -n "$version" ]; then
                        echo "  Network Version: $version"
                    fi
                else
                    echo "  RPC: Not responding (Port: $rpc_port)"
                fi
            else
                echo "  RPC: Port $rpc_port (curl not available for testing)"
            fi
            
            # Check log file
            local log_file="logs/node$node_num.log"
            if [ -f "$log_file" ]; then
                local last_log=$(tail -n 1 "$log_file" 2>/dev/null)
                if [ -n "$last_log" ]; then
                    echo "  Last Log: $last_log"
                fi
            fi
            
        else
            echo "  Status: Not running (PID file exists but process not found)"
            rm -f "$pid_file"
        fi
    else
        echo "  Status: Not running (no PID file)"
    fi
    
    echo
}

# Check each node
check_node 1 8545
check_node 2 8555
check_node 3 8565

# Check system resources
echo "System Resources:"
echo "================="

# Check Java processes
echo "Java Processes:"
ps aux | grep -E "(besu|java)" | grep -v grep | while read line; do
    echo "  $line"
done

echo

# Check port usage
echo "Port Usage:"
echo "  Port 8545 (Node 1 RPC): $(netstat -tlnp 2>/dev/null | grep :8545 || echo 'Not listening')"
echo "  Port 8555 (Node 2 RPC): $(netstat -tlnp 2>/dev/null | grep :8555 || echo 'Not listening')"
echo "  Port 8565 (Node 3 RPC): $(netstat -tlnp 2>/dev/null | grep :8565 || echo 'Not listening')"
echo "  Port 30303 (Node 1 P2P): $(netstat -tlnp 2>/dev/null | grep :30303 || echo 'Not listening')"
echo "  Port 30304 (Node 2 P2P): $(netstat -tlnp 2>/dev/null | grep :30304 || echo 'Not listening')"
echo "  Port 30305 (Node 3 P2P): $(netstat -tlnp 2>/dev/null | grep :30305 || echo 'Not listening')"

echo
echo "To view detailed logs:"
echo "  tail -f logs/node1.log"
echo "  tail -f logs/node2.log"
echo "  tail -f logs/node3.log"
