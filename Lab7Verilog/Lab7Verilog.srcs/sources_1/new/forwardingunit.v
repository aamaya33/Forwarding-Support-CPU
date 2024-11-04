`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 05:43:50 PM
// Design Name: 
// Module Name: forwardingunit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module forwardingunit( 
    input [4:0] IDEX_Rs, IDEX_Rt,           
    input EXMEM_RegWrite,                   
    input [4:0] EXMEM_RegisterRd,           
    input MEMWB_RegWrite,                   
    input [4:0] MEMWB_RegisterRd,
    output reg [1:0] forwardA, forwardB   
    );
    
     always @(*) begin
        //base case (no forwarding) 
        forwardA = 2'b00;
        forwardB = 2'b00;

        //add 1 ahead forwarding 
        if (EXMEM_RegWrite && (EXMEM_RegisterRd != 0)) begin //make sure we're not forwarding to $0 since its our ~special~ register
            if (EXMEM_RegisterRd == IDEX_Rs)
                forwardA = 2'b10; //logic ripped straight from the slides and we don't include both since 10 tells us that the data is one cycle ahead of idex which prevents stalls 
            if (EXMEM_RegisterRd == IDEX_Rt)
                forwardB = 2'b10; 
//            if ((EXMEM_RegisterRd != IDEX_Rs) && (MEMWB_RegisterRd == IDEX_Rs))
//                forwardA = 2'b01;
//            if ((EXMEM_RegisterRd != IDEX_Rt) && (MEMWB_RegisterRd == IDEX_Rt))
//                forwardB = 2'b01;
        end

        //add 2 ahead forwarding 
        if (MEMWB_RegWrite && (MEMWB_RegisterRd != 0)) begin
//            if ((EXMEM_RegisterRd == IDEX_Rs) && (forwardA == 2'b00))
//                forwardA = 2'b10; //logic ripped straight from the slides 
//            if ((EXMEM_RegisterRd == IDEX_Rt) && (forwardB == 2'b00))
//                forwardB = 2'b10; 
            if ((EXMEM_RegisterRd != IDEX_Rs) && (MEMWB_RegisterRd == IDEX_Rs))
                forwardA = 2'b01;
            if ((EXMEM_RegisterRd != IDEX_Rt) && (MEMWB_RegisterRd == IDEX_Rt))
                forwardB = 2'b01;
        end
    end
endmodule

