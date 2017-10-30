//Verilog source file for VGAEncoder Module
//Brian Willis, 5/31/2017
//Encodes a 12-bit color select value into RGB codes and vertical/horizontal sync values 
//used by VGA compliant monitor to display unique colors on monitor
`timescale 1ns / 1ps

module VGAEncoder(
    input CLK, ARST_L,
    input wire [11:0] CSEL,
    output wire HSYNC, VSYNC,
    output wire [3:0] RED, GREEN, BLUE,
    output reg [9:0] HCOORD, VCOORD
    );
    
    wire arst_i;
    wire hsync_i, vsync_i;
    reg [3:0] red_i, green_i, blue_i;
    reg [3:0] D1, D2, D3;
    reg D4, D5;
    
    assign arst_i = ~ARST_L;
    assign hsync_i = (HCOORD > 658 && HCOORD < 756) ? 1'b0 : 1'b1;  //HSYNC range
    assign vsync_i = (VCOORD > 492 && VCOORD < 495) ? 1'b0 : 1'b1;  //VSYNC range
    assign RED = D1;
    assign GREEN = D2;
    assign BLUE = D3;
    assign HSYNC = D4;
    assign VSYNC = D5;
    
    always @(posedge CLK, posedge arst_i)begin      //counters for horizontal, vertical coordinates
        if(arst_i)begin
            HCOORD = 10'b0;
            VCOORD = 10'b0;
        end
        else if(HCOORD > 800)begin
            HCOORD = 1'b0;
            VCOORD = VCOORD + 1'b1;
        end
        else if(VCOORD > 525)begin
            HCOORD = 1'b0;
            VCOORD = 1'b0;
        end
        else
            HCOORD = HCOORD + 1'b1;            
    end
    
    always @(posedge CLK, posedge arst_i)begin       //RGB selector
        if(arst_i)begin
            red_i = 4'b0;
            green_i = 4'b0;
            blue_i = 4'b0;
        end
        else if (HCOORD < 640 && VCOORD < 480)begin //display only on non-blanking sections of monitor
            red_i = CSEL[11:8];
            green_i = CSEL[7:4];
            blue_i = CSEL[3:0];
        end
        else begin
            red_i = 4'b0;
            green_i = 4'b0;
            blue_i = 4'b0;        
        end
    end
    
    always  @(posedge CLK, posedge arst_i)begin     //DFF for RED
        if(arst_i)
            D1 = 4'b0;
        else 
            D1 = red_i;            
    end 
    
    always  @(posedge CLK, posedge arst_i)begin     //DFF for GREEN
        if(arst_i)
            D2 = 4'b0;
        else 
            D2 = green_i;            
    end  
    
    always  @(posedge CLK, posedge arst_i)begin     //DFF for BLUE
        if(arst_i)
            D3 = 4'b0;
        else 
            D3 = blue_i;            
    end  
    
    always  @(posedge CLK, posedge arst_i)begin     //DFF for HSYNC
        if(arst_i)
            D4 = 1'b0;
        else 
            D4 = hsync_i;            
    end  
    
    always  @(posedge CLK, posedge arst_i)begin     //DFF for VSYNC
        if(arst_i)
            D5 = 1'b0;
        else 
            D5 = vsync_i;            
    end  
endmodule
