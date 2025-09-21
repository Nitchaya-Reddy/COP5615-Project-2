import node
import gleam/erlang/process.{type Subject}

pub fn launch_aggregation_consensus(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  case nodes {
    [seed_node, ..] -> {
      // Initialize push-sum by sending baseline values to seed node
      node.transmit_aggregation_data(seed_node, 0.0, 0.0)
    }
    [] -> Nil
  }
}
