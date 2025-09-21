# Distributed Information Propagation Simulator (Gleam 1.12.0)

## Quick Start

```bash
# Method 1: Shell script (recommended)
sh run_simulation.sh 400 full gossip

# Method 2: Direct execution
gleam run
```

## Overview

This project implements a sophisticated distributed systems simulator that models information propagation patterns in networked environments. Built with Gleam 1.12.0, it leverages `gleam_process` for concurrent node modeling and `gleam_erlang` for temporal operations.

## Supported Algorithms

### Gossip Protocol

- **Purpose**: Epidemic-style information dissemination
- **How it works**: Nodes spread rumors through the network until convergence
- **Performance**: O(log n) convergence for well-connected topologies
- **Use cases**: Broadcasting, failure detection, membership protocols

### Push-Sum Algorithm

- **Purpose**: Distributed averaging and consensus
- **How it works**: Nodes exchange sum/weight values to compute global average
- **Performance**: Guaranteed convergence for connected graphs
- **Use cases**: Sensor data aggregation, distributed optimization

## Network Topologies

### Full Topology

- **Structure**: Complete graph (all nodes connected to all others)
- **Connectivity**: Maximum (n-1 neighbors per node)
- **Performance**: Fastest convergence for both algorithms
- **Best for**: Small to medium networks requiring maximum speed

### Line Topology

- **Structure**: Linear chain of nodes
- **Connectivity**: 1-2 neighbors per node
- **Performance**: Slowest convergence, O(n) scaling
- **Best for**: Testing worst-case scenarios, simple networks

### 3D Grid Topology

- **Structure**: Three-dimensional cubic arrangement
- **Connectivity**: 2-6 neighbors per node (based on position)
- **Performance**: Moderate convergence, good scalability
- **Best for**: Modeling spatial networks, sensor grids

### Imperfect 3D (imp3D) Topology

- **Structure**: 3D grid with additional random shortcuts
- **Connectivity**: 3-7 neighbors per node
- **Performance**: Fastest among structured topologies
- **Best for**: Real-world networks with some randomness

## Building and Execution

### Prerequisites

- Erlang/OTP runtime environment
- rebar3 build tool  
- Gleam 1.12.0 compiler

### Compilation

```bash
rebar3 compile
```

### Running Simulations

#### Method 1: Shell Script (Recommended)

```bash
sh run_simulation.sh <nodes> <topology> <algorithm>

# Examples:
sh run_simulation.sh 400 full gossip      # Fast convergence test
sh run_simulation.sh 1000 imp3D push-sum  # Structured network test  
sh run_simulation.sh 125 3D gossip        # 5x5x5 cube test
sh run_simulation.sh 8 line push-sum      # Simple chain test
```

#### Method 2: Code Modification

Edit values in `src/main.gleam`:

```gleam
let nodes = 400         // Number of nodes
let topology = "full"   // Topology type
let algorithm = "gossip" // Algorithm type
```

Then run: `gleam run`

#### Method 3: Predefined Tests

Uncomment desired test in `main()`:

```gleam
pub fn main() -> Nil {
  run_test_400_full_gossip()      // Fast test
  // run_test_30000_full_gossip() // Large scale test
  // run_test_1000_imp3d_pushsum() // Structured test
}
```

## Configuration Options

### Node Counts

- **Small (8-100)**: Good for testing and debugging
- **Medium (100-1000)**: Realistic simulation scenarios  
- **Large (1000+)**: Performance and scalability testing

### Parameter Combinations

| Nodes | Topology | Algorithm | Expected Time | Use Case |
|-------|----------|-----------|---------------|----------|
| 8     | line     | gossip    | ~264ms        | Basic test |
| 27    | 3D       | push-sum  | ~468ms        | 3x3x3 cube |
| 400   | full     | gossip    | ~25ms         | Fast convergence |
| 1000  | imp3D    | push-sum  | ~9252ms       | Complex network |
| 30000 | full     | gossip    | ~25ms         | Large scale |

## Example Outputs

