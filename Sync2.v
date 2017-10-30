//Verilog source file for Sync2 Module
//Brian Willis, 5/8/2017
//Synchronizes SCLK and SDATA inputs to EksBox's clock
`timescale 1ns / 1ps

module Sync2(
    input CLK, 
    input ASYNC, 
    input ACLR_L, 
    output reg SYNC
    );
    
    wire aclr_i;
    reg qout1_i;
    assign aclr_i = ~ACLR_L;
    
    always @(posedge CLK or posedge aclr_i)begin        //clock and asynchronous reset
        if(aclr_i)begin                                 //higher priority for reset
            qout1_i <= 0;
            SYNC <=0;
        end
        else begin
            if(ASYNC) qout1_i <= 1;                     //D-FF 1
            else qout1_i <= 0;
            if(qout1_i) SYNC <= 1;                      //D-FF 2
            else SYNC <= 0;            
        end
    end
endmodule
