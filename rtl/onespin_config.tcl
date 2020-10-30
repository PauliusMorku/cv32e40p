################################################################################################
# OneSpin script directory
################################################################################################
set ONESPIN_SCRIPT_DIR $::env(ONESPIN_SCRIPT_DIR)

################################################################################################
# Common root directory for all the files involved in the experiment
# NOTE: when using "make_copy 1" option all referenced files must originate from this directory
# (files can't be referenced using "../" operator)
################################################################################################
set COMMON_ROOT_DIR $::env(WORKSPACE_DIR)

################################################################################################
# Comment for the experiment (will appear in the OneSpin log files and the generated report)
################################################################################################
set comment "initial attempt to load cv32e40p"

################################################################################################
# Generate report from all experiments in the result directory (1 - enable, 0 - disable)
################################################################################################
set generate_report 1

################################################################################################
# Arguments for the property check in OneSpin (can be used to configure engines, etc.)
################################################################################################
set check_args "-all"

################################################################################################
# TCL script files that are executed prior loading the desing in OneSpin
################################################################################################
set tcl_config_files {
	cv32e40p/rtl/design_load.tcl
}

################################################################################################
# Filter messages (1 - enable, 0 - disable)
################################################################################################
set filter_messages 1

################################################################################################
# Copy experiment files before running checks (1 - enable, 0 - disable)
################################################################################################
set make_copy 0

################################################################################################
# ITL property files, similarly named TCL files will be sourced automatically
################################################################################################
set itl_property_files {
	cv32e40p/rtl/property.vli
	cv32e40p/rtl/core_functions.vli
}

################################################################################################
# VHDL files
################################################################################################
set vhdl_files {
}

################################################################################################
# Verilog files
################################################################################################
set verilog_files {
	cv32e40p/rtl/fpnew_pkg.sv
	cv32e40p/rtl/include/cv32e40p_defines.sv
	cv32e40p/rtl/include/cv32e40p_apu_core_package.sv
	cv32e40p/rtl/include/cv32e40p_apu_macros.sv
	cv32e40p/rtl/include/cv32e40p_config.sv
	cv32e40p/rtl/include/cv32e40p_tracer_defines.sv
	cv32e40p/rtl/cv32e40p_if_stage.sv
	cv32e40p/rtl/cv32e40p_hwloop_regs.sv
	cv32e40p/rtl/cv32e40p_hwloop_controller.sv
	cv32e40p/rtl/cv32e40p_prefetch_controller.sv
	cv32e40p/rtl/cv32e40p_obi_interface.sv
	cv32e40p/rtl/cv32e40p_prefetch_buffer.sv
	cv32e40p/rtl/cv32e40p_fetch_fifo.sv
	cv32e40p/rtl/cv32e40p_compressed_decoder.sv
	cv32e40p/rtl/cv32e40p_decoder.sv
	cv32e40p/rtl/cv32e40p_apu_disp.sv
	cv32e40p/rtl/cv32e40p_id_stage.sv
	cv32e40p/rtl/cv32e40p_cs_registers.sv
	cv32e40p/rtl/cv32e40p_register_file_ff.sv
	cv32e40p/rtl/cv32e40p_register_file_test_wrap.sv
	cv32e40p/rtl/cv32e40p_ex_stage.sv
	cv32e40p/rtl/cv32e40p_alu_div.sv
	cv32e40p/rtl/cv32e40p_alu.sv
	cv32e40p/rtl/cv32e40p_popcnt.sv
	cv32e40p/rtl/cv32e40p_ff_one.sv
	cv32e40p/rtl/cv32e40p_mult.sv
	cv32e40p/rtl/cv32e40p_load_store_unit.sv
	cv32e40p/rtl/cv32e40p_int_controller.sv
	cv32e40p/rtl/cv32e40p_controller.sv
	cv32e40p/rtl/cv32e40p_core.sv
}

################################################################################################
# Common ITL files
################################################################################################
set itl_common_files {
}

################################################################################################
# Common signals to be cut
################################################################################################
set cut_signals {
}

################################################################################################
# Read common variables and launch - do not modify
################################################################################################
set config_file [info script]
source $ONESPIN_SCRIPT_DIR/launcher.tcl
