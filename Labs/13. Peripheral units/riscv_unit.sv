module riscv_unit(
  input  logic        clk_i,
  input  logic        resetn_i,

  // Входы и выходы периферии
  input  logic [15:0] sw_i,       // Переключатели

  output logic [15:0] led_o,      // Светодиоды

  input  logic        kclk_i,     // Тактирующий сигнал клавиатуры
  input  logic        kdata_i,    // Сигнал данных клавиатуры

  output logic [ 6:0] hex_led_o,  // Вывод семисегментных индикаторов
  output logic [ 7:0] hex_sel_o,  // Селектор семисегментных индикаторов

  input  logic        rx_i,       // Линия приема по UART
  output logic        tx_o,       // Линия передачи по UART

  output logic [3:0]  vga_r_o,    // красный канал vga
  output logic [3:0]  vga_g_o,    // зеленый канал vga
  output logic [3:0]  vga_b_o,    // синий канал vga
  output logic        vga_hs_o,   // линия горизонтальной синхронизации vga
  output logic        vga_vs_o    // линия вертикальной синхронизации vga
);

logic sysclk, rst;
sys_clk_rst_gen divider(.ex_clk_i(clk_i),.ex_areset_n_i(resetn_i),.div_i(10),.sys_clk_o(sysclk), .sys_reset_o(rst));

logic [31:0] instr_addr;
logic [31:0] instr;
logic [31:0] mem_wd;
logic [31:0] mem_addr;
logic [31:0] mem_rd;

logic [31:0] mem_wd_lsu;
logic [31:0] mem_addr_lsu;

logic [31:0] mem_rd_core;
logic [31:0] mem_rd_lsu;

logic [31:0] mem_rd_core;
logic [31:0] mem_rd_lsu;
logic [31:0] mem_rd_ps2;
logic [31:0] mem_rd_vga;

logic [2:0] mem_size;

logic stall;
logic mem_we;

logic mem_req_lsu;
logic mem_we_lsu;

logic irq_req;

logic irq_ret;

logic [3:0] mem_be;
logic mem_ready;

logic [255:0] per_sel;
logic req;
logic ps2_sb_ctrl_req;
logic vga_req; 

assign mem_ready = 1'b1;
assign per_sel = 255'b1 << mem_addr[31:24];
assign mem_req = per_sel[0] & req;
assign ps2_sb_ctrl_req = per_sel[3] & req;
assign vga_req = per_sel[7] & req;

always_comb begin
    if (ps2_sb_ctrl_req) mem_rd_core <= mem_rd_ps2;
    else if (vga_req) mem_rd_core <= mem_rd_vga;
    else mem_rd_core <= mem_rd_lsu;
end



instr_mem instruction_memory
(
  .addr_i           (instr_addr),     
  .read_data_o      (instr) 
);


riscv_core core (
    .clk_i          (sysclk),
    .rst_i          (rst),

    .stall_i        (stall),
    .instr_i        (instr),
    .mem_rd_i       (mem_rd_core),
    .irq_req_i      (irq_req),

    .instr_addr_o   (instr_addr),
    .mem_addr_o     (mem_addr),
    
    .mem_req_o      (req),
    .mem_we_o       (mem_we),
    .mem_wd_o       (mem_wd),
    
    .irq_ret_o      (irq_ret),
    .mem_size_o     (mem_size)
);


riscv_lsu lsu(
  .clk_i            (sysclk),
  .rst_i            (rst),

  // Core_interface
  .core_req_i       (mem_req),
  .core_we_i        (mem_we),
  .core_size_i      (mem_size),
  .core_addr_i      (mem_addr),
  .core_wd_i        (mem_wd),
  .core_rd_o        (mem_rd_lsu),
  .core_stall_o     (stall),

  // Memory_interface
  .mem_req_o        (mem_req_lsu),
  .mem_we_o         (mem_we_lsu),
  .mem_be_o         (mem_be),
  .mem_addr_o       (mem_addr_lsu),
  .mem_wd_o         (mem_wd_lsu),
  .mem_rd_i         (mem_rd),
  .mem_ready_i      (mem_ready)
);


ext_mem external_memory (
  .clk_i            (sysclk),
  .mem_req_i        (mem_req_lsu),
  .write_enable_i   (mem_we_lsu),
  .byte_enable_i    (mem_be),
  .addr_i           (mem_addr_lsu),
  .write_data_i     (mem_wd_lsu),
  .read_data_o      (mem_rd),
  .ready_o          (mem_rd_ps2)
);


ps2_sb_ctrl ps2_sb_ctrl(
    .clk_i          (sysclk),
    .rst_i          (rst),
    .addr_i         (mem_addr),
    .req_i          (ps2_sb_ctrl_req),
    .write_data_i   (mem_wd),
    .write_enable_i (mem_we),
    .read_data_o    (mem_rd_ps2)          

);

vga_sb_ctrl vga_sb_ctrl(
    .clk_i          (sysclk),
    .clk100m_i      (clk_i),
    .rst_i          (rst),
    .req_i          (vga_req),
    .write_enable_i (mem_we),
    .mem_be_i       (),
    .addr_i         (mem_addr),
    .write_data_i   (mem_wd),
    .read_data_o    (mem_rd_vga),

    .vga_r_o        (vga_r_o),
    .vga_g_o        (vga_g_o),
    .vga_b_o        (vga_b_o),
    .vga_hs_o       (vga_hs_o),
    .vga_vs_o       (vga_vs_o)
);
