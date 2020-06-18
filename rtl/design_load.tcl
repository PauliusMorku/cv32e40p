delete_design -both
set_read_hdl_option -golden -verilog_version 2001 -verilog_include_path {include} -vhdl_version 93 -init_vhdl  -verilog_define {} -pragma_ignore {}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {fpnew/src/fpnew_pkg.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {include/cv32e40p_defines.sv include/cv32e40p_apu_core_package.sv include/cv32e40p_apu_macros.sv include/cv32e40p_config.sv include/cv32e40p_tracer_defines.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {cv32e40p_if_stage.sv cv32e40p_hwloop_regs.sv cv32e40p_hwloop_controller.sv cv32e40p_prefetch_controller.sv cv32e40p_obi_interface.sv cv32e40p_prefetch_buffer.sv cv32e40p_fetch_fifo.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {cv32e40p_id_stage.sv cv32e40p_apu_disp.sv cv32e40p_decoder.sv cv32e40p_compressed_decoder.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {cv32e40p_cs_registers.sv cv32e40p_register_file_ff.sv cv32e40p_register_file_test_wrap.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {cv32e40p_ex_stage.sv cv32e40p_alu_div.sv cv32e40p_alu.sv cv32e40p_popcnt.sv cv32e40p_ff_one.sv cv32e40p_mult.sv}
read_verilog -golden  -pragma_ignore {}  -version sv2012 {cv32e40p_load_store_unit.sv cv32e40p_int_controller.sv cv32e40p_controller.sv cv32e40p_core.sv}
elaborate -golden