`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2023 08:12:25 PM
// Design Name: 
// Module Name: Write
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Write(
    output reg SCL,
    inout I2C_SDA_0,
    input FSM_Clk,
    input run,
    output reg [7:0] State,
    output reg ACK_bit,
    output reg SDA,
    input [8:0] deviceadd,
    input [7:0] regadd,
    input [7:0] regval

    );
    assign I2C_SDA_0= SDA;
    localparam STATE_INIT       = 8'd0; 
    initial  begin
        SCL = 1'b1;
        SDA = 1'b1;
        ACK_bit = 1'b1;  
        State = 8'd0;
    end
    always @(posedge FSM_Clk) begin 
//    tempval[15:0]<=0;                     
        case (State)
            // Press Button[3] to start the state machine. Otherwise, stay in the STATE_INIT state        
            STATE_INIT : begin
                 if (run == 1'b1) State <= 8'd1;                    
                 else begin                
                      SCL <= 1'b1;
                      SDA <= 1'b1;
                      State <= 8'd0;
                  end
            end            
           
            // This is the Start sequence            
            8'd1 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b0;
                  State <= State + 1'b1;                                
            end  
            // SCL low
            8'd2 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;
                  State <= State + 1'b1;                
            end  

            // transmit bit 7 start device address transmission
            8'd3 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[7];
                  State <= State + 1'b1;                
            end  

            8'd4 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd5 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd6 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 6
            8'd7 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[6];  
                  State <= State + 1'b1;              
            end  

            8'd8 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd9 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd10 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 5
            8'd11 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[5];
                  State <= State + 1'b1;                
            end  

            8'd12 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd13 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd14 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 4
            8'd15 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[4];
                  State <= State + 1'b1;                
            end  

            8'd16 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd17 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd18 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 3
            8'd19 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[3];
                  State <= State + 1'b1;                
            end  

            8'd20 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd21 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd22 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
           
            // transmit bit 2
            8'd23 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[2];
                  State <= State + 1'b1;                
            end  

            8'd24 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd25 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd26 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
 
            // transmit bit 1
            8'd27 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[1];  
                  State <= State + 1'b1;              
            end  

            8'd28 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd29 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd30 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end
           
            // transmit bit 0
            8'd31 : begin
                  SCL <= 1'b0;
                  SDA <= deviceadd[0];      
                  State <= State + 1'b1;          
            end  

            8'd32 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd33 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd34 : begin
                  SCL <= 1'b0;                  
                  State <= State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
            8'd35 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  State <= State + 1'b1;                
            end  

            8'd36 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd37 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  State <= State + 1'b1;
            end  

            8'd38 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
           
           
            8'd39 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[7];
                    State<=State+ 1'b1;
            end
            8'd40 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    State<=State+ 1'b1;
            end
            8'd41 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    State<=State+ 1'b1;
            end
            8'd42 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[7];                    
                    State<=State+ 1'b1;
            end
            8'd43 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[6];
                    State<=State+ 1'b1;
            end
            8'd44 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    State<=State+ 1'b1;
            end
            8'd45 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[6];                    
                    State<=State+ 1'b1;
            end
            8'd46 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[6];                    
                    State<=State+ 1'b1;
            end
            8'd47 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[5];
                    State<=State+ 1'b1;
            end
            8'd48 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    State<=State+ 1'b1;
            end
            8'd49 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[5];                    
                    State<=State+ 1'b1;
            end
            8'd50 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[5];                    
                    State<=State+ 1'b1;
            end
            8'd51 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[4];
                    State<=State+ 1'b1;
            end
            8'd52 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    State<=State+ 1'b1;
            end
            8'd53 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[4];                    
                    State<=State+ 1'b1;
            end
            8'd54 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[4];                    
                    State<=State+ 1'b1;
            end
            8'd55 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[3];
                    State<=State+ 1'b1;
            end
            8'd56 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    State<=State+ 1'b1;
            end
            8'd57 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[3];                    
                    State<=State+ 1'b1;
            end
            8'd58 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[3];                    
                    State<=State+ 1'b1;
            end
            8'd59 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[2];
                    State<=State+ 1'b1;
            end
            8'd60 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[2];                    
                    State<=State+ 1'b1;
            end
            8'd61 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[7];                    
                    State<=State+ 1'b1;
            end
            8'd62 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[2];                    
                    State<=State+ 1'b1;
            end
            8'd63 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[1];
                    State<=State+ 1'b1;
            end
            8'd64 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    State<=State+ 1'b1;
            end
            8'd65 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[1];                    
                    State<=State+ 1'b1;
            end
            8'd66 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[1];                    
                    State<=State+ 1'b1;
            end
            8'd67 : begin
                    SCL<= 1'b0;
                    SDA <= regadd[0];
                    ACK_bit<=1;
                    State<=State+ 1'b1;
            end
            8'd68 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    State<=State+ 1'b1;
            end
            8'd69 : begin
                    SCL<= 1'b1;
//                    SDA <= tempregadd[0];                    
                    State<=State+ 1'b1;
            end
            8'd70 : begin
                    SCL<= 1'b0;
//                    SDA <= tempregadd[0];                    
                    State<=State+ 1'b1;
            end
           
            8'd71 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  State <= State + 1'b1;                
            end  

            8'd72 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd73 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  State <= State + 1'b1;
            end  

            8'd74 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
            
            //Beginning restart/////////////////////////////////////////////////////////////////////
            8'd75 : begin
                  SCL <= 1'b0;
                  SDA<= 1'b0;
                  State <= State + 1'b1;
            end
            8'd76 : begin
                  SCL <= 1'b0;
                  SDA<=1'b1;
                  State <= State + 1'b1;
            end
            8'd77 : begin
                  SCL <= 1'b1;
                  //SDA<= 1'b1;
                  State <= State + 1'b1;
            end
            8'd78 : begin
                  SCL<= 1'b1;
                  SDA <= 1'b0;
                  State <= State + 1'b1;
            end
            8'd79 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;
                  State <= State + 1'b1;                
            end  
            //begin device add/////////////////////////////////////////////////////////////////////////////
            8'd80 : begin
                  SCL <= 1'b0;
                  SDA <= regval[7];
                  State <= State + 1'b1;                
            end  

            8'd81 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd82 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd83 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 6
            8'd84 : begin
                  SCL <= 1'b0;
                  SDA <= regval[6];  
                  State <= State + 1'b1;              
            end  

            8'd85 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd86 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd87 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 5
            8'd88 : begin
                  SCL <= 1'b0;
                  SDA <= regval[5];
                  State <= State + 1'b1;                
            end  

            8'd89 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd90 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd91 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 4
            8'd92 : begin
                  SCL <= 1'b0;
                  SDA <= regval[4];
                  State <= State + 1'b1;                
            end  

            8'd93 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd94 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd95 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  

            // transmit bit 3
            8'd96 : begin
                  SCL <= 1'b0;
                  SDA <= regval[3];
                  State <= State + 1'b1;                
            end  

            8'd97 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd98 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd99 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
           
            // transmit bit 2
            8'd100 : begin
                  SCL <= 1'b0;
                  SDA <= regval[2];
                  State <= State + 1'b1;                
            end  

            8'd101 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd102 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd103 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end  
 
            // transmit bit 1
            8'd104 : begin
                  SCL <= 1'b0;
                  SDA <= regval[1];  
                  State <= State + 1'b1;              
            end  

            8'd105 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd106 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd107 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end
           
            // transmit bit 0
            8'd108 : begin
                  SCL <= 1'b0;
                  SDA <=regval[0];  
                  ACK_bit=1;    
                  State <= State + 1'b1;          
            end  

            8'd109 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd110 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd111 : begin
                  SCL <= 1'b0;                  
                  State <= State + 1'b1;
            end  
                       
            // read the ACK bit from the sensor and display it on LED[7]
           
            8'd112 : begin
                  SCL <= 1'b0;
                  SDA <= 1'bz;
                  State <= State + 1'b1;                
            end  

            8'd113 : begin
                  SCL <= 1'b1;
                  State <= State + 1'b1;
            end  

            8'd114 : begin
                  SCL <= 1'b1;
                  ACK_bit <= SDA;                
                  State <= State + 1'b1;
            end  

            8'd115 : begin
                  SCL <= 1'b0;
                  State <= State + 1'b1;
            end 
            8'd116 : begin
                  SCL <= 1'b0;
                  SDA <= 1'b0;                
                  State <= State + 1'b1;
            end  

            8'd117 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b0;
                  State <= State + 1'b1;
            end                                    

            8'd118 : begin
                  SCL <= 1'b1;
                  SDA <= 1'b1;
                  State <= STATE_INIT;                
            end               
    endcase
    end
endmodule
