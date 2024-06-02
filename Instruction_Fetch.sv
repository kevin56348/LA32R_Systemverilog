`include "Interfaces.vh"

module Instruction_Fetch (
    input  logic         clk,
    input  logic         rst,

    input  logic         br_taken,
    input  logic [31: 0] br_target,

    output logic [31: 0] pc,
    output logic [31: 0] inst
);
    
    logic [31: 0] next_pc;
    ram_port      read_req_data();
    ram_port      write_req();
    dram_port     dram_req_data();

    always_ff @( posedge clk ) begin
        if(rst) begin
            pc <= 32'h1bff_fffc;
        end else begin
            pc <= next_pc;
        end
    end

    always_comb begin
        if(br_taken) begin
            next_pc = br_target;
        end else begin
            next_pc = pc + 32'd4;
        end
    end

    always_comb begin
        read_req_data.valid = 1'b1;
        read_req_data.addr  = pc;

        write_req.valid = 1'b0;
        write_req.addr = 32'b0;
        write_req.data = 32'b0;

        inst = read_req_data.data;
    end

    Memory_Access iROM_Access(
        .read_req_data ( read_req_data ),
        .write_req     ( write_req     ),
        .dram_req_data ( dram_req_data )
    );  

    Instruction_ROM Instruction_ROM(
        .a             ( dram_req_data.a   ),
        .spo           ( dram_req_data.spo )
    );

endmodule