module fulladder8(
    input logic [7:0] a_i,
    input logic [7:0] b_i,
    input logic carry_i,

    output logic [7:0] sum_o,
    output logic carry_o  
);

logic intermediate_signal_0;

fulladder4 fulladder0(
   .a_i(a_i[3:0]),

   .b_i(b_i[3:0]),

   .carry_i(carry_i),
   
   .carry_o(intermediate_signal_0),

   .sum_o(sum_o[3:0])
);

fulladder4 fulladder1(
   .a_i(a_i[7:4]),

   .b_i(b_i[7:4]),

   .carry_i(intermediate_signal_0),
   
   .carry_o(carry_o),

   .sum_o(sum_o[7:4])
);

endmodule