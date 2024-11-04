`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 06:13:27 PM
// Design Name: 
// Module Name: forwardingunit_tb
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

module forwardingunit_tb;

    reg [4:0] IDEX_Rs, IDEX_Rt;
    reg EXMEM_RegWrite, MEMWB_RegWrite;
    reg [4:0] EXMEM_RegisterRd, MEMWB_RegisterRd;
    wire [1:0] forwardA, forwardB;
    reg [1:0] expected_forwardA, expected_forwardB;
    integer errors;

    forwardingunit DUT (
        .IDEX_Rs(IDEX_Rs),
        .IDEX_Rt(IDEX_Rt),
        .EXMEM_RegWrite(EXMEM_RegWrite),
        .EXMEM_RegisterRd(EXMEM_RegisterRd),
        .MEMWB_RegWrite(MEMWB_RegWrite),
        .MEMWB_RegisterRd(MEMWB_RegisterRd),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    //task to check if output matches expected
    task check_output;
        input [1:0] expected_A, expected_B;
        begin
            expected_forwardA = expected_A;
            expected_forwardB = expected_B;
            #1; // wait for output to stabilize
            if (forwardA !== expected_forwardA || forwardB !== expected_forwardB) begin
                $display("Test Failed: IDEX_Rs=%b IDEX_Rt=%b EXMEM_RegWrite=%b EXMEM_RegisterRd=%b MEMWB_RegWrite=%b MEMWB_RegisterRd=%b -> forwardA=%b (Expected: %b), forwardB=%b (Expected: %b)",
                         IDEX_Rs, IDEX_Rt, EXMEM_RegWrite, EXMEM_RegisterRd, MEMWB_RegWrite, MEMWB_RegisterRd,
                         forwardA, expected_forwardA, forwardB, expected_forwardB);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        
        //no forwarding case
        IDEX_Rs = 5'b00001; IDEX_Rt = 5'b00010;
        EXMEM_RegWrite = 0; EXMEM_RegisterRd = 5'b00011;
        MEMWB_RegWrite = 0; MEMWB_RegisterRd = 5'b00100;
        check_output(2'b00, 2'b00);

        //1 ahead forwarding to Rs only
        EXMEM_RegWrite = 1; EXMEM_RegisterRd = IDEX_Rs;
        MEMWB_RegWrite = 0; MEMWB_RegisterRd = 5'b00100;
        check_output(2'b10, 2'b00);

        //1 ahead forwarding to Rt only
        EXMEM_RegWrite = 1; EXMEM_RegisterRd = IDEX_Rt;
        check_output(2'b00, 2'b10);

        //1 ahead forwarding to both Rs and Rt
        EXMEM_RegWrite = 1; EXMEM_RegisterRd = 5'b11111;
        IDEX_Rs = 5'b11111; IDEX_Rt = 5'b11111;
        check_output(2'b10, 2'b10);

        //2 ahead forwarding to Rs only
        EXMEM_RegWrite = 0; MEMWB_RegWrite = 1;
        EXMEM_RegisterRd = 5'b00000; MEMWB_RegisterRd = IDEX_Rs;
        check_output(2'b01, 2'b01); 

        //2 ahead forwarding to Rt only
        MEMWB_RegisterRd = IDEX_Rt;
        check_output(2'b01, 2'b01);

        //2 ahead forwarding to both Rs and Rt
        MEMWB_RegisterRd = 5'b11111;
        IDEX_Rs = 5'b11111; IDEX_Rt = 5'b11111;
        check_output(2'b01, 2'b01);

        //EX/MEM and MEM/WB write to the same register, EX/MEM should take priority
        EXMEM_RegWrite = 1; MEMWB_RegWrite = 1;
        EXMEM_RegisterRd = IDEX_Rs; MEMWB_RegisterRd = IDEX_Rs;
        check_output(2'b10, 2'b10); // Only forward to Rs from EX/MEM

        if (errors == 0) begin
            $display("\nAll test cases passed!");
            $display("****************************");
            $display("*                          *");
            $display("*       SUCCESS!           *");
            $display("* All cases passed.        *");
            $display("*                          *");
            $display("****************************");
        end else begin
            $display("\n%d test cases failed", errors);
            $display("****************************");
            $display("*                          *");
            $display("*        FAILURE           *");
            $display("* Check failed cases.      *");
            $display("*                          *");
            $display("****************************");
        end
        $finish;
    end
endmodule