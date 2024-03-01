`timescale 1ns / 1ps

module I2C_Transmit(    
    output [7:0] led,
    input  FSM_Clk,
//    input  ILA_Clk,
//     output ADT7420_A0,
//     output ADT7420_A1,
    output I2C_SCL_1,
    inout  I2C_SDA_1,        
    output reg ACK_bit,
    output reg SCL,
    output reg SDA,
    output reg [8:0] I2C_State,
    input wire [31:0] PC_control,
    input wire [31:0] i2c_slave_address,
    input wire [31:0] tempregadd,
    input wire [31:0] regadd,
    input wire [31:0] regval,
    output reg [31:0] tempval, tempval2, tempval3
    );

                  
       
    localparam STATE_INIT = 9'd0;

    assign led[7] = ACK_bit;

    assign I2C_SCL_1 = SCL;
    assign I2C_SDA_1 = SDA;
   
    initial  begin
        SCL = 1'b1;
        SDA = 1'b1;
        ACK_bit = 1'b1;  
        I2C_State = 9'd0;
        tempval = 0;
        tempval2 = 0; 
        tempval3 = 0;
    end // these are all module parameter registers sent out for monitoring and recording
   
/*    always @(*) begin          
        FSM_Clk_reg = FSM_Clk;
        ILA_Clk_reg = ILA_Clk;  
    end  */

 
    always @(posedge FSM_Clk) begin 

        case (I2C_State)
              
            STATE_INIT : begin
                 if (PC_control[0] == 1'b1) I2C_State <= 9'd1;                    
                 else begin                
                      SCL <= 1'b1;
                      SDA <= 1'b1;
                      I2C_State <= 9'd0;
                  end
            end            
           
            // This is the Start sequence            
            9'd1 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;                                
            end  
            // SCL low
            9'd2 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            // transmit bit 7 start device address transmission
            9'd3 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[7];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd4 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd5 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd6 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 6
            9'd7 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[6];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd8 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd9 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd10 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 5
            9'd11 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[5];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd12 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd13 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd14 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 4
            9'd15 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[4];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd16 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd17 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd18 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 3
            9'd19 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[3];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd20 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd21 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd22 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
            // transmit bit 2
            9'd23 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[2];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd24 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd25 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd26 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
 
            // transmit bit 1
            9'd27 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[1];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd28 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd29 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd30 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
           
            // transmit bit 0
            9'd31 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[0];      
                  I2C_State <= I2C_State + 1'b1;          
            end  

            9'd32 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd33 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd34 : begin
                  SCL <= 1'b0;                  
                  I2C_State <= I2C_State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
            9'd35 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd36 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd37 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd38 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
           
            9'd39 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[7];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd40 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd41 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd42 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd43 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[6];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd44 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd45 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd46 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd47 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[5];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd48 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd49 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd50 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd51 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[4];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd52 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd53 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd54 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd55 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[3];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd56 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd57 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd58 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd59 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[2];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd60 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[2];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd61 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd62 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[2];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd63 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[1];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd64 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd65 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd66 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd67 : begin
                    SCL<= 1'b0;
                    SDA <= tempregadd[0];
                    ACK_bit<=1;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd68 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd69 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd70 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd71 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd72 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd73 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd74 : begin
                  SCL <= 1'b0;
                  I2C_State <= 9'd80;
            end  

             9'd80 : begin
                  SCL <= 1'b0;
                  SDA <= regval[7];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd81 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd82 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd83 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 6
            9'd84 : begin
                  SCL <= 1'b0;
                  SDA <= regval[6];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd85 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd86 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd87 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 5
            9'd88 : begin
                  SCL <= 1'b0;
                  SDA <= regval[5];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd89 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd90 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd91 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 4
            9'd92 : begin
                  SCL <= 1'b0;
                  SDA <= regval[4];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd93 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd94 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd95 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 3
            9'd96 : begin
                  SCL <= 1'b0;
                  SDA <= regval[3];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd97 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd98 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd99 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
            // transmit bit 2
            9'd100 : begin
                  SCL <= 1'b0;
                  SDA <= regval[2];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd101 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd102 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd103 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
 
            // transmit bit 1
            9'd104 : begin
                  SCL <= 1'b0;
                  SDA <= regval[1];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd105 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd106 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd107 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
           
            // transmit bit 0
            9'd108 : begin
                  SCL <= 1'b0;
                  SDA <=regval[0];  
                  ACK_bit=1;    
                  I2C_State <= I2C_State + 1'b1;          
            end  

            9'd109 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd110 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd111 : begin
                  SCL <= 1'b0;                  
                  I2C_State <= I2C_State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
           
            9'd112 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd113 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd114 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd115 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end 
            9'd116 : begin
                  SCL <= 1'b0;
                  SDA<= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd117 : begin
                  SCL <= 1'b0;
                  SDA<=1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd118 : begin
                  SCL <= 1'b1;
                  //SDA<= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd119 : begin
                  SCL<= 1'b1;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd120 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;                
            end       
            9'd121 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[7];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd122 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd123 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd124 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 6
            9'd125 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[6];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd126 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd127 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd128 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 5
            9'd129 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[5];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd130: begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd131 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd132 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 4
            9'd133 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[4];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd134 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd135 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd136 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 3
            9'd137 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[3];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd138 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd139 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd140 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
            // transmit bit 2
            9'd141 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[2];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd142 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd143 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd144 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
 
            // transmit bit 1
            9'd145 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[1];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd146 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd147 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd148 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
           
            // transmit bit 0
            9'd149 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[0];      
                  I2C_State <= I2C_State + 1'b1;          
            end  

            9'd150 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd151 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd152 : begin
                  SCL <= 1'b0;                  
                  I2C_State <= I2C_State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
            9'd153 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd154 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd155 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd156 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
           
            9'd157 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[7];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd158 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd159 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd160 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd161 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[6];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd162: begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd163 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd164 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[6];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd165 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[5];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd166 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd167 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd168 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[5];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd169 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[4];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd170 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd171 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd172 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[4];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd173 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[3];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd174 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd175 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd176 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[3];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd177 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[2];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd178 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[2];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd179 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd180 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[2];                    
                    I2C_State<=I2C_State+ 10;
            end
            9'd190 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[1];
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd191 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd192 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd193 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[1];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd194 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[0];
                    ACK_bit<=1;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd195 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd196 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd197 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[0];                    
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd198 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd199 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd200 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd201 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
            //Beginning restart/////////////////////////////////////////////////////////////////////
            9'd202 : begin
                  SCL <= 1'b0;
                  SDA<= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd203 : begin
                  SCL <= 1'b0;
                  SDA<=1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd204 : begin
                  SCL <= 1'b1;
                  //SDA<= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd205 : begin
                  SCL<= 1'b1;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            9'd206 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;                
            end
            9'd207 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[7];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd208 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd209 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd210 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 6
            9'd211 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[6];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd212 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd213 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd214 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 5
            9'd215 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[5];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd216 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd217: begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd218 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 4
            9'd219 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[4];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd220 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd221 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd222 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  

            // transmit bit 3
            9'd223 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[3];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd224 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd225 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd226 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
            // transmit bit 2
            9'd227 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[2];
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd228 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd229 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd230 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
 
            // transmit bit 1
            9'd231 : begin
                  SCL <= 1'b0;
                  SDA <= i2c_slave_address[1];  
                  I2C_State <= I2C_State + 1'b1;              
            end  

            9'd232 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd233 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd234 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
           
            // transmit bit 0
            9'd235 : begin
                  SCL <= 1'b0;
                  SDA <=1'b1;  
                  ACK_bit=1;    
                  I2C_State <= I2C_State + 1'b1;          
            end  

            9'd236 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd237 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd238 : begin
                  SCL <= 1'b0;                  
                  I2C_State <= I2C_State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
           
            9'd239 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd240 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd241 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd242 : begin
                  SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end  
           
            /////// reading temp msb
           
            9'd243 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
//                    tempval[15]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd244 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd245 : begin
                    SCL<= 1'b1;

                    tempval[15]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd246 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd247 : begin
                    SCL<= 1'b0;
//                    tempval[14]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd248 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd249 : begin
                    SCL<= 1'b1;

                    tempval[14]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd250 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd251 : begin
                    SCL<= 1'b0;
//                    tempval[13]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd252 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd253 : begin
                    SCL<= 1'b1;

                    tempval[13]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd254 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd255 : begin
                    SCL<= 1'b0;
//                    tempval[12]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd256 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd257 : begin
                    SCL<= 1'b1;

                    tempval[12]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd258 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd259 : begin
                    SCL<= 1'b0;
//                    tempval[11]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd260 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd261 : begin
                    SCL<= 1'b1;

                    tempval[11]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd262 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd263 : begin
                    SCL<= 1'b0;
//                    tempval[10]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd264 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd265 : begin
                    SCL<= 1'b1;

                    tempval[10]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd266 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd267 : begin
                    SCL<= 1'b0;
//                    tempval[9]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd268 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd269 : begin
                    SCL<= 1'b1;

                    tempval[9]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd270 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd271 : begin
                    SCL<= 1'b0;
//                    tempval[8]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd272 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd273 : begin
                    SCL<= 1'b1;

                    tempval[8]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd274 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd275 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0; ///SETTING MASTER ACK VALUE TO 0
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd276 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd277 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd278 : begin
                 SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
                 
                 
            //// BEGINNING LSB REG
            end        
            9'd279 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd280 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd281 : begin
                    SCL<= 1'b1;
                    tempval[7]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd282 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd283 : begin
                    SCL<= 1'b0;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd284 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd285 : begin
                    SCL<= 1'b1;
                    tempval[6]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd286 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd287 : begin
                    SCL<= 1'b0;
//                    tempval[5]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd288 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd289 : begin
                    SCL<= 1'b1;

                    tempval[5]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd290 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd291 : begin
                    SCL<= 1'b0;
//                    tempval[4]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd292 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd293 : begin
                    SCL<= 1'b1;

                    tempval[4]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd294 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd295 : begin
                    SCL<= 1'b0;
//                    tempval[3]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd296 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd297 : begin
                    SCL<= 1'b1;

                    tempval[3]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd298 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd299 : begin
                    SCL<= 1'b0;
//                    tempval[2]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd300 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd301 : begin
                    SCL<= 1'b1;

                    tempval[2]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd302 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd303 : begin
                    SCL<= 1'b0;
//                    tempval[1]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd304 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd305 : begin
                    SCL<= 1'b1;

                    tempval[1]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd306 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd307 : begin
                    SCL<= 1'b0;
//                    tempval[0]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd308 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd309 : begin
                    SCL<= 1'b1;

                    tempval[0]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd310 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd311 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0; // SETTING MASTER ACK VALUE
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd312 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd313 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd314 : begin
                 SCL <= 1'b0;
                 I2C_State <= I2C_State + 1'b1;
            end
            
            /////// reading 2nd byte msb
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            9'd315 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
//                    tempval2[15]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd316 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd317 : begin
                    SCL<= 1'b1;

                    tempval2[15]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd318 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd319 : begin
                    SCL<= 1'b0;
//                    tempval[14]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd320 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd321 : begin
                    SCL<= 1'b1;

                    tempval2[14]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd322 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd323 : begin
                    SCL<= 1'b0;
//                    tempval[13]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd324 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd325 : begin
                    SCL<= 1'b1;

                    tempval2[13]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd326 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd327 : begin
                    SCL<= 1'b0;
//                    tempval[12]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd328 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd329 : begin
                    SCL<= 1'b1;

                    tempval2[12]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd330 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd331 : begin
                    SCL<= 1'b0;
//                    tempval[11]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd332 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd333 : begin
                    SCL<= 1'b1;

                    tempval2[11]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd334 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd335 : begin
                    SCL<= 1'b0;
//                    tempval[10]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd336 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd337 : begin
                    SCL<= 1'b1;

                    tempval2[10]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd338 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd339 : begin
                    SCL<= 1'b0;
//                    tempval[9]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd340 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd341 : begin
                    SCL<= 1'b1;

                    tempval2[9]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd342 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd343 : begin
                    SCL<= 1'b0;
//                    tempval[8]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd344 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd345 : begin
                    SCL<= 1'b1;

                    tempval2[8]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd346 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd347 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0; ///SETTING MASTER ACK VALUE TO 0
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd348 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd349 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd350 : begin
                 SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            
            // 2nd byte LSB
            
            9'd351 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd352 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd353 : begin
                    SCL<= 1'b1;
                    tempval2[7]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd354 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd355 : begin
                    SCL<= 1'b0;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd356 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd357 : begin
                    SCL<= 1'b1;
                    tempval2[6]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd358 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd359 : begin
                    SCL<= 1'b0;
//                    tempval[5]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd360 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd361 : begin
                    SCL<= 1'b1;

                    tempval2[5]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd362 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd363 : begin
                    SCL<= 1'b0;
//                    tempval[4]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd364 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd365 : begin
                    SCL<= 1'b1;

                    tempval2[4]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd366 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd367 : begin
                    SCL<= 1'b0;
//                    tempval[3]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd368 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd369 : begin
                    SCL<= 1'b1;

                    tempval2[3]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd370 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd371 : begin
                    SCL<= 1'b0;
//                    tempval[2]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd372 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd373 : begin
                    SCL<= 1'b1;

                    tempval2[2]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd374 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd375 : begin
                    SCL<= 1'b0;
//                    tempval[1]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd376 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd377 : begin
                    SCL<= 1'b1;

                    tempval2[1]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd378 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd379 : begin
                    SCL<= 1'b0;
//                    tempval[0]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd380 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd381 : begin
                    SCL<= 1'b1;

                    tempval2[0]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd382 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd383 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0; // SETTING MASTER ACK VALUE
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd384 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd385 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd386 : begin
                 SCL <= 1'b0;
                 I2C_State <= I2C_State + 1'b1;
            end
            
            // 3rd byte MSB 
            
            9'd387 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
//                    tempval2[15]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd388 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd389 : begin
                    SCL<= 1'b1;

                    tempval3[15]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd390 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd391 : begin
                    SCL<= 1'b0;
//                    tempval[14]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd392 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd393 : begin
                    SCL<= 1'b1;

                    tempval3[14]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd394 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd395 : begin
                    SCL<= 1'b0;
//                    tempval[13]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd396 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd397 : begin
                    SCL<= 1'b1;

                    tempval3[13]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd398 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd399 : begin
                    SCL<= 1'b0;
//                    tempval[12]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd400 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd401 : begin
                    SCL<= 1'b1;

                    tempval3[12]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd402 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd403 : begin
                    SCL<= 1'b0;
//                    tempval[11]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd404 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd405 : begin
                    SCL<= 1'b1;

                    tempval3[11]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd406 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd407 : begin
                    SCL<= 1'b0;
//                    tempval[10]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd408 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd409 : begin
                    SCL<= 1'b1;

                    tempval3[10]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd410 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd411 : begin
                    SCL<= 1'b0;
//                    tempval[9]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd412 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd413 : begin
                    SCL<= 1'b1;

                    tempval3[9]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd414 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd415 : begin
                    SCL<= 1'b0;
//                    tempval[8]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd416 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd417 : begin
                    SCL<= 1'b1;

                    tempval3[8]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd418 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd419 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0; ///SETTING MASTER ACK VALUE TO 0
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd420 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd421 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd422 : begin
                 SCL <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end
            
            // 3rd byte LSB
            
            9'd423 : begin
                    SCL<= 1'b0;
                    SDA<=1'bz;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd424 : begin
                    SCL<= 1'b1;
             
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd425 : begin
                    SCL<= 1'b1;
                    tempval3[7]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd426 : begin
                    SCL<= 1'b0;
           
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd427 : begin
                    SCL<= 1'b0;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd428 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd429 : begin
                    SCL<= 1'b1;
                    tempval3[6]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd430 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd431 : begin
                    SCL<= 1'b0;
//                    tempval[5]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd432 : begin
                    SCL<= 1'b1;
               
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd433 : begin
                    SCL<= 1'b1;

                    tempval3[5]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd434 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd435 : begin
                    SCL<= 1'b0;
//                    tempval[4]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd436 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd437 : begin
                    SCL<= 1'b1;

                    tempval3[4]<=SDA;                  
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd438 : begin
                    SCL<= 1'b0;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd439 : begin
                    SCL<= 1'b0;
//                    tempval[3]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd440 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd441 : begin
                    SCL<= 1'b1;

                    tempval3[3]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd442 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd443 : begin
                    SCL<= 1'b0;
//                    tempval[2]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd444 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd445 : begin
                    SCL<= 1'b1;

                    tempval3[2]<=SDA;                    
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd446 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd447 : begin
                    SCL<= 1'b0;
//                    tempval[1]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd448 : begin
                    SCL<= 1'b1;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd449 : begin
                    SCL<= 1'b1;

                    tempval3[1]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd450 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd451 : begin
                    SCL<= 1'b0;
//                    tempval[0]<=SDA;
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd452 : begin
                    SCL<= 1'b1;
                   
                    I2C_State<=I2C_State+ 1'b1;
            end
            9'd453 : begin
                    SCL<= 1'b1;

                    tempval3[0]<=SDA;                
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            9'd454 : begin
                    SCL<= 1'b0;
                 
                    I2C_State<=I2C_State+ 1'b1;
            end
           
            // begin MASTER ACKNOWLEDGEMENT
           
            9'd455 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b1; // SETTING MASTER NACK VALUE... FINAL
                  I2C_State <= I2C_State + 1'b1;                
            end  

            9'd456 : begin
                  SCL <= 1'b1;
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd457 : begin
                  SCL <= 1'b1;
//                  ACK_bit <= SDA;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd458 : begin
                 SCL <= 1'b0;
                 I2C_State <= I2C_State + 1'b1;
                 
            end
            
               
            
           
            //stop bit sequence and go back to STATE_INIT          
            9'd459 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;                
                  I2C_State <= I2C_State + 1'b1;
            end  

            9'd460 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b0;
                  I2C_State <= I2C_State + 1'b1;
            end                                    

            9'd461 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b1;
                  I2C_State <= STATE_INIT;                
            end                             
    endcase
    end      

   
    
                             
                   
endmodule