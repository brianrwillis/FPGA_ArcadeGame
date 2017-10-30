//Verilog source file for KBDecoder Module
//Brian Willis, 5/8/2017
//Outputs decoded input from keyboard as two nybbles
`timescale 1ns / 1ps

module KBDecoder(
    input CLK,
    input SDATA,
    input ARST_L,
    output wire [3:0] HEX0,
    output wire [3:0] HEX1,
    output wire KEYUP
    );
        
    wire arst_i;
    reg [21:0] shiftreg;
    assign arst_i = ~ARST_L;
    
    assign KEYUP = (shiftreg[20:13] == 8'h0F) ? 1 : 0;       //assert KEYUP on keyboard's "keyup" signal of 0xF0
    assign HEX0 = {shiftreg[6], shiftreg[7], shiftreg[8], shiftreg[9]};  //due to left shifting, reverse order of input bits from keyboard
    assign HEX1 = {shiftreg[2], shiftreg[3], shiftreg[4], shiftreg[5]};
        
    always @(negedge CLK, posedge arst_i)begin
        if(arst_i)begin
            shiftreg[21:0] = 22'b0000000000000000000000;     //clear entire shift register
        end
        else begin
             shiftreg[21:0] = {shiftreg[20:0], SDATA};       //left-shift in values from keyboard into shift register
        end
    end
endmodule
