`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
	`include "IDC.sv"
`elsif GATE
	`include "IDC_SYN.v"
`endif

module TESTBED();

logic clk, rst_n, in_valid;
logic [5:0] in_id;

logic out_valid, out_legal_id;

initial begin
	`ifdef RTL
		$fsdbDumpfile("IDC.fsdb");
		$fsdbDumpvars(0,"+mda");
	`elsif GATE
		$fsdbDumpfile("IDC_SYN.fsdb");
		$sdf_annotate("IDC_SYN.sdf", I_IDC);
		$fsdbDumpvars(0,"+mda");
	`endif
end

IDC I_IDC
(
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_id(in_id),
	.out_valid(out_valid),
	.out_legal_id(out_legal_id)
);

PATTERN I_PATTERN
(
	.clk(clk),
	.rst_n(rst_n),
	.in_valid(in_valid),
	.in_id(in_id),
	.out_valid(out_valid),
	.out_legal_id(out_legal_id)
);
endmodule
