module Reg_File(
    input  logic         clk,
    input  logic         rst,

    regfile_port.R       read_port1,
    regfile_port.R       read_port2,
    regfile_port.W       write_port
);

    // R0 is always zero
    logic [31: 0] R [31: 0];

    always_ff @( posedge clk ) begin : regfile
        if(write_port.en)
            R[write_port.addr] <= write_port.data;
    end

    assign read_port1.data = read_port1.addr==0 ? 32'b0 : R[read_port1.addr];
    assign read_port2.data = read_port2.addr==0 ? 32'b0 : R[read_port2.addr];

endmodule