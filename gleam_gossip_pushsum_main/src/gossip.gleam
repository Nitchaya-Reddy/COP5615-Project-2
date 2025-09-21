import node
import gleam/erlang/process.{type Subject}

pub fn initiate_rumor_propagation(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  case nodes {
    [initial_node, ..] -> {
      // Begin gossip by activating the first node
      node.transmit_rumor(initial_node)
    }
    [] -> Nil
  }
}
