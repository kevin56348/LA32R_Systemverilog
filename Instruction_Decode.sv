`include "Interfaces.vh"

module Instruction_Decode(
    // inst and decode
    input  logic [31: 0] pc_i,
    input  logic [31: 0] inst_i,
    output logic [ 3: 0] inst_decoded_o,
    // regfile ports
    regfile_port.R       rf_r1,
    regfile_port.R       rf_r2,
    regfile_port.W       rf_w,
    // alu ports
    alu_port             alu_if,
    // memory ports
    ram_port             mem_rd_if,
    ram_port             mem_wr_if,
    // control ports
    output logic         br_taken_o,
    output logic [31: 0] br_target_o
    );

    logic [ 4: 0] rj;
    logic [ 4: 0] rd;

    logic [11: 0] si12;
    logic [15: 0] offs;

    logic [ 5: 0] op_31_26;
    logic [ 3: 0] op_25_22;

    logic [63: 0] op_31_26_d;
    logic [15: 0] op_25_22_d;

    logic         inst_ld_w,
                  inst_st_w,
                  inst_addi_w,
                  inst_beq;

    logic [31: 0] imm;
    logic         need_si12;
    logic         need_offs;
    logic         src_is_imm;

    logic         rf_src_is_rd;

    assign rj = inst_i[9:5];
    assign rd = inst_i[4:0];

    assign si12 = inst_i[21:10];
    assign offs = inst_i[25:10];

    assign op_31_26 = inst_i[31:26];
    assign op_25_22 = inst_i[25:22];

    one_hot_decoder#(
        .WIDTH (6)
    ) u_op_31_26(
        .in_i  ( op_31_26   ),
        .out_o ( op_31_26_d )
    );

    one_hot_decoder#(
        .WIDTH (4)
    ) u_op_25_22(
        .in_i  ( op_25_22   ),
        .out_o ( op_25_22_d )
    );

    assign inst_addi_w = op_31_26_d[6'b000000] && op_25_22_d[4'b1010];
    assign inst_ld_w   = op_31_26_d[6'b001010] && op_25_22_d[4'b0010];
    assign inst_st_w   = op_31_26_d[6'b001010] && op_25_22_d[4'b0110];
    assign inst_beq    = op_31_26_d[6'b010110];

    assign inst_decoded_o = {
        inst_addi_w,
        inst_ld_w  ,
        inst_st_w  ,
        inst_beq   
    };

    assign need_si12 = inst_addi_w 
                     || inst_ld_w
                     || inst_st_w;

    assign need_offs = inst_beq;

    assign rf_src_is_rd = inst_st_w 
                       || inst_beq;

    assign rf_r1.addr = rj;
    assign rf_r2.addr = rd;
    assign rf_w.addr = rd;
    assign rf_w.en = inst_ld_w 
                  || inst_addi_w;
    
    assign src_is_imm = inst_ld_w
                     || inst_st_w
                     || inst_addi_w;

    assign imm = {32{need_si12}} & {{20{si12[11]}}, si12}
               | {32{need_offs}} & {{14{offs[15]}}, offs, 2'b0};

    assign alu_if.src1 = rf_r1.data;
    assign alu_if.src2 = src_is_imm ? imm : rf_r2.data;
    assign alu_if.add = inst_ld_w 
                     || inst_st_w 
                     || inst_addi_w;

    assign mem_wr.valid = inst_st_w;
    assign mem_wr.data = rf_r2.data;

    assign mem_rd_if.valid = inst_ld_w;

    assign br_taken_o = inst_beq && rf_r1.data==rf_r2.data;
    assign br_target_o = pc_i + imm;

endmodule

module one_hot_decoder #(
    parameter WIDTH = 6
) (
    input  logic [   WIDTH - 1: 0] in_i,
    output logic [2**WIDTH - 1: 0] out_o
);

    genvar i;
    generate
        for (i = 0; i < 2**WIDTH; i = i + 1) begin
            assign out_o[i] = in_i == i;
        end
    endgenerate

endmodule