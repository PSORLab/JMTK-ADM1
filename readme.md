# JMTK ADM1: Julia ModelingToolkit Implementation of Anaerobic Digestion Model No. 1 (ADM1)
This work implements the anaerobic digestion model described in Rosen and Jeppson [1] using the ModelingToolkit framework [3] in the Julia programming language.

<p align="center">
  <img src="https://user-images.githubusercontent.com/63276909/180452652-148654ae-aff8-44e4-b215-0c64687c3c2b.png" />
</p>

## Features and Capabilities
This model simulates anaerobic digestion by solving the DAE described in Rosen and Jeppson [1]. This model is implemented in the acausal, symbolic modeling framework, ModelingToolkit.jl, to create a foundation for a versatile, efficient, and flexible model for future work. The model simulates various states of interest in anaerobic digestion such as pH, methane gas production, volatile fatty acids (VFAs), etc. This work implements two versions of the model: one model to simulate a constant influent and one model to simulate a dynamic influent stream. The static influent model simulates the DAE in mass matrix form using a medium tolerance ($10^{-6}$). The dynamic influent model uses a zeroth-order interpolation of digester influent data from the PyADM1 implementation and simulates the DAE in mass matrix form using a high tolerance ($10^{-10}$).

## Required Libraries
#### Main
- [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl) v8.15.1
- [DifferentialEquations.jl](https://github.com/SciML/DifferentialEquations.jl) v7.1.0
- [Symbolics.jl](https://symbolics.juliasymbolics.org/dev/) v4.8.3
#### Supporting
- DelimitedFiles.jl
- IfElse.jl
- LinearAlgebra.jl

## Works In Progress
- ### High Fidelity / Advanced Modeling <img align="right" src="https://user-images.githubusercontent.com/63276909/180566202-1413bc1c-a80c-4510-8eb9-62670a5e09ac.png">
    - Establish spatial heterogeneity using compartment modeling with Modelingtoolkit modules
    - Map common wastewater parameters to ADM1 state variables and or parameters
    - Establish temperature dependency / energy balance within model
    - Develop low complexity surrogate for model to accelerate model predictive control

- ### Develop and Simulate Anaerobic Digester Controls
    - Develop control strategy to prevent digester upsets
    - Implement model predictive control using Julia optimization framework to implement control strategies

## Contact
Samuel Degnan-Morgenstern, Research Specialist, samuel.morgenstern@uconn.edu / stm16109@mit.edu

Dr. Matthew Stuber, Principal Investigator, matthew.stuber@uconn.edu

## References
1. Rosén, C., & Jeppsson, U. (2006). **Aspects on ADM1 Implementation within the BSM2 Framework.** Department of Industrial Electrical Engineering and Automation, Lund University, Lund, Sweden, 1-35.
2. Sadrimajd, P., Mannion, P., Howley, E., & Lens, P. N. L. (2021). **PyADM1: a Python implementation of Anaerobic Digestion Model No. 1.** bioRxiv.
3. Ma, Y., Gowda, S., Anantharaman, R., Laughman, C., Shah, V., & Rackauckas, C. (2021). **Modelingtoolkit: A composable graph transformation system for equation-based modeling.** arXiv preprint arXiv:2103.05244.
