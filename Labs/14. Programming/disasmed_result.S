
result.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00005197          	auipc	gp,0x5
   4:	80018193          	add	gp,gp,-2048 # 4800 <_gbl_ptr>
   8:	00007117          	auipc	sp,0x7
   c:	5f810113          	add	sp,sp,1528 # 7600 <_stack_ptr>
  10:	00004297          	auipc	t0,0x4
  14:	ff028293          	add	t0,t0,-16 # 4000 <_bss_end>
  18:	00004317          	auipc	t1,0x4
  1c:	fe830313          	add	t1,t1,-24 # 4000 <_bss_end>

00000020 <_bss_init_loop>:
  20:	00534863          	blt	t1,t0,30 <_irq_config>
  24:	0002a023          	sw	zero,0(t0)
  28:	00428293          	add	t0,t0,4
  2c:	ff5ff06f          	j	20 <_bss_init_loop>

00000030 <_irq_config>:
  30:	05c00293          	li	t0,92
  34:	fff00313          	li	t1,-1
  38:	00008397          	auipc	t2,0x8
  3c:	fc838393          	add	t2,t2,-56 # 8000 <_trap_stack_ptr>
  40:	30529073          	csrw	mtvec,t0
  44:	30431073          	csrw	mie,t1
  48:	34039073          	csrw	mscratch,t2

0000004c <_main_call>:
  4c:	00000513          	li	a0,0
  50:	00000593          	li	a1,0
  54:	154000ef          	jal	1a8 <main>

00000058 <_endless_loop>:
  58:	0000006f          	j	58 <_endless_loop>

0000005c <_int_handler>:
  5c:	34011173          	csrrw	sp,mscratch,sp
  60:	fb010113          	add	sp,sp,-80
  64:	00112223          	sw	ra,4(sp)
  68:	00007097          	auipc	ra,0x7
  6c:	59808093          	add	ra,ra,1432 # 7600 <_stack_ptr>
  70:	fe1144e3          	blt	sp,ra,58 <_endless_loop>
  74:	00512623          	sw	t0,12(sp)
  78:	00612823          	sw	t1,16(sp)
  7c:	00712a23          	sw	t2,20(sp)
  80:	00a12c23          	sw	a0,24(sp)
  84:	00b12e23          	sw	a1,28(sp)
  88:	02c12023          	sw	a2,32(sp)
  8c:	02d12223          	sw	a3,36(sp)
  90:	02e12423          	sw	a4,40(sp)
  94:	02f12623          	sw	a5,44(sp)
  98:	03012823          	sw	a6,48(sp)
  9c:	03112a23          	sw	a7,52(sp)
  a0:	03c12c23          	sw	t3,56(sp)
  a4:	03d12e23          	sw	t4,60(sp)
  a8:	05e12023          	sw	t5,64(sp)
  ac:	05f12223          	sw	t6,68(sp)
  b0:	340022f3          	csrr	t0,mscratch
  b4:	34102373          	csrr	t1,mepc
  b8:	34202573          	csrr	a0,mcause
  bc:	00512423          	sw	t0,8(sp)
  c0:	04612423          	sw	t1,72(sp)
  c4:	04a12623          	sw	a0,76(sp)
  c8:	16c000ef          	jal	234 <int_handler>
  cc:	00010513          	mv	a0,sp
  d0:	04852303          	lw	t1,72(a0)
  d4:	05010113          	add	sp,sp,80
  d8:	34011073          	csrw	mscratch,sp
  dc:	34131073          	csrw	mepc,t1
  e0:	00452083          	lw	ra,4(a0)
  e4:	00852103          	lw	sp,8(a0)
  e8:	00c52283          	lw	t0,12(a0)
  ec:	01052303          	lw	t1,16(a0)
  f0:	01452383          	lw	t2,20(a0)
  f4:	01c52583          	lw	a1,28(a0)
  f8:	02052603          	lw	a2,32(a0)
  fc:	02452683          	lw	a3,36(a0)
 100:	02852703          	lw	a4,40(a0)
 104:	02c52783          	lw	a5,44(a0)
 108:	03052803          	lw	a6,48(a0)
 10c:	03452883          	lw	a7,52(a0)
 110:	03852e03          	lw	t3,56(a0)
 114:	03c52e83          	lw	t4,60(a0)
 118:	04052f03          	lw	t5,64(a0)
 11c:	04452f83          	lw	t6,68(a0)
 120:	02852503          	lw	a0,40(a0)
 124:	30200073          	mret

00000128 <_Z15uart_rx_receivev>:
 128:	ff010113          	add	sp,sp,-16
 12c:	00812623          	sw	s0,12(sp)
 130:	01010413          	add	s0,sp,16
 134:	00000013          	nop
 138:	050007b7          	lui	a5,0x5000
 13c:	0087a783          	lw	a5,8(a5) # 5000008 <_trap_stack_ptr+0x4ff8008>
 140:	00f037b3          	snez	a5,a5
 144:	0ff7f793          	zext.b	a5,a5
 148:	fe0798e3          	bnez	a5,138 <_Z15uart_rx_receivev+0x10>
 14c:	050007b7          	lui	a5,0x5000
 150:	0007a783          	lw	a5,0(a5) # 5000000 <_trap_stack_ptr+0x4ff8000>
 154:	00078513          	mv	a0,a5
 158:	00c12403          	lw	s0,12(sp)
 15c:	01010113          	add	sp,sp,16
 160:	00008067          	ret

