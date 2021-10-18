`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2021 14:46:22
// Design Name: 
// Module Name: tb_chenille
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_chenille;

	// Inputs
	reg clock_in;
	reg reset;
	reg stop;
	reg load_mem;
	reg load_sw;
	reg [7:0] sw;
	reg save;

	// Outputs
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	chenille uut (
		.clock_in(clock_in), 
		.reset(reset),		
		.stop(stop), 
		.load_mem(load_mem),
		.load_sw(load_sw),
		.sw(sw),
		.save(save),
		.led(led)
	);
	
	initial begin
		clock_in = 0;
		forever #5 clock_in = ~clock_in;
	end

	initial begin
		// Initialize Inputs
		reset = 0;
		stop = 0;
		load_mem = 0;
		load_sw = 0;
		sw = 0;
		save = 0;

		// Wait 100 ns for global reset to finish
		#100
        
		// Add stimulus here
		sw = 8'b10110011;
		#50 load_sw = 1;
		#10 load_sw = 0;
		#5 save = 1;
		#25 save = 0;
		#100 stop = 1;
		#25 stop = 0;
		#100 load_mem = 1;
		#25 load_mem = 0;
		#100 stop = 1;
		#25 stop = 0;
		#100 stop = 1;
		#25 save = 0;
		#100 stop = 0; reset = 1;
		#25 reset = 0;
	end
      
endmodule
