//Verilog source file for Clk25MHz Module
//Brian Willis, 5/15/2017
//Divides a clock input by 4
`timescale 1ns / 1ps

module Clk25MHz(
    input CLKIN, ACLR_L,
    output CLKOUT
    );
    
    wire aclr_i;
    reg D1;
    reg D2; 
    wire Q1;
    wire Q2;
    
    assign aclr_i = ~ACLR_L;
    assign CLKOUT = Q2;
    assign Q2 = D2;
    assign Q1 = D1;
    
    //design utilizes two TFFs to divide clock by 2, then 2 again
    always @(posedge CLKIN, posedge aclr_i)begin    //TFF 1
        if(aclr_i)
            D1 = 0;
        else 
            D1 = ~Q1;            
    end    
    
    always @(posedge Q1, posedge aclr_i)begin       //TFF 2
        if(aclr_i)
            D2 = 0;
        else 
            D2 = ~Q2;
    end
endmodule
