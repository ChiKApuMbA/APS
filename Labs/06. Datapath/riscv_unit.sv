module riscv_unit(
  input  logic        clk_i,
  input  logic        rst_i
);
    logic [31:0] instr_addr;
    logic [31:0] instr;
    logic [31:0] core_rd;
    logic [31:0] RD;

    logic        mem_req;
    logic        mem_we;
    logic [2:0]  mem_size;
    logic [31:0] mem_wd;
    logic [31:0] mem_addr;

    logic        req;
    logic        WE;
    logic [3:0]  BE;
    logic [31:0] WD;
    logic [31:0] A;

    logic        READY;
    logic        stall;

    instr_mem Instruction_Memory (
        .addr_i(instr_addr),
        .read_data_o(instr)
    );
    
    data_mem Data_Memory (
        .clk_i(clk_i),
        .mem_req_i(req),
        .write_enable_i(WE),
        .addr_i(A),
        .write_data_i(WD),
        .read_data_o(READY)
    );
    riscv_core Core(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .instr_addr_o(instr_addr),
        .instr_i(instr),
        .mem_rd_i(core_rd),
        .mem_req_o(mem_req),
        .mem_we_o(mem_we),
        .mem_size_o(mem_size),
        .mem_wd_o(mem_wd),
        .mem_addr_o(mem_addr),
        .stall_i(stall)
    );
endmodule