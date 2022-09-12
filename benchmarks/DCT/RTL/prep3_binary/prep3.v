/*
** prep3.v
**
** prep benchmark 3 -- small state machine
** benchmark suite #1 -- version 1.2 -- March 28, 1993
** Programmable Electronics Performance Corporation
**
** binary state assignment -- highly encoded
*/

module prep3 (clk, rst, in, out) ;
	input clk, rst ;
	input [7:0] in ;
	output [7:0] out ;

	// synopsys enum code
	parameter [2:0] 
 		START = 3'd0 ,
 		SA = 3'd1 ,
 		SB = 3'd2 ,
 		SC = 3'd3 ,
 		SD = 3'd4 ,
 		SE = 3'd5 ,
 		SF = 3'd6 ,
 		SG = 3'd7 ;

// synopsys state_vector state
	// synopsys enum code
	reg [2:0] state/*verilator public*/;
	reg [2:0] next_state ;
	reg [7:0] out, next_out ;

	always @ (in or state) 
		begin
 		// default values
 		next_state = START ;
 		next_out = 8'bx ;

 		// state machine
 		case (state) // synopsys parallel_case full_case
 			START:
 				if (in == 8'h3c) //60
					begin
 					next_state = SA ;
					next_out = 8'h82 ;
 					end
 				else	begin
 					next_state = START ;
 					next_out = 8'h00 ;
 					end
 			SA:
 				case (in) // synopsys parallel_case full_case
 					8'h2a: //42
 					begin
 					next_state = SC ;
 					next_out = 8'h40 ;
 					end

 					8'h1f: //31
 					begin
 					next_state = SB ;
 					next_out = 8'h20 ;
 					end

 					default:
 					begin
 					next_state = SA ;
 					next_out = 8'h04 ;
 					end
				endcase
  			SB:
 				if (in == 8'haa) //170
					begin
 					next_state = SE ;
 					next_out = 8'h11 ;
 					end
 				else	begin
 					next_state = SF ;
 					next_out = 8'h30 ;
 					end
 			SC:
 				begin
 				next_state = SD ;//original SD
 				next_out = 8'h08 ;
 				end
 			SD:
 				begin
 				next_state = SG ;
 				next_out = 8'h80 ;
 				end
 			SE:
 				begin
 				next_state = START ;
 				next_out = 8'h40 ;
 				end
 			SF:
 				begin
 				next_state = SG ;
 				next_out = 8'h02 ;
 				end
 			SG:
 				begin
 				next_state = START ;
 				next_out = 8'h01 ;
 				end
 		endcase
		end

// build the state flops
	always @ (posedge clk or negedge rst)
 	begin
 		if (!rst) state <= START ;
 		else state <= next_state ;
 	end

// build the output flops
	always @ (posedge clk or negedge rst)
 	begin
 		if (!rst) out <= 8'b0 ;
 		else out <= next_out ;
 		end

endmodule
