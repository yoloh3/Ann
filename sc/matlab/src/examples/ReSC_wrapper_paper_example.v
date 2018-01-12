/*
 * This file was generated by the scsynth tool, and is availablefor use under
 * the MIT license. More information can be found at
 * https://github.com/arminalaghi/scsynth/
 */
module ReSC_wrapper_paper_example( //handles stochastic/binary conversion for ReSC
	input [9:0] x_bin, //binary value of input
	input start, //signal to start counting
	output reg done, //signal that a number has been computed 
	output reg [9:0] z_bin, //binary value of output

	input clk,
	input reset
);

	//the weights of the Bernstein polynomial
	reg [9:0] w0_bin = 10'd256;
	reg [9:0] w1_bin = 10'd640;
	reg [9:0] w2_bin = 10'd384;
	reg [9:0] w3_bin = 10'd768;

	wire [2:0] x_stoch;
	wire [3:0] w_stoch;
	wire z_stoch;
	wire init;
	wire running;

	//RNGs for binary->stochastic conversion
	wire [9:0] randx0;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_0 (
		.seed (10'd0),
		.data (randx0),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[0] = randx0 < x_bin;

	wire [9:0] randx1;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_1 (
		.seed (10'd146),
		.data (randx1),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[1] = randx1 < x_bin;

	wire [9:0] randx2;
	LFSR_10_bit_added_zero_paper_example rand_gen_x_2 (
		.seed (10'd293),
		.data (randx2),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign x_stoch[2] = randx2 < x_bin;

	wire [9:0] randw;
	LFSR_10_bit_added_zero_paper_example rand_gen_w (
		.seed (10'd683),
		.data (randw),
		.enable (running),
		.restart (init),
		.clk (clk),
		.reset (reset)
	);
	assign w_stoch[0] = randw < w0_bin;

	assign w_stoch[1] = randw < w1_bin;

	assign w_stoch[2] = randw < w2_bin;

	assign w_stoch[3] = randw < w3_bin;

	ReSC_paper_example ReSC (
		.x (x_stoch),
		.w (w_stoch),
		.z (z_stoch)
	);

	reg [9:0] count; //count clock cycles
	wire [9:0] neg_one;
	assign neg_one = -1;

	//Finite state machine. States:
	//0: finished, in need of resetting
	//1: initialized, start counting when start signal falls
	//2: running
	reg [1:0] cs; //current FSM state
	reg [1:0] ns; //next FSM state
	assign init = cs == 1;
	assign running = cs == 2;

	always @(posedge clk or posedge reset) begin
		if (reset) cs <= 0;
		else begin
			cs <= ns;
			if (running) begin
				if (count == neg_one) done <= 1;
				count <= count + 1;
				z_bin <= z_bin + z_stoch;
			end
		end
	end

	always @(*) begin
		case (cs)
			0: if (start) ns = 1; else ns = 0;
			1: if (start) ns = 1; else ns = 2;
			2: if (done) ns = 0; else ns = 2;
			default ns = 0;
		endcase
	end

	always @(posedge init) begin
		count <= 0;
		z_bin <= 0;
		done <= 0;
	end
endmodule
