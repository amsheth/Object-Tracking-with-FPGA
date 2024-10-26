`timescale 1ns / 1ps

module finaltoplevel(   

    output CVM300_CLK_IN,
    input CVM300_CLK_OUT,
    output CVM300_SYS_RES_N,
    output CVM300_FRAME_REQ,
    input CVM300_Enable_LVDS,
    input CVM300_Line_valid,
    input CVM300_Data_valid,
    input [9:0] CVM300_D,
    
    output CVM300_SPI_EN,
    input CVM300_SPI_OUT,
    output CVM300_SPI_CLK,
    output  CVM300_SPI_IN,
   
    output [7:0] led,
    input sys_clkn,
    input sys_clkp,  
    
    output LSM303_INT1,
    output LSM303_INT2,
    output I2C_SCL_1,
    inout I2C_SDA_1,
    
    output PMOD_A1,
    output PMOD_A2,

    inout PMOD_A3,
    inout PMOD_A4,
    inout PMOD_A7,
    inout PMOD_A8,
    inout PMOD_A9,
    inout PMOD_A10,
   
    input  [4:0] okUH,
    output [2:0] okHU,
    inout  [31:0] okUHU,
    inout  okAA      
);

    ///////////////////////////////////////////////////////////// GLOBAL CONTROL VARIABLES
    wire [31:0] SPI_control, I2C_control, motor_control;
    wire TrigerEvent;

    // MAIN: WRITTEN TO BY CLOCK GENERATOR
    wire ILA_Clk, ACK_bit, FSM_Clk;
    
    
    
    
    /////////////////////////////////////////////////////////////////// I2C STUFF
    // monitoring signal from module    
    wire SCL, SDA; 

    // monitoring signal from module
    wire [8:0] I2C_State;

    // coming in from okwirein
    wire [31:0] tempregadd;
    wire [31:0] regadd;
    wire [31:0] regval;
    wire [31:0] i2c_slave_address;

    // going out through okwireout
    wire [31:0] tempval, tempval2, tempval3;
    
    I2C_Transmit I2C_Test1 (        
        .led(),
        .FSM_Clk(clk),
//        .ILA_Clk(ILA_Clk),
        // .ADT7420_A0(LSM303_INT1),
        // .ADT7420_A1(LSM303_INT2),

        // directly updates pins with internal happenings             
        .I2C_SCL_1(I2C_SCL_1),
        .I2C_SDA_1(I2C_SDA_1),

        .ACK_bit(ACK_bit),

        // for our own signal monitoring
        .SCL(),
        .SDA(),

        .PC_control(I2C_control),

        // input wires
        .i2c_slave_address(i2c_slave_address),
        .tempregadd(tempregadd),
        .regadd(regadd),
        .regval(regval),

        // output regs
        .tempval(tempval), .tempval2(tempval2), .tempval3(tempval3)
    );

    ///////////////////////////////////////////////////////////////////////////// VALUES FOR FIFO STUFF TO WORK
    
    localparam STATE_INIT                = 8'd0;
    localparam STATE_RESET               = 8'd1;   
    localparam STATE_DELAY               = 8'd2;
    localparam STATE_RESET_FINISHED      = 8'd3;
    localparam STATE_FRAME_REQ           = 8'd4;
    localparam STATE_FINISH              = 8'd5;
    
    reg [31:0] counter = 8'd0;
    reg [15:0] counter_delay = 16'd0;
    reg [7:0] State = STATE_INIT;
    reg [7:0] led_register = 0;
    reg [3:0] button_reg, write_enable_counter;  
    
    reg write_reset, read_reset, write_enable = 0; // initialize without initial block??
    
    wire [31:0] Reset_Counter;
    wire [31:0] DATA_Counter;    
    wire FIFO_read_enable, FIFO_BT_BlockSize_Full, FIFO_full, FIFO_empty, BT_Strobe;
    wire [31:0] FIFO_data_out;
    
    wire clkout;
    assign clkout = CVM300_CLK_OUT;
   
    reg frame_req = 0; 
    wire [7:0] dat;
    assign dat = CVM300_D[9:2];
    assign CVM300_FRAME_REQ = frame_req;
 
    //////////////////////////////////////////////////////////////////////////// SPI STUFF
    wire miso;
    wire mosi;
    wire en;
    wire sclk;
    wire [31:0] val;
    wire [31:0] add;
    wire [31:0] data;
    
    spi_toplevel spi(
    .led(),
    .FSM_Clk(FSM_Clk),
    .ILA_Clk(ILA_Clk),
    .sys_clkn(sys_clkn),
    .sys_clkp(sys_clkp),
    .State(SPI_STATE),
    .PC_control(SPI_control),
    .CVM300_SPI_EN(CVM300_SPI_EN),
    .CVM300_SPI_OUT(CVM300_SPI_OUT),
    .CVM300_SPI_CLK(CVM300_SPI_CLK),
    .CVM300_SPI_IN(CVM300_SPI_IN),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .en(en),
    .data(data[7:0]),
    .val(val),
    .add(add[7:0])
    );
    
    
    ///////////////////////////////////////////////////////////// MOTOR CONTROLLER
    wire [31:0] cycle_count; // could be made a reg before passing to module?
    
    motor_controller motor (    .FSM_Clk(FSM_Clk),
                                .led(led),
                                .PMOD_A1(PMOD_A1),
                                .PMOD_A2(PMOD_A2), .PMOD_A3(PMOD_A3), .PMOD_A4(PMOD_A4), .PMOD_A7(PMOD_A7), .PMOD_A8(PMOD_A8), .PMOD_A9(PMOD_A9), 
                                .PMOD_A10(PMOD_A10), .button(motor_control[3:0]),
                                .cycle_count(cycle_count)
                                );
    

    //////////////////////////////////////////////////////////////////////////////////////// OKHOST STUFF
        
    wire okClk;            //These are FrontPanel wires needed to IO communication    
    wire [112:0]    okHE;  //These are FrontPanel wires needed to IO communication    
    wire [64:0]     okEH;  //These are FrontPanel wires needed to IO communication
   
    //This is the OK host that allows data to be sent or recived    
    okHost hostIF (
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okClk(okClk),
        .okAA(okAA),
        .okHE(okHE),
        .okEH(okEH)
    );
                     
     ////////////////////////////////////////////////////////////////////////////////////////////// FIFO MODULE 
     
     fifo_generator_0 FIFO_for_Counter_BTPipe_Interface (
        .wr_clk(CVM300_CLK_OUT),
        .wr_rst(write_reset),
        .rd_clk(okClk),
        .rd_rst(read_reset),
        .din(CVM300_D[9:2]),
        .wr_en(CVM300_Data_valid && CVM300_Line_valid), // write to FIFO when line valid signal goes high... what about data valid?
        .rd_en(FIFO_read_enable),
        .dout(FIFO_data_out),
        .full(FIFO_full),
        .empty(FIFO_empty),       
        .prog_full(FIFO_BT_BlockSize_Full)        
    );
      

     /////////////////////////////////////////////////////////// OK WIRE INS FOR CONTROLLING SPI AND CAMERA 
     
     okWireIn wire0 (  .okHE(okHE),
                        .ep_addr(8'h00),
                        .ep_dataout(SPI_control));
                        
     okWireIn wire1 (  .okHE(okHE),
                        .ep_addr(8'h01),
                        .ep_dataout(data));
                        
     okWireIn wire2 (  .okHE(okHE),
                        .ep_addr(8'h02),
                        .ep_dataout(add));
                        
//     okWireIn wire3 (  .okHE(okHE),
//                        .ep_addr(8'h03),
//                        .ep_dataout(Reset_Counter));

    // I2C wireins 

    okWireIn wire4 (   .okHE(okHE),
                        .ep_addr(8'h04),
                        .ep_dataout(I2C_control));
    okWireIn wire5 (   .okHE(okHE),
                        .ep_addr(8'h05),
                        .ep_dataout(i2c_slave_address));
    okWireIn wire6 (   .okHE(okHE),
                        .ep_addr(8'h06),
                        .ep_dataout(tempregadd));
    okWireIn wire7 (   .okHE(okHE),
                        .ep_addr(8'h07),
                        .ep_dataout(regval));
    okWireIn wire8 (   .okHE(okHE),
                        .ep_addr(8'h08),
                        .ep_dataout(regadd));        

    // motor wireins
    okWireIn wire9 (   .okHE(okHE),
                        .ep_addr(8'h09),
                        .ep_dataout(motor_control));

    okWireIn wire10 (   .okHE(okHE),
                        .ep_addr(8'h10),
                        .ep_dataout(cycle_count));
    reg [8:0]cnt;
    reg clk;
    always @(posedge FSM_Clk) begin
    if (cnt >= 10) begin
        cnt <= 0;
        clk <= ~clk; // Toggle the output clock
    end else begin
        cnt <= cnt + 1;
    end
end                                 
    okTriggerIn trigIn53 (.okHE(okHE),.ep_addr(8'h40), .ep_clk(FSM_Clk), .ep_trigger(Reset_Counter));
//    okTriggerIn trigIn44 (.okHE(okHE),.ep_addr(8'h44), .ep_clk(clk), .ep_trigger(I2C_control));                    
    //////////////////////////////////////////////////////////// OK WIRE OUTS FOR SPI CONFIRMATION
    
    localparam endPt_count = 2 + 3;
    wire [endPt_count*65-1:0] okEHx;
    okWireOR # (.N(endPt_count)) wireOR (okEH, okEHx);
   
    okWireOut wire20 ( .okHE(okHE),
    .okEH(okEHx[ 0*65 +: 65 ]),
    .ep_addr(8'h20),
    .ep_datain(val));
    
    okBTPipeOut CounterToPC (
        .okHE(okHE), 
        .okEH(okEHx[ 1*65 +: 65 ]),
        .ep_addr(8'hA0), 
        .ep_datain(FIFO_data_out),
        .ep_read(FIFO_read_enable),
        .ep_blockstrobe(BT_Strobe), 
        .ep_ready(FIFO_BT_BlockSize_Full)
    );

    okWireOut wire21 ( .okHE(okHE),
    .okEH(okEHx[ 2*65 +: 65 ]),
    .ep_addr(8'h21),
    .ep_datain(tempval[15:0]));
    
    okWireOut wire22 ( .okHE(okHE),
    .okEH(okEHx[ 3*65 +: 65 ]),
    .ep_addr(8'h22),
    .ep_datain(tempval2[15:0]));
    
    okWireOut wire23 ( .okHE(okHE),
    .okEH(okEHx[ 4*65 +: 65 ]),
    .ep_addr(8'h23),
    .ep_datain(tempval3[15:0]));                                          
    
    
    ////////////////////////////////////////////////////////// CAMERA READING CODE -> CLOCKS CONTROLLED INSIDE SPI MODULE
//    reg [8:0]cnt=0;
//    reg clk;
    assign CVM300_CLK_IN = FSM_Clk;
//    always @(posedge FSM) begin
//    if (cnt >= 40) begin
//        cnt <= 0;
//        clk <= ~clk; // Toggle the output clock
//    end 
//    else begin
//        cnt <= cnt + 1;
//    end
//    end
    always @(posedge FSM_Clk) begin
    
        if (Reset_Counter[0] == 1'b1) State <= STATE_RESET;
        
        case (State)
            STATE_INIT:   begin                              
                if (Reset_Counter[0] == 1'b1) State <= STATE_RESET;                
            end
            
            STATE_RESET:   begin
                counter <= 0;
                counter_delay <= 0;
                write_reset <= 1'b1;
                read_reset <= 1'b1;                
                if (Reset_Counter[0] == 1'b0) State <= STATE_RESET_FINISHED;             
            end                                     
 
           STATE_RESET_FINISHED:   begin
                write_reset <= 1'b0;
                read_reset <= 1'b0;                 
                State <= STATE_DELAY;                                   
            end   
                          
            STATE_DELAY:   begin // does this state also give us the necessary wait time of 1 us?
                if (counter_delay == 16'b0000_0000_0000_0000)  State <= STATE_FRAME_REQ;
                else counter_delay <= counter_delay + 1;
            end
            
             STATE_FRAME_REQ: begin
                frame_req <= 1;
                State <= STATE_FINISH;
             end
                                  
             STATE_FINISH:   begin
                frame_req <= 0;
                State <= STATE_INIT; // you just sit here, the DVAL will handle the write enable as pixels get written
             end

        endcase
    end
    
    
    ////////////////////////////////////////////////////////////////////////////// ILA MODULE
    ila_0 ila_sample12 ( 
        .clk(ILA_Clk),                      
        .probe0(dat[7:0]),//8
        .probe1(frame_req), //1
        .probe2({Reset_Counter[0],FSM_Clk}), //1
        .probe3(clkout) //1      
//        .probe4(CVM300_CLK_IN) //1
//        .probe5(Reset_Counter[0]),
//        .probe6(State)
    );      
   
                           
endmodule