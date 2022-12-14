/* Generated by Yosys 0.9+3882 (git sha1 beeaad1, clang 3.8.0-2ubuntu4 -fPIC -Os) */

(* top =  1  *)
(* src = "KeyExpand128.sv:53.1-148.10" *)
module KeyExpand128(kt, kt_vld, kt_rdy, rkey, rkey_vld, rkey_last, clk, rst);
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
  (* src = "KeyExpand128.sv:64.8-64.11" *)
  input clk;
  (* src = "KeyExpand128.sv:74.14-74.26" *)
  reg [0:3] keyexp_state/*verilator public*/;
  (* src = "KeyExpand128.sv:84.7-84.21" *)
  wire keyexp_state_0;
  (* src = "KeyExpand128.sv:85.7-85.22" *)
  wire keyexp_state_10;
  (* src = "KeyExpand128.sv:56.16-56.18" *)
  input [0:127] kt;
  (* src = "KeyExpand128.sv:58.9-58.15" *)
  output kt_rdy;
  (* src = "KeyExpand128.sv:57.8-57.14" *)
  input kt_vld;
  (* keep = "true" *)
  (* max_fanout = 32'd1 *)
  (* src = "KeyExpand128.sv:90.50-90.57" *)
  wire [0:31] next_w0;
  (* keep = "true" *)
  (* max_fanout = 32'd1 *)
  (* src = "KeyExpand128.sv:91.50-91.57" *)
  wire [0:31] next_w1;
  (* keep = "true" *)
  (* max_fanout = 32'd1 *)
  (* src = "KeyExpand128.sv:92.50-92.57" *)
  wire [0:31] next_w2;
  (* keep = "true" *)
  (* max_fanout = 32'd1 *)
  (* src = "KeyExpand128.sv:93.50-93.57" *)
  wire [0:31] next_w3;
  (* src = "KeyExpand128.sv:60.17-60.21" *)
  output [0:127] rkey;
  (* src = "KeyExpand128.sv:62.9-62.18" *)
  output rkey_last;
  (* src = "KeyExpand128.sv:61.9-61.17" *)
  output rkey_vld;
  (* src = "KeyExpand128.sv:65.8-65.11" *)
  input rst;
  (* src = "KeyExpand128.sv:77.14-77.25" *)
  wire [0:31] subword_out;
  (* src = "KeyExpand128.sv:69.15-69.17" *)
  reg [0:31] w0;
  (* src = "KeyExpand128.sv:79.14-79.21" *)
  wire [0:31] w0_feed;
  (* src = "KeyExpand128.sv:70.15-70.17" *)
  reg [0:31] w1;
  (* src = "KeyExpand128.sv:80.14-80.21" *)
  wire [0:31] w1_feed;
  (* src = "KeyExpand128.sv:71.15-71.17" *)
  reg [0:31] w2;
  (* src = "KeyExpand128.sv:81.14-81.21" *)
  wire [0:31] w2_feed;
  (* src = "KeyExpand128.sv:72.15-72.17" *)
  reg [0:31] w3;
  (* src = "KeyExpand128.sv:82.14-82.21" *)
  wire [0:31] w3_feed;
  assign _002_ = keyexp_state[2] & ~(keyexp_state[3]);
  assign _003_ = keyexp_state[1] | ~(keyexp_state[0]);
  assign rkey_last = _002_ & ~(_003_);
  assign _004_ = ~(keyexp_state[3] | keyexp_state[2]);
  assign _005_ = keyexp_state[0] | keyexp_state[1];
  assign kt_rdy = _004_ & ~(_005_);
  assign rkey_vld = kt_vld | ~(kt_rdy);
  assign _006_ = ~(kt_rdy | rkey_last);
  assign _007_ = ~(keyexp_state[0] | keyexp_state[1]);
  assign _008_ = keyexp_state[2] | ~(keyexp_state[3]);
  assign _009_ = _007_ & ~(_008_);
  assign _010_ = _002_ & ~(_005_);
  assign _011_ = _010_ | _009_;
  assign _012_ = ~(keyexp_state[3] & keyexp_state[2]);
  assign _013_ = _007_ & ~(_012_);
  assign _014_ = keyexp_state[0] | ~(keyexp_state[1]);
  assign _015_ = _004_ & ~(_014_);
  assign _016_ = _015_ | _013_;
  assign _017_ = _016_ | _011_;
  assign _018_ = keyexp_state[3] & ~(keyexp_state[2]);
  assign _019_ = _018_ & ~(_014_);
  assign _020_ = _002_ & ~(_014_);
  assign _021_ = _020_ | _019_;
  assign _022_ = keyexp_state[3] & keyexp_state[2];
  assign _023_ = _022_ & ~(_014_);
  assign _024_ = _004_ & ~(_003_);
  assign _025_ = _024_ | _023_;
  assign _026_ = _025_ | _021_;
  assign _027_ = _026_ | _017_;
  assign _028_ = _018_ & ~(_003_);
  assign _029_ = _028_ | _027_;
  assign _030_ = _006_ & ~(_029_);
  assign _000_ = rkey_vld & ~(_030_);
  assign _031_ = _009_ | rkey_last;
  assign _032_ = _013_ | _010_;
  assign _033_ = _032_ | _031_;
  assign _034_ = _019_ | _015_;
  assign _035_ = _023_ | _020_;
  assign _036_ = _035_ | _034_;
  assign _037_ = _036_ | _033_;
  assign _038_ = _028_ | _024_;
  assign _039_ = ~(_038_ | _037_);
  assign _040_ = _039_ & ~(kt_rdy);
  assign _041_ = _040_ | rst;
  assign _001_ = rkey_vld & ~(_041_);
  assign rkey[127] = kt_rdy ? kt[127] : w3[31];
  assign rkey[126] = kt_rdy ? kt[126] : w3[30];
  assign rkey[125] = kt_rdy ? kt[125] : w3[29];
  assign rkey[124] = kt_rdy ? kt[124] : w3[28];
  assign rkey[123] = kt_rdy ? kt[123] : w3[27];
  assign rkey[122] = kt_rdy ? kt[122] : w3[26];
  assign rkey[121] = kt_rdy ? kt[121] : w3[25];
  assign rkey[120] = kt_rdy ? kt[120] : w3[24];
  assign rkey[119] = kt_rdy ? kt[119] : w3[23];
  assign rkey[118] = kt_rdy ? kt[118] : w3[22];
  assign rkey[117] = kt_rdy ? kt[117] : w3[21];
  assign rkey[116] = kt_rdy ? kt[116] : w3[20];
  assign rkey[115] = kt_rdy ? kt[115] : w3[19];
  assign rkey[114] = kt_rdy ? kt[114] : w3[18];
  assign rkey[113] = kt_rdy ? kt[113] : w3[17];
  assign rkey[112] = kt_rdy ? kt[112] : w3[16];
  assign rkey[111] = kt_rdy ? kt[111] : w3[15];
  assign rkey[110] = kt_rdy ? kt[110] : w3[14];
  assign rkey[109] = kt_rdy ? kt[109] : w3[13];
  assign rkey[108] = kt_rdy ? kt[108] : w3[12];
  assign rkey[107] = kt_rdy ? kt[107] : w3[11];
  assign rkey[106] = kt_rdy ? kt[106] : w3[10];
  assign rkey[105] = kt_rdy ? kt[105] : w3[9];
  assign rkey[104] = kt_rdy ? kt[104] : w3[8];
  assign rkey[103] = kt_rdy ? kt[103] : w3[7];
  assign rkey[102] = kt_rdy ? kt[102] : w3[6];
  assign rkey[101] = kt_rdy ? kt[101] : w3[5];
  assign rkey[100] = kt_rdy ? kt[100] : w3[4];
  assign rkey[99] = kt_rdy ? kt[99] : w3[3];
  assign rkey[98] = kt_rdy ? kt[98] : w3[2];
  assign rkey[97] = kt_rdy ? kt[97] : w3[1];
  assign rkey[96] = kt_rdy ? kt[96] : w3[0];
  assign rkey[95] = kt_rdy ? kt[95] : w2[31];
  assign rkey[94] = kt_rdy ? kt[94] : w2[30];
  assign rkey[93] = kt_rdy ? kt[93] : w2[29];
  assign rkey[92] = kt_rdy ? kt[92] : w2[28];
  assign rkey[91] = kt_rdy ? kt[91] : w2[27];
  assign rkey[90] = kt_rdy ? kt[90] : w2[26];
  assign rkey[89] = kt_rdy ? kt[89] : w2[25];
  assign rkey[88] = kt_rdy ? kt[88] : w2[24];
  assign rkey[87] = kt_rdy ? kt[87] : w2[23];
  assign rkey[86] = kt_rdy ? kt[86] : w2[22];
  assign rkey[85] = kt_rdy ? kt[85] : w2[21];
  assign rkey[84] = kt_rdy ? kt[84] : w2[20];
  assign rkey[83] = kt_rdy ? kt[83] : w2[19];
  assign rkey[82] = kt_rdy ? kt[82] : w2[18];
  assign rkey[81] = kt_rdy ? kt[81] : w2[17];
  assign rkey[80] = kt_rdy ? kt[80] : w2[16];
  assign rkey[79] = kt_rdy ? kt[79] : w2[15];
  assign rkey[78] = kt_rdy ? kt[78] : w2[14];
  assign rkey[77] = kt_rdy ? kt[77] : w2[13];
  assign rkey[76] = kt_rdy ? kt[76] : w2[12];
  assign rkey[75] = kt_rdy ? kt[75] : w2[11];
  assign rkey[74] = kt_rdy ? kt[74] : w2[10];
  assign rkey[73] = kt_rdy ? kt[73] : w2[9];
  assign rkey[72] = kt_rdy ? kt[72] : w2[8];
  assign rkey[71] = kt_rdy ? kt[71] : w2[7];
  assign rkey[70] = kt_rdy ? kt[70] : w2[6];
  assign rkey[69] = kt_rdy ? kt[69] : w2[5];
  assign rkey[68] = kt_rdy ? kt[68] : w2[4];
  assign rkey[67] = kt_rdy ? kt[67] : w2[3];
  assign rkey[66] = kt_rdy ? kt[66] : w2[2];
  assign rkey[65] = kt_rdy ? kt[65] : w2[1];
  assign rkey[64] = kt_rdy ? kt[64] : w2[0];
  assign rkey[63] = kt_rdy ? kt[63] : w1[31];
  assign rkey[62] = kt_rdy ? kt[62] : w1[30];
  assign rkey[61] = kt_rdy ? kt[61] : w1[29];
  assign rkey[60] = kt_rdy ? kt[60] : w1[28];
  assign rkey[59] = kt_rdy ? kt[59] : w1[27];
  assign rkey[58] = kt_rdy ? kt[58] : w1[26];
  assign rkey[57] = kt_rdy ? kt[57] : w1[25];
  assign rkey[56] = kt_rdy ? kt[56] : w1[24];
  assign rkey[55] = kt_rdy ? kt[55] : w1[23];
  assign rkey[54] = kt_rdy ? kt[54] : w1[22];
  assign rkey[53] = kt_rdy ? kt[53] : w1[21];
  assign rkey[52] = kt_rdy ? kt[52] : w1[20];
  assign rkey[51] = kt_rdy ? kt[51] : w1[19];
  assign rkey[50] = kt_rdy ? kt[50] : w1[18];
  assign rkey[49] = kt_rdy ? kt[49] : w1[17];
  assign rkey[48] = kt_rdy ? kt[48] : w1[16];
  assign rkey[47] = kt_rdy ? kt[47] : w1[15];
  assign rkey[46] = kt_rdy ? kt[46] : w1[14];
  assign rkey[45] = kt_rdy ? kt[45] : w1[13];
  assign rkey[44] = kt_rdy ? kt[44] : w1[12];
  assign rkey[43] = kt_rdy ? kt[43] : w1[11];
  assign rkey[42] = kt_rdy ? kt[42] : w1[10];
  assign rkey[41] = kt_rdy ? kt[41] : w1[9];
  assign rkey[40] = kt_rdy ? kt[40] : w1[8];
  assign rkey[39] = kt_rdy ? kt[39] : w1[7];
  assign rkey[38] = kt_rdy ? kt[38] : w1[6];
  assign rkey[37] = kt_rdy ? kt[37] : w1[5];
  assign rkey[36] = kt_rdy ? kt[36] : w1[4];
  assign rkey[35] = kt_rdy ? kt[35] : w1[3];
  assign rkey[34] = kt_rdy ? kt[34] : w1[2];
  assign rkey[33] = kt_rdy ? kt[33] : w1[1];
  assign rkey[32] = kt_rdy ? kt[32] : w1[0];
  assign _042_ = ~kt[31];
  assign _043_ = ~w0[31];
  assign _044_ = kt_rdy ? _042_ : _043_;
  assign rkey[31] = ~_044_;
  assign _045_ = ~kt[30];
  assign _046_ = ~w0[30];
  assign _047_ = kt_rdy ? _045_ : _046_;
  assign rkey[30] = ~_047_;
  assign _048_ = ~kt[29];
  assign _049_ = ~w0[29];
  assign _050_ = kt_rdy ? _048_ : _049_;
  assign rkey[29] = ~_050_;
  assign _051_ = ~kt[28];
  assign _052_ = ~w0[28];
  assign _053_ = kt_rdy ? _051_ : _052_;
  assign rkey[28] = ~_053_;
  assign _054_ = ~kt[27];
  assign _055_ = ~w0[27];
  assign _056_ = kt_rdy ? _054_ : _055_;
  assign rkey[27] = ~_056_;
  assign _057_ = ~kt[26];
  assign _058_ = ~w0[26];
  assign _059_ = kt_rdy ? _057_ : _058_;
  assign rkey[26] = ~_059_;
  assign _060_ = ~kt[25];
  assign _061_ = ~w0[25];
  assign _062_ = kt_rdy ? _060_ : _061_;
  assign rkey[25] = ~_062_;
  assign _063_ = ~kt[24];
  assign _064_ = ~w0[24];
  assign _065_ = kt_rdy ? _063_ : _064_;
  assign rkey[24] = ~_065_;
  assign _066_ = ~kt[23];
  assign _067_ = ~w0[23];
  assign _068_ = kt_rdy ? _066_ : _067_;
  assign rkey[23] = ~_068_;
  assign _069_ = ~kt[22];
  assign _070_ = ~w0[22];
  assign _071_ = kt_rdy ? _069_ : _070_;
  assign rkey[22] = ~_071_;
  assign _072_ = ~kt[21];
  assign _073_ = ~w0[21];
  assign _074_ = kt_rdy ? _072_ : _073_;
  assign rkey[21] = ~_074_;
  assign _075_ = ~kt[20];
  assign _076_ = ~w0[20];
  assign _077_ = kt_rdy ? _075_ : _076_;
  assign rkey[20] = ~_077_;
  assign _078_ = ~kt[19];
  assign _079_ = ~w0[19];
  assign _080_ = kt_rdy ? _078_ : _079_;
  assign rkey[19] = ~_080_;
  assign _081_ = ~kt[18];
  assign _082_ = ~w0[18];
  assign _083_ = kt_rdy ? _081_ : _082_;
  assign rkey[18] = ~_083_;
  assign _084_ = ~kt[17];
  assign _085_ = ~w0[17];
  assign _086_ = kt_rdy ? _084_ : _085_;
  assign rkey[17] = ~_086_;
  assign _087_ = ~kt[16];
  assign _088_ = ~w0[16];
  assign _089_ = kt_rdy ? _087_ : _088_;
  assign rkey[16] = ~_089_;
  assign _090_ = ~kt[15];
  assign _091_ = ~w0[15];
  assign _092_ = kt_rdy ? _090_ : _091_;
  assign rkey[15] = ~_092_;
  assign _093_ = ~kt[14];
  assign _094_ = ~w0[14];
  assign _095_ = kt_rdy ? _093_ : _094_;
  assign rkey[14] = ~_095_;
  assign _096_ = ~kt[13];
  assign _097_ = ~w0[13];
  assign _098_ = kt_rdy ? _096_ : _097_;
  assign rkey[13] = ~_098_;
  assign _099_ = ~kt[12];
  assign _100_ = ~w0[12];
  assign _101_ = kt_rdy ? _099_ : _100_;
  assign rkey[12] = ~_101_;
  assign _102_ = ~kt[11];
  assign _103_ = ~w0[11];
  assign _104_ = kt_rdy ? _102_ : _103_;
  assign rkey[11] = ~_104_;
  assign _105_ = ~kt[10];
  assign _106_ = ~w0[10];
  assign _107_ = kt_rdy ? _105_ : _106_;
  assign rkey[10] = ~_107_;
  assign _108_ = ~kt[9];
  assign _109_ = ~w0[9];
  assign _110_ = kt_rdy ? _108_ : _109_;
  assign rkey[9] = ~_110_;
  assign _111_ = ~kt[8];
  assign _112_ = ~w0[8];
  assign _113_ = kt_rdy ? _111_ : _112_;
  assign rkey[8] = ~_113_;
  assign _114_ = ~kt[7];
  assign _115_ = ~w0[7];
  assign _116_ = kt_rdy ? _114_ : _115_;
  assign rkey[7] = ~_116_;
  assign _117_ = ~kt[6];
  assign _118_ = ~w0[6];
  assign _119_ = kt_rdy ? _117_ : _118_;
  assign rkey[6] = ~_119_;
  assign _120_ = ~kt[5];
  assign _121_ = ~w0[5];
  assign _122_ = kt_rdy ? _120_ : _121_;
  assign rkey[5] = ~_122_;
  assign _123_ = ~kt[4];
  assign _124_ = ~w0[4];
  assign _125_ = kt_rdy ? _123_ : _124_;
  assign rkey[4] = ~_125_;
  assign _126_ = ~kt[3];
  assign _127_ = ~w0[3];
  assign _128_ = kt_rdy ? _126_ : _127_;
  assign rkey[3] = ~_128_;
  assign _129_ = ~kt[2];
  assign _130_ = ~w0[2];
  assign _131_ = kt_rdy ? _129_ : _130_;
  assign rkey[2] = ~_131_;
  assign _132_ = ~kt[1];
  assign _133_ = ~w0[1];
  assign _134_ = kt_rdy ? _132_ : _133_;
  assign rkey[1] = ~_134_;
  assign _135_ = ~kt[0];
  assign _136_ = ~w0[0];
  assign _137_ = kt_rdy ? _135_ : _136_;
  assign rkey[0] = ~_137_;
  assign _173_ = ~(rkey_last | keyexp_state[3]);
  assign _174_ = _002_ ? _003_ : _018_;
  assign _138_ = _022_ ^ keyexp_state[1];
  assign _175_ = _138_ & ~(rkey_last);
  assign _139_ = ~(_022_ & keyexp_state[1]);
  assign _140_ = ~(_139_ ^ keyexp_state[0]);
  assign _176_ = _140_ & ~(rkey_last);
  assign _141_ = _044_ ^ rkey[63];
  assign next_w1[31] = ~_141_;
  assign _142_ = _047_ ^ rkey[62];
  assign next_w1[30] = ~_142_;
  assign _143_ = _050_ ^ rkey[61];
  assign next_w1[29] = ~_143_;
  assign _144_ = _053_ ^ rkey[60];
  assign next_w1[28] = ~_144_;
  assign _145_ = _056_ ^ rkey[59];
  assign next_w1[27] = ~_145_;
  assign _146_ = _059_ ^ rkey[58];
  assign next_w1[26] = ~_146_;
  assign _147_ = _062_ ^ rkey[57];
  assign next_w1[25] = ~_147_;
  assign _148_ = _065_ ^ rkey[56];
  assign next_w1[24] = ~_148_;
  assign _149_ = _068_ ^ rkey[55];
  assign next_w1[23] = ~_149_;
  assign _150_ = _071_ ^ rkey[54];
  assign next_w1[22] = ~_150_;
  assign _151_ = _074_ ^ rkey[53];
  assign next_w1[21] = ~_151_;
  assign _152_ = _077_ ^ rkey[52];
  assign next_w1[20] = ~_152_;
  assign _153_ = _080_ ^ rkey[51];
  assign next_w1[19] = ~_153_;
  assign _154_ = _083_ ^ rkey[50];
  assign next_w1[18] = ~_154_;
  assign _155_ = _086_ ^ rkey[49];
  assign next_w1[17] = ~_155_;
  assign _156_ = _089_ ^ rkey[48];
  assign next_w1[16] = ~_156_;
  assign _157_ = _092_ ^ rkey[47];
  assign next_w1[15] = ~_157_;
  assign _158_ = _095_ ^ rkey[46];
  assign next_w1[14] = ~_158_;
  assign _159_ = _098_ ^ rkey[45];
  assign next_w1[13] = ~_159_;
  assign _160_ = _101_ ^ rkey[44];
  assign next_w1[12] = ~_160_;
  assign _161_ = _104_ ^ rkey[43];
  assign next_w1[11] = ~_161_;
  assign _162_ = _107_ ^ rkey[42];
  assign next_w1[10] = ~_162_;
  assign _163_ = _110_ ^ rkey[41];
  assign next_w1[9] = ~_163_;
  assign _164_ = _113_ ^ rkey[40];
  assign next_w1[8] = ~_164_;
  assign _165_ = _116_ ^ rkey[39];
  assign next_w1[7] = ~_165_;
  assign _166_ = _119_ ^ rkey[38];
  assign next_w1[6] = ~_166_;
  assign _167_ = _122_ ^ rkey[37];
  assign next_w1[5] = ~_167_;
  assign _168_ = _125_ ^ rkey[36];
  assign next_w1[4] = ~_168_;
  assign _169_ = _128_ ^ rkey[35];
  assign next_w1[3] = ~_169_;
  assign _170_ = _131_ ^ rkey[34];
  assign next_w1[2] = ~_170_;
  assign _171_ = _134_ ^ rkey[33];
  assign next_w1[1] = ~_171_;
  assign _172_ = _137_ ^ rkey[32];
  assign next_w1[0] = ~_172_;
  assign next_w2[31] = ~(_141_ ^ rkey[95]);
  assign next_w2[30] = ~(_142_ ^ rkey[94]);
  assign next_w2[29] = ~(_143_ ^ rkey[93]);
  assign next_w2[28] = ~(_144_ ^ rkey[92]);
  assign next_w2[27] = ~(_145_ ^ rkey[91]);
  assign next_w2[26] = ~(_146_ ^ rkey[90]);
  assign next_w2[25] = ~(_147_ ^ rkey[89]);
  assign next_w2[24] = ~(_148_ ^ rkey[88]);
  assign next_w2[23] = ~(_149_ ^ rkey[87]);
  assign next_w2[22] = ~(_150_ ^ rkey[86]);
  assign next_w2[21] = ~(_151_ ^ rkey[85]);
  assign next_w2[20] = ~(_152_ ^ rkey[84]);
  assign next_w2[19] = ~(_153_ ^ rkey[83]);
  assign next_w2[18] = ~(_154_ ^ rkey[82]);
  assign next_w2[17] = ~(_155_ ^ rkey[81]);
  assign next_w2[16] = ~(_156_ ^ rkey[80]);
  assign next_w2[15] = ~(_157_ ^ rkey[79]);
  assign next_w2[14] = ~(_158_ ^ rkey[78]);
  assign next_w2[13] = ~(_159_ ^ rkey[77]);
  assign next_w2[12] = ~(_160_ ^ rkey[76]);
  assign next_w2[11] = ~(_161_ ^ rkey[75]);
  assign next_w2[10] = ~(_162_ ^ rkey[74]);
  assign next_w2[9] = ~(_163_ ^ rkey[73]);
  assign next_w2[8] = ~(_164_ ^ rkey[72]);
  assign next_w2[7] = ~(_165_ ^ rkey[71]);
  assign next_w2[6] = ~(_166_ ^ rkey[70]);
  assign next_w2[5] = ~(_167_ ^ rkey[69]);
  assign next_w2[4] = ~(_168_ ^ rkey[68]);
  assign next_w2[3] = ~(_169_ ^ rkey[67]);
  assign next_w2[2] = ~(_170_ ^ rkey[66]);
  assign next_w2[1] = ~(_171_ ^ rkey[65]);
  assign next_w2[0] = ~(_172_ ^ rkey[64]);
  assign next_w3[31] = next_w2[31] ^ rkey[127];
  assign next_w3[30] = next_w2[30] ^ rkey[126];
  assign next_w3[29] = next_w2[29] ^ rkey[125];
  assign next_w3[28] = next_w2[28] ^ rkey[124];
  assign next_w3[27] = next_w2[27] ^ rkey[123];
  assign next_w3[26] = next_w2[26] ^ rkey[122];
  assign next_w3[25] = next_w2[25] ^ rkey[121];
  assign next_w3[24] = next_w2[24] ^ rkey[120];
  assign next_w3[23] = next_w2[23] ^ rkey[119];
  assign next_w3[22] = next_w2[22] ^ rkey[118];
  assign next_w3[21] = next_w2[21] ^ rkey[117];
  assign next_w3[20] = next_w2[20] ^ rkey[116];
  assign next_w3[19] = next_w2[19] ^ rkey[115];
  assign next_w3[18] = next_w2[18] ^ rkey[114];
  assign next_w3[17] = next_w2[17] ^ rkey[113];
  assign next_w3[16] = next_w2[16] ^ rkey[112];
  assign next_w3[15] = next_w2[15] ^ rkey[111];
  assign next_w3[14] = next_w2[14] ^ rkey[110];
  assign next_w3[13] = next_w2[13] ^ rkey[109];
  assign next_w3[12] = next_w2[12] ^ rkey[108];
  assign next_w3[11] = next_w2[11] ^ rkey[107];
  assign next_w3[10] = next_w2[10] ^ rkey[106];
  assign next_w3[9] = next_w2[9] ^ rkey[105];
  assign next_w3[8] = next_w2[8] ^ rkey[104];
  assign next_w3[7] = next_w2[7] ^ rkey[103];
  assign next_w3[6] = next_w2[6] ^ rkey[102];
  assign next_w3[5] = next_w2[5] ^ rkey[101];
  assign next_w3[4] = next_w2[4] ^ rkey[100];
  assign next_w3[3] = next_w2[3] ^ rkey[99];
  assign next_w3[2] = next_w2[2] ^ rkey[98];
  assign next_w3[1] = next_w2[1] ^ rkey[97];
  assign next_w3[0] = next_w2[0] ^ rkey[96];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[0] <= next_w2[31];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[1] <= next_w2[30];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[2] <= next_w2[29];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[3] <= next_w2[28];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[4] <= next_w2[27];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[5] <= next_w2[26];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[6] <= next_w2[25];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[7] <= next_w2[24];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[8] <= next_w2[23];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[9] <= next_w2[22];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[10] <= next_w2[21];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[11] <= next_w2[20];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[12] <= next_w2[19];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[13] <= next_w2[18];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[14] <= next_w2[17];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[15] <= next_w2[16];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[16] <= next_w2[15];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[17] <= next_w2[14];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[18] <= next_w2[13];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[19] <= next_w2[12];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[20] <= next_w2[11];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[21] <= next_w2[10];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[22] <= next_w2[9];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[23] <= next_w2[8];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[24] <= next_w2[7];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[25] <= next_w2[6];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[26] <= next_w2[5];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[27] <= next_w2[4];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[28] <= next_w2[3];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[29] <= next_w2[2];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[30] <= next_w2[1];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w2[31] <= next_w2[0];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[0] <= rkey[31];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[1] <= rkey[30];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[2] <= rkey[29];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[3] <= rkey[28];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[4] <= rkey[27];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[5] <= rkey[26];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[6] <= rkey[25];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[7] <= rkey[24];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[8] <= rkey[23];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[9] <= rkey[22];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[10] <= rkey[21];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[11] <= rkey[20];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[12] <= rkey[19];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[13] <= rkey[18];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[14] <= rkey[17];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[15] <= rkey[16];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[16] <= rkey[15];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[17] <= rkey[14];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[18] <= rkey[13];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[19] <= rkey[12];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[20] <= rkey[11];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[21] <= rkey[10];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[22] <= rkey[9];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[23] <= rkey[8];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[24] <= rkey[7];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[25] <= rkey[6];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[26] <= rkey[5];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[27] <= rkey[4];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[28] <= rkey[3];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[29] <= rkey[2];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[30] <= rkey[1];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w0[31] <= rkey[0];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[0] <= next_w1[31];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[1] <= next_w1[30];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[2] <= next_w1[29];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[3] <= next_w1[28];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[4] <= next_w1[27];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[5] <= next_w1[26];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[6] <= next_w1[25];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[7] <= next_w1[24];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[8] <= next_w1[23];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[9] <= next_w1[22];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[10] <= next_w1[21];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[11] <= next_w1[20];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[12] <= next_w1[19];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[13] <= next_w1[18];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[14] <= next_w1[17];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[15] <= next_w1[16];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[16] <= next_w1[15];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[17] <= next_w1[14];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[18] <= next_w1[13];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[19] <= next_w1[12];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[20] <= next_w1[11];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[21] <= next_w1[10];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[22] <= next_w1[9];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[23] <= next_w1[8];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[24] <= next_w1[7];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[25] <= next_w1[6];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[26] <= next_w1[5];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[27] <= next_w1[4];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[28] <= next_w1[3];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[29] <= next_w1[2];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[30] <= next_w1[1];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w1[31] <= next_w1[0];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[0] <= next_w3[31];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[1] <= next_w3[30];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[2] <= next_w3[29];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[3] <= next_w3[28];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[4] <= next_w3[27];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[5] <= next_w3[26];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[6] <= next_w3[25];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[7] <= next_w3[24];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[8] <= next_w3[23];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[9] <= next_w3[22];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[10] <= next_w3[21];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[11] <= next_w3[20];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[12] <= next_w3[19];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[13] <= next_w3[18];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[14] <= next_w3[17];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[15] <= next_w3[16];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[16] <= next_w3[15];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[17] <= next_w3[14];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[18] <= next_w3[13];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[19] <= next_w3[12];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[20] <= next_w3[11];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[21] <= next_w3[10];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[22] <= next_w3[9];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[23] <= next_w3[8];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[24] <= next_w3[7];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[25] <= next_w3[6];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[26] <= next_w3[5];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[27] <= next_w3[4];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[28] <= next_w3[3];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[29] <= next_w3[2];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[30] <= next_w3[1];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (_001_) w3[31] <= next_w3[0];
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (rst) keyexp_state[0] <= 1'h0;
    else if (_000_) keyexp_state[0] <= _173_;
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (rst) keyexp_state[1] <= 1'h0;
    else if (_000_) keyexp_state[1] <= _174_;
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (rst) keyexp_state[2] <= 1'h0;
    else if (_000_) keyexp_state[2] <= _175_;
  (* src = "KeyExpand128.sv:116.2-146.5" *)
  always @(posedge clk)
    if (rst) keyexp_state[3] <= 1'h0;
    else if (_000_) keyexp_state[3] <= _176_;
  assign keyexp_state_0 = kt_rdy;
  assign keyexp_state_10 = rkey_last;
  assign next_w0 = rkey[0:31];
  assign subword_out = 32'hxxxxxxxx;
  assign w0_feed = rkey[0:31];
  assign w1_feed = rkey[32:63];
  assign w2_feed = rkey[64:95];
  assign w3_feed = rkey[96:127];
endmodule
