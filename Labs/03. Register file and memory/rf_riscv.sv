module rf_riscv(
  input  logic clk_i,
  input  logic write_enable_i,

  input  logic [ 4:0] write_addr_i,
  input  logic [ 4:0] read_addr1_i,
  input  logic [ 4:0] read_addr2_i,

  input  logic [31:0] write_data_i,
  output logic [31:0] read_data1_o,
  output logic [31:0] read_data2_o
);

    logic [31:0] rf_mem [32];
    initial rf_mem[0] = 32'b0;
    
    always_ff @(posedge clk_i) begin
        if(write_enable_i && write_addr_i != 0) begin
            rf_mem[write_addr_i] <= write_data_i;
        end
    end
    assign read_data1_o = rf_mem[read_addr1_i];
    assign read_data2_o = rf_mem[read_addr2_i];

endmodule