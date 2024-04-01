module instr_mem(
  input  logic [31:0] addr_i,
  output logic [31:0] read_data_o
);

    logic [31:0] ROM [1024];
    initial begin
        $readmemh("program.mem", ROM);
    end

    assign read_data_o = ROM[addr_i[11:2]]; 

endmodule