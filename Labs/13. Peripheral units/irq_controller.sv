`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 16:07:49
// Design Name: 
// Module Name: irq_controller
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

module irq_controller(
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        exception_i,
  input  logic        irq_req_i,
  input  logic        mie_i,
  input  logic        mret_i,

  output logic        irq_ret_o,
  output logic [31:0] irq_cause_o,
  output logic        irq_o
);
  //  регистры отслеживания обработки прерывания и исключения
  logic exc_h;
  logic irq_h;
  
  logic for_exc_h;
  logic for_irq_h;
  
  logic set_exc_h;
  logic set_irq_h;
  
  assign set_exc_h = exception_i || exc_h;
  assign set_irq_h = irq_o || irq_h;
  
  assign irq_ret_o = (~(set_exc_h) && mret_i);
  
  assign for_exc_h = (~(mret_i) && set_exc_h);
  assign for_irq_h = (~(irq_ret_o) && set_irq_h);
  
  always_ff @(posedge clk_i) begin
      if(rst_i) begin
          exc_h <= 0;
      end else begin
          exc_h <= for_exc_h;
      end
  end
  
  always_ff @(posedge clk_i) begin
      if(rst_i) begin
          irq_h <= 0;
      end else begin
          irq_h <= for_irq_h;
      end
  end
  
  assign irq_o = (irq_req_i && mie_i) && (~(set_exc_h || irq_h));
  
  assign irq_cause_o = 32'h1000_0010;
  
endmodule