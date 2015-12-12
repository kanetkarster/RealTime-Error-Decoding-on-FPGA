/********************************************************
/   32bit UNIFORM DISTRIBUTED RANDOM NUMBER GENERATOR   /
/                                                       /
/   Author: Mike Yuhas                                  /
/   Date:   2014-11-18                                  /
/                                                       /
/   Arguments:                                          /
/     CLK - Every rising edge a new output is produced  /
/   Returns:                                            /
/     Y - A uniformly distributed RV with 32bits        /
********************************************************/

module uniformRV32 ( RST, CLK, Y );
  
  input   CLK;
  input   RST;
  
  parameter SEED = 32'h0F0F0F0F;

  output reg [31:0]  Y;
  
  reg  [31:0] next;
  
  always@* begin
    next[31] = Y[30];
    next[30] = Y[29];
    next[29] = Y[28];
    next[28] = Y[27];
    next[27] = Y[26];
    next[26] = Y[25];
    next[25] = Y[24];
    next[24] = Y[23];
    next[23] = Y[22];
    next[22] = Y[21];
    next[21] = Y[20];
    next[20] = Y[19];
    next[19] = Y[18];
    next[18] = Y[17];
    next[17] = Y[16];
    next[16] = Y[15];
    next[15] = Y[14];
    next[14] = Y[13];
    next[13] = Y[12];
    next[12] = Y[11];
    next[11] = Y[10];
    next[10] = Y[9];
    next[9] = Y[8];
    next[8] = Y[7];
    next[7] = Y[6];
    next[6] = Y[5];
    next[5] = Y[4];
    next[4] = Y[3];
    next[3] = Y[2];
    next[2] = Y[1];
    next[1] = Y[0];
    next[0] = Y[31]^Y[21]^Y[1]^Y[0];
  end
  
  always@(posedge CLK or posedge RST) begin
    if (RST) begin
      Y <= SEED;
    end else begin
      Y <= next;
    end
  end
  
endmodule
