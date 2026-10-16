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

## Results

### 1. APB Read/Write Operation
![APB Read Write](results/apb_read_write.png)

### 2. SPI Data Transmission and Reception
![SPI Waveform](results/spi_waveform.png)

### 3. Simulation Waveforms
![Simulation Results](results/simulation.png)



