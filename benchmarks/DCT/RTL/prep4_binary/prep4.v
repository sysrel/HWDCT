/*
** prep4.v
**
** prep benchmark 4 -- large state machine
** benchmark suite #1 -- version 1.2 -- March 28, 1993
** Programmable Electronics Performance Corporation
**
** binary state assignment -- highly encoded
*/
module prep4 (clk, rst, in, out) ;
input clk, rst ;
input [7:0] in ;
output [7:0] out ;
parameter [3:0] // synopsys enum code
 S0 = 4'd0 , S1 = 4'd1 , S2 = 4'd2 , S3 = 4'd3 ,
 S4 = 4'd4 , S5 = 4'd5 , S6 = 4'd6 , S7 = 4'd7 ,
 S8 = 4'd8 , S9 = 4'd9 , S10 = 4'd10 , S11 = 4'd11 ,
 S12 = 4'd12 , S13 = 4'd13 , S14 = 4'd14 , S15 = 4'd15 ;
// synopsys state_vector state
reg [3:0]  state/*verilator public*/; 
reg [3:0]  next_state ;
reg [7:0] out ;
// state machine
always @ (in or state) begin
 // default value
 next_state = S0 ; // always overridden
 case (state) // synopsys parallel_case full_case
 S0: case(1'b1) // synopsys parallel_case full_case
 (in == 8'd0): next_state = S0 ;
 (8'd0 < in && in < 8'd4): next_state = S1 ;
 (8'd3 < in && in < 8'd32): next_state = S2 ;
 (8'd31 < in && in < 8'd64): next_state = S3 ;
 (in > 8'd63): next_state = S4 ;
 endcase
 S1: if (in[0] && in[1]) next_state = S0 ;
 else next_state = S3 ;
 S2: next_state = S3 ;
 S3: next_state = S5 ;
 S4: if (in[0] || in[2] || in[4]) next_state = S5 ;
 else next_state = S6 ;
 S5: if (in[0] == 1'b0) next_state = S5 ;
 else next_state = S7 ;
 S6: case(in[7:6]) // synopsys parallel_case full_case
 2'b11: next_state = S1 ;
 2'b00: next_state = S6 ;
 2'b01: next_state = S8 ;
 2'b10: next_state = S9 ;
 endcase
 S7: case(in[7:6]) // synopsys parallel_case full_case
 2'b00: next_state = S3 ;
 2'b11: next_state = S4 ;
 2'b10,
 2'b01: next_state = S7 ;
 endcase
 S8: if(in[4] ^ in[5]) next_state = S11 ;
 else if (in[7]) next_state = S1 ;
 else next_state = S8 ;
 S9: if (in[0] == 1'b0) next_state = S9 ;
 else next_state = S11 ;
 S10: next_state = S1 ;
 S11: if (in == 8'd64) next_state = S15 ;
 else next_state = S8 ;
 S12: if (in == 8'd255) next_state = S0 ;
 else next_state = S12 ;
 S13: if (in[1] ^ in[3] ^ in[5]) next_state = S12 ;
 else next_state = S14 ;
 S14: case(1'b1) // synopsys parallel_case full_case
(in == 8'd0): next_state = S14 ;
(8'd0 < in && in < 8'd64): next_state = S12 ;
(in > 8'd63): next_state = S10 ;
 endcase
 S15: if (in[7] == 1'b0) next_state = S15 ;
 else
 case (in[1:0])
 // synopsys parallel_case full_case
 2'b11: next_state = S0 ;
 2'b01: next_state = S10 ;
 2'b10: next_state = S13 ;
 2'b00: next_state = S14 ;
 endcase
 endcase
 end
// outputs
always @ (state) begin
 // default value
 out = 8'bx ;
 case (state) // synopsys parallel_case full_case
 S0: out = 8'b00000000 ;
 S1: out = 8'b00000110 ;
 S2: out = 8'b00011000 ;
 S3: out = 8'b01100000 ;
 S4: begin
 out[7] = 1'b1 ; out[0] = 1'b0 ;
 end
 S5: begin
 out[6] = 1'b1 ; out[1] = 1'b0 ;
 end
 S6: out = 8'b00011111 ;
 S7: out = 8'b00111111 ;
 S8: out = 8'b01111111 ;
 S9: out = 8'b11111111 ;
 S10: begin
 out[6] = 1'b1 ; out[4] = 1'b1 ;
 out[2] = 1'b1 ; out[0] = 1'b1 ;
 end
 S11: begin
 out[7] = 1'b1 ; out[5] = 1'b1 ;
 out[3] = 1'b1 ; out[1] = 1'b1 ;
 end
 S12: out = 8'b11111101 ;
 S13: out = 8'b11110111 ;
 S14: out = 8'b11011111 ;
 S15: out = 8'b01111111 ;
 endcase
 end
// build the state flops
always @ (posedge clk or negedge rst)
 begin
 if (!rst) state <= #1 S0 ;
 else state <= #1 next_state ;
 end
endmodule
