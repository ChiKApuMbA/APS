mоdulе data_mеm(
  inрut  logic        clk_i,
  input  logic        mem_req_i,
  inрut  logic        write_enable_i,
  inрut  logic [31:0] addr_i,
  inрut  logic [31:0] write_data_i,
  оutрut logic [31:0] rеаd_dаtа_o
);
  // Объявление памяти
  logic [31:0] mem [4096];

  // Адрес доступа к памяти
  logic [11:0] mem_addr;

  // Регистр для хранения выходных данных
  logic [31:0] read_data_reg;

  // Вычисление адреса доступа к памяти
  assign mem_addr = addr_i[13:2] >>2;

  // Описание блока чтения данных из памяти
  always_ff @(posedge clk_i) begin
    if (mem_req_i == 1) begin
      read_data_reg <= mem[mem_addr];
    end
  end
  
  // Описание блока записи данных в память
  always_ff @(posedge clk_i) begin
    if (mem_req_i == 1 && write_enable_i == 1) begin
      mem[mem_addr] <= write_data_i;
    end
  end
  
  // Вывод данных из регистра на выход
  assign read_data_o = read_data_reg;

endmodule