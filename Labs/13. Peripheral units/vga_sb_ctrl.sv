module vga_sb_ctrl (
  input  logic        clk_i,
  input  logic        rst_i,
  input  logic        clk100m_i,
  input  logic        req_i,
  input  logic        write_enable_i,
  input  logic [3:0]  mem_be_i,
  input  logic [31:0] addr_i,
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data_o,
  
  output logic [3:0]  vga_r_o,
  output logic [3:0]  vga_g_o,
  output logic [3:0]  vga_b_o,
  output logic        vga_hs_o,
  output logic        vga_vs_o
);

  // Экземпляр vgachargen
  vgachargen vgachar_inst (
    .clk_i(clk_i),
    .clk100m_i(clk100m_i),
    .rst_i(rst_i),
    .char_map_addr_i(addr_i[11:2]),
    .char_map_be_i(mem_be_i),
    .char_map_wdata_i(write_data_i),
    .char_map_rdata_o(read_data_o),
    .col_map_addr_i(addr_i[11:2]),
    .col_map_be_i(mem_be_i),
    .col_map_wdata_i(write_data_i),
    .col_map_rdata_o(read_data_o),
    .char_tiff_addr_i(addr_i[11:2]),
    .char_tiff_be_i(mem_be_i),
    .char_tiff_wdata_i(write_data_i),
    .char_tiff_rdata_o(read_data_o),
    .vga_r_o(vga_r_o),
    .vga_g_o(vga_g_o),
    .vga_b_o(vga_b_o),
    .vga_hs_o(vga_hs_o),
    .vga_vs_o(vga_vs_o)
  );

  // Мультиплексирование сигналов write_enable_i
  always_comb begin
    case(addr_i[13:12])
      2'b00: vgachar_inst.char_map_we_i = write_enable_i;
      2'b01: vgachar_inst.col_map_we_i = write_enable_i;
      2'b10: vgachar_inst.char_tiff_we_i = write_enable_i;
      default: begin
        vgachar_inst.char_map_we_i = 1'b0;
        vgachar_inst.col_map_we_i = 1'b0;
        vgachar_inst.char_tiff_we_i = 1'b0;
      end
    endcase
  end

  // Демультиплексирование сигнала read_data_o
  always_comb begin
    case(addr_i[13:12])
      2'b00: read_data_o = vgachar_inst.char_map_rdata_o;
      2'b01: read_data_o = vgachar_inst.col_map_rdata_o;
      2'b10: read_data_o = vgachar_inst.char_tiff_rdata_o;
      default: read_data_o = 32'h0; // Значение по умолчанию
    endcase
  end

endmodule
