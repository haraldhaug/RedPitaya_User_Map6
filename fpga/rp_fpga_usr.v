// HH : 2017-02-18 new module for memory map "6"

module rp_fpga_usr (
  // system signals
  input                clk_i      ,  // clock
  input                rstn_i     ,  // reset - active low
  // LED
  output reg [7:0] led_o,        // LED output
  // System bus
  input      [ 32-1:0] sys_addr   ,  // bus address
  input      [ 32-1:0] sys_wdata  ,  // bus write data
  input                sys_wen    ,  // bus write enable
  input                sys_ren    ,  // bus read enable
  output reg [ 32-1:0] sys_rdata  ,  // bus read data
  output reg           sys_err    ,  // bus error indicator
  output reg           sys_ack       // bus acknowledge signal
);
reg [31:0] lCnt;
reg [31:0] cntLim;
//reg [3:0] togPattern;


always @(posedge clk_i)
if (rstn_i == 1'b0) begin
  lCnt <= 32'd0; // reset the counter
  led_o[7:0] <= 8'H3; // initialize the blinkin: 2 LEDs on / 2 LEDs off
  cntLim <= 32'H03FFFFFF; // set the blinking period to some human -visible value
end else if (sys_wen) begin
  // 0x00600000
  // [31:28] [27:24] [23:20] [19:16] [15:12] [11:8] [7:4] [3:0]  
  if (sys_addr[19:0]==20'h0) begin  led_o[7] <= sys_wdata[7]; led_o[6] <=  ~led_o[6]; end // 0x00 LED
  if (sys_addr[19:0]==20'h4) begin  led_o[3:0] <= sys_wdata[3:0]; led_o[4] <=  ~led_o[4]; end // 0x04 pattern
  if (sys_addr[19:0]==20'h8) begin  cntLim[31:0] <= sys_wdata[31:0]; led_o[5] <= ~led_o[5]; end // 0x08 period
end else begin 
  if (lCnt[31:0] > cntLim[31:0]) begin
    // toggle 4 LEDs when the counter has reached the limit
    lCnt <= 32'd0;
    led_o[3:0] <=  ~led_o[3:0];
  end else begin
    lCnt <= lCnt + 32'd1;
  end
end

wire sys_en;
assign sys_en = sys_wen | sys_ren;

always @(posedge clk_i)
if (rstn_i == 1'b0) begin
  sys_err <= 1'b0;
  sys_ack <= 1'b0;
end else begin
  sys_err <= 1'b0;

  casez (sys_addr[19:0])
    20'h00000: begin sys_ack <= sys_en;  sys_rdata <= {24'h0, led_o[7], 7'b0}             ; end
    20'h00004: begin sys_ack <= sys_en;  sys_rdata <= {28'h0, led_o[3:0]}             ; end
    20'h00008: begin sys_ack <= sys_en;  sys_rdata <= cntLim             ; end

    default: begin sys_ack <= sys_en;  sys_rdata <=  32'h0; end // need to acknoledge write access ?
  endcase
  
end



endmodule
