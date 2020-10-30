import cv32e40p_apu_core_pkg::*;

typedef enum int {UNKNOWN_INSTR, ADD_INSTR, ADDI_INSTR, AND_INSTR, ANDI_INSTR, AUIPC_INSTR, BEQ_INSTR, BGE_INSTR, BGEU_INSTR, BLT_INSTR, BLTU_INSTR, BNE_INSTR, CSRRC_INSTR, CSRRCI_INSTR, CSRRS_INSTR, CSRRSI_INSTR, CSRRW_INSTR, CSRRWI_INSTR, EBREAK_INSTR, ECALL_INSTR, FENCE_INSTR, FENCEI_INSTR, JAL_INSTR, JALR_INSTR, LB_INSTR, LBU_INSTR, LH_INSTR, LHU_INSTR, LUI_INSTR, LW_INSTR, MRET_INSTR, OR_INSTR, ORI_INSTR, SB_INSTR, SFENCEVMA_INSTR, SH_INSTR, SLL_INSTR, SLLI_INSTR, SLT_INSTR, SLTI_INSTR, SLTIU_INSTR, SLTU_INSTR, SRA_INSTR, SRAI_INSTR, SRET_INSTR, SRL_INSTR, SRLI_INSTR, SUB_INSTR, SW_INSTR, URET_INSTR, WFI_INSTR, XOR_INSTR, XORI_INSTR} Instr_t;

module top #(
  parameter PULP_XPULP          =  0,                   // PULP ISA Extension (incl. custom CSRs and hardware loop, excl. p.elw)
  parameter PULP_CLUSTER        =  0,                   // PULP Cluster interface (incl. p.elw)
  parameter FPU                 =  0,                   // Floating Point Unit (interfaced via APU interface)
  parameter PULP_ZFINX          =  0,                   // Float-in-General Purpose registers
  parameter NUM_MHPMCOUNTERS    =  0
)
(
  // Clock and Reset
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic        pulp_clock_en_i,                  // PULP clock enable (only used if PULP_CLUSTER = 1)
  input  logic        scan_cg_en_i,                     // Enable all clock gates for testing

  // Core ID, Cluster ID, debug mode halt address and boot address are considered more or less static
  input  logic [31:0] boot_addr_i,
  input  logic [31:0] mtvec_addr_i,
  input  logic [31:0] dm_halt_addr_i,
  input  logic [31:0] hart_id_i,
  input  logic [31:0] dm_exception_addr_i,

  // Instruction memory interface
  output logic        instr_req_o,
  input  logic        instr_gnt_i,
  input  logic        instr_rvalid_i,
  output logic [31:0] instr_addr_o,
  input  logic [31:0] instr_rdata_i,

  // Data memory interface
  output logic        data_req_o,
  input  logic        data_gnt_i,
  input  logic        data_rvalid_i,
  output logic        data_we_o,
  output logic [3:0]  data_be_o,
  output logic [31:0] data_addr_o,
  output logic [31:0] data_wdata_o,
  input  logic [31:0] data_rdata_i,

  // apu-interconnect
  // handshake signals
  output logic                           apu_req_o,
  input logic                            apu_gnt_i,
  // request channel
  output logic [APU_NARGS_CPU-1:0][31:0] apu_operands_o,
  output logic [APU_WOP_CPU-1:0]         apu_op_o,
  output logic [APU_NDSFLAGS_CPU-1:0]    apu_flags_o,
  // response channel
  input logic                            apu_rvalid_i,
  input logic [31:0]                     apu_result_i,
  input logic [APU_NUSFLAGS_CPU-1:0]     apu_flags_i,

  // Interrupt inputs
  input  logic [31:0] irq_i,                    // CLINT interrupts + CLINT extension interrupts
  output logic        irq_ack_o,
  output logic [4:0]  irq_id_o,

  // Debug Interface
  input  logic        debug_req_i,


  // CPU Control Signals
  input  logic        fetch_enable_i,
  output logic        core_sleep_o,

  // Verification related signals
  input                            IF_tcnt_inc,
  input                            ID_tcnt_inc,
  input                            EX_tcnt_inc,
  input                            ME_tcnt_inc,
  input                            WB_tcnt_inc,

  input                            tl_IF_tx_wait,
  input                            tl_ID_rx_wait,
  input                            tl_ID_tx_wait,
  input                            tl_EX_rx_wait,
  input                            tl_EX_tx_wait,
  input                            tl_ME_rx_wait,
  input                            tl_ME_tx_wait,
  input                            tl_WB_rx_wait,
  input                            tl_WB_tx_wait,

  input                            t2_IF_tx_wait,
  input                            t2_ID_rx_wait,
  input                            t2_ID_tx_wait,
  input                            t2_EX_rx_wait,
  input                            t2_EX_tx_wait,
  input                            t2_ME_rx_wait,
  input                            t2_ME_tx_wait,
  input                            t2_WB_rx_wait,
  input                            t2_WB_tx_wait,

  // For debugging
  input Instr_t IF_instr_enum,
  input Instr_t ID_instr_enum,
  input Instr_t EX_instr_enum,
  input Instr_t ME_instr_enum,
  input Instr_t WB_instr_enum
);


  logic [5:0] IF_tcnt;
  logic [5:0] ID_tcnt;
  logic [5:0] EX_tcnt;
  logic [5:0] ME_tcnt;
  logic [5:0] WB_tcnt;


  always_ff @(posedge clk_i)
  begin
    if (IF_tcnt_inc)
    begin
      IF_tcnt <= $size(IF_tcnt)'($size(IF_tcnt+1)'(IF_tcnt)+1);
    end
    if (ID_tcnt_inc)
    begin
      ID_tcnt <= IF_tcnt;
    end
    if (EX_tcnt_inc)
    begin
      EX_tcnt <= ID_tcnt;
    end
    if (ME_tcnt_inc)
    begin
      ME_tcnt <= EX_tcnt;
    end
    if (WB_tcnt_inc)
    begin
      WB_tcnt <= ME_tcnt;
    end
  end


  cv32e40p_core #(
    .PULP_XPULP            ( PULP_XPULP            ),
    .PULP_CLUSTER          ( PULP_CLUSTER          ),
    .FPU                   ( FPU                   ),
    .PULP_ZFINX            ( PULP_ZFINX            ),
    .NUM_MHPMCOUNTERS      ( NUM_MHPMCOUNTERS      ))
  c (
    .*
  );

endmodule

