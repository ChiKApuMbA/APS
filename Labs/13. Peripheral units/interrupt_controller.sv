`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 09:47:52
// Design Name: 
// Module Name: interrupt_controller
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


module interrupt_controller(
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

logic exc_h;
logic irq_h;

logic exc_h_OR_exc_i___N1;
logic irq_req_i_AND_mie_i___N2;
logic nmret_i_AND_N1___N3;
logic mret_i_AND_N1___N4;
logic irq_h_OR_N8___N5;
logic nN4_AND_N5___N6;
logic not_irq_h_OR_N1___N7;
logic N7_AND_N2___N8;

assign irq_o        = N7_AND_N2___N8;
assign irq_ret_o    = mret_i_AND_N1___N4;
assign irq_cause_o  = 32'h1000_0010;

always_comb begin

    exc_h_OR_exc_i___N1         <= exc_h | exception_i;
    irq_req_i_AND_mie_i___N2    <= irq_req_i & mie_i;
    nmret_i_AND_N1___N3         <= ~mret_i & exc_h_OR_exc_i___N1;
    mret_i_AND_N1___N4          <= mret_i & ~exc_h_OR_exc_i___N1;
    irq_h_OR_N8___N5            <= irq_h | N7_AND_N2___N8;
    nN4_AND_N5___N6             <= ~mret_i_AND_N1___N4 & irq_h_OR_N8___N5;
    not_irq_h_OR_N1___N7        <= ~(irq_h | exc_h_OR_exc_i___N1);
    N7_AND_N2___N8              <= not_irq_h_OR_N1___N7 & irq_req_i_AND_mie_i___N2;

end

always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) exc_h <= 0;
    else exc_h <= nmret_i_AND_N1___N3;
        //if (mret_i & ~exc_h) exc_h <= 0;
        //else if (~mret_i & exc_h) exc_h <= 1;


end

always_ff @(posedge clk_i or posedge rst_i) begin
    
    if (rst_i) irq_h <= 0;
    else irq_h <= nN4_AND_N5___N6;
        //if (mret_i_AND_N1___N4 & ~N7_AND_N2___N8) irq_h <= 0;
        //else if (~mret_i_AND_N1___N4 & N7_AND_N2___N8) irq_h <= 0;
    
end

endmodule
