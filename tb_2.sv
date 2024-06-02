`include "Interfaces.vh"

module tb_2;
reg clk;
reg rst_n;

debug_port debug_if();
debug_port trace_if();

integer file_handle;

initial begin
    file_handle = $fopen("../../../golden_trace.txt", "r");
    clk = 0; 
    rst_n = 0;
    #2000
    rst_n = 1;
end

always #5 clk = !clk;

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
            $display("=====================================");
            $display("================PASS=================");
            $display("=====================================");
            $finish();
        end else if(debug_if.rf_wport.en && debug_if.rf_wport.addr!=0 || debug_if.ram_wport.we)begin
            $fscanf(file_handle, 
                        "%h %h %h %h %h %h %h",
                        trace_if.pc,
                        trace_if.rf_wport.en, trace_if.rf_wport.addr, trace_if.rf_wport.data,
                        trace_if.ram_wport.we, trace_if.ram_wport.a, trace_if.ram_wport.d);
            if(debug_if.pc!=trace_if.pc || debug_if.rf_wport.en!=trace_if.rf_wport.en || debug_if.rf_wport.en && (debug_if.rf_wport.addr!=trace_if.rf_wport.addr || debug_if.rf_wport.data!=trace_if.rf_wport.data) || debug_if.ram_wport.we!=trace_if.ram_wport.we || debug_if.ram_wport.we && (debug_if.ram_wport.a!=trace_if.ram_wport.a || debug_if.ram_wport.spo!=trace_if.ram_wport.spo || debug_if.ram_wport.d!=trace_if.ram_wport.d ))begin
                $display("=====================================");
                $display("Something is wrong!!!");
                $display("\tpc=%h, trace=%h", debug_if.pc, trace_if.pc);
                $display("\trf_en=%h, trace=%h", debug_if.rf_wport.en, trace_if.rf_wport.en);
                $display("\trf_waddr=%h, trace=%h", debug_if.rf_wport.addr, trace_if.rf_wport.addr);
                $display("\trf_wdata=%h, trace=%h", debug_if.rf_wport.data, trace_if.rf_wport.data);
                $display("\tram_we=%h, trace=%h", debug_if.ram_wport.we, trace_if.ram_wport.we);
                $display("\tram_waddr=%h, trace=%h", debug_if.ram_wport.a, trace_if.ram_wport.a);
                $display("\tram_wdata=%h, trace=%h", debug_if.ram_wport.d, trace_if.ram_wport.d);
                $display("=====================================");
                $fclose(file_handle);
                $finish();
            end
        end
    end
end

endmodule