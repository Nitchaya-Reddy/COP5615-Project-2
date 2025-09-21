# Project 2 – Gossip Simulator
**COP5615 - Distributed Operating Systems Principles**

---
## Group Info

* Palapati Tanuja Naga Sai UF ID - 89475480
* Venkata Nitchaya Reddy Konkala UF ID - 36102083

## Explanation

## Gossip Algorithm

* The Gossip algorithm mimics how information naturally spreads among people. It begins with one actor who randomly picks a neighbor to share the information (or “rumor”) with. Each actor continues spreading the rumor until it has heard it a certain number of times — for example, 10. Once most or all nodes in the system have received the rumor, we say the system has “converged.” It’s a simple technique, but its effectiveness largely depends on how the network is structured.

## Push-Sum Algorithm

* Push-Sum is used when we want to compute aggregates, like the average of values across a network. Each actor keeps track of two numbers: s (for sum) and w (for weight). At the start, every actor sets s to its own ID and w to 1. With each step:

* The actor splits (s, w) into two equal parts.

* One half is kept; the other is sent to a randomly chosen neighbor.

* The actor updates its estimate as s / w.

* Convergence happens when this s/w ratio becomes stable — meaning it changes very little over time (say, less than 10⁻¹⁰). Unlike the Gossip algorithm, the values of s and w don’t converge individually — just their ratio.

## Topologies

* Full Network: Every actor can talk directly to every other. This leads to the fastest convergence because messages can spread instantly across the system.

* Line: Actors are placed in a straight line, each connected only to its immediate neighbors. Since information moves step-by-step, this is the slowest setup for convergence.

* 3D Grid: Actors are arranged in a 3D cube, with each having up to six neighbors (left, right, front, back, up, and down). Convergence is faster than in a line but slower than in a fully connected network.

* Imperfect 3D Grid: Similar to the 3D grid, but each node also gets one extra random neighbor. This added randomness helps avoid slowdowns (“bottlenecks”) and speeds up convergence.

## Bonus: Failure Model

* The simulator also supports modeling failures — great for testing network resilience.

* Node Failure: A node drops out permanently and stops participating.

* Connection Failure: A link between two nodes breaks, either temporarily or for good.

* By tweaking the failure rate, we can observe how different topologies hold up:

* The Full Network is very resilient — if one path fails, there are many others.

* The Line is the most fragile — one failure can cut off entire sections.

* The Imperfect 3D Grid performs well, thanks to its randomly placed backup links.

---

## What is working?  

* Used both Gossip and Push-Sum protocols via the actor model in Gleam.

* Network topologies supported: full, line, 3D grid, and imperfect 3D grid.

* Gossip protocol: rumor circulates correctly and convergence is determined after the rumor is heard at every node the right number of times.

* Push-Sum protocol: actors maintain (s, w) values, exchange between neighbors, and converge after the ratio of s/w is stabilized.

* Convergence time is calculated accurately and provided at the end of the simulation.

* Scalability: It scales up to big node counts (checked up to [insert your max nodes]) and converges appropriately.

* Performance: Line topology converges slowest, full topology converges fastest, and imperfect 3D converges better than regular 3D due to randomness of connections.

* Bonus implementation: introduced failure model (node and/or connection failures) controlled by a parameter. System resilience under failures, especially under full and imperfect 3D topologies.
---

## Instructions:

  chmod +x ./run_simulation.sh
  ./run_simulation.sh 5 line push-sum
  ./run_simulation.sh 50 imp3D gossip
  ./run_simulation.sh 100 full push-sum
  ./run_simulation.sh 3000 3D gossip
---

## Result of running: 
# Gossip full
<img width="1254" height="1280" alt="image" src="https://github.com/user-attachments/assets/18dd43df-c5ab-41a1-8eec-70bd10e308ad" />

# Gossip line
<img width="1280" height="1102" alt="image" src="https://github.com/user-attachments/assets/29ca724b-c230-4172-b60e-382627157f18" />

# Gossip 3D
<img width="1280" height="1088" alt="image" src="https://github.com/user-attachments/assets/6103400a-7b56-4aa5-9afd-cd64727c989a" />

# Gossip imp3D
<img width="1280" height="731" alt="image" src="https://github.com/user-attachments/assets/cd8f7452-5dbe-470d-befc-cde2bf73ebb3" />

# Push-sum full
<img width="1598" height="1394" alt="image" src="https://github.com/user-attachments/assets/b7b59e77-aa0c-4e2f-b787-e1515b28825e" />

# push-sum line
<img width="1600" height="1350" alt="image" src="https://github.com/user-attachments/assets/ed19f706-3176-4fbd-baf9-f8a8189a0d88" />

# push-sum 3D
<img width="1600" height="1362" alt="image" src="https://github.com/user-attachments/assets/aa54076d-6c49-4f0b-ae65-45281140545d" />

# push-sum imp3D
<img width="1598" height="1362" alt="image" src="https://github.com/user-attachments/assets/2b2449d5-6d02-4a89-a0dd-325107b07483" />

## What is the largest network you managed to deal with for each type of topology and algorithm?
| Algorithm      | Topology | Nodes | Time (milliseconds)
| ----------- | ----------- | ------| ------------- |
| Gossip | Full | 10000  | 2,240 |
| Gossip | Line |7000 |105000 | 
| Gossip | 3D | 9000 | 90000|
| Gossip | Imp3D | 10,000 | 112956 |
| Pushsum | Full | 2000 |1574 |
| Pushsum | Line |10000 | 150250| 
| Pushsum | 3D |10,000 | 100200 |
| Pushsum | Imp3D | 1000|100150 |




















                                                                                                                                                            
                                                                                                                                                            

 
 ---
 

