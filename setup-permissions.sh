#!/bin/bash

echo "Setting up script permissions..."
echo

# Make all shell scripts executable
chmod +x *.sh

echo "Permissions set for the following scripts:"
ls -la *.sh

echo
echo "You can now run the scripts:"
echo "  ./install-ubuntu.sh    # Install Besu and dependencies"
echo "  ./start-all-nodes.sh   # Start all nodes"
echo "  ./check-status.sh      # Check node status"
echo "  ./stop-all-nodes.sh    # Stop all nodes"
echo "  ./start-docker.sh      # Start with Docker Compose"
