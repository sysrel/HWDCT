/* Generated by Yosys 0.9+3882 (git sha1 beeaad1, clang 3.8.0-2ubuntu4 -fPIC -Os) */

(* top =  1  *)
(* src = "prep4.v:10.1-121.10" *)
module prep4(clk, rst, in, out);
  wire _000_;
  wire _001_;
  wire _002_;
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
  wire _085_;
  wire _086_;
  wire _087_;
  wire _088_;
  wire _089_;
  wire _090_;
  wire _091_;
  wire _092_;
  wire _093_;
  wire _094_;
  wire _095_;
  wire _096_;
  wire _097_;
  wire _098_;
  wire _099_;
  wire _100_;
  wire _101_;
  wire _102_;
  wire _103_;
  wire _104_;
  wire _105_;
  wire _106_;
  wire _107_;
  wire _108_;
  wire _109_;
  wire _110_;
  wire _111_;
  wire _112_;
  wire _113_;
  wire _114_;
  wire _115_;
  wire _116_;
  wire _117_;
  wire _118_;
  wire _119_;
  wire _120_;
  wire _121_;
  wire _122_;
  wire _123_;
  wire _124_;
  wire _125_;
  wire _126_;
  wire _127_;
  wire _128_;
  wire _129_;
  wire _130_;
  wire _131_;
  wire _132_;
  wire _133_;
  wire _134_;
  wire _135_;
  wire _136_;
  wire _137_;
  wire _138_;
  wire _139_;
  wire _140_;
  wire _141_;
  wire _142_;
  wire _143_;
  wire _144_;
  wire _145_;
  wire _146_;
  wire _147_;
  wire _148_;
  wire _149_;
  wire _150_;
  wire _151_;
  wire _152_;
  wire _153_;
  wire _154_;
  wire _155_;
  wire _156_;
  wire _157_;
  wire _158_;
  wire _159_;
  wire _160_;
  wire _161_;
  wire _162_;
  wire _163_;
  wire _164_;
  wire _165_;
  wire _166_;
  wire _167_;
  wire _168_;
  wire _169_;
  wire _170_;
  wire _171_;
  wire _172_;
  wire _173_;
  wire _174_;
  wire _175_;
  wire _176_;
  wire _177_;
  wire _178_;
  wire _179_;
  wire _180_;
  wire _181_;
  wire _182_;
  wire _183_;
  wire _184_;
  wire _185_;
  wire _186_;
  wire _187_;
  wire _188_;
  (* src = "prep4.v:11.7-11.10" *)
  input clk;
  (* src = "prep4.v:12.13-12.15" *)
  input [7:0] in;
  (* src = "prep4.v:20.43-20.53" *)
  wire [3:0] next_state;
  (* src = "prep4.v:13.14-13.17" *)
  output [7:0] out;
  (* src = "prep4.v:11.12-11.15" *)
  input rst;
  (* src = "prep4.v:20.36-20.41" *)
  reg [3:0] state/*verilator public*/;
  assign _123_ = state[0] & state[1];
  assign _124_ = ~(state[2] | state[3]);
  assign _125_ = _124_ & _123_;
  assign _126_ = state[2] & state[3];
  assign _127_ = _126_ & _123_;
  assign _128_ = _127_ | _125_;
  assign _129_ = state[1] & ~(state[0]);
  assign _130_ = _129_ & _126_;
  assign _131_ = state[1] | ~(state[0]);
  assign _132_ = _126_ & ~(_131_);
  assign _133_ = _132_ | _130_;
  assign _134_ = _133_ | _128_;
  assign _135_ = ~(state[0] | state[1]);
  assign _136_ = _135_ & _126_;
  assign _137_ = state[2] | ~(state[3]);
  assign _138_ = ~(_137_ | _131_);
  assign _139_ = _138_ | _136_;
  assign _140_ = _135_ & ~(_137_);
  assign _141_ = state[3] | ~(state[2]);
  assign _142_ = ~(_141_ | _131_);
  assign _143_ = _142_ | _140_;
  assign _144_ = _143_ | _139_;
  assign _145_ = _144_ | _134_;
  assign _146_ = _129_ & ~(_137_);
  assign out[6] = _146_ | _145_;
  assign _147_ = _130_ | _127_;
  assign _148_ = _136_ | _132_;
  assign _149_ = _148_ | _147_;
  assign _150_ = _140_ | _138_;
  assign _151_ = _123_ & ~(_141_);
  assign _152_ = _129_ & ~(_141_);
  assign _153_ = _152_ | _151_;
  assign _154_ = _153_ | _150_;
  assign _155_ = _154_ | _149_;
  assign out[0] = _155_ | _146_;
  assign out[5] = state[1] ? state[0] : state[3];
  assign _156_ = _129_ & _124_;
  assign _157_ = _156_ | _127_;
  assign _158_ = _157_ | _133_;
  assign _159_ = _151_ | _140_;
  assign _160_ = _159_ | _139_;
  assign _161_ = _160_ | _158_;
  assign _162_ = _152_ | _146_;
  assign out[4] = _162_ | _161_;
  assign _163_ = _123_ & ~(_137_);
  assign _164_ = _163_ | _138_;
  assign _165_ = _159_ | _164_;
  assign _166_ = _124_ & ~(_131_);
  assign _167_ = _166_ | _127_;
  assign _168_ = _167_ | _133_;
  assign _169_ = _168_ | _165_;
  assign out[1] = _169_ | _152_;
  assign _170_ = _168_ | _160_;
  assign out[2] = _170_ | _162_;
  assign _171_ = _136_ | _130_;
  assign _172_ = _171_ | _157_;
  assign _173_ = _172_ | _165_;
  assign out[3] = _173_ | _152_;
  assign _174_ = in[5] | in[6];
  assign _175_ = _174_ | in[7];
  assign _176_ = in[1] | in[0];
  assign _177_ = in[3] | in[2];
  assign _178_ = ~(_177_ | _176_);
  assign _085_ = in[6] | in[7];
  assign _179_ = _175_ & ~(_085_);
  assign _180_ = in[4] | in[5];
  assign _181_ = _085_ | _180_;
  assign _182_ = _178_ & ~(_181_);
  assign _183_ = in[3] | ~(in[2]);
  assign _184_ = _183_ | _176_;
  assign _185_ = _184_ & _177_;
  assign _186_ = _185_ | _181_;
  assign _187_ = ~(_184_ | _181_);
  assign _188_ = ~(_187_ | _186_);
  assign _000_ = _188_ & ~(_182_);
  assign _001_ = _000_ | _179_;
  assign _002_ = ~(_179_ | _085_);
  assign _003_ = _177_ | _180_;
  assign _004_ = _003_ | _085_;
  assign _005_ = in[4] | ~(in[5]);
  assign _006_ = _005_ | _085_;
  assign _007_ = _178_ & ~(_006_);
  assign _008_ = _085_ | in[5];
  assign _009_ = _008_ | _007_;
  assign _010_ = _004_ & ~(_009_);
  assign _011_ = _010_ | _000_;
  assign _012_ = _002_ & ~(_011_);
  assign _013_ = _001_ & ~(_012_);
  assign _014_ = _163_ | _146_;
  assign _015_ = _014_ | _150_;
  assign _016_ = ~(_015_ | _149_);
  assign _017_ = _135_ & ~(_141_);
  assign _018_ = _017_ | _142_;
  assign _019_ = _018_ | _153_;
  assign _020_ = _156_ | _125_;
  assign _021_ = _020_ | _166_;
  assign _022_ = _021_ | _019_;
  assign _023_ = _016_ & ~(_022_);
  assign _024_ = in[1] & ~(in[0]);
  assign _025_ = in[7] & ~(_024_);
  assign _026_ = _127_ & ~(_025_);
  assign _027_ = in[7] | ~(in[6]);
  assign _028_ = _027_ | _180_;
  assign _029_ = _028_ | ~(_178_);
  assign _030_ = _163_ & ~(_029_);
  assign _031_ = _030_ | _146_;
  assign _032_ = ~(in[4] ^ in[5]);
  assign _033_ = _032_ & ~(in[7]);
  assign _034_ = _140_ & ~(_033_);
  assign _035_ = _034_ | _138_;
  assign _036_ = _035_ | _031_;
  assign _037_ = _036_ | _026_;
  assign _038_ = in[6] & in[7];
  assign _039_ = _151_ & ~(_038_);
  assign _040_ = in[6] | ~(in[7]);
  assign _041_ = _040_ & ~(_038_);
  assign _042_ = _152_ & ~(_041_);
  assign _043_ = _042_ | _039_;
  assign _044_ = in[2] | in[0];
  assign _045_ = _044_ | in[4];
  assign _046_ = _045_ & _017_;
  assign _047_ = _046_ | _142_;
  assign _048_ = _047_ | _043_;
  assign _049_ = in[1] & in[0];
  assign _050_ = _166_ & ~(_049_);
  assign _051_ = _050_ | _020_;
  assign _052_ = _051_ | _048_;
  assign _053_ = _052_ | _037_;
  assign next_state[0] = _023_ ? _013_ : _053_;
  assign _054_ = _010_ | _179_;
  assign _055_ = _054_ & ~(_012_);
  assign _056_ = ~(in[1] & in[0]);
  assign _057_ = in[0] & ~(in[1]);
  assign _058_ = _176_ & ~(_057_);
  assign _059_ = _056_ & ~(_058_);
  assign _060_ = in[7] & ~(_059_);
  assign _061_ = _127_ & ~(_060_);
  assign _062_ = ~(_182_ | _085_);
  assign _063_ = _062_ & ~(_085_);
  assign _064_ = _130_ & ~(_063_);
  assign _065_ = _064_ | _061_;
  assign _066_ = in[3] ^ in[1];
  assign _067_ = _066_ ^ in[5];
  assign _068_ = _132_ & ~(_067_);
  assign _069_ = _068_ | _065_;
  assign _070_ = _138_ & in[0];
  assign _071_ = _140_ & ~(_032_);
  assign _072_ = _071_ | _070_;
  assign _073_ = _072_ | _030_;
  assign _074_ = _073_ | _069_;
  assign _075_ = _040_ & _027_;
  assign _076_ = _152_ & ~(_085_);
  assign _077_ = _076_ | _039_;
  assign _078_ = _142_ & in[0];
  assign _079_ = _017_ & ~(_045_);
  assign _080_ = _079_ | _078_;
  assign _081_ = _080_ | _077_;
  assign _082_ = _050_ | _156_;
  assign _083_ = _082_ | _081_;
  assign _084_ = _083_ | _074_;
  assign next_state[1] = _023_ ? _055_ : _084_;
  assign _086_ = in[0] & in[7];
  assign _087_ = _127_ & ~(_086_);
  assign _088_ = _130_ & ~(_085_);
  assign _089_ = ~(_088_ | _087_);
  assign _090_ = ~(in[3] & in[2]);
  assign _091_ = _049_ & ~(_090_);
  assign _092_ = ~(in[6] & in[7]);
  assign _093_ = ~(in[4] & in[5]);
  assign _094_ = _093_ | _092_;
  assign _095_ = _091_ & ~(_094_);
  assign _096_ = _136_ & ~(_095_);
  assign _097_ = ~(_096_ | _132_);
  assign _098_ = ~(_097_ & _089_);
  assign _099_ = _098_ | _030_;
  assign _100_ = ~(in[6] | in[7]);
  assign _101_ = _151_ & ~(_100_);
  assign _102_ = _101_ | _076_;
  assign _103_ = _102_ | _018_;
  assign _104_ = _103_ | _125_;
  assign _105_ = _104_ | _099_;
  assign next_state[2] = _023_ ? _085_ : _105_;
  assign _106_ = in[7] & ~(_056_);
  assign _107_ = _127_ & ~(_106_);
  assign _108_ = _107_ | _130_;
  assign _109_ = _097_ & ~(_108_);
  assign _110_ = _032_ & in[7];
  assign _111_ = _140_ & ~(_110_);
  assign _112_ = _111_ | _138_;
  assign _113_ = _112_ | _163_;
  assign _114_ = _109_ & ~(_113_);
  assign _115_ = _038_ | _075_;
  assign _116_ = _152_ & ~(_115_);
  assign _117_ = _114_ & ~(_116_);
  assign next_state[3] = ~(_117_ | _023_);
  assign _118_ = _135_ & _124_;
  assign _119_ = ~(_118_ | _166_);
  assign _120_ = _119_ & ~(_020_);
  assign _121_ = _140_ | _127_;
  assign _122_ = _121_ | _153_;
  assign out[7] = _120_ & ~(_122_);
  (* src = "prep4.v:116.1-120.5" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[0] <= 1'h0;
    else state[0] <= next_state[0];
  (* src = "prep4.v:116.1-120.5" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[1] <= 1'h0;
    else state[1] <= next_state[1];
  (* src = "prep4.v:116.1-120.5" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[2] <= 1'h0;
    else state[2] <= next_state[2];
  (* src = "prep4.v:116.1-120.5" *)
  always @(posedge clk, negedge rst)
    if (!rst) state[3] <= 1'h0;
    else state[3] <= next_state[3];
endmodule
