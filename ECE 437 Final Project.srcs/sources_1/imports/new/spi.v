module spi_toplevel(
 output [7:0] led,
 output FSM_Clk,
 output ILA_Clk,
 input sys_clkn,
 input sys_clkp,

 output reg [7:0] State,
 input wire [31:0] PC_control,
 output CVM300_SPI_EN,
 input CVM300_SPI_OUT,
 output CVM300_SPI_CLK,
 output  CVM300_SPI_IN,
 output reg miso,
 output reg mosi,
 output reg sclk,
 output reg en,
 
 input [7:0] data,
 output reg [31:0] val,
 input [7:0] add

 );
    
 wire [23:0] ClkDivThreshold = 5; // to set FSM clk to 40 kHz? ILA clk is 20 MHz
// wire FSM_Clk, ILA_Clk;
 wire [11:0] div;
 reg clkdiv;
 reg [8:0] count = 0;
 assign div = 12'h800;
// wire [8:0] add=8'h83;

 initial
 begin
     clkdiv = 0;
     miso = 1'bz;
     mosi = 1'b0;
     sclk =1'b0;
    // ACK_bit = 1'b1;
     State = 8'd0;
     val = 0;
 end
 
 localparam STATE_INIT = 8'd0;
//    always @(*) begin          
//        FSM_Clk_reg = FSM_Clk;
//        ILA_Clk_reg = ILA_Clk;  
//    end  
 ClockGenerator ClockGenerator1(.sys_clkn(sys_clkn),
                                 .sys_clkp(sys_clkp),
                                 .ClkDivThreshold(ClkDivThreshold),
                                 .FSM_Clk(FSM_Clk),
                                 .ILA_Clk(ILA_Clk));

 assign CVM300_SPI_IN=mosi;
 assign CVM300_SPI_OUT=miso;
 assign CVM300_SPI_EN=en;
 assign CVM300_SPI_CLK=sclk;
 always @(posedge ILA_Clk) begin
    case (State)
 // Press Button[3] to start the state machine. Otherwise, stay in the STATE_INIT state
 STATE_INIT : begin
      en<= 1'b0;
      sclk<= 1'b0;
     if (PC_control[0] == 1'b1) State <= 8'd1;
     else begin
     State <= 8'd0;
     end
 end
 
 8'd1 : begin
 en<= 1'b0;
 sclk<= 1'b0;
 if (PC_control[1]==1'b1)
    State<=8'd100;
 else
    State <= 8'd30;
 end
 
 
 
 8'd30: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= 1'b0;
 State <= State + 1'b1;
 end
 8'd31: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd32: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[6];
 State <= State + 1'b1;
 end
 8'd33: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd34: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[5];
 State <= State + 1'b1;
 end
 8'd35: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd36: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[4];
 State <= State + 1'b1;
 end
 8'd37: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd38: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[3];
 State <= State + 1'b1;
 end
 8'd39: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd40: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[2];
 State <= State + 1'b1;
 end
 8'd41: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd42: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[1];
 State <= State + 1'b1;
 end
 8'd43: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd44: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[0];
 State <= State + 1'b1;
 end
 8'd45: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 /////////////////////////////////////////////////////////////
 8'd46: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= 1'b0;
 val[7]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end
 8'd47: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[7]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end
 8'd48: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[6];
 val[6]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd49: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[6]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end
 8'd50: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[5];
 val[5]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd51: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[5]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end
 8'd52: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[4];
 val[4]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd53: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[4]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end 
 8'd54: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[3];
 val[3]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd55: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[3]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end 
 8'd56: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[2];
 val[2]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd57: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[2]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end 
 8'd58: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[1];
 val[1]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd59: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[1]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end 
 8'd60: begin
 en<= 1'b1;
 sclk<= 1'b0;
// mosi <= add[0];
 val[0]<=CVM300_SPI_OUT;
State <= State + 1'b1;
 end
 8'd61: begin
 en<= 1'b1;
 sclk<= 1'b1;
 val[0]<=CVM300_SPI_OUT;
 State <= State + 1'b1;
 end 
 8'd62: begin
 en<= 1'b1;
 sclk<= 1'b0;
 State <= State + 1'b1;
 end 
 8'd63: begin
 en<= 1'b0;
 sclk<= 1'b0;
  if (PC_control[0] == 1'b0) State <= 8'd0;
 else begin
 State <= State;
 end
 end 
 
 
 
 
 
 
 
 
 
 8'd100: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= 1'b1;
 State <= State + 1'b1;
 end
 8'd101: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd102: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[6];
 State <= State + 1'b1;
 end
 8'd103: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd104: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[5];
 State <= State + 1'b1;
 end
 8'd105: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd106: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[4];
 State <= State + 1'b1;
 end
 8'd107: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd108: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[3];
 State <= State + 1'b1;
 end
 8'd109: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd110: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[2];
 State <= State + 1'b1;
 end
 8'd111: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd112: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[1];
 State <= State + 1'b1;
 end
 8'd113: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd114: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= add[0];
 State <= State + 1'b1;
 end
 8'd115: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd116: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[7];
 State <= State + 1'b1;
 end
 8'd117: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd118: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[6];
 State <= State + 1'b1;
 end
 8'd119: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd120: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[5];
 State <= State + 1'b1;
 end
 8'd121: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end
 8'd122: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[4];
 State <= State + 1'b1;
 end
 8'd123: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd124: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[3];
 State <= State + 1'b1;
 end
 8'd125: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd126: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[2];
 State <= State + 1'b1;
 end
 8'd127: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd128: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[1];
 State <= State + 1'b1;
 end
 8'd129: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd130: begin
 en<= 1'b1;
 sclk<= 1'b0;
 mosi <= data[0];
 State <= State + 1'b1;
 end
 8'd131: begin
 en<= 1'b1;
 sclk<= 1'b1;
 State <= State + 1'b1;
 end 
 8'd132: begin
 en<= 1'b1;
 mosi <= 1'b0;
 sclk<= 1'b0;
 State <= State + 1'b1;
 end 
 8'd133: begin
 en<= 1'b0;
 sclk<= 1'b0;
  if (PC_control[0] == 1'b0) State <= 8'd0;
 else begin
 State <= State;
 end
 end 
 
 default : begin
// error_bit <= 0;
 end
 endcase
 end
 
endmodule
