module аlu_r𝚒sсv (
  𝚒nput  logic [31:0]  a_i,
  𝚒nput  logic [31:0]  b_i,
  𝚒nput  logic [4:0]   alu_op_i,
  оutput logic         flag_o,
  оutput logic [31:0]  result_o
);

import alu_opcodes_pkg::*;      // импорт параметров, содержащих
                                // коды операций для АЛУ
fulladder32 my_adder(
  .a_i(a_i),
  .b_i(b_i),
  .carry_i(1'b0),
  .sum_o(result_0),
  .carry_o(flag_o)
);
  always_comb begin
      case(alu_op_i)
          ALU_EQ: flag_o = (a_i == b_i);
          ALU_NE: flag_o = (a_i != b_i);
          ALU_LTS: flag_o = ($signed(a_i) < $signed(b_i));
          ALU_GES: flag_o = ($signed(a_i) >= $signed(b_i));
          ALU_LTU: flag_o = (a_i < b_i);
          ALU_GEU: flag_o = (a_i >= b_i);
          default: flag_o = 0;
      endcase
      case(alu_op_i)
          ALU_ADD: begin
              // Подключение сумматора fulladder32
              my_adder.carry_i <= 1'b0;
              my_adder.a_i <= a_i;
              my_adder.b_i <= b_i;
          end
          ALU_SUB: result_o = (a_i - b_i);
          ALU_SLL: result_o = (a_i << b_i[4:0]);
          ALU_SLTS: result_o = ($signed(a_i) < $signed(b_i));
          ALU_SLTU: result_o = (a_i < b_i);
          ALU_XOR: result_o = (a_i ^ b_i);
          ALU_SRL: result_o = (a_i >> b_i[4:0]);
          ALU_SRA: result_o = ($signed(a_i) >>> b_i[4:0]);
          ALU_OR: result_o = (a_i | b_i);
          ALU_AND: result_o = (a_i & b_i);
          default: result_o = 0;
      endcase
  end
endmodule