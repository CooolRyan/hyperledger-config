#!/bin/bash

echo "Starting Besu Nodes with Docker Compose..."
echo

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    echo "Please start Docker service first:"
    echo "  sudo systemctl start docker"
    echo "  sudo usermod -aG docker $USER"
    echo "  # Then log out and log back in"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker Compose is not available"
    echo "Please install Docker Compose first:"
    echo "  sudo apt-get install docker-compose"
    echo "  # or"
    echo "  sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose"
    echo "  sudo chmod +x /usr/local/bin/docker-compose"
    exit 1
fi

echo "Starting all nodes..."
docker-compose up -d

echo
echo "All nodes are starting..."
echo
echo "Node Status:"
docker-compose ps
echo
echo "To view logs:"
echo "  docker-compose logs -f besu-node1"
echo "  docker-compose logs -f besu-node2"
echo "  docker-compose logs -f besu-node3"
echo
echo "To stop all nodes:"
echo "  docker-compose down"
echo
echo "To restart nodes:"
echo "  docker-compose restart"
echo
echo "Node endpoints:"
echo "  Node 1: http://localhost:8545"
echo "  Node 2: http://localhost:8555"
echo "  Node 3: http://localhost:8565"
echo
echo "Press Enter to continue..."
read
