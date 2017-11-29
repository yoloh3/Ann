`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Kyushu Institute of Technology
// Engineer: DSP Lab
// 
// Create Date:    13:48:25 09/06/2017 
// Design Name: Neural Network (using backpropagation)
// Module Name:    mem test bench
// Project Name: LSI Design Contest in Okinawa 2018
// Target Devices: 
// Tool versions: 
//
// Description: 
// 	Test bench for memory with input 8 bits and output 16 bits
// 
// Test scenario:
//		insert the address value.
// 	output value (dout) is stated at every end of the input
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Name : date : what changed
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mem_tb;
	//parameter
	parameter clk_period=1000;		
	// Inputs
	reg clk;
	reg din;
	reg signed [7:0] addr;

	// Outputs
	wire [31:0] dout;

	// Instantiate the Unit Under Test (UUT)
	mem uut (
		.clk(clk), 
		.din(din),
		.addr(addr), 
		.dout(dout)
	);
	
	//generate
	always begin
		clk=0;
		#(clk_period/2) clk=1;
		#(clk_period/2);
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		din = 1;
		addr = 0;
        
		// Add stimulus here
		#(clk_period)   addr=8'b0010_1111; 		//dout = b0000_0000_1111_0011_0001_1101_1000_1000
		#(clk_period)   addr=8'b0101_0110; 		//dout = b0000_0000_1111_1110_1101_0001_1110_1000
		#(clk_period)	 addr=8'b0100_1001;		//dout = b0000_0000_1111_1101_0101_1011_0010_0010
		#(clk_period)	 addr=8'b0001_1100; 		//dout = b0000_0000_1101_1010_0001_1001_1001_0100
		#(clk_period)	 addr=8'b0011_1110;		//dout = b0000_0000_1111_1010_1100_1011_1000_0000
		#(clk_period)	 addr=8'b0100_0100;		//dout = b0000_0000_1111_1100_0110_0110_0101_0011
		#(clk_period)   addr=8'b0010_1011; 		//dout = b0000_0000_1110_1111_1011_0000_0110_0000
		#(clk_period)   addr=8'b0100_0111; 		//dout = b0000_0000_1111_1101_0000_0010_0001_0000
		#(clk_period)	 addr=8'b0010_1100;		//dout = b0000_0000_1111_0000_1001_1110_0010_1001
		#(clk_period)	 addr=8'b0001_0111; 		//dout = b0000_0000_1100_1110_1101_1101_0111_1110
		#(clk_period)	 addr=8'b0010_1111;		//dout = b0000_0000_1111_0011_0001_1101_1000_1000
		#(clk_period)	 addr=8'b0010_0111;		//dout = b0000_0000_1110_1011_0110_1101_1011_0001

		#(clk_period) $finish; 
	end
      //•\Ž¦
		always@(dout)
			$display( $time, " clk= %b din=%d addr=%d dout=%b", 
											clk, din, addr, dout);
endmodule

