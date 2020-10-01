# Multi-Stage Flash (MSF) Desalination Plant

## Overview

Desalination is the process of converting high salinity sea water into potable water. This full-order model has been tested and validated against real plant data obtained from the Khubar II MSF plant in Saudi Arabia \[1\]. The model is a 22 stage MSF desalination plant, which consists of 3 Heat Rejection Sections and 19 Heat Recovery Sections ported from \[2\] \[3\]. It also consists of 4 flow rate, 3 level, 3 temperature, 1 pressure sensors, 2 gas valves, 9 liquid valves, and 3 PI controllers. The base simulation is modified to include support for Hardware-in-the-loop (HIL).

## Requirements

Simulink-RealTime<br />
Windows OS

## Instructions

1. Change the HIL bit to **0** for using Simulink and **1** to enable HIL. Set to **0** by default.

## Cite us

If you like the work, please cite our ASIACCS' 19 paper:

Prashant Hari Narayan Rajput, Pankaj Rajput, Marios Sazos, and Michail Maniatakos. 2019. Process-Aware Cyberattacks for Thermal Desalination Plants. In _Proceedings of the 2019 ACM Asia Conference on Computer and Communications Security_ (_Asia CCS '19_).

## References

[1] Ali, Emad, Khalid Alhumaizi, and Abdelhamid Ajbar. "Model reduction and robust control of multi-stage flash (MSF) desalination plants." _Desalination_ 121.1 (1999): 65-85.<br />
[2] Ali, Emad. "Understanding the operation of industrial MSF plants Part I: Stability and steady-state analysis." _Desalination_ 143.1 (2002): 53-72.<br />
[3] Ali, Emad. "Understanding the operation of industrial MSF plants Part II: Optimization and dynamic analysis." _Desalination_ 143.1 (2002): 73-91.
