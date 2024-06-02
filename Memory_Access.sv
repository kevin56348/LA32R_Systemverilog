module Memory_Access(
    ram_port.R            read_req_data,
    ram_port.W            write_req,

    dram_port             dram_req_data
);

    // it can not read and write at the same time.
    // lower 16 bits are valid address
    assign dram_req_data.a = write_req.valid ? {2'b0,write_req.addr[15:2]}  // write valid, ignore rvalid
                                             : {2'b0,read_req_data.addr[15:2]}; // write invalid, ignore rvalid
    assign dram_req_data.d = write_req.data;
    assign dram_req_data.we = write_req.valid;
    assign read_req_data.data = dram_req_data.spo;

endmodule
