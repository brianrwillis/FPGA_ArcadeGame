//Verilog source file for pushbutton de-bouncer
//Brian Willis, 5/1/2017
//De-bounces user pushbutton input for 3-bit counter
`timescale 1ns / 1ps

module SwitchDB(SW, CLK, ACLR_L, SWDB);
    input SW;
    input CLK;
    input ACLR_L;
    output reg SWDB;
    
    wire aclr_i = ~ACLR_L;
    reg [1:0] state;                                    //Symbolic definitions for SwitchDB states
    parameter [1:0] sw_off = 2'b00;                          
    parameter [1:0] sw_edge = 2'b01;
    parameter [1:0] sw_verf = 2'b10;
    parameter [1:0] sw_hold = 2'b11;
        
    always @(posedge CLK or posedge aclr_i)begin        //clock and asynchronous reset
        SWDB <= 0;                                      //By default, SWDB is low
        if(aclr_i == 1) state <= sw_off;    
        else begin
            case (state)
                sw_off : begin
                    if(SW == 1) state <= sw_edge;
                    else state <= sw_off;
                end
                sw_edge : begin
                    if(SW == 1)begin
                        state <= sw_verf;
                        SWDB <= 1;                      //SWDB goes high when in state "sw_verf"
                    end
                    else state <= sw_off;
                end
                sw_verf : state <= sw_hold;
                sw_hold : begin
                    if(SW == 1) state <= sw_hold;
                    else state <= sw_off;
                end
                default : state <= sw_off;
            endcase
        end
    end
endmodule