00000164 <_Z12uart_tx_sendm>:
 164:	fe010113          	add	sp,sp,-32
 168:	00812e23          	sw	s0,28(sp)
 16c:	02010413          	add	s0,sp,32
 170:	fea42623          	sw	a0,-20(s0)
 174:	00000013          	nop
 178:	060007b7          	lui	a5,0x6000
 17c:	0087a783          	lw	a5,8(a5) # 6000008 <_trap_stack_ptr+0x5ff8008>
 180:	00f037b3          	snez	a5,a5
 184:	0ff7f793          	zext.b	a5,a5
 188:	fe0798e3          	bnez	a5,178 <_Z12uart_tx_sendm+0x14>
 18c:	060007b7          	lui	a5,0x6000
 190:	fec42703          	lw	a4,-20(s0)
 194:	00e7a023          	sw	a4,0(a5) # 6000000 <_trap_stack_ptr+0x5ff8000>
 198:	00000013          	nop
 19c:	01c12403          	lw	s0,28(sp)
 1a0:	02010113          	add	sp,sp,32
 1a4:	00008067          	ret

000001a8 <main>:
 1a8:	fe010113          	add	sp,sp,-32
 1ac:	00112e23          	sw	ra,28(sp)
 1b0:	00812c23          	sw	s0,24(sp)
 1b4:	02010413          	add	s0,sp,32
 1b8:	f71ff0ef          	jal	128 <_Z15uart_rx_receivev>
 1bc:	fea42623          	sw	a0,-20(s0)
 1c0:	fec42783          	lw	a5,-20(s0)
 1c4:	00f7f713          	and	a4,a5,15
 1c8:	fec42783          	lw	a5,-20(s0)
 1cc:	0047d793          	srl	a5,a5,0x4
 1d0:	00f7f793          	and	a5,a5,15
 1d4:	00f70733          	add	a4,a4,a5
 1d8:	fec42783          	lw	a5,-20(s0)
 1dc:	0087d793          	srl	a5,a5,0x8
 1e0:	00f7f793          	and	a5,a5,15
 1e4:	00f70733          	add	a4,a4,a5
 1e8:	fec42783          	lw	a5,-20(s0)
 1ec:	00c7d793          	srl	a5,a5,0xc
 1f0:	00f7f793          	and	a5,a5,15
 1f4:	00f707b3          	add	a5,a4,a5
 1f8:	fef42423          	sw	a5,-24(s0)
 1fc:	fe842503          	lw	a0,-24(s0)
 200:	f65ff0ef          	jal	164 <_Z12uart_tx_sendm>
 204:	fe042223          	sw	zero,-28(s0)
 208:	0100006f          	j	218 <main+0x70>
 20c:	fe442783          	lw	a5,-28(s0)
 210:	00178793          	add	a5,a5,1
 214:	fef42223          	sw	a5,-28(s0)
 218:	fe442703          	lw	a4,-28(s0)
 21c:	000f47b7          	lui	a5,0xf4
 220:	24078793          	add	a5,a5,576 # f4240 <_trap_stack_ptr+0xec240>
 224:	00f727b3          	slt	a5,a4,a5
 228:	0ff7f793          	zext.b	a5,a5
 22c:	fe0790e3          	bnez	a5,20c <main+0x64>
 230:	f89ff06f          	j	1b8 <main+0x10>

00000234 <int_handler>:
 234:	ff010113          	add	sp,sp,-16
 238:	00812623          	sw	s0,12(sp)
 23c:	01010413          	add	s0,sp,16
 240:	ff0007b7          	lui	a5,0xff000
 244:	0087a703          	lw	a4,8(a5) # ff000008 <_trap_stack_ptr+0xfeff8008>
 248:	215227b7          	lui	a5,0x21522
 24c:	52f78793          	add	a5,a5,1327 # 2152252f <_trap_stack_ptr+0x2151a52f>
 250:	00f707b3          	add	a5,a4,a5
 254:	0017b793          	seqz	a5,a5
 258:	0ff7f793          	zext.b	a5,a5
 25c:	00078863          	beqz	a5,26c <int_handler+0x38>
 260:	ff0007b7          	lui	a5,0xff000
 264:	00100713          	li	a4,1
 268:	00e7a623          	sw	a4,12(a5) # ff00000c <_trap_stack_ptr+0xfeff800c>
 26c:	00000013          	nop
 270:	00c12403          	lw	s0,12(sp)
 274:	01010113          	add	sp,sp,16
 278:	00008067          	ret

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	5078                	.insn	2, 0x5078
   8:	6361                	.insn	2, 0x6361
   a:	4e47206b          	.insn	4, 0x4e47206b
   e:	2055                	.insn	2, 0x2055
  10:	4952                	.insn	2, 0x4952
  12:	562d4353          	.insn	4, 0x562d4353
  16:	4520                	.insn	2, 0x4520
  18:	626d                	.insn	2, 0x626d
  1a:	6465                	.insn	2, 0x6465
  1c:	6564                	.insn	2, 0x6564
  1e:	2064                	.insn	2, 0x2064
  20:	20434347          	.insn	4, 0x20434347
  24:	3878                	.insn	2, 0x3878
  26:	5f36                	.insn	2, 0x5f36
  28:	3436                	.insn	2, 0x3436
  2a:	2029                	.insn	2, 0x2029
  2c:	3331                	.insn	2, 0x3331
  2e:	322e                	.insn	2, 0x322e
  30:	302e                	.insn	2, 0x302e
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	2841                	.insn	2, 0x2841
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <_start+0x14>
   c:	001e                	.insn	2, 0x001e
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f31                	.insn	2, 0x5f31
  1c:	697a                	.insn	2, 0x697a
  1e:	32727363          	bgeu	tp,t2,344 <int_handler+0x110>
  22:	3070                	.insn	2, 0x3070
  24:	0800                	.insn	2, 0x0800
  26:	0a01                	.insn	2, 0x0a01
  28:	Address 0x28 is out of bounds.

