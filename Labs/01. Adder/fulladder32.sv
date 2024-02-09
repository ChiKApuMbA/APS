module fulladder32(
    input logic [31:0] a_i,
    input logic [31:0] b_i,
    
    input logic carry_i,

    output logic [31:0] sum_o,
    output logic carry_o
);

logic intermediate_signal_0;
logic intermediate_signal_1;
logic intermediate_signal_2;

fulladder8 fulladder0(
    .a_i(a_i[7:0]),

    .b_i(b_i[7:0]),

    .carry_i(carry_i),

    .carry_o(intermediate_signal_0),

    .sum_o(sum_o[7:0])
);

fulladder8 fulladder1(
    .a_i(a_i[15:8]),

    .b_i(b_i[15:8]),

    .carry_i(intermediate_signal_0),

    .carry_o(intermediate_signal_1),

    .sum_o(sum_o[15:8])
);

fulladder8 fulladder2(
    .a_i(a_i[23:16]),

    .b_i(b_i[23:16]),

    .carry_i(intermediate_signal_1),

    .carry_o(intermediate_signal_2),

    .sum_o(sum_o[23:16])
);

fulladder8 fulladder3(
    .a_i(a_i[31:24]),

    .b_i(b_i[31:24]),

    .carry_i(intermediate_signal_2),

    .carry_o(carry_o),

    .sum_o(sum_o[31:24])
);

endmodule