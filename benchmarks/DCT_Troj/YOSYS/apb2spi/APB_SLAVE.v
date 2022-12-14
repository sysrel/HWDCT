/* Generated by Yosys 0.9+3882 (git sha1 beeaad1, clang 3.8.0-2ubuntu4 -fPIC -Os) */

(* src = "APB_SLAVE.v:49.1-225.10" *)
module APB_SLAVE(PCLK, PRESETn, PADDR, PWRITE, PSEL, PENABLE, PWDATA, PRDATA, PREADY, TrFr, SPI_CR_1, SPI_CR_2, SPI_BR_R, SPI_ST_R, SPI_DATA_Reg_1, SPI_DATA_Reg_2, SPI_DATA_Reg_3, SPI_DATA_Reg_4);
  (* src = "APB_SLAVE.v:91.1-127.4" *)
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
  (* force_downto = 32'd1 *)
  (* src = "APB_SLAVE.v:0.0-0.0|APB_SLAVE.v:200.10-210.17|/home/ruochen/tools/yosys/share/techmap.v:575.21-575.22" *)
  wire [7:0] _149_;
  (* force_downto = 32'd1 *)
  (* src = "APB_SLAVE.v:0.0-0.0|APB_SLAVE.v:140.9-160.10|/home/ruochen/tools/yosys/share/techmap.v:571.28-571.29" *)
  (* unused_bits = "2" *)
  wire [3:0] _150_;
  (* force_downto = 32'd1 *)
  (* src = "APB_SLAVE.v:0.0-0.0|APB_SLAVE.v:140.9-160.10|/home/ruochen/tools/yosys/share/techmap.v:583.28-583.35" *)
  (* unused_bits = "2 3" *)
  wire [3:0] _151_;
  (* force_downto = 32'd1 *)
  (* src = "APB_SLAVE.v:0.0-0.0|APB_SLAVE.v:140.9-160.10|/home/ruochen/tools/yosys/share/techmap.v:575.21-575.22" *)
  wire [1:0] _152_;
  (* force_downto = 32'd1 *)
  (* src = "APB_SLAVE.v:0.0-0.0|APB_SLAVE.v:101.5-125.12|/home/ruochen/tools/yosys/share/techmap.v:575.21-575.22" *)
  wire [1:0] _153_;
  (* src = "APB_SLAVE.v:54.22-54.27" *)
  input [2:0] PADDR;
  (* src = "APB_SLAVE.v:52.36-52.40" *)
  input PCLK;
  (* src = "APB_SLAVE.v:57.36-57.43" *)
  input PENABLE;
  (* src = "APB_SLAVE.v:59.22-59.28" *)
  output [7:0] PRDATA;
  reg [7:0] PRDATA;
  (* src = "APB_SLAVE.v:60.36-60.42" *)
  output PREADY;
  reg PREADY;
  (* src = "APB_SLAVE.v:53.36-53.43" *)
  input PRESETn;
  (* src = "APB_SLAVE.v:56.36-56.40" *)
  input PSEL;
  (* src = "APB_SLAVE.v:58.22-58.28" *)
  input [7:0] PWDATA;
  (* src = "APB_SLAVE.v:55.36-55.42" *)
  input PWRITE;
  (* src = "APB_SLAVE.v:65.22-65.30" *)
  output [7:0] SPI_BR_R;
  reg [7:0] SPI_BR_R;
  (* src = "APB_SLAVE.v:63.22-63.30" *)
  output [7:0] SPI_CR_1;
  reg [7:0] SPI_CR_1;
  (* src = "APB_SLAVE.v:64.22-64.30" *)
  output [7:0] SPI_CR_2;
  reg [7:0] SPI_CR_2;
  (* src = "APB_SLAVE.v:67.22-67.36" *)
  output [7:0] SPI_DATA_Reg_1;
  reg [7:0] SPI_DATA_Reg_1;
  (* src = "APB_SLAVE.v:68.22-68.36" *)
  output [7:0] SPI_DATA_Reg_2;
  reg [7:0] SPI_DATA_Reg_2;
  (* src = "APB_SLAVE.v:69.22-69.36" *)
  output [7:0] SPI_DATA_Reg_3;
  reg [7:0] SPI_DATA_Reg_3;
  (* src = "APB_SLAVE.v:70.22-70.36" *)
  output [7:0] SPI_DATA_Reg_4;
  reg [7:0] SPI_DATA_Reg_4;
  (* src = "APB_SLAVE.v:66.22-66.30" *)
  output [7:0] SPI_ST_R;
  reg [7:0] SPI_ST_R;
  (* src = "APB_SLAVE.v:89.15-89.20" *)
  reg [1:0] STATE/*verilator public*/;
  (* src = "APB_SLAVE.v:61.36-61.40" *)
  input TrFr;
  (* src = "APB_SLAVE.v:74.5-74.18" *)
  reg outTrojan_ena;
  (* src = "APB_SLAVE.v:75.11-75.23" *)
  reg [1:0] trojan_state;
  assign _150_[3] = ~(STATE[1] & STATE[0]);
  assign _011_ = STATE[0] | ~(STATE[1]);
  assign _012_ = PWRITE & ~(_011_);
  assign _013_ = ~PADDR[2];
  assign _014_ = PADDR[1] | ~(PADDR[0]);
  assign _015_ = _014_ | _013_;
  assign _004_ = _012_ & ~(_015_);
  assign _016_ = PADDR[1] | PADDR[0];
  assign _017_ = _016_ | PADDR[2];
  assign _009_ = _012_ & ~(_017_);
  assign _018_ = _016_ | _013_;
  assign _005_ = _012_ & ~(_018_);
  assign _019_ = _014_ | PADDR[2];
  assign _008_ = _012_ & ~(_019_);
  assign _020_ = ~(PADDR[1] & PADDR[0]);
  assign _021_ = _020_ | PADDR[2];
  assign _006_ = _012_ & ~(_021_);
  assign _022_ = PADDR[0] | ~(PADDR[1]);
  assign _023_ = _022_ | PADDR[2];
  assign _007_ = _012_ & ~(_023_);
  assign _024_ = trojan_state[0] | ~(trojan_state[1]);
  assign _151_[1] = ~_024_;
  assign _001_ = ~(trojan_state[0] & trojan_state[1]);
  assign _025_ = _020_ | _013_;
  assign _002_ = _012_ & ~(_025_);
  assign _026_ = STATE[1] | ~(STATE[0]);
  assign _027_ = ~(_026_ | PWRITE);
  assign _028_ = _027_ & PENABLE;
  assign _010_ = _028_ & ~(_012_);
  assign _029_ = _022_ | _013_;
  assign _003_ = _012_ & ~(_029_);
  assign _030_ = _029_ & _025_;
  assign _031_ = ~(_018_ & _015_);
  assign _032_ = _030_ & ~(_031_);
  assign _033_ = ~(_023_ & _021_);
  assign _034_ = _033_ | ~(_019_);
  assign _035_ = _032_ & ~(_034_);
  assign _036_ = SPI_DATA_Reg_4[0] & ~(_025_);
  assign _037_ = SPI_DATA_Reg_3[0] & ~(_029_);
  assign _038_ = _037_ | _036_;
  assign _039_ = SPI_DATA_Reg_2[0] & ~(_015_);
  assign _040_ = SPI_DATA_Reg_1[0] & ~(_018_);
  assign _041_ = _040_ | _039_;
  assign _042_ = _041_ | _038_;
  assign _043_ = SPI_ST_R[0] & ~(_021_);
  assign _044_ = SPI_BR_R[0] & ~(_023_);
  assign _045_ = _044_ | _043_;
  assign _046_ = SPI_CR_2[0] & ~(_019_);
  assign _047_ = _046_ | _045_;
  assign _048_ = _047_ | _042_;
  assign _149_[0] = _035_ ? SPI_CR_1[0] : _048_;
  assign _049_ = SPI_DATA_Reg_4[1] & ~(_025_);
  assign _050_ = SPI_DATA_Reg_3[1] & ~(_029_);
  assign _051_ = _050_ | _049_;
  assign _052_ = SPI_DATA_Reg_2[1] & ~(_015_);
  assign _053_ = SPI_DATA_Reg_1[1] & ~(_018_);
  assign _054_ = _053_ | _052_;
  assign _055_ = _054_ | _051_;
  assign _056_ = SPI_ST_R[1] & ~(_021_);
  assign _057_ = SPI_BR_R[1] & ~(_023_);
  assign _058_ = _057_ | _056_;
  assign _059_ = SPI_CR_2[1] & ~(_019_);
  assign _060_ = _059_ | _058_;
  assign _061_ = _060_ | _055_;
  assign _149_[1] = _035_ ? SPI_CR_1[1] : _061_;
  assign _062_ = SPI_DATA_Reg_4[2] & ~(_025_);
  assign _063_ = SPI_DATA_Reg_3[2] & ~(_029_);
  assign _064_ = _063_ | _062_;
  assign _065_ = SPI_DATA_Reg_2[2] & ~(_015_);
  assign _066_ = SPI_DATA_Reg_1[2] & ~(_018_);
  assign _067_ = _066_ | _065_;
  assign _068_ = _067_ | _064_;
  assign _069_ = SPI_ST_R[2] & ~(_021_);
  assign _070_ = SPI_BR_R[2] & ~(_023_);
  assign _071_ = _070_ | _069_;
  assign _072_ = SPI_CR_2[2] & ~(_019_);
  assign _073_ = _072_ | _071_;
  assign _074_ = _073_ | _068_;
  assign _149_[2] = _035_ ? SPI_CR_1[2] : _074_;
  assign _075_ = SPI_DATA_Reg_4[3] & ~(_025_);
  assign _076_ = SPI_DATA_Reg_3[3] & ~(_029_);
  assign _077_ = _076_ | _075_;
  assign _078_ = SPI_DATA_Reg_2[3] & ~(_015_);
  assign _079_ = SPI_DATA_Reg_1[3] & ~(_018_);
  assign _080_ = _079_ | _078_;
  assign _081_ = _080_ | _077_;
  assign _082_ = SPI_ST_R[3] & ~(_021_);
  assign _083_ = SPI_BR_R[3] & ~(_023_);
  assign _084_ = _083_ | _082_;
  assign _085_ = SPI_CR_2[3] & ~(_019_);
  assign _086_ = _085_ | _084_;
  assign _087_ = _086_ | _081_;
  assign _149_[3] = _035_ ? SPI_CR_1[3] : _087_;
  assign _088_ = SPI_DATA_Reg_4[4] & ~(_025_);
  assign _089_ = SPI_DATA_Reg_3[4] & ~(_029_);
  assign _090_ = _089_ | _088_;
  assign _091_ = SPI_DATA_Reg_2[4] & ~(_015_);
  assign _092_ = SPI_DATA_Reg_1[4] & ~(_018_);
  assign _093_ = _092_ | _091_;
  assign _094_ = _093_ | _090_;
  assign _095_ = SPI_ST_R[4] & ~(_021_);
  assign _096_ = SPI_BR_R[4] & ~(_023_);
  assign _097_ = _096_ | _095_;
  assign _098_ = SPI_CR_2[4] & ~(_019_);
  assign _099_ = _098_ | _097_;
  assign _100_ = _099_ | _094_;
  assign _149_[4] = _035_ ? SPI_CR_1[4] : _100_;
  assign _101_ = SPI_DATA_Reg_4[5] & ~(_025_);
  assign _102_ = SPI_DATA_Reg_3[5] & ~(_029_);
  assign _103_ = _102_ | _101_;
  assign _104_ = SPI_DATA_Reg_2[5] & ~(_015_);
  assign _105_ = SPI_DATA_Reg_1[5] & ~(_018_);
  assign _106_ = _105_ | _104_;
  assign _107_ = _106_ | _103_;
  assign _108_ = SPI_ST_R[5] & ~(_021_);
  assign _109_ = SPI_BR_R[5] & ~(_023_);
  assign _110_ = _109_ | _108_;
  assign _111_ = SPI_CR_2[5] & ~(_019_);
  assign _112_ = _111_ | _110_;
  assign _113_ = _112_ | _107_;
  assign _149_[5] = _035_ ? SPI_CR_1[5] : _113_;
  assign _114_ = SPI_DATA_Reg_4[6] & ~(_025_);
  assign _115_ = SPI_DATA_Reg_3[6] & ~(_029_);
  assign _116_ = _115_ | _114_;
  assign _117_ = SPI_DATA_Reg_2[6] & ~(_015_);
  assign _118_ = SPI_DATA_Reg_1[6] & ~(_018_);
  assign _119_ = _118_ | _117_;
  assign _120_ = _119_ | _116_;
  assign _121_ = SPI_ST_R[6] & ~(_021_);
  assign _122_ = SPI_BR_R[6] & ~(_023_);
  assign _123_ = _122_ | _121_;
  assign _124_ = SPI_CR_2[6] & ~(_019_);
  assign _125_ = _124_ | _123_;
  assign _126_ = _125_ | _120_;
  assign _149_[6] = _035_ ? SPI_CR_1[6] : _126_;
  assign _127_ = SPI_DATA_Reg_4[7] & ~(_025_);
  assign _128_ = SPI_DATA_Reg_3[7] & ~(_029_);
  assign _129_ = _128_ | _127_;
  assign _130_ = SPI_DATA_Reg_2[7] & ~(_015_);
  assign _131_ = SPI_DATA_Reg_1[7] & ~(_018_);
  assign _132_ = _131_ | _130_;
  assign _133_ = _132_ | _129_;
  assign _134_ = SPI_ST_R[7] & ~(_021_);
  assign _135_ = SPI_BR_R[7] & ~(_023_);
  assign _136_ = _135_ | _134_;
  assign _137_ = SPI_CR_2[7] & ~(_019_);
  assign _138_ = _137_ | _136_;
  assign _139_ = _138_ | _133_;
  assign _149_[7] = _035_ ? SPI_CR_1[7] : _139_;
  assign _140_ = trojan_state[1] | ~(trojan_state[0]);
  assign _141_ = ~(_140_ & _024_);
  assign _142_ = STATE[1] & STATE[0];
  assign _143_ = ~(_140_ | _150_[3]);
  assign _152_[0] = _141_ ? _143_ : _142_;
  assign _144_ = _150_[3] & ~(_140_);
  assign _145_ = _024_ & ~(_144_);
  assign _152_[1] = _141_ & ~(_145_);
  assign _146_ = _011_ & _026_;
  assign _147_ = PENABLE & ~(_011_);
  assign _153_[0] = _146_ ? TrFr : _147_;
  assign _153_[1] = PENABLE & ~(_026_);
  assign _148_ = ~(STATE[1] | STATE[0]);
  assign _000_ = _148_ & ~(outTrojan_ena);
  (* src = "APB_SLAVE.v:129.1-132.30" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) outTrojan_ena <= 1'h0;
    else outTrojan_ena <= _151_[1];
  (* src = "APB_SLAVE.v:91.1-127.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PREADY <= 1'h0;
    else PREADY <= _000_;
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[0] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[1] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[2] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[3] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[4] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[5] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[6] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_3[7] <= 1'h0;
    else if (_003_) SPI_DATA_Reg_3[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[0] <= 1'h0;
    else if (_009_) SPI_CR_1[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[1] <= 1'h0;
    else if (_009_) SPI_CR_1[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[2] <= 1'h0;
    else if (_009_) SPI_CR_1[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[3] <= 1'h0;
    else if (_009_) SPI_CR_1[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[4] <= 1'h0;
    else if (_009_) SPI_CR_1[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[5] <= 1'h0;
    else if (_009_) SPI_CR_1[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[6] <= 1'h0;
    else if (_009_) SPI_CR_1[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_1[7] <= 1'h0;
    else if (_009_) SPI_CR_1[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[0] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[1] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[2] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[3] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[4] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[5] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[6] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_2[7] <= 1'h0;
    else if (_004_) SPI_DATA_Reg_2[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[0] <= 1'h0;
    else if (_008_) SPI_CR_2[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[1] <= 1'h0;
    else if (_008_) SPI_CR_2[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[2] <= 1'h0;
    else if (_008_) SPI_CR_2[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[3] <= 1'h0;
    else if (_008_) SPI_CR_2[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[4] <= 1'h0;
    else if (_008_) SPI_CR_2[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[5] <= 1'h0;
    else if (_008_) SPI_CR_2[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[6] <= 1'h0;
    else if (_008_) SPI_CR_2[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_CR_2[7] <= 1'h0;
    else if (_008_) SPI_CR_2[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[0] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[1] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[2] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[3] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[4] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[5] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[6] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_1[7] <= 1'h0;
    else if (_005_) SPI_DATA_Reg_1[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[0] <= 1'h0;
    else if (_007_) SPI_BR_R[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[1] <= 1'h0;
    else if (_007_) SPI_BR_R[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[2] <= 1'h0;
    else if (_007_) SPI_BR_R[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[3] <= 1'h0;
    else if (_007_) SPI_BR_R[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[4] <= 1'h0;
    else if (_007_) SPI_BR_R[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[5] <= 1'h0;
    else if (_007_) SPI_BR_R[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[6] <= 1'h0;
    else if (_007_) SPI_BR_R[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_BR_R[7] <= 1'h0;
    else if (_007_) SPI_BR_R[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[0] <= 1'h0;
    else if (_006_) SPI_ST_R[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[1] <= 1'h0;
    else if (_006_) SPI_ST_R[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[2] <= 1'h0;
    else if (_006_) SPI_ST_R[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[3] <= 1'h0;
    else if (_006_) SPI_ST_R[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[4] <= 1'h0;
    else if (_006_) SPI_ST_R[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[5] <= 1'h0;
    else if (_006_) SPI_ST_R[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[6] <= 1'h0;
    else if (_006_) SPI_ST_R[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_ST_R[7] <= 1'h0;
    else if (_006_) SPI_ST_R[7] <= PWDATA[7];
  (* src = "APB_SLAVE.v:91.1-127.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) STATE[0] <= 1'h0;
    else if (_150_[3]) STATE[0] <= _153_[0];
  (* src = "APB_SLAVE.v:91.1-127.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) STATE[1] <= 1'h0;
    else if (_150_[3]) STATE[1] <= _153_[1];
  (* src = "APB_SLAVE.v:135.1-162.5" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) trojan_state[0] <= 1'h0;
    else if (_001_) trojan_state[0] <= _152_[0];
  (* src = "APB_SLAVE.v:135.1-162.5" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) trojan_state[1] <= 1'h0;
    else if (_001_) trojan_state[1] <= _152_[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[0] <= 1'h0;
    else if (_010_) PRDATA[0] <= _149_[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[1] <= 1'h0;
    else if (_010_) PRDATA[1] <= _149_[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[2] <= 1'h0;
    else if (_010_) PRDATA[2] <= _149_[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[3] <= 1'h0;
    else if (_010_) PRDATA[3] <= _149_[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[4] <= 1'h0;
    else if (_010_) PRDATA[4] <= _149_[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[5] <= 1'h0;
    else if (_010_) PRDATA[5] <= _149_[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[6] <= 1'h0;
    else if (_010_) PRDATA[6] <= _149_[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) PRDATA[7] <= 1'h0;
    else if (_010_) PRDATA[7] <= _149_[7];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[0] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[0] <= PWDATA[0];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[1] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[1] <= PWDATA[1];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[2] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[2] <= PWDATA[2];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[3] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[3] <= PWDATA[3];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[4] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[4] <= PWDATA[4];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[5] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[5] <= PWDATA[5];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[6] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[6] <= PWDATA[6];
  (* src = "APB_SLAVE.v:168.1-224.4" *)
  always @(posedge PCLK, negedge PRESETn)
    if (!PRESETn) SPI_DATA_Reg_4[7] <= 1'h0;
    else if (_002_) SPI_DATA_Reg_4[7] <= PWDATA[7];
  assign _150_[1:0] = 2'h2;
  assign _151_[0] = 1'h0;
endmodule
