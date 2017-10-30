//Verilog source file for Hierarchical Video Game Design
//Brian Willis, 5/31/2017
//Interconnects six modules to create a VGA driver that outputs a 12-bit RGB value
//to a VGA port, displaying graphics on a VGA compliant monitor
`timescale 1ns / 1ps

module EksBox(
    input CLK, ARST_L, SCLK, SDATA, MM,
    output HSYNC, VSYNC,
    output [3:0] RED, GREEN, BLUE
    );
    
    wire sync1_i, sync2_i, clkslow_i, keyup_i, swdb_i;
    wire [3:0] hex1_i, hex0_i;
    wire [7:0] kbcode_i;
    wire [11:0] csel_i;
    wire [9:0] hcoord_i, vcoord_i;
 
    assign kbcode_i = {hex1_i, hex0_i};
    
    Sync2 U1(.CLK(CLK), .ASYNC(SCLK), .ACLR_L(ARST_L), .SYNC(sync1_i));
    Sync2 U2(.CLK(CLK), .ASYNC(SDATA), .ACLR_L(ARST_L), .SYNC(sync2_i));
    Clk25MHz U3(.CLKIN(CLK), .ACLR_L(ARST_L), .CLKOUT(clkslow_i));
    KBDecoder U4(.CLK(sync1_i), .SDATA(sync2_i), .ARST_L(ARST_L), .HEX1(hex1_i), .HEX0(hex0_i), .KEYUP(keyup_i));
    SwitchDB U5(.SW(keyup_i), .CLK(clkslow_i), .ACLR_L(ARST_L), .SWDB(swdb_i));
    VGAController U6(.CLK(clkslow_i), .KBCODE(kbcode_i), .HCOORD(hcoord_i), .VCOORD(vcoord_i), .KBSTROBE(swdb_i), 
                     .ARST_L(ARST_L), .CSEL(csel_i), .MM(MM));
    VGAEncoder U7(.CLK(clkslow_i), .CSEL(csel_i), .ARST_L(ARST_L), .HSYNC(HSYNC), .VSYNC(VSYNC), .RED(RED), 
                  .GREEN(GREEN), .BLUE(BLUE), .HCOORD(hcoord_i), .VCOORD(vcoord_i));
endmodule