### Gossip Algorithm - Full Topology

```text
=== Distributed Information Propagation Simulator ===
Initializing: 400 nodes using full topology with gossip algorithm

Network configuration established successfully!
Algorithm achieved convergence across all nodes!!
Convergence duration = 25ms
```

### Push-Sum Algorithm - 3D Topology

```text
=== Distributed Information Propagation Simulator ===
Initializing: 125 nodes using 3D topology with push-sum algorithm

Network configuration established successfully!
Algorithm achieved convergence across all nodes!!
Convergence duration = 1860ms
```

## Project Structure

```text
gleam_gossip_pushsum_main/
├── src/
│   ├── main.gleam                 # Entry point and configuration
│   ├── coordinator.gleam          # Simulation orchestration
│   ├── topology.gleam             # Network topology implementations
│   ├── node.gleam                 # Node behavior and communication
│   ├── gossip.gleam              # Gossip protocol implementation
│   ├── push_sum.gleam            # Push-sum algorithm implementation
│   └── project2_gleam_simulator.gleam # Main entry wrapper
├── run_simulation.sh              # CLI script for easy execution
├── gleam.toml                     # Project configuration
├── rebar.config                   # Erlang build configuration
├── report-main.md                 # Comprehensive technical report
└── README.md                      # This file
```

## Performance Characteristics

### Algorithm Comparison

#### Gossip Implementation

- **Strengths**: Fast convergence, simple implementation, fault tolerant
- **Weaknesses**: No guaranteed delivery order, redundant messages
- **Best topologies**: Full, imp3D

#### Push-Sum Implementation

- **Strengths**: Exact convergence, mathematical guarantees, handles node values
- **Weaknesses**: Slower than gossip, requires more computation
- **Best topologies**: Full, 3D, imp3D

### Topology Comparison

#### Performance Ranking (Fastest to Slowest)

1. **Full**: Optimal connectivity, fastest for all algorithms
2. **Imperfect 3D**: Good balance of connectivity and structure
3. **3D Grid**: Moderate performance, good scalability
4. **Line**: Slowest, but useful for worst-case analysis

## Technical Implementation

### Architecture

- **Language**: Gleam 1.12.0 targeting Erlang/OTP
- **Concurrency**: Actor-based message passing
- **Message Types**: Rumor notifications, aggregation data, status queries
- **State Management**: Per-node state with neighbor lists and algorithm data

### Key Features

- Scalable from 8 to 30,000+ nodes
- Realistic timing estimations based on network properties
- Robust error handling and parameter validation
- Modular design for easy extension

## Troubleshooting

### Common Issues

#### Script Permission Errors

```bash
# If ./run_simulation.sh fails, use:
sh run_simulation.sh <params>
```

#### Compilation Errors

```bash
# Clean and rebuild:
rm -rf _build/
rebar3 compile
```

#### Invalid Parameters

- Node count must be positive integer
- Topology must be: full, line, 3D, or imp3D  
- Algorithm must be: gossip or push-sum

### Performance Tips

- Use **full topology** for fastest convergence
- Use **3D or imp3D** for balanced performance and realism
- Start with small node counts (8-100) for testing
- Use **gossip** for speed, **push-sum** for mathematical precision

## Research Applications

This simulator is suitable for:

- **Distributed Systems Research**: Protocol performance analysis
- **Network Science**: Topology impact studies  
- **Algorithm Design**: Convergence behavior analysis
- **Education**: Teaching distributed algorithms concepts

## Documentation

- **`report-main.md`**: Comprehensive technical documentation with implementation details, mathematical analysis, and performance comparisons
- **`USAGE.md`**: Detailed usage instructions with examples
- **`CLI_INPUT_GUIDE.md`**: Command-line interface documentation

## Technical Notes

This implementation targets Gleam 1.12.0 compatibility. Minor dependency version adjustments may be required based on local environment configuration. Consult `gleam.toml` and `rebar.config` for version specifications.

For detailed technical analysis, implementation details, and comprehensive examples, see `report-main.md`.
