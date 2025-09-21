#!/bin/sh

# Distributed Information Propagation Simulator Runner
# Usage: ./run_simulation.sh <nodes> <topology> <algorithm>
# Example: ./run_simulation.sh 30000 full gossip

if [ $# -ne 3 ]; then
    echo "Usage: $0 <nodes> <topology> <algorithm>"
    echo ""
    echo "Available topologies: full, line, 3D, imp3D"
    echo "Available algorithms: gossip, push-sum"
    echo ""
    echo "Examples:"
    echo "  $0 8 line push-sum"
    echo "  $0 75 imp3D gossip"
    echo "  $0 150 full push-sum"
    echo "  $0 2500 3D gossip"
    exit 1
fi

NODES=$1
TOPOLOGY=$2
ALGORITHM=$3

echo "Setting up simulation with $NODES nodes, $TOPOLOGY topology, $ALGORITHM algorithm..."

# Create a temporary main.gleam with the specified parameters
cat > src/main_temp.gleam << EOF
import gleam/io
import gleam/int
import coordinator

pub fn main() -> Nil {
  // Command-line configured simulation
  let nodes = $NODES
  let topology = "$TOPOLOGY"
  let algorithm = "$ALGORITHM"
  
  io.println("=== Distributed Information Propagation Simulator ===")
  io.println("Initializing: " <> int.to_string(nodes) <> " nodes using " <> topology <> " topology with " <> algorithm <> " algorithm")
  io.println("")
  
  execute_simulation([int.to_string(nodes), topology, algorithm])
  
  io.println("")
  io.println("Simulation run via run_simulation.sh")
}

pub fn execute_simulation(parameters: List(String)) -> Nil {
  case parameters {
    [nodes_str, topology, algorithm] ->
      case int.parse(nodes_str) {
        Ok(nodes) -> coordinator.initiate_distributed_simulation(nodes, topology, algorithm)
        Error(_) -> io.println("Invalid node count specified")
      }
    _ ->
      io.println("Usage: <nodes> <topology: full|line|3D|imp3D> <algorithm: gossip|push-sum>")
  }
}
EOF

# Backup original main.gleam
cp src/main.gleam main_backup_temp.gleam

# Replace main.gleam with the temporary version
mv src/main_temp.gleam src/main.gleam

# Run the simulation
echo ""
gleam run

# Restore original main.gleam
mv main_backup_temp.gleam src/main.gleam

echo ""
echo "Simulation completed! Original main.gleam restored."