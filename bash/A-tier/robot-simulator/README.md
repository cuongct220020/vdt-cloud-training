# Robot Simulator

## Introduction

A robot factory's test facility needs a program to verify robot movements.
Robots are placed on a hypothetical infinite grid, facing a particular direction (north, east, south, or west) at a set of {x,y} coordinates, with coordinates increasing to the north and east.
The robot then receives a stream of instructions, at which point the testing facility verifies the robot's new position and the direction it is now facing.

## Instructions

Write a robot simulator.

The robots have three possible movements:

- turn right
- turn left
- advance

- The letter-string "RAALAL" means:
  - Turn right
  - Advance twice
  - Turn left
  - Advance once
  - Turn left yet again
- Say a robot starts at {7, 3} facing north.
  Then running this stream of instructions should leave it at {9, 4} facing west.

## My Solution Idea

