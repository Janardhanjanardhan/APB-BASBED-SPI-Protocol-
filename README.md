# APB BASBED SPI Protocol 

**Project Description:**

Designed and implemented an APB-interfaced SPI Slave using Verilog HDL to enable communication between a high-frequency processor interface and low-speed SPI peripherals. APB is used for register read/write operations and control, while SPI is used for serial data transmission and reception between the SPI master and slave.

The project includes **APB Slave Interface, SPI Clock/Baud Rate Generator, SPI Shift Register, and Slave Select Control** modules. It supports configurable clock polarity (CPOL) and clock phase (CPHA), serial data shifting, and SPI communication control.

The design was verified through simulation using Verilog testbenches and waveform analysis.

**Key Technologies:** Verilog HDL, RTL Design, AMBA APB Protocol, SPI Protocol, FSM Design, ModelSim.

**Key Modules:**
- APB Slave Interface
- SPI Clock/Baud Rate Generator
- SPI Shift Register
- Slave Select Control

 **How to Use This Project:**
- Download or clone the repository.
- Add all Verilog module files to your simulation project.
- Set the top-level module and compile the design.
- Run the testbench in ModelSim to verify APB register read/write operations and SPI serial data transmission and reception.
- Check the simulation waveforms to observe the APB and SPI signals.

**Key Learning Outcomes:**
- RTL design and modular hardware development.
- Understanding APB register access and SPI serial communication.
- Clock generation, data shifting, and control logic implementation.
- Functional verification using simulation waveforms.

---


---

## Simulation Results
### 1. APB Interface

![APB Interface Simulation 1](https://github.com/Janardhanjaanu/APB-BASBED-SPI-Protocol-/blob/e9dc956582b7815efe69e2414d8dab64100b7d3b/Results/APB%20Interface.png?raw=true)

![APB Interface Simulation 2](https://github.com/Janardhanjaanu/APB-BASBED-SPI-Protocol-/blob/6c6b741bf8f35a64f4673136c6a94c57f1713a28/Results/Screenshot%20(267).png?raw=true)

### 2. Baud Rate Generator
![Baud Rate Generator](https://github.com/Janardhanjaanu/APB-BASBED-SPI-Protocol-/blob/e9dc956582b7815efe69e2414d8dab64100b7d3b/Results/Screenshot%20(260).png?raw=true)

### 3. SPI Shift Register
![SPI Shift Register](https://github.com/Janardhanjaanu/APB-BASBED-SPI-Protocol-/blob/e9dc956582b7815efe69e2414d8dab64100b7d3b/Results/Screenshot%20(261).png?raw=true)

### 4. SPI Slave Select Control
![SPI Slave Select Control](https://github.com/Janardhanjaanu/APB-BASBED-SPI-Protocol-/blob/e9dc956582b7815efe69e2414d8dab64100b7d3b/Results/Screenshot%20(259).png?raw=true)







