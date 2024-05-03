`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2023 10:46:39
// Design Name: 
// Module Name: riscv_lsu
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

module riscv_lsu(
  input logic clk_i,
  input logic rst_i,

  // Core_interface
  input  logic        core_req_i,
  input  logic        core_we_i,
  input  logic [ 2:0] core_size_i,
  input  logic [31:0] core_addr_i,
  input  logic [31:0] core_wd_i,
  output logic [31:0] core_rd_o,
  output logic        core_stall_o,

  // Memory_interface
  output logic        mem_req_o,
  output logic        mem_we_o,
  output logic [ 3:0] mem_be_o,
  output logic [31:0] mem_addr_o,
  output logic [31:0] mem_wd_o,
  input  logic [31:0] mem_rd_i,
  input  logic        mem_ready_i
);

  localparam LDST_B	    = 3'd0;
  localparam LDST_H	    = 3'd1;
  localparam LDST_W	    = 3'd2;
  localparam LDST_BU	= 3'd4;
  localparam LDST_HU	= 3'd5;


  logic [1:0] byte_offset;
  logic half_offset;
  logic stall_reg;

  logic [31:0] mem_rd_i_0_SE;
  logic [31:0] mem_rd_i_1_SE;
  logic [31:0] mem_rd_i_2_SE;
  logic [31:0] mem_rd_i_3_SE;

  logic [31:0] mem_rd_i_0_ZE;
  logic [31:0] mem_rd_i_1_ZE;
  logic [31:0] mem_rd_i_2_ZE;
  logic [31:0] mem_rd_i_3_ZE;

  logic [31:0] mem_rd_i_01_SE;
  logic [31:0] mem_rd_i_23_SE;

  logic [31:0] mem_rd_i_01_ZE;
  logic [31:0] mem_rd_i_23_ZE;



  assign byte_offset = core_addr_i[1:0];
  assign half_offset = core_addr_i[1];

  assign mem_rd_i_0_SE = {{24{mem_rd_i[7]}} ,mem_rd_i[7:0]};
  assign mem_rd_i_1_SE = {{24{mem_rd_i[15]}} ,mem_rd_i[15:8]};
  assign mem_rd_i_2_SE = {{24{mem_rd_i[23]}} ,mem_rd_i[23:16]};
  assign mem_rd_i_3_SE = {{24{mem_rd_i[31]}} ,mem_rd_i[31:24]};

  assign mem_rd_i_0_ZE = {{24{1'b0}}, mem_rd_i[7:0]};
  assign mem_rd_i_1_ZE = {{24{1'b0}}, mem_rd_i[15:8]};
  assign mem_rd_i_2_ZE = {{24{1'b0}}, mem_rd_i[23:16]};
  assign mem_rd_i_3_ZE = {{24{1'b0}}, mem_rd_i[31:24]};

  assign mem_rd_i_01_SE = {{16{mem_rd_i[15]}}, mem_rd_i[15:0]};
  assign mem_rd_i_23_SE = {{16{mem_rd_i[31]}}, mem_rd_i[31:16]};

  assign mem_rd_i_01_ZE = {{16{1'b0}}, mem_rd_i[15:0]};
  assign mem_rd_i_23_ZE = {{16{1'b0}}, mem_rd_i[31:16]};



  always_comb begin
  
    case (core_size_i)
      LDST_W: mem_be_o <= 4'b1111;
      LDST_H: mem_be_o <= (half_offset ? 4'b1100 : 4'b0011);
      LDST_B: mem_be_o <= (4'b0001 << byte_offset);
    endcase


    mem_addr_o <= core_addr_i;


    case (core_size_i)
      LDST_W: core_rd_o <= mem_rd_i;

      LDST_B:
        case (byte_offset)
          2'b00: core_rd_o <= mem_rd_i_0_SE;
          2'b01: core_rd_o <= mem_rd_i_1_SE;
          2'b10: core_rd_o <= mem_rd_i_2_SE;
          2'b11: core_rd_o <= mem_rd_i_3_SE;
        endcase

      LDST_BU:
        case (byte_offset)
          2'b00: core_rd_o <= mem_rd_i_0_ZE;
          2'b01: core_rd_o <= mem_rd_i_1_ZE;
          2'b10: core_rd_o <= mem_rd_i_2_ZE;
          2'b11: core_rd_o <= mem_rd_i_3_ZE;
        endcase

      LDST_H: 
        case (half_offset)
          1'b0: core_rd_o <= mem_rd_i_01_SE;
          1'b1: core_rd_o <= mem_rd_i_23_SE;
        endcase

      LDST_HU: 
        case (half_offset)
          1'b0: core_rd_o <= mem_rd_i_01_ZE;
          1'b1: core_rd_o <= mem_rd_i_23_ZE;
        endcase
    endcase


    case (core_size_i)
      LDST_H: mem_wd_o <= {{2{core_wd_i[15:0]}}};
      LDST_W: mem_wd_o <= core_wd_i;
      LDST_B: mem_wd_o <= {{4{core_wd_i[7:0]}}};
    endcase


    mem_we_o <= core_we_i;
    mem_req_o <= core_req_i;

  end

  always_ff @( clk_i ) begin

    if (~rst_i) begin
      stall_reg <= core_stall_o;
      core_stall_o <= (core_req_i & ~stall_reg) | (core_req_i & stall_reg & ~mem_ready_i);
    end

    else
      core_stall_o <= 1'b0;

  end

endmodule
