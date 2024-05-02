module ps2_sb_ctrl(
    /*
    Часть интерфейса модуля, отвечающая за подключение к системной шине
    */
    
    input  logic         clk_i,
    input  logic         rst_i,
    input  logic [31:0]  addr_i,
    input  logic         req_i,
    input  logic [31:0]  write_data_i,
    input  logic         write_enable_i,
    output logic [31:0]  read_data_o,
    
    /*
    Часть интерфейса модуля, отвечающая за отправку запросов на прерывание
    процессорного ядра
    */
    
    output logic        interrupt_request_o,
    input  logic        interrupt_return_i,
    
    /*
    Часть интерфейса модуля, отвечающая за подключение к модулю,
    осуществляющему прием данных с клавиатуры
    */

    input  logic        kclk_i,
    input  logic        kdata_i
);

    logic [7:0] scan_code;
    logic       scan_code_is_unread;

    PS2Receiver ps2_receiver(
        .clk_i(clk_i),
        .kclk_i(kclk_i),
        .kdata_i(kdata_i),
        .keycode_o(scan_code),
        .keycode_valid_o(scan_code_is_unread)
    );

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            scan_code <= 0;
            scan_code_is_unread <= 0;
        end else if (scan_code_is_unread && keycode_valid_o) begin
            scan_code <= keycode_o;
            scan_code_is_unread <= 1;
        end else if (req_i && addr_i == 32'h00) begin
            if (!scan_code_is_unread || !keycode_valid_o) begin
                scan_code_is_unread <= 0;
            end
        end else if (interrupt_return_i) begin
            if (!scan_code_is_unread || !keycode_valid_o) begin
                scan_code_is_unread <= 0;
            end
        end else if (write_enable_i && addr_i == 32'h24 && write_data_i == 1) begin
            scan_code <= 0;
            scan_code_is_unread <= 0;
        end
    end

    assign interrupt_request_o = scan_code_is_unread;

    always_comb begin
        read_data_o = 32'h00;
        if (req_i && addr_i == 32'h00) begin
            read_data_o = {24'h00, scan_code};
        end else if (req_i && addr_i == 32'h04) begin
            read_data_o = scan_code_is_unread;
        end
    end

endmodule
