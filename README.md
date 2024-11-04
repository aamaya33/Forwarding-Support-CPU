# EC413 Lab – Pipelined CPUs

## Overview
The purpose of this lab is to learn in-depth how a pipelined CPU functions. You will start with a standard five-stage MIPS CPU with no forwarding support and add, debug, and test several new features to enhance its functionality.

## Lab Tasks
1. **Synthesize the Project**  
   Synthesize the project and generate outputs for the provided instruction sequence. (Pre-lab task)

2. **1-Ahead Forwarding**  
   Implement "1-ahead" forwarding logic to handle data hazards.

3. **2-Ahead Forwarding**  
   Implement "2-ahead" forwarding logic to further optimize data hazard handling.

4. **Arbitration Logic**  
   Develop logic to decide between "1-ahead" and "2-ahead" forwarding.

5. **$0 Register Write**  
   Add logic to handle writing to register $0.

6. **No Write Logic**  
   Implement logic to handle cases where no write should occur.

7. **Register Bypass Check**  
   Verify that the register bypass logic functions correctly.