module CYBERcobra (

input  logic clk_i,
input  logic rst_i,
input  logic [15:0] sw_i,

output logic [31:0] out_o

);

logic [31:0] pc_i_w;
logic [31:0] pc_o_w; 
logic [31:0] reg_instr_out_w;
logic [31:0] sum_b_w; 
logic [31:0] wd_w;
logic [31:0] rd1_w; 
logic [31:0] rd2_w;
logic [31:0] alu_res_w;
logic alu_flag_w;

    instr_mem instr_mem(
    
    .addr_i(pc_o_w),
    .read_data_o(reg_instr_out_w)
    
    );
    
    fulladder32 pc_adder(
    
    .a_i(pc_o_w),
    .b_i(sum_b_w),
    .sum_o(pc_i_w),
    .carry_i('0)
    
    );
    
    
    rf_riscv regfile(
    
    .clk_i(clk_i),
    .write_enable_i(!(reg_instr_out_w[31] || reg_instr_out_w[30])),
    .read_addr1_i(reg_instr_out_w[22:18]),
    .read_addr2_i(reg_instr_out_w[17:13]),
    .write_addr_i(reg_instr_out_w[4:0]),
    .write_data_i(wd_w),
    .read_data1_o(rd1_w),
    .read_data2_o(rd2_w)
    
    ); 
               
    alu_riscv alu(
    
    .a_i(rd1_w),
    .b_i(rd2_w),
    .alu_op_i(reg_instr_out_w[27:23]),
    .flag_o(alu_flag_w),
    .result_o(alu_res_w)
    
    );   
    
    
assign out_o = rd1_w;
    
    
always_ff @(posedge clk_i) begin
        
        if(rst_i) begin
        
        pc_o_w <= '0;
        
        end else begin
    
            pc_o_w <= pc_i_w;
            end
end

    
      //мультиплексор записи данных
        always_comb begin 
        
            case(reg_instr_out_w[29:28])
            
                2'b00 : wd_w = {{9{reg_instr_out_w[27]}}, reg_instr_out_w[27:5]};
                
                2'b01 : wd_w = alu_res_w;
                
                2'b10 : wd_w = {{16{sw_i[15]}}, sw_i};
                
                default : wd_w = 32'd0;
            
            endcase 
            
        //мультиплексор jump команд 
        
            case(reg_instr_out_w[31] || (reg_instr_out_w[30] && alu_flag_w))
            
                1'b0: sum_b_w = 32'd4;
            
                1'b1: sum_b_w = {{22{reg_instr_out_w[12]}}, reg_instr_out_w[12:5], 2'b0};
                
            endcase
            
end
     
endmodule