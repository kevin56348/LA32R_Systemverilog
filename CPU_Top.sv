`include "Interfaces.vh"

module Core(
    input  logic         clk,
    input  logic         rst_n,
    debug_port debug_
);

    logic         rst;

    logic         br_taken ;
    logic [31: 0] br_target;
    logic [31: 0] pc       ;
    logic [31: 0] inst     ;

    always_ff @(posedge clk)begin
        rst <= ~rst_n;
    end

    Instruction_Fetch u_if(
        .clk       ( clk       ),
        .rst       ( rst       ),
        .br_taken  ( br_taken  ),
        .br_target ( br_target ),
        .pc        ( pc        ),
        .inst      ( inst      )
    );

    logic [ 3: 0] inst_decoded;
    // regfile ports
    regfile_port         rf_r1();
    regfile_port         rf_r2();
    regfile_port         rf_w();
    // alu ports
    alu_port             alu_if();
    // memory ports
    ram_port             mem_rd();
    ram_port             mem_wr();

    Instruction_Decode u_id(
        .pc_i           ( pc            ),
        .inst_i         ( inst          ),
        .inst_decoded_o ( inst_decoded  ),
        
        .rf_r1          ( rf_r1         ),
        .rf_r2          ( rf_r2         ),
        .rf_w           ( rf_w          ),

        .alu_if         ( alu_if        ),

        .mem_rd_if      ( mem_rd        ),
        .mem_wr_if      ( mem_wr        ),

        .br_taken_o     ( br_taken      ),
        .br_target_o    ( br_target     )
    );

    logic [31: 0] alu_result;

    Execute u_exe(
        .alu_if         ( alu_if        ),
        .result         ( alu_result    )
    );

    assign mem_rd.addr = {2'b0,alu_result[15:2]};
    assign mem_wr.addr = {2'b0,alu_result[15:2]};

    dram_port             dram_req_data();

    assign rf_w.data = mem_rd.valid ? dram_req_data.spo : alu_result;

    Memory_Access u_mem(
        .read_req_data  ( mem_rd        ),
        .write_req      ( mem_wr        ),
        .dram_req_data  ( dram_req_data )
    );

    Reg_File u_rf(
        .clk            ( clk   ),
        .rst            ( rst   ),

        .read_port1     ( rf_r1 ),
        .read_port2     ( rf_r2 ),
        .write_port     ( rf_w  )
    );

    Data_RAM Data_RAM(
        .a             ( dram_req_data.a   ),
        .d             ( dram_req_data.d   ),
        .clk           ( clk               ),
        .we            ( dram_req_data.we  ),
        .spo           ( dram_req_data.spo )
    );

    assign debug_.pc = pc;

    assign debug_.rf_wport.en = rf_w.en;
    assign debug_.rf_wport.addr = rf_w.addr;
    assign debug_.rf_wport.data = rf_w.data;

    assign debug_.ram_wport.a = dram_req_data.a;
    assign debug_.ram_wport.spo = dram_req_data.spo;
    assign debug_.ram_wport.d = dram_req_data.d;
    assign debug_.ram_wport.we = dram_req_data.we;


endmodule