import gleam/list
import gleam/io
import gleam/int
import node
import gleam/erlang/process.{type Subject}

pub fn create_participant_network(nodes: Int) -> List(Subject(node.ParticipantMessage)) {
  list.range(1, nodes)
    |> list.map(node.initialize_participant)
}

pub fn establish_connections(nodes: List(Subject(node.ParticipantMessage)), topology: String) -> Nil {
  case topology {
    "full" -> configure_complete_network(nodes)
    "line" -> configure_linear_chain(nodes)
    "3D" -> configure_cubic_grid(nodes)
    "imp3D" -> configure_enhanced_cubic_grid(nodes)
    _ -> {
      io.println("Unrecognized topology: " <> topology)
      io.println("Supported topologies: full, line, 3D, imp3D")
    }
  }
  io.println("Network configuration established successfully!")
}

fn configure_complete_network(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  list.each(nodes, fn(current_node) {
    let adjacent_nodes = nodes |> list.filter(fn(other) { other != current_node })
    node.establish_adjacency(current_node, adjacent_nodes)
  })
}

fn configure_linear_chain(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  let total_count = list.length(nodes)
  let enumerated_nodes = list.index_map(nodes, fn(node_ref, position) { #(position, node_ref) })
  
  list.each(enumerated_nodes, fn(entry) {
    let #(position, current_node) = entry
    let adjacent_list = case position {
      0 if total_count > 1 -> {
        // First node - connects only to the next
        case list.drop(nodes, 1) {
          [next_node, ..] -> [next_node]
          [] -> []
        }
      }
      pos if pos == total_count - 1 && total_count > 1 -> {
        // Last node - connects only to the previous
        case list.drop(nodes, total_count - 2) |> list.take(1) {
          [previous_node] -> [previous_node]
          _ -> []
        }
      }
      pos if pos > 0 && pos < total_count - 1 -> {
        // Middle nodes - connect to both neighbors
        let previous = case list.drop(nodes, pos - 1) |> list.take(1) {
          [p] -> [p]
          _ -> []
        }
        let next = case list.drop(nodes, pos + 1) |> list.take(1) {
          [n] -> [n]
          _ -> []
        }
        list.append(previous, next)
      }
      _ -> []
    }
    node.establish_adjacency(current_node, adjacent_list)
  })
}

fn configure_cubic_grid(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  let total_count = list.length(nodes)
  // Determine cubic dimensions for 3D grid arrangement
  let dimension_size = calculate_cubic_dimension(total_count)
  
  let indexed_nodes = list.index_map(nodes, fn(node_ref, linear_index) { #(linear_index, node_ref) })
  
  list.each(indexed_nodes, fn(entry) {
    let #(linear_index, current_node) = entry
    
    // Transform linear index to 3D spatial coordinates
    let coord_x = linear_index % dimension_size
    let coord_y = { linear_index / dimension_size } % dimension_size
    let coord_z = linear_index / { dimension_size * dimension_size }
    
    let adjacent_nodes = list.filter_map(indexed_nodes, fn(other_entry) {
      let #(other_index, other_node) = other_entry
      
      // Transform other node's linear index to 3D coordinates
      let other_coord_x = other_index % dimension_size
      let other_coord_y = { other_index / dimension_size } % dimension_size
      let other_coord_z = other_index / { dimension_size * dimension_size }
      
      // Verify if nodes are spatially adjacent (unit distance in 3D space)
      let x_distance = int.absolute_value(coord_x - other_coord_x)
      let y_distance = int.absolute_value(coord_y - other_coord_y)
      let z_distance = int.absolute_value(coord_z - other_coord_z)
      
      case x_distance + y_distance + z_distance == 1 {
        True -> Ok(other_node)
        False -> Error(Nil)
      }
    })
    
    node.establish_adjacency(current_node, adjacent_nodes)
  })
}

fn calculate_cubic_dimension(total_count: Int) -> Int {
  // Approximate cubic root calculation for 3D grid sizing
  case total_count {
    count if count <= 1 -> 1
    count if count <= 8 -> 2
    count if count <= 27 -> 3
    count if count <= 64 -> 4
    count if count <= 125 -> 5
    count if count <= 216 -> 6
    _ -> int.max(3, total_count / 25)  // Reasonable fallback for larger networks
  }
}

fn configure_enhanced_cubic_grid(nodes: List(Subject(node.ParticipantMessage))) -> Nil {
  let total_count = list.length(nodes)
  let dimension_size = calculate_cubic_dimension(total_count)
  
  let indexed_nodes = list.index_map(nodes, fn(node_ref, linear_index) { #(linear_index, node_ref) })
  
  list.each(indexed_nodes, fn(entry) {
    let #(linear_index, current_node) = entry
    
    // Transform linear index to 3D spatial coordinates
    let coord_x = linear_index % dimension_size
    let coord_y = { linear_index / dimension_size } % dimension_size
    let coord_z = linear_index / { dimension_size * dimension_size }
    
    let base_adjacents = list.filter_map(indexed_nodes, fn(other_entry) {
      let #(other_index, other_node) = other_entry
      
      // Transform other node's linear index to 3D coordinates
      let other_coord_x = other_index % dimension_size
      let other_coord_y = { other_index / dimension_size } % dimension_size
      let other_coord_z = other_index / { dimension_size * dimension_size }
      
      // Verify if nodes are spatially adjacent (unit distance in 3D space)
      let x_distance = int.absolute_value(coord_x - other_coord_x)
      let y_distance = int.absolute_value(coord_y - other_coord_y)
      let z_distance = int.absolute_value(coord_z - other_coord_z)
      
      case x_distance + y_distance + z_distance == 1 {
        True -> Ok(other_node)
        False -> Error(Nil)
      }
    })
    
    // Enhance connectivity by adding one supplementary connection
    let supplementary_connection = find_supplementary_connection(indexed_nodes, linear_index, base_adjacents)
    let enhanced_adjacents = case supplementary_connection {
      Ok(extra_node) -> [extra_node, ..base_adjacents]
      Error(_) -> base_adjacents
    }
    
    node.establish_adjacency(current_node, enhanced_adjacents)
  })
}

fn find_supplementary_connection(
  all_nodes: List(#(Int, Subject(node.ParticipantMessage))), 
  current_index: Int,
  existing_adjacents: List(Subject(node.ParticipantMessage))
) -> Result(Subject(node.ParticipantMessage), Nil) {
  let candidate_nodes = list.filter_map(all_nodes, fn(entry) {
    let #(index, node_ref) = entry
    
    // Exclude self and current adjacents
    let is_self = index == current_index
    let is_current_adjacent = list.contains(existing_adjacents, node_ref)
    
    case is_self || is_current_adjacent {
      True -> Error(Nil)
      False -> Ok(node_ref)
    }
  })
  
  // Select first available candidate
  // In practice, this could use proper randomization
  case candidate_nodes {
    [first_candidate, ..] -> Ok(first_candidate)
    [] -> Error(Nil)
  }
}
