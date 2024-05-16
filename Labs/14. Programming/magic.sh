wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-gcc.exe -c -march=rv32i_zicsr -mabi=ilp32 startup.S -o startup.o
wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-gcc.exe -c -march=rv32i_zicsr -mabi=ilp32 main.cpp -o main.o


wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-gcc.exe -march=rv32i_zicsr -mabi=ilp32 -Wl,--gc-sections -nostartfiles -T linker_script.ld startup.o main.o -o result.elf

wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-objcopy.exe --verilog-data-width=4 -O verilog -j .text result.elf init_instr.mem
wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-objcopy.exe --verilog-data-width=4 -O verilog -j .data -j .bss -j .sdata result.elf init_data.mem

wine /workspaces/APS/Labs/'14. Programming'/xpack-riscv-none-elf-gcc-13.2.0-1/bin/riscv-none-elf-objdump.exe -D result.elf > disasmed_result.S
