# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {HDL-1065} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.cache/wt [current_project]
set_property parent.project_path C:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_repo_paths c:/workspace/Perlpheral_course_2022/ip_repo [current_project]
update_ip_catalog
set_property ip_output_repo c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog {
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_params.vh
  C:/workspace/Perlpheral_course_2022/rtl_src/typedef.svh
  C:/workspace/Perlpheral_course_2022/rtl_src/assign.svh
  C:/workspace/Perlpheral_course_2022/rtl_src/registers.svh
}
set_property file_type "Verilog Header" [get_files C:/workspace/Perlpheral_course_2022/rtl_src/typedef.svh]
set_property file_type "Verilog Header" [get_files C:/workspace/Perlpheral_course_2022/rtl_src/assign.svh]
set_property file_type "Verilog Header" [get_files C:/workspace/Perlpheral_course_2022/rtl_src/registers.svh]
read_mem C:/workspace/Perlpheral_course_2022/rtl_src/BootROM/sw/boot_main.mem
read_verilog -library xil_defaultlib -sv {
  C:/workspace/Perlpheral_course_2022/rtl_src/axi_pkg.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/axi_cdc.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/axi_intf.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/binary_to_gray.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/bscan_tap.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/cdc_fifo_gray.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/gray_to_binary.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/spill_register.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/sync.sv
  C:/workspace/Perlpheral_course_2022/rtl_src/rvfpga.sv
}
read_verilog -library xil_defaultlib {
  C:/workspace/Perlpheral_course_2022/rtl_src/clk_gen_nexys.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/litedram_core.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/litedram_top.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_alu.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_bufreg.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_csr.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_ctrl.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_decode.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_mem_if.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_rf_if.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_rf_ram.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_rf_ram_if.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_rf_top.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_shift.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_state.v
  C:/workspace/Perlpheral_course_2022/rtl_src/LiteDRAM/serv_1.0.2/rtl/serv_top.v
  C:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/hdl/swerv_soc_wrapper.v
}
add_files C:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/swerv_soc.bd
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_axi_gpio_0_0/swerv_soc_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_axi_gpio_0_0/swerv_soc_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_axi_gpio_0_0/swerv_soc_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_xbar_0/swerv_soc_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_axi_iic_0_0/swerv_soc_axi_iic_0_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_axi_iic_0_0/swerv_soc_axi_iic_0_0_ooc.xdc]
set_property used_in_synthesis false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_auto_ds_0/swerv_soc_auto_ds_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_auto_ds_0/swerv_soc_auto_ds_0_clocks.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_auto_ds_0/swerv_soc_auto_ds_0_ooc.xdc]
set_property used_in_implementation false [get_files -all c:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/ip/swerv_soc_auto_pc_0/swerv_soc_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all C:/workspace/Perlpheral_course_2022/RVfpga_Soc/RVfpga_Soc.srcs/sources_1/bd/swerv_soc/swerv_soc_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/workspace/Perlpheral_course_2022/rtl_src/liteDRAM.xdc
set_property used_in_implementation false [get_files C:/workspace/Perlpheral_course_2022/rtl_src/liteDRAM.xdc]

read_xdc C:/workspace/Perlpheral_course_2022/rtl_src/rvfpga.xdc
set_property used_in_implementation false [get_files C:/workspace/Perlpheral_course_2022/rtl_src/rvfpga.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top rvfpga -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef rvfpga.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file rvfpga_utilization_synth.rpt -pb rvfpga_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
