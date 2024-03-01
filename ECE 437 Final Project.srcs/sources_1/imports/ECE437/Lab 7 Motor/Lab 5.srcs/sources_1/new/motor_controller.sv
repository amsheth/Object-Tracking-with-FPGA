module motor_controller(
    output [7:0] led,
    input reg FSM_Clk, // curious how this works with a wire input from top level
    output reg PMOD_A1, 
    output reg PMOD_A2,
    inout PMOD_A3,
    inout PMOD_A4,
    inout PMOD_A7,
    inout PMOD_A8,
    inout PMOD_A9,
    inout PMOD_A10,
    input [3:0] button,
    input [31:0] cycle_count
    );

wire [3:0] hard_code;
assign hard_code = 4'b0010;

reg [31:0] counter = 0;
reg [31:0] cyc = 0;

reg CLK_200Hz;

// initial begin
//     cyc = 0;
// end

// directly initialized cyc to 0

always @(posedge FSM_Clk) begin
    if (counter >= 200) begin
        counter <= 0;
        CLK_200Hz <= ~CLK_200Hz; // Toggle the output clock
    end else begin
        counter <= counter + 1;
    end
end

// The above creates a new clock to run your motor

assign led[7:0] = cyc; // for debugging

always @(posedge CLK_200Hz) begin  

    if ((button[0] == 1) && (cyc <= cycle_count )) begin
        PMOD_A1 <= 1'b1;
        cyc <= cyc+1;
    end
    
    else begin
        PMOD_A1 <= 1'b0;       
    end
    
    if (button[1] == 1) begin
        PMOD_A2 <= 1;
        // counter++;
    end
    
    else begin
        PMOD_A2 <= 0;
    end
    
    if (button[0] == 0) cyc <= 0; // reset cyc when the enable signal goes back down to 0
    
end

endmodule