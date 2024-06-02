interface ram_port;
    logic         valid;
    logic [31: 0] addr;
    logic [31: 0] data;

    modport R (
        input  valid,
        input  addr,
        output data
    );

    modport W (
        input  valid,
        input  addr,
        input  data
    );

endinterface //ram_port

interface dram_port;
    logic [15: 0] a;
    logic [31: 0] spo;
    logic [31: 0] d;
    logic         we;
endinterface //dram_port

interface regfile_port;
    logic         en;
    logic [ 4: 0] addr;
    logic [31: 0] data;

    modport R (
        input  addr,
        output data
    );

    modport W (
        input  en,
        input  addr,
        input  data
    );

endinterface //regfile_port

interface debug_port;
    logic [31: 0] pc;
    regfile_port  rf_wport();
    dram_port     ram_wport();
endinterface //debug_portmodule tb_;

interface alu_port;
    logic [31: 0] src1;
    logic [31: 0] src2;
    logic         add;
endinterface