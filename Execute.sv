`include "Interfaces.vh"

module Execute (
    alu_port             alu_if,
    output logic [31: 0] result
);
    logic [31: 0] add_result;

    assign add_result = alu_if.src1 + alu_if.src2;

    assign result = {32{alu_if.add}} & add_result;
endmodule