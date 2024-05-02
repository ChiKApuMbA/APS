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
    input  logic kclk_i,
    input  logic kdata_i
);

    logic [7:0] scan_code;
    logic       scan_code_is_unread;

    // Экземпляр модуля PS2Receiver
    PS2Receiver PS2Receiver_inst(
        .clk_i(clk_i),
        .kclk_i(kclk_i),
        .kdata_i(kdata_i),
        .keycode_o(scan_code),
        .keycode_valid_o(scan_code_is_unread)
    );

    // Логика обработки запросов чтения и записи
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            scan_code        <= 8'h00;
            scan_code_is_unread <= 1'b0;
        end else begin
            case(addr_i)
                32'h00: begin // Запрос на чтение по адресу 0x00
                    if (req_i) begin
                        read_data_o <= {24'h00, scan_code};
                        if (!scan_code_is_unread)
                            scan_code_is_unread <= 1'b0;
                    end
                end
                32'h04: begin // Запрос на чтение по адресу 0x04
                    if (req_i) begin
                        read_data_o <= {24'h00, scan_code_is_unread};
                    end
                end
                32'h24: begin // Запрос на запись по адресу 0x24
                    if (write_enable_i && req_i && write_data_i == 1'b1) begin
                        scan_code        <= 8'h00;
                        scan_code_is_unread <= 1'b0;
                    end
                end
                default: begin
                    // По умолчанию ничего не делаем
                end
            endcase
        end
    end

    // Обработка прерывания
    always_comb begin
        interrupt_request_o = scan_code_is_unread;
    end

    // Обнуление scan_code_is_unread по прерыванию или при чтении при наличии новых данных
    always_ff @(posedge clk_i or posedge interrupt_return_i) begin
        if (interrupt_return_i || (req_i && (addr_i == 32'h00) && scan_code_is_unread)) begin
            scan_code_is_unread <= 1'b0;
        end
    end

endmodule
