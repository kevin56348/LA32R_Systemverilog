`include "Interfaces.vh"

module tb_;
reg clk;
reg rst_n;

debug_port debug_if();

integer file_handle;

initial begin
    file_handle = $fopen("../../../golden_trace.txt", "w");
    clk = 0;
    rst_n = 0;
    #2000 
    rst_n = 1;
end

always #5 clk = ~clk;


Core cpu
(
    .clk   ( clk   ),
    .rst_n ( rst_n ),

    .debug_ (debug_if)
);


always_ff @( posedge clk ) begin : record
    if(rst_n)begin
        if(debug_if.pc==32'h1c000144)begin
            $fclose(file_handle);
            $finish();
        end else if(debug_if.rf_wport.en && debug_if.rf_wport.addr!=0 || debug_if.ram_wport.we)begin
            $fdisplay(file_handle, 
                        "%h %h %h %h %h %h %h",
                        debug_if.pc,
                        debug_if.rf_wport.en, debug_if.rf_wport.addr, debug_if.rf_wport.data,
                        debug_if.ram_wport.we, debug_if.ram_wport.a, debug_if.ram_wport.d);
        end
    end
end

endmodule