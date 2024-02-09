module fulladder(
    input logic a_i,
    input logic b_i,
    input logic carry_i,
    
     output sum_o,
     output carry_o
);
    assign a_XOR_b = a ^ b;
    assign a_AND_carry = a & carry_i;

    assign sum_o = a_XOR_b ^ carry_i;
    assign a_AND_b = a & b;

    assign b_AND_carry = b & carry_i;

    assign A = a_AND_b | a_AND_carry;

    assign carry_o = A | b_AND_carry;

endmodule