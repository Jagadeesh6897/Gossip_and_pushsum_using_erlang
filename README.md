
# COP5615 - Distributed Operating System Principles - Project 2
# Gossip Simulator using Erlang

## Group Members:

- Jagadeeshwar Reddy Baddam (UFID: 99510882)
- Yeshitha Linga (UFID: 37260022)

## Objective

The objective of this project is to evaluate the convergence of gossip algorithms which can be used for group communication and for aggregate computation using an Erlang-based simulator.

## Description

We are asked to implement gossip and push-sum algorithms for information propagation. We have implemented these two algorithms on different topologies like line, full, 2D, imp2D.

•	The way the gossip protocol operates is that one actor starts the process and then sends the message to other actors. When each actor hears the message ten times, the moment of convergence is reached.

•	When using the push-sum technique, messages are sent as pairs(s,w), where s is the actor number and w is 1 for each actor. When the s/w ratio stays the same when compared to a specified value three times in a row, the propagation converges.

## Implementation

Algorithm_executor: This erlang file is the entry point and hosts the main method. Our implementation takes 3 parameters in the order -Nodes, Topology, Algorithm 

• NumNodes: Specifies the number of actors in the network 

• Topology: Stands for the name of the topology, i.e. line, full, 2d or imp2d 

• Algorithm: Stands for the algorithm used, i.e. gossip or pushsum

Algo_topology: This file contains the code for distinguishing the different topologies depending on the input topology name. In addition, this file contains the logic for terminating the actors once they have met their convergence conditions and reporting the execution time.

Algo_pushsum: The data for just one push-sum participant is contained in this file. This includes the details of its neighbors, which are kept in a list (neighbourList) that is supplied to it at startup. Iteratively sending half of its state to one of its neighbors while updating its own state to the other half, the implementation keeps state as the pair (s,w). Because each node updates its state after waiting for a maximum of 100 milliseconds to receive any pairs from its neighbors, the nature of this solution helps assure convergence.
## How to execute code in Intellij terminal

#### FOR GOSSIP ALGORITHM
 - enter the number of nodes (will be rounded up for 2d and imp2d topologies)
 - enter the topology: 
 - enter the algorithm------"gossip"
After starting the algo_executor code we get gossip converged message and get the time as time elapsed


#### FOR PUSH SUM ALGORITHM
 - enter the number of nodes (will be rounded up for 2d and imp2d topologies)
 - enter the topology:
 - enter the algorithm:------"push-sum"
Here we get message as push sum converged and  get the ratio after converging and 
we also get the time elapsed for this
## What is Working

For the given algorithms and topologies, the program outputs the convergence times of all nodes. It makes sure that every node in gossip hears the rumor at least ten times. For push-sum, the average s/w ratio across all nodes shouldn't have varied by more than 10^-10 during the course of three rounds.
## Result

Due to the inherent characteristics of the aforementioned topologies, which control the distribution of messages, Gossip and Push-Sum algorithms are successfully simulated for all the aforementioned topologies with variable convergence times. For example, when compared to Imperfect grid, Line Topolgy consistently has the highest time to converge values. 

#### Gossip Protocol:

| Topology  | Network Size  | Convergence time(ms) |
| :------------ |:---------------:| -----:|
|Full Network     | 1000 | 123859 |
| 2D      | 700        |   11828 |
| Line | 2500       |    50453 |
| Imperfect 2D Grid | 2500        |    50453 |


#### Push Sum Algorithm:

| Topology  | Network Size  | Convergence time(ms) |
| :------------ |:---------------:| -----:|
|Full Network     | 1500 | 73563 |
| 2D      | 3000        |  99172 |
| Line | 400        |    666281 |
| Imperfect 2D Grid | 1500        |    86391 |



## Largest network dealt with

The largest network dealt with for each type of topology and algorithm are as follows: 

#### Gossip Protocol:
```bash
Full Network: 5000
Line: 5000
2D Grid: 5000
Imperfect 2D: 5000
```

#### Push Sum Algorithm:
```bash
Full Network: 5000
Line: 5000
2D Grid: 5000
Imperfect 2D: 5000
```
