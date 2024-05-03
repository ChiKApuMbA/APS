`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 09:48:38
// Design Name: 
// Module Name: csr_controller
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


module csr_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        trap_i,

    input  logic [ 2:0] opcode_i,

    input  logic [11:0] addr_i,
    input  logic [31:0] pc_i,
    input  logic [31:0] mcause_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] imm_data_i,
    input  logic        write_enable_i,

    output logic [31:0] read_data_o,
    output logic [31:0] mie_o,
    output logic [31:0] mepc_o,
    output logic [31:0] mtvec_o
);

import csr_pkg::*;

logic [31:0]    opcode_sel;
logic [4:0]     enable;
logic [31:0]    trap_sel_1;
logic [31:0]    trap_sel_2;
logic [31:0]    mscratch;
logic [31:0]    mcause;

always_comb begin
    
    case (opcode_i)
        CSR_RW:     opcode_sel <= rs1_data_i;
        CSR_RS:     opcode_sel <= rs1_data_i | read_data_o;
        CSR_RC:     opcode_sel <= ~rs1_data_i & read_data_o;
        CSR_RWI:    opcode_sel <= imm_data_i;
        CSR_RSI:    opcode_sel <= imm_data_i | read_data_o;
        CSR_RCI:    opcode_sel <= ~imm_data_i & read_data_o;
    endcase

    case (addr_i)
        MIE_ADDR:       enable <= trap_i ? {4'b1100, write_enable_i} : {4'b0, write_enable_i};              
        MTVEC_ADDR:     enable <= trap_i ? {3'b110, write_enable_i, 1'b0} : {3'b0, write_enable_i, 1'b0};   
        MSCRATCH_ADDR:  enable <= trap_i ? {2'b11, write_enable_i, 2'b0} : {2'b0, write_enable_i, 2'b0};
        MEPC_ADDR:      enable <= trap_i ? 5'b11000 : {1'b0, write_enable_i, 3'b0};
        MCAUSE_ADDR:    enable <= trap_i ? 5'b11000 : {write_enable_i, 4'b0};
        default: begin
            enable <= trap_i ? {5'b11, enable[2:0]} : 5'b0;
        end
    endcase

    case (trap_i)
        1'b0: begin
            trap_sel_1 <= opcode_sel;
            trap_sel_2 <= opcode_sel;
        end

        1'b1: begin
            trap_sel_1 <= pc_i;
            trap_sel_2 <= mcause_i;
        end
    endcase

    case (addr_i)
        MIE_ADDR:       read_data_o <= mie_o;
        MTVEC_ADDR:     read_data_o <= mtvec_o;
        MSCRATCH_ADDR:  read_data_o <= mscratch;
        MEPC_ADDR:      read_data_o <= mepc_o;
        MCAUSE_ADDR:    read_data_o <= mcause;
    endcase

end

always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) begin
        mie_o       <= 32'b0;
        mtvec_o     <= 32'b0;
        mscratch    <= 32'b0;
        mepc_o      <= 32'b0;
        mcause      <= 32'b0;
    end
    
    
    else begin
        if (enable[0])  mie_o       <= opcode_sel;
        if (enable[1])  mtvec_o     <= opcode_sel;
        if (enable[2])  mscratch    <= opcode_sel;
        if (enable[3])  mepc_o      <= trap_sel_1;
        if (enable[4])  mcause      <= trap_sel_2;
    end

end

endmodule
