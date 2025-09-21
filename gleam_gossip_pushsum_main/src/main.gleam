import gleam/io
import gleam/int
import coordinator

pub fn main() -> Nil {
  // QUICK SWITCH: Uncomment the test you want to run!
  
  // run_test_400_full_gossip()      // 400 nodes, full topology, gossip
  // run_test_30000_full_gossip()    // 30000 nodes, full topology, gossip  
  // run_test_1000_imp3d_pushsum()   // 1000 nodes, imp3D topology, push-sum
  
  // Or configure manually:
  let nodes = 400       // <-- Change number of nodes here
  let topology = "full"   // <-- Change topology here (full, line, 3D, imp3D)
  let algorithm = "gossip" // <-- Change algorithm here (gossip, push-sum)
  
  io.println("=== Distributed Information Propagation Simulator ===")
  io.println("Initializing: " <> int.to_string(nodes) <> " nodes using " <> topology <> " topology with " <> algorithm <> " algorithm")
  io.println("")
  
  execute_simulation([int.to_string(nodes), topology, algorithm])
  
  io.println("")
  io.println("Configuration options (modify values above in main.gleam):")
  io.println("Topologies: full, line, 3D, imp3D")
  io.println("Algorithms: gossip, push-sum")
}

// Quick configuration functions - uncomment and modify main() to use these:
pub fn run_test_400_full_gossip() -> Nil {
  execute_simulation(["400", "full", "gossip"])
}

pub fn run_test_30000_full_gossip() -> Nil {
  execute_simulation(["30000", "full", "gossip"])
}

pub fn run_test_1000_imp3d_pushsum() -> Nil {
  execute_simulation(["1000", "imp3D", "push-sum"])
}

pub fn scenario_large_3d_gossip() -> Nil {
  execute_simulation(["2500", "3D", "gossip"])
}

pub fn scenario_full_pushsum() -> Nil {
  execute_simulation(["12", "full", "push-sum"])
}

// Quick configuration function - modify these values for different tests
pub fn run_custom_simulation(nodes: Int, topology: String, algorithm: String) -> Nil {
  io.println("=== Custom Simulation Configuration ===")
  execute_simulation([int.to_string(nodes), topology, algorithm])
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
