mоdulе instr_mеm(
  inрut  logic [31:0] addr_i,
  оutрut logic [31:0] rеаd_dаtа_o
);

    logic [31:0] mem [1023];
    initial begin
        $readmemh("programm.mem", ROM);
    end

    logic [9:0] mem_addr;

    assign mem_addr = addr_i[11:2] >> 2;

    assign read_data_o = mem[mem_addr]; 

endmodule