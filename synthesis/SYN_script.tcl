analyze -library WORK -format vhdl {DLX/DATAPATH/DECODE_UNIT/a.a.b.b.a-mux21_generic.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b.b-reg32.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b.c-reg_generic.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b.d-sign_extend.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b.e-sign_extend26.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b.f-registerfile.vhd DLX/DATAPATH/DECODE_UNIT/a.a.b.b-decode_unit.vhd}

analyze -library WORK -format vhdl {DLX/DATAPATH/FETCH_UNIT/a.a.b.a.a-reg_generic2.vhd DLX/DATAPATH/FETCH_UNIT/a.a.b.a.b-reg_generic3.vhd DLX/DATAPATH/FETCH_UNIT/a.a.b.a-fetch_unit.vhd}

analyze -library WORK -format vhdl {DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h-mypackage.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.a.a.a-mux21_generic.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.a.a.b.a-fa.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.a.a.b-rca.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.a.a-carryselblock.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.a-sumGen.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.b.d-XOR_block.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.b.c-general_generate.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.b.a-PG_block.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.b.b-general_prop.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h.b-sparse_tree_carry_gen.vhd DLX/DATAPATH/EXECUTION_UNIT/adder/a.a.b.c.h-P4Adder.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.a-alu.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.d-compare_zero.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.e-reg32.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.f-reg.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.g-reg_generic.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.b-mux21_1bit.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c.c-AND_gate.vhd DLX/DATAPATH/EXECUTION_UNIT/a.a.b.c-execution_unit.vhd}

analyze -library WORK -format vhdl {DLX/DATAPATH/MEMORY_UNIT/a.a.b.d.a-mux21_generic.vhd DLX/DATAPATH/MEMORY_UNIT/a.a.b.d.b-OR_gate.vhd DLX/DATAPATH/MEMORY_UNIT/a.a.b.d.c-reg32.vhd DLX/DATAPATH/MEMORY_UNIT/a.a.b.d-memory_unit.vhd}

analyze -library WORK -format vhdl {DLX/DATAPATH/WRITEBACK_UNIT/a.a.b.e-a-mux41_generic.vhd DLX/DATAPATH/WRITEBACK_UNIT/a.a.b.e-write_back_unit.vhd}

analyze -library WORK -format vhdl {DLX/DATAPATH/a.a.b-Datapath.vhd}

analyze -library WORK -format vhdl {DLX/CU/a.a.a.b-myTypes.vhd DLX/CU/a.a.a-CU.vhd}

analyze -library WORK -format vhdl {000-globals.vhd a.a-DLX.vhd}

elaborate dlx_processor -architecture STRUCT -library WORK






