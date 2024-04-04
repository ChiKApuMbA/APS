module decoder_riscv (
  //Инструкция для декодирования, считанная из памяти инструкций
  input  logic [31:0] fetched_instr_i,
  
  //Управляющий сигнал мультиплексора для выбора первого операнда АЛУ 
  output logic [1:0] a_sel_o,
  
  //Управляющий сигнал мультиплексора для выбора второго операнда АЛУ
  output logic [2:0] b_sel_o,
  
  //Операция АЛУ
  output logic [4:0] alu_op_o,
  
  //Операция модуля CSR(регистры статуса и контроля)
  output logic [2:0] csr_op_o,
  
  //Разрешение на запись в CSR
  output logic csr_we_o,Ф
  
  //Запрос на доступ к памяти (часть интерфейса памяти)
  output logic mem_req_o,
  
  //Сигнал разрешения записи в память, «write enable» (при равенстве нулю происходит чтение)
  output logic mem_we_o,
  
  //Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти)
  output logic [2:0] mem_size_o,
  
  //Сигнал разрешения записи в регистровый файл
  output logic gpr_we_o,
  
  //Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый файл
  output logic [1:0] wb_sel_o,        //write back selector
  
  //Сигнал о некорректной инструкции (на схеме не отмечен)
  output logic illegal_instr_o,
  
  //Сигнал об инструкции условного перехода
  output logic branch_o,
  
  //Сигнал об инструкции безусловного перехода jal
  output logic jal_o,
  
  //Сигнал об инструкции безусловного перехода jalr
  output logic jalr_o,
  
  //Сигнал об инструкции возврата из прерывания/исключения mret
  output logic mret_o
);
  import riscv_pkg::*;

  always_comb begin

    //Определение значение по умолчанию
    a_sel_o = 0;
    b_sel_o = 0;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_o = 0;
    wb_sel_o = 0;
    illegal_instr_o = 0;
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
    mret = 0;

    //Проверка на то что 2 младших бита opcode равны '11'
    if(fetched_instr_i[1:0]) begin
      //case для всех возможных значений opcode
      case(fetched_instr_i[6:2])
        
        //ALU операция с двумя регистрами
        OP_CODE: begin
          
          //Выставление флага на разрешение записи в рестровый файл          
          gpr_we_o = 1;

          //fetched_instr_i[31:25] - func7, fetched_instr_i[14:12] - func3 
          case({fetched_instr_i[31:25], fetched_instr_i[14:12]})
            10'h00_0 : alu_op_o = ALU_ADD;
            10'h00_1 : alu_op_o = ALU_SLL;
            10'h00_2 : alu_op_o = ALU_SLTS;
            10'h00_3 : alu_op_o = ALU_SLTU;
            10'h00_4 : alu_op_o = ALU_XOR;
            10'h00_5 : alu_op_o = ALU_SRL;
            10'h00_6 : alu_op_o = ALU_OR;
            10'h00_7 : alu_op_o = ALU_AND;

            10'h20_0 : alu_op_o = ALU_SUB;
            10'h20_5 : alu_op_o = ALU_SRA;

            //В случаи некорректной команды запрещаем запись
            //в регистровый файл и выставляем флаг illegal_instr_o 
            default: begin illegal_instr_o = 1; gpr_we_o = 0; end
          endcase
        end
        
        //ALU операция с регистром и константой
        OP_IMM_OPCODE: begin
          
          //Выставление флага на разрешение записи в рестровый файл
          gpr_we_o = 1;
          
          //выставление кода что в качестве аргумента будет константа
          b_sel_o = OP_B_IMM_I;
          
          //case для сдвигов на константную величину 
          case({fetched_instr_i[31:25], fetched_instr_i[14:12]})
            10'h00_1 : alu_op_o = ALU_SLL;
            10'h00_5 : alu_op_o = ALU_SRL;
            10'h20_5 : alu_op_o = ALU_SRA;
            default: begin illegal_instr_o = 1; gpr_we_o = 0; end
          endcase

          case({fetched_instr_i[14:12]})
            3'd0 : alu_op_o = ALU_ADD;
            3'd2 : alu_op_o = ALU_SLTS;
            3'd3 : alu_op_o = ALU_SLTU;
            3'd4 : alu_op_o = ALU_XOR;
            3'd6 : alu_op_o = ALU_OR;
            3'd7 : alu_op_o = ALU_AND;
            default : begin illegal_instr_o = 1; gpr_we_o = 0; end
          endcase
        end
        
        LUI_OPCODE: begin
          a_sel_o = OP_A_ZERO;
          b_sel_o = OP_B_IMM_U;
          alu_op_o = ALU_ADD;
          gpr_we_o = 1;
        end

        LOAD_OPCODE: begin
          gpr_we_o = 1;
          mem_req_o = 1;
          wb_sel_o = 1;
          b_sel_o = OP_B_IMM_I;
          //alu_op_o = ALU_ADD;

          case(fetched_instr_i[14:12])
            3'h0 : mem_size_o = LDST_B;
            3'h1 : mem_size_o = LDST_H;
            3'h2 : mem_size_o = LDST_W;
            3'h4 : mem_size_o = LDST_BU;
            3'h5 : mem_size_o = LDST_HU;
            default : begin illegal_instr_o = 1; mem_req_o = 0; gpr_we_o = 0; end
          endcase
        end
        STORE_OPCODE: begin
          b_sel_o = OP_B_IMM_S;
          gpr_we_o = 0;
          mem_req_o = 1;
          mem_we_o = 1;
          case(fetched_instr_i[14:12])
            3'h0 : mem_size_o = LDST_B;
            3'h1 : mem_size_o = LDST_H;
            3'h2 : mem_size_o = LDST_W;

            default : begin illegal_instr_o = 1;  mem_req_o = 0; mem_we_o = 0; end
          endcase
        end
        BRANCH_OPCODE: begin
          branch_o = 1;
          gpr_we_o = 0;
          a_sel_o = 0;
          b_sel_o = 0;
          case(fetched_instr_i[14:12])
            3'h0 : alu_op_o = ALU_EQ;
            3'h1 : alu_op_o = ALU_NE;
            3'h4 : alu_op_o = ALU_LTS;
            3'h5 : alu_op_o = ALU_GES;
            3'h6 : alu_op_o = ALU_LTU;
            3'h7 : alu_op_o = ALU_GEU;
            default : begin illegal_instr_o = 1; branch_o = 0; end
          endcase
        end
        JAL_OPCODE: begin
          jal_o = 1;
          gpr_we_o = 1;
          a_sel_o = OP_A_CURR_PC;
          b_sel_o  = OP_B_INCR;
          alu_op_o =  ALU_ADD;
        end
        JALR_OPCODE: begin
          case(fetched_instr_i[14:12])
            3'h0: 
            begin
              jalr_o   = 1;
              gpr_we_o = 1;
              a_sel_o  = OP_A_CURR_PC;
              b_sel_o  = OP_B_INCR;
              alu_op_o = ALU_ADD;
            end
            default: illegal_instr_o = 1;
          endcase
        end
        AUIPC_OPCODE: begin
          a_sel_o = OP_A_CURR_PC;
          b_sel_o  = OP_B_IMM_U;
          alu_op_o = ALU_ADD;
          gpr_we_o = 1;
        end
        MISC_MEM_OPCODE: begin
          case(fetched_instr_i[14:12])
            3'h0 : begin alu_op_o = ALU_AND; b_sel_o = OP_B_IMM_I; end
            default: illegal_instr_o = 1;
          endcase
        end
        SYSTEM_OPCODE: begin
          case(fetched_instr_i[14:12])
            3'b000: begin
              case(fetched_instr_i[31:25])
                7'b000_0000: begin illegal_instr_o = 1'd1; gpr_we_o = 1'd0; end
                7'b000_0001: begin illegal_instr_o = 1'd1; gpr_we_o = 1'd0; end
                default:
                  case(fetched_instr_i[31:0])
                    32'b00110000001000000000000001110011: mret_o = 1'd1;
                    default: illegal_instr_o = 1'd1;
                  endcase
              endcase
            end
            CSR_RW,CSR_RS,CSR_RS,CSR_RS,CSR_RSI,CSR_RCI: begin
              gpr_we_o = 1'd1;
              wb_sel_o = WB_CSR_DATA;
              csr_we_o = 1'd1;
              csr_op_o = fetched_instr_i[14:12];
              end
            default: begin illegal_instr_o = 1'd1;gpr_we_o = 1'd0; end
          endcase
        end
        default: begin illegal_instr_o = 1'd1;gpr_we_o = 1'd0; end
      endcase
    end
    else begin 
      illegal_instr_o = 1; 
    end
endmodule