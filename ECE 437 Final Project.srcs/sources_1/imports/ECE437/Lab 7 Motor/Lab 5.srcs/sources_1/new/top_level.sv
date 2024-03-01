`timescale 1ns / 1ps

module top_level( sdsldkslkdlskdlskldskldklskdlskdlskdsl;kd  
    output [7:0] led,
    input sys_clkn,
    input sys_clkp,  
    output LSM303_INT1,
    output LSM303_INT2,
    output I2C_SCL_1,
    inout I2C_SDA_1,
    input  [4:0] okUH,
    output [2:0] okHU,
    inout  [31:0] okUHU,
    output reg PMOD_A1,
    output reg PMOD_A2,
    inout PMOD_A3,
    inout PMOD_A4,
    inout PMOD_A7,
    inout PMOD_A8,
    inout PMOD_A9,
    inout PMOD_A10,
    inout  okAA,
    input [3:0] button    
);

    wire  ILA_Clk, ACK_bit, FSM_Clk, TrigerEvent;    
    wire [23:0] ClkDivThreshold = 1_000;   
    wire SCL, SDA; 
    wire [8:0] State;
    wire [31:0] PC_control;
    wire [31:0] tempregadd;
    wire [24:0]regval;
    wire [31:0]tempval;
    wire [31:0]SingleByteData;
    wire [31:0] motor_controller_1;
    reg [31:0] cycle_count;
    initial begin
    cycle_count=0;
    end
    assign TrigerEvent = PC_control[0];   

    //Instantiate the module that we like to test
    I2C_Transmit I2C_Test1 (        
//        .led(led),/
        .sys_clkn(sys_clkn),
        .sys_clkp(sys_clkp),
        .ADT7420_A0(LSM303_INT1),
        .ADT7420_A1(LSM303_INT2),
        .I2C_SCL_0(I2C_SCL_1),
        .I2C_SDA_0(I2C_SDA_1),             
        .FSM_Clk_reg(FSM_Clk),        
        .ILA_Clk_reg(ILA_Clk),
        .ACK_bit(ACK_bit),
        .SCL(SCL),
        .SDA(SDA),
        .State(State),
        .PC_control(PC_control),
        .okUH(okUH),
        .okHU(okHU),
        .okUHU(okUHU),
        .okAA(okAA),
        .tempval(tempval),
        .tempregadd(tempregadd),
        .SingleByteData(SingleByteData),
        .regval(regval),
        .motor_controller_1(motor_controller_1),
        .cycle_count(cycle_count)
        );
        
     // motor is instantiated here... different clock generated for it
     motor_controller motor (   .FSM_Clk(FSM_Clk),
                                .led(led),
//                                .sys_clkn(sys_clkn),.sys_clkp(sys_clkp), 
                                .PMOD_A1(PMOD_A1),
                                .PMOD_A2(PMOD_A2), .PMOD_A3(PMOD_A3), .PMOD_A4(PMOD_A4), .PMOD_A7(PMOD_A7), .PMOD_A8(PMOD_A8), .PMOD_A9(PMOD_A9), 
                                .PMOD_A10(PMOD_A10), .button(motor_controller_1[3:0])
                                , .cycle_count(cycle_count)
                                );
                             
    //Instantiate the ILA module
    ila_0 ila_sample12 ( 
        .clk(ILA_Clk),
        .probe0({State, SDA, SCL, ACK_bit}),                             
        .probe1({FSM_Clk, TrigerEvent}),
        .probe2(cycle_count)
        );                        
                                                  
endmodule