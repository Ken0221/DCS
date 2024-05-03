`timescale 1ns/1ps
`include "PATTERN.sv"
`ifdef RTL
	`include "ME.sv"
`elsif GATE
	`include "ME_SYN.v"
`endif

module TESTBED();

logic clk, rst_n, area_valid, block_valid;
logic [7:0] in_data;

logic out_valid;
logic signed [2:0] out_vector;


initial begin
	`ifdef RTL
		//$fsdbDumpfile("ME.fsdb");
		//$fsdbDumpvars(0,"+mda");
	`elsif GATE
		//$fsdbDumpfile("ME_SYN.fsdb");
		$sdf_annotate("ME_SYN.sdf", I_design);
		//$fsdbDumpvars(0,"+mda");
	`endif
end

ME I_design
(
	.clk(clk),
	.rst_n(rst_n),
	.area_valid(area_valid),
	.block_valid(block_valid),
	.in_data(in_data),
	.out_valid(out_valid),
	.out_vector(out_vector)
);

PATTERN I_PATTERN
(
	.clk(clk),
	.rst_n(rst_n),
	.area_valid(area_valid),
	.block_valid(block_valid),
	.in_data(in_data),
	.out_valid(out_valid),
	.out_vector(out_vector)
);
endmodule
