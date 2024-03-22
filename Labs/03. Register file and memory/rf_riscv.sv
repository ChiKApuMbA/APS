mоdulе rf_r𝚒sсv(
  inрut  logic        сlk_i,
  inрut  logic        write_enable_i,

  inрut  logic [ 4:0] write_addr_i,
  inрut  logic [ 4:0] read_addr1_i,
  inрut  logic [ 4:0] read_addr2_i,

  inрut  logic [31:0] write_data_i,
  оutрut logic [31:0] read_data1_o,
  оutрut logic [31:0] read_data2_o
);

    logic [31:0] rf_mem [32];

    logic [31:0] read_data1_reg;
    logic [31:0] read_data2_reg;

    initial begin
        rf_mem[0] = 0
    end
    
    always_ff @(posedge clk_i) begin
        if(write_enable_i && write_addr_i != 0) begin
            rf_mem[write_addr_i] <= write_data_i;
        end
    end
    
    assign read_data1_o = rf_mem[read_addr1_i];
    assign read_data2_o = rf_mem[read_addr2_i];

endmodule