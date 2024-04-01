module data_mem(
  input  logic        clk_i,
  input  logic        mem_req_i,
  input  logic        write_enable_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o
);
  // Объявление памяти
  logic [31:0] mem [4096];

  // Регистр для хранения выходных данных
  logic [31:0] read_data_reg;

  // Описание блока чтения данных из памяти
  always_ff @(posedge clk_i) begin
    if (mem_req_i == 1) begin
      read_data_reg <= mem[addr_i[13:2]];
    end
  end
  
  // Описание блока записи данных в память
  always_ff @(posedge clk_i) begin
    if (mem_req_i == 1 && write_enable_i == 1) begin
      mem[addr_i[13:2]] <= write_data_i;
    end
  end
  
  // Вывод данных из регистра на выход
  assign read_data_o = read_data_reg;

endmodule