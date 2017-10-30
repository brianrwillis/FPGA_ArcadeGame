//Verilog source file for VGAController module
//Brian Willis, 5/31/2017
//Receives user input through Nexys 4 switches as well as a USB connected
//keyboard to display video game graphics on VGA-compliant monitor via 
//a 12-bit RGB value.
`timescale 1ns / 1ps

module VGAController(
    input CLK, KBSTROBE, ARST_L, MM,
    input [7:0] KBCODE,
    input [9:0] HCOORD, VCOORD,
    output reg [11:0] CSEL
);

    wire arst_i;
    assign arst_i = ~ARST_L;
    
    reg hsouth_i;                                                       //current direcection of hero
    reg hstill_i;                                                       //hero still
    reg hybumper_i;                                                     //hero hit a Y-border
    reg [11:0] hcolor_i = blue;                                         //color of hero
    reg [11:0] mcolor_i = red;
    reg [11:0] bmcolor_i = red;
    reg [9:0] hxcoord_i, hycoord_i;                                     //coordinates of hero
    reg [31:0] hspeed_i;                                                //speed of hero
    reg [31:0] hcycles_i;                                               //cycles before hero updates
    reg [31:0] hhitflashdur_i;                                          //duration of hero flash after hit
    reg [3:0] hhitflashnum_i;                                           //number of times hero flashes after hit
    reg invul_i;                                                        //hero is temporarily invulnerable after hit
    reg [2:0] lives_i;                                                  //number of lives for hero
    reg [31:0] introflashdur_i;                                         //duration of intro flash
    reg [3:0] introflashnum_i;                                          //number of times intro flashes
    reg intro_i;                                                        //intro sequence before play
    reg introdelay_i;                                                   //delay before intro plays
    reg [31:0] introdelaydur_i;                                         //duration of intro delay    
    reg [31:0] nextstage_i;                                             //time until next stage
    reg [4:0] stage_i;
    
    reg [23:0] mhit_i;                                                  //missile hit hero
    
    reg [9:0] m1xcoord_i, m1ycoord_i;                                   //missile coordinates
    reg [31:0] m1speed_i;                                               //speed of missile
    reg [31:0] m1speedreset_i;                                          //temp value for missile speed
    reg [31:0] m1wait_i;                                                //time before missile appears
    
    reg [9:0] m2xcoord_i, m2ycoord_i;
    reg [31:0] m2speed_i;
    reg [31:0] m2speedreset_i;
    reg [31:0] m2wait_i;
    
    reg [9:0] m3xcoord_i, m3ycoord_i;
    reg [31:0] m3speed_i;
    reg [31:0] m3speedreset_i;
    reg [31:0] m3wait_i;
    
    reg [9:0] m4xcoord_i, m4ycoord_i;
    reg [31:0] m4speed_i;
    reg [31:0] m4speedreset_i;
    reg [31:0] m4wait_i;
    
    reg [9:0] m5xcoord_i, m5ycoord_i;
    reg [31:0] m5speed_i;
    reg [31:0] m5speedreset_i;
    reg [31:0] m5wait_i;
    
    reg [9:0] m6xcoord_i, m6ycoord_i;
    reg [31:0] m6speed_i;
    reg [31:0] m6speedreset_i;
    reg [31:0] m6wait_i;
    
    reg [9:0] m7xcoord_i, m7ycoord_i;
    reg [31:0] m7speed_i;
    reg [31:0] m7speedreset_i;
    reg [31:0] m7wait_i;
        
    reg [9:0] m8xcoord_i, m8ycoord_i;
    reg [31:0] m8speed_i;
    reg [31:0] m8speedreset_i;
    reg [31:0] m8wait_i;
    
    reg [9:0] m9xcoord_i, m9ycoord_i;
    reg [31:0] m9speed_i;
    reg [31:0] m9speedreset_i;
    reg [31:0] m9wait_i;
    
    reg [9:0] m10xcoord_i, m10ycoord_i;
    reg [31:0] m10speed_i;
    reg [31:0] m10speedreset_i;
    reg [31:0] m10wait_i;
    
    reg [9:0] m11xcoord_i, m11ycoord_i;
    reg [31:0] m11speed_i;
    reg [31:0] m11speedreset_i;
    reg [31:0] m11wait_i;
    
    reg [9:0] m12xcoord_i, m12ycoord_i;
    reg [31:0] m12speed_i;
    reg [31:0] m12speedreset_i;
    reg [31:0] m12wait_i;
    
    reg [9:0] m13xcoord_i, m13ycoord_i;
    reg [31:0] m13speed_i;
    reg [31:0] m13speedreset_i;
    reg [31:0] m13wait_i;
        
    reg [9:0] m14xcoord_i, m14ycoord_i;
    reg [31:0] m14speed_i;
    reg [31:0] m14speedreset_i;
    reg [31:0] m14wait_i;
        
    reg [9:0] m15xcoord_i, m15ycoord_i;
    reg [31:0] m15speed_i;
    reg [31:0] m15speedreset_i;
    reg [31:0] m15wait_i;
    
    reg [9:0] m16xcoord_i, m16ycoord_i;
    reg [31:0] m16speed_i;
    reg [31:0] m16speedreset_i;
    reg [31:0] m16wait_i;
    
    reg [9:0] m17xcoord_i, m17ycoord_i;
    reg [31:0] m17speed_i;
    reg [31:0] m17speedreset_i;
    reg [31:0] m17wait_i;
    
    reg [9:0] m18xcoord_i, m18ycoord_i;
    reg [31:0] m18speed_i;
    reg [31:0] m18speedreset_i;
    reg [31:0] m18wait_i;
    
    reg [9:0] m19xcoord_i, m19ycoord_i;
    reg [31:0] m19speed_i;
    reg [31:0] m19speedreset_i;
    reg [31:0] m19wait_i;
    
    reg [9:0] m20xcoord_i, m20ycoord_i;
    reg [31:0] m20speed_i;
    reg [31:0] m20speedreset_i;
    reg [31:0] m20wait_i;
    
    //big missile
    reg [9:0] bmxcoord_i, bmycoord_i;                                
    reg [31:0] bmxspeed_i, bmyspeed_i;
    reg [31:0] bmxspeedreset_i, bmyspeedreset_i;
    reg [31:0] bmwait_i;
    reg [31:0] bmxspeedchange_i, bmyspeedchange_i;            
        
    parameter [7:0] UP = 8'h75;
    parameter [7:0] DN = 8'h72;
    
    parameter [11:0] black = 12'h000;
    parameter [11:0] white = 12'hFFF;
    parameter [11:0] red = 12'hF00;
    parameter [11:0] dullred = 12'h711;
    parameter [11:0] green = 12'h0F0;
    parameter [11:0] blue = 12'h00F;
    
    parameter [31:0] speed1 = 225000;               //speeds of missiles
    parameter [31:0] speed2 = 200000;
    parameter [31:0] speed3 = 175000;
    parameter [31:0] speed4 = 150000;
    parameter [31:0] speed5 = 125000;
    
    parameter [9:0] start1 = 20;                    //starting Y-coordinates for missiles
    parameter [9:0] start2 = 62;
    parameter [9:0] start3 = 104;
    parameter [9:0] start4 = 146;
    parameter [9:0] start5 = 188;        
    parameter [9:0] start6 = 230;
    parameter [9:0] start7 = 272;
    parameter [9:0] start8 = 314;
    parameter [9:0] start9 = 356;
    parameter [9:0] start10 = 400;
    
    parameter [9:0] halfstart2 = 41;
    parameter [9:0] halfstart3 = 83;
    parameter [9:0] halfstart4 = 125;
    parameter [9:0] halfstart5 = 167;        
    parameter [9:0] halfstart6 = 209;
    parameter [9:0] halfstart7 = 251;
    parameter [9:0] halfstart8 = 293;
    parameter [9:0] halfstart9 = 335;
    parameter [9:0] halfstart10 = 377;
    
    wire mariamode_i;                           //easy mode
    assign mariamode_i = MM;
    
    //color selectors
    always @(posedge CLK, posedge arst_i)begin
        if(arst_i)begin
            CSEL = black;         
            hcolor_i = blue;       
            
        end else begin
            if(mariamode_i)
                hcolor_i = green;      
            else if(!mariamode_i)
                hcolor_i = blue;              
            //CSEL selectors
            if(lives_i == 0 && !mariamode_i)                                                //game over screen
                CSEL = red;
            else if((lives_i > 0 && stage_i == 7) || (stage_i == 7 && mariamode_i))         //win screen
                CSEL = green;       
            //missile displayers
            else if((HCOORD >= m1xcoord_i-6 && HCOORD <= m1xcoord_i+6 
            && VCOORD >= m1ycoord_i-1 && VCOORD <= m1ycoord_i+1 && !mhit_i[0])              //update missile in this range if yet to hit hero
            || (HCOORD >= m2xcoord_i-6 && HCOORD <= m2xcoord_i+6 
            && VCOORD >= m2ycoord_i-1 && VCOORD <= m2ycoord_i+1 && !mhit_i[1])
            || (HCOORD >= m3xcoord_i-6 && HCOORD <= m3xcoord_i+6 
            && VCOORD >= m3ycoord_i-1 && VCOORD <= m3ycoord_i+1 && !mhit_i[2])
            || (HCOORD >= m4xcoord_i-6 && HCOORD <= m4xcoord_i+6 
            && VCOORD >= m4ycoord_i-1 && VCOORD <= m4ycoord_i+1 && !mhit_i[3])
            || (HCOORD >= m5xcoord_i-6 && HCOORD <= m5xcoord_i+6 
            && VCOORD >= m5ycoord_i-1 && VCOORD <= m5ycoord_i+1 && !mhit_i[4])
            || (HCOORD >= m6xcoord_i-6 && HCOORD <= m6xcoord_i+6 
            && VCOORD >= m6ycoord_i-1 && VCOORD <= m6ycoord_i+1 && !mhit_i[5])
            || (HCOORD >= m7xcoord_i-6 && HCOORD <= m7xcoord_i+6 
            && VCOORD >= m7ycoord_i-1 && VCOORD <= m7ycoord_i+1 && !mhit_i[6])
            || (HCOORD >= m8xcoord_i-6 && HCOORD <= m8xcoord_i+6 
            && VCOORD >= m8ycoord_i-1 && VCOORD <= m8ycoord_i+1 && !mhit_i[7])
            || (HCOORD >= m9xcoord_i-6 && HCOORD <= m9xcoord_i+6 
            && VCOORD >= m9ycoord_i-1 && VCOORD <= m9ycoord_i+1 && !mhit_i[8])
            || (HCOORD >= m10xcoord_i-6 && HCOORD <= m10xcoord_i+6 
            && VCOORD >= m10ycoord_i-1 && VCOORD <= m10ycoord_i+1 && !mhit_i[9])
            || (HCOORD >= m11xcoord_i-6 && HCOORD <= m11xcoord_i+6 
            && VCOORD >= m11ycoord_i-1 && VCOORD <= m11ycoord_i+1 && !mhit_i[10])
            || (HCOORD >= m12xcoord_i-6 && HCOORD <= m12xcoord_i+6 
            && VCOORD >= m12ycoord_i-1 && VCOORD <= m12ycoord_i+1 && !mhit_i[11])
            || (HCOORD >= m13xcoord_i-6 && HCOORD <= m13xcoord_i+6 
            && VCOORD >= m13ycoord_i-1 && VCOORD <= m13ycoord_i+1 && !mhit_i[12])
            || (HCOORD >= m14xcoord_i-6 && HCOORD <= m14xcoord_i+6 
            && VCOORD >= m14ycoord_i-1 && VCOORD <= m14ycoord_i+1 && !mhit_i[13])
            || (HCOORD >= m15xcoord_i-6 && HCOORD <= m15xcoord_i+6 
            && VCOORD >= m15ycoord_i-1 && VCOORD <= m15ycoord_i+1 && !mhit_i[14])
            || (HCOORD >= m16xcoord_i-6 && HCOORD <= m16xcoord_i+6 
            && VCOORD >= m16ycoord_i-1 && VCOORD <= m16ycoord_i+1 && !mhit_i[15])
            || (HCOORD >= m17xcoord_i-6 && HCOORD <= m17xcoord_i+6 
            && VCOORD >= m17ycoord_i-1 && VCOORD <= m17ycoord_i+1 && !mhit_i[16])
            || (HCOORD >= m18xcoord_i-6 && HCOORD <= m18xcoord_i+6 
            && VCOORD >= m18ycoord_i-1 && VCOORD <= m18ycoord_i+1 && !mhit_i[17])
            || (HCOORD >= m19xcoord_i-6 && HCOORD <= m19xcoord_i+6 
            && VCOORD >= m19ycoord_i-1 && VCOORD <= m19ycoord_i+1 && !mhit_i[18])
            || (HCOORD >= m20xcoord_i-6 && HCOORD <= m20xcoord_i+6 
            && VCOORD >= m20ycoord_i-1 && VCOORD <= m20ycoord_i+1 && !mhit_i[19]))
                CSEL = mcolor_i;
                                        
            else if((HCOORD >= bmxcoord_i-18 && HCOORD <= bmxcoord_i+18 
            && VCOORD >= bmycoord_i-3 && VCOORD <= bmycoord_i+3 && !mhit_i[20]))                //update big missile in this range if yet to hit hero
                CSEL = bmcolor_i;
                                
            //hero displayer
            else if(HCOORD >= hxcoord_i-32 && HCOORD <= hxcoord_i+32 
            && VCOORD >= hycoord_i-24 && VCOORD <= hycoord_i+24                                 //update hero in this range
            && (!invul_i || (invul_i && hhitflashnum_i[0] == 0)))                               //if hhitflashnum is odd, hero disappears
                CSEL = hcolor_i; 
                    
            //border displayer                
            else if((VCOORD >= 410 && VCOORD <= 420) || VCOORD <= 10)                           //create a border that hurts hero if touched
                CSEL = dullred;
                
            //lives displayer
            else if((HCOORD >= 203 && HCOORD <= 235 && VCOORD >= 438 && VCOORD <= 462 && lives_i > 0)                           
            || (HCOORD >= 303 && HCOORD <= 335 && VCOORD >= 438 && VCOORD <= 462 && lives_i > 1)
            || (HCOORD >= 403 && HCOORD <= 435 && VCOORD >= 438 && VCOORD <= 462 && lives_i > 2))
                CSEL = hcolor_i;
                
            //intro displayer
            else if((HCOORD >= hxcoord_i-2 && HCOORD <= hxcoord_i+2 
            && VCOORD >= hycoord_i-66 && VCOORD <= hycoord_i-36 && introflashnum_i[0] == 1)             //top vertical line
            || (HCOORD >= hxcoord_i-2 && HCOORD <= hxcoord_i+2 
            && VCOORD >= hycoord_i+36 && VCOORD <= hycoord_i+66 && introflashnum_i[0] == 1)             //bottom vertical line
            || (HCOORD >= (hxcoord_i-10+((hycoord_i-66-VCOORD)>>1)) 
            && HCOORD <= (hxcoord_i+10-((hycoord_i-66-VCOORD)>>1))
            && VCOORD <= hycoord_i-66 && VCOORD >= hycoord_i-86 && introflashnum_i[0] == 1)             //top arrow
            || (HCOORD >= (hxcoord_i-((hycoord_i+86-VCOORD)>>1)) 
            && HCOORD <= (hxcoord_i+((hycoord_i+86-VCOORD)>>1))
            && VCOORD <= hycoord_i+86 && VCOORD >= hycoord_i+66 && introflashnum_i[0] == 1))            //bottom arrow
                CSEL = white;
            else 
                CSEL = black;           //display background elsewhere
        end        
    end
    
    //hero updaters, collision detectors, hero flashing, intro flashing
    always @(posedge CLK, posedge arst_i)begin
        if(arst_i)begin 
            hxcoord_i = 75;             //starting coordinates for hero
            hycoord_i = 179;                  
            hcycles_i = hspeed_i;   
            hybumper_i = 0;  
            invul_i = 0;
            lives_i = 3;
            hhitflashnum_i = 8;         
            hhitflashdur_i = 5000000;
            introflashnum_i = 6;
            introflashdur_i = 6000000;         
            intro_i = 1;   
            introdelay_i = 1;
            introdelaydur_i = 30000000;
            mhit_i = 24'h000000;
        end else begin         
            //hero collision checks
            //missile 1
            if(m1xcoord_i-6 <= hxcoord_i+32 && m1xcoord_i+6 >= hxcoord_i-32
            && m1ycoord_i-1 <= hycoord_i+24 && m1ycoord_i+1 >= hycoord_i-24 && !invul_i)begin     //missile-hero collision checks
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[0] = 1;
            //missile 2
            end if(m2xcoord_i-6 <= hxcoord_i+32 && m2xcoord_i+6 >= hxcoord_i-32 
            && m2ycoord_i-1 <= hycoord_i+24 && m2ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[1] = 1;
            //missile 3
            end if(m3xcoord_i-6 <= hxcoord_i+32 && m3xcoord_i+6 >= hxcoord_i-32 
            && m3ycoord_i-1 <= hycoord_i+24 && m3ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[2] = 1;
            //missile 4
            end if(m4xcoord_i-6 <= hxcoord_i+32 && m4xcoord_i+6 >= hxcoord_i-32 
            && m4ycoord_i-1 <= hycoord_i+24 && m4ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[3] = 1;
            //missile 5
            end if(m5xcoord_i-6 <= hxcoord_i+32 && m5xcoord_i+6 >= hxcoord_i-32 
            && m5ycoord_i-1 <= hycoord_i+24 && m5ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[4] = 1;
            //missile 6
            end if(m6xcoord_i-6 <= hxcoord_i+32 && m6xcoord_i+6 >= hxcoord_i-32 
            && m6ycoord_i-1 <= hycoord_i+24 && m6ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[5] = 1;
            //missile 7
            end if(m7xcoord_i-6 <= hxcoord_i+32 && m7xcoord_i+6 >= hxcoord_i-32 
            && m7ycoord_i-1 <= hycoord_i+24 && m7ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[6] = 1;
            //missile 8
            end if(m8xcoord_i-6 <= hxcoord_i+32 && m8xcoord_i+6 >= hxcoord_i-32 
            && m8ycoord_i-1 <= hycoord_i+24 && m8ycoord_i+1 >= hycoord_i-24 && !invul_i)begin     //missile-hero collision checks
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[7] = 1;
            //missile 9
            end if(m9xcoord_i-6 <= hxcoord_i+32 && m9xcoord_i+6 >= hxcoord_i-32 
            && m9ycoord_i-1 <= hycoord_i+24 && m9ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[8] = 1;
            //missile 10
            end if(m10xcoord_i-6 <= hxcoord_i+32 && m10xcoord_i+6 >= hxcoord_i-32 
            && m10ycoord_i-1 <= hycoord_i+24 && m10ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[9] = 1;
            //missile 11
            end if(m11xcoord_i-6 <= hxcoord_i+32 && m11xcoord_i+6 >= hxcoord_i-32 
            && m11ycoord_i-1 <= hycoord_i+24 && m11ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[10] = 1;
            //missile 12
            end if(m12xcoord_i-6 <= hxcoord_i+32 && m12xcoord_i+6 >= hxcoord_i-32 
            && m12ycoord_i-1 <= hycoord_i+24 && m12ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[11] = 1;
            //missile 13
            end if(m13xcoord_i-6 <= hxcoord_i+32 && m13xcoord_i+6 >= hxcoord_i-32 
            && m13ycoord_i-1 <= hycoord_i+24 && m13ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[12] = 1;
            //missile 14
            end if(m14xcoord_i-6 <= hxcoord_i+32 && m14xcoord_i+6 >= hxcoord_i-32 
            && m14ycoord_i-1 <= hycoord_i+24 && m14ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[13] = 1;
            //missile 15
            end if(m15xcoord_i-6 <= hxcoord_i+32 && m15xcoord_i+6 >= hxcoord_i-32 
            && m15ycoord_i-1 <= hycoord_i+24 && m15ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[14] = 1;
            //missile 16
            end if(m16xcoord_i-6 <= hxcoord_i+32 && m16xcoord_i+6 >= hxcoord_i-32 
            && m16ycoord_i-1 <= hycoord_i+24 && m16ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[15] = 1;
            //missile 17
            end if(m17xcoord_i-6 <= hxcoord_i+32 && m17xcoord_i+6 >= hxcoord_i-32 
            && m17ycoord_i-1 <= hycoord_i+24 && m17ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[16] = 1;
            //missile 18
            end if(m18xcoord_i-6 <= hxcoord_i+32 && m18xcoord_i+6 >= hxcoord_i-32 
            && m18ycoord_i-1 <= hycoord_i+24 && m18ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[17] = 1;
            //missile 19
            end if(m19xcoord_i-6 <= hxcoord_i+32 && m19xcoord_i+6 >= hxcoord_i-32 
            && m19ycoord_i-1 <= hycoord_i+24 && m19ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[18] = 1;
            //missile 20
            end if(m20xcoord_i-6 <= hxcoord_i+32 && m20xcoord_i+6 >= hxcoord_i-32 
            && m20ycoord_i-1 <= hycoord_i+24 && m20ycoord_i+1 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[19] = 1;
                
            //big missile 1
            end if(bmxcoord_i-18 <= hxcoord_i+32 && bmxcoord_i+18 >= hxcoord_i-32 
            && bmycoord_i-3 <= hycoord_i+24 && bmycoord_i+3 >= hycoord_i-24 && !invul_i)begin
                if(lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                mhit_i[20] = 1;
                
            //Y-border
            end if((hycoord_i+24 >= 409 && hsouth_i) 
            || (hycoord_i-24 <= 11 && !hsouth_i))begin                          //Y-border-hero collision check
                if(!invul_i && lives_i > 0 && stage_i != 7)
                    lives_i = lives_i - 1;
                invul_i = 1;
                hybumper_i = 1;
                
            //hero position updater
            end if(hcycles_i <= 0)begin                                         //only update hero position when counter completes
                if(hsouth_i && !hstill_i && !hybumper_i)begin                   //if going downward and not supposed to be still, move down
                    hycoord_i = hycoord_i + 1;
                end else if(!hsouth_i && !hstill_i && !hybumper_i)begin         //if going upward and not supposed to be still, move up
                    hycoord_i = hycoord_i - 1; 
                end else begin
                    hycoord_i = hycoord_i;                                      //stay still
                end     
                hybumper_i = 0;     
                hcycles_i = hspeed_i;
            end else
                hcycles_i = hcycles_i - 1;
                
            //hero invulnerability flashing
            if(invul_i && hhitflashdur_i <= 0)begin                 //when counter finishes, flash hero
                hhitflashnum_i = hhitflashnum_i - 1;
                hhitflashdur_i = 5000000;
                if(hhitflashnum_i == 0)begin 
                    invul_i = 0;                                    //once flashing finishes, hero is vulnerable again
                    hhitflashnum_i = 8;                             //reset flash number for next hit
                end
            end else if(invul_i)
                hhitflashdur_i = hhitflashdur_i - 1;
                
            //intro flashing
            if(introdelay_i && introdelaydur_i <=0)begin            //initial delay before intro to allow monitor to wake up
                introdelay_i = 0;                
            end else if(introdelay_i)
                introdelaydur_i = introdelaydur_i - 1;
            if(!introdelay_i && intro_i && introflashdur_i <= 0)begin
                introflashnum_i = introflashnum_i - 1;
                introflashdur_i = 6000000;
                if(introflashnum_i == 0)                
                    intro_i = 0;
            end else if(!introdelay_i && intro_i)
                introflashdur_i = introflashdur_i - 1;
                
            if(nextstage_i <= 0)begin
                mhit_i = 21'h00000;                                 //reset missile hits for next stage
            end
        end    
    end
    
    //missile updater
    always @(posedge CLK, posedge arst_i)begin
        if(arst_i)begin
            nextstage_i = 320000000;          
            stage_i = 2;                                            //once counter completes, start stage 2 of missiles
        
            m1speed_i = speed3;  
            m1speedreset_i = m1speed_i;
            m1wait_i = 75000000;
            m1xcoord_i = 700;                                       //starting coordinates for missile (hidden off-screen)
            m1ycoord_i = start6;   
              
            m2speed_i = speed4; 
            m2speedreset_i = m2speed_i;
            m2wait_i = 85000000;
            m2xcoord_i = 700;
            m2ycoord_i = start4;  
            
            m3speed_i = speed4;  
            m3speedreset_i = m3speed_i;
            m3wait_i = 88000000;
            m3xcoord_i = 700;
            m3ycoord_i = start2; 
                
            m4speed_i = speed2;  
            m4speedreset_i = m4speed_i;
            m4wait_i = 100000000;
            m4xcoord_i = 700;
            m4ycoord_i = start6; 
            
            m5speed_i = speed5; 
            m5speedreset_i = m5speed_i;
            m5wait_i = 105000000;
            m5xcoord_i = 700;
            m5ycoord_i = start5; 
             
            m6speed_i = speed3;  
            m6speedreset_i = m6speed_i;
            m6wait_i = 110000000;
            m6xcoord_i = 700;
            m6ycoord_i = start3; 
                
            m7speed_i = speed2;  
            m7speedreset_i = m7speed_i;
            m7wait_i = 120000000;
            m7xcoord_i = 700;
            m7ycoord_i = start10;  
                           
            m8speed_i = speed4;  
            m8speedreset_i = m8speed_i;
            m8wait_i = 133000000;
            m8xcoord_i = 700;
            m8ycoord_i = start4;   
                       
            m9speed_i = speed2;  
            m9speedreset_i = m9speed_i;
            m9wait_i = 135000000;
            m9xcoord_i = 700;
            m9ycoord_i = start3;  
            
            m10speed_i = speed3;  
            m10speedreset_i = m10speed_i;
            m10wait_i = 135000000;
            m10xcoord_i = 700;
            m10ycoord_i = start4; 
             
            m11speed_i = speed5;  
            m11speedreset_i = m11speed_i;
            m11wait_i = 135000000;
            m11xcoord_i = 700;
            m11ycoord_i = start7; 
            
            m12speed_i = speed5;  
            m12speedreset_i = m12speed_i;
            m12wait_i = 137000000;
            m12xcoord_i = 700;
            m12ycoord_i = start9; 
            
            m13speed_i = speed5;  
            m13speedreset_i = m13speed_i;
            m13wait_i = 137000000;
            m13xcoord_i = 700;
            m13ycoord_i = start1; 
             
            m14speed_i = speed4; 
            m14speedreset_i = m14speed_i;
            m14wait_i = 145000000;
            m14xcoord_i = 700;
            m14ycoord_i = start8;   
                                
            m15speed_i = speed4;  
            m15speedreset_i = m15speed_i;
            m15wait_i = 150000000;
            m15xcoord_i = 700;
            m15ycoord_i = start9;  
            
            m16speed_i = speed2; 
            m16speedreset_i = m16speed_i ;
            m16wait_i = 151000000;
            m16xcoord_i = 700;
            m16ycoord_i = start4; 
            
            m17speed_i = speed2;  
            m17speedreset_i = m17speed_i;
            m17wait_i = 155000000;
            m17xcoord_i = 700;
            m17ycoord_i = start3; 
            
            m18speed_i = speed1;  
            m18speedreset_i = m18speed_i;
            m18wait_i = 160000000;
            m18xcoord_i = 700;
            m18ycoord_i = start7; 
            
            m19speed_i = speed1;  
            m19speedreset_i = m19speed_i;
            m19wait_i = 161000000;
            m19xcoord_i = 700;
            m19ycoord_i = start1; 
            
            m20speed_i = speed3;
            m20speedreset_i = m20speed_i;
            m20wait_i = 165000000;
            m20xcoord_i = 700;
            m20ycoord_i = start8;
                                              
            bmxspeed_i = 0;                                         
            bmyspeed_i = 0; 
            bmxspeedreset_i = 0;
            bmyspeedreset_i = 0;
            bmwait_i = 0;
            bmxcoord_i = 700;
            bmycoord_i = 500;                                      //hide big missile until its proper stage
            bmxspeedchange_i = 0;
            bmyspeedchange_i = 0;
        end else begin
            //missile 1
            if(m1wait_i <= 0)begin                                  //wait until missile can enter screen
                if(m1speed_i <= 0 && m1xcoord_i != 710)begin        //move missile forward if hasn't run one screen length or hasn't hit hero yet
                    m1xcoord_i = m1xcoord_i - 1;    
                    m1speed_i = m1speedreset_i;
                end else
                    m1speed_i = m1speed_i - 1;
            end else
                m1wait_i = m1wait_i - 1;
                
            //missile 2
            if(m2wait_i <= 0)begin
                if(m2speed_i <= 0 && m2xcoord_i != 710)begin
                    m2xcoord_i = m2xcoord_i - 1;    
                    m2speed_i = m2speedreset_i;
                end else
                    m2speed_i = m2speed_i - 1;
            end else
                m2wait_i = m2wait_i - 1;
                
            //missile 3
            if(m3wait_i <= 0)begin
                if(m3speed_i <= 0 && m3xcoord_i != 710)begin
                    m3xcoord_i = m3xcoord_i - 1;    
                    m3speed_i = m3speedreset_i;
                end else
                    m3speed_i = m3speed_i - 1;
            end else
                m3wait_i = m3wait_i - 1;
                
            //missile 4
            if(m4wait_i <= 0)begin
                if(m4speed_i <= 0 && m4xcoord_i != 710)begin
                    m4xcoord_i = m4xcoord_i - 1;    
                    m4speed_i = m4speedreset_i;
                end else
                    m4speed_i = m4speed_i - 1;
            end else
                m4wait_i = m4wait_i - 1;
                
            //missile 5
            if(m5wait_i <= 0)begin
                if(m5speed_i <= 0 && m5xcoord_i != 710)begin
                    m5xcoord_i = m5xcoord_i - 1;    
                    m5speed_i = m5speedreset_i;
                end else
                    m5speed_i = m5speed_i - 1;
            end else
                m5wait_i = m5wait_i - 1;
                
            //missile 6
            if(m6wait_i <= 0)begin
                if(m6speed_i <= 0 && m6xcoord_i != 710)begin
                    m6xcoord_i = m6xcoord_i - 1;    
                    m6speed_i = m6speedreset_i;
                end else
                    m6speed_i = m6speed_i - 1;
            end else
                m6wait_i = m6wait_i - 1;
                
            //missile 7
            if(m7wait_i <= 0)begin
                if(m7speed_i <= 0 && m7xcoord_i != 710)begin
                    m7xcoord_i = m7xcoord_i - 1;    
                    m7speed_i = m7speedreset_i;
                end else
                    m7speed_i = m7speed_i - 1;
            end else
                m7wait_i = m7wait_i - 1;
                            
            //missile 8
            if(m8wait_i <= 0)begin
                if(m8speed_i <= 0 && m8xcoord_i != 710)begin
                    m8xcoord_i = m8xcoord_i - 1;    
                    m8speed_i = m8speedreset_i;
                end else
                    m8speed_i = m8speed_i - 1;
            end else
                m8wait_i = m8wait_i - 1;
                
            //missile 9
            if(m9wait_i <= 0)begin
                if(m9speed_i <= 0 && m9xcoord_i != 710)begin
                    m9xcoord_i = m9xcoord_i - 1;    
                    m9speed_i = m9speedreset_i;
                end else
                    m9speed_i = m9speed_i - 1;
            end else
                m9wait_i = m9wait_i - 1;
                
            //missile 10
            if(m10wait_i <= 0)begin
                if(m10speed_i <= 0 && m10xcoord_i != 710)begin
                    m10xcoord_i = m10xcoord_i - 1;    
                    m10speed_i = m10speedreset_i;
                end else
                    m10speed_i = m10speed_i - 1;
            end else
                m10wait_i = m10wait_i - 1;
                
            //missile 11
            if(m11wait_i <= 0)begin
                if(m11speed_i <= 0 && m11xcoord_i != 710)begin
                    m11xcoord_i = m11xcoord_i - 1;    
                    m11speed_i = m11speedreset_i;
                end else
                    m11speed_i = m11speed_i - 1;
            end else
                m11wait_i = m11wait_i - 1;
                
            //missile 12
            if(m12wait_i <= 0)begin
                if(m12speed_i <= 0 && m12xcoord_i != 710)begin
                    m12xcoord_i = m12xcoord_i - 1;    
                    m12speed_i = m12speedreset_i;
                end else
                    m12speed_i = m12speed_i - 1;
            end else
                m12wait_i = m12wait_i - 1;
                
            //missile 13
            if(m13wait_i <= 0)begin
                if(m13speed_i <= 0 && m13xcoord_i != 710)begin
                    m13xcoord_i = m13xcoord_i - 1;    
                    m13speed_i = m13speedreset_i;
                end else
                    m13speed_i = m13speed_i - 1;
            end else
                m13wait_i = m13wait_i - 1;
                            
            //missile 14
            if(m14wait_i <= 0)begin
                if(m14speed_i <= 0 && m14xcoord_i != 710)begin
                    m14xcoord_i = m14xcoord_i - 1;    
                    m14speed_i = m14speedreset_i;
                end else
                    m14speed_i = m14speed_i - 1;
            end else
                m14wait_i = m14wait_i - 1;
                
            //missile 15
            if(m15wait_i <= 0)begin
                if(m15speed_i <= 0 && m15xcoord_i != 710)begin
                    m15xcoord_i = m15xcoord_i - 1;    
                    m15speed_i = m15speedreset_i;
                end else
                    m15speed_i = m15speed_i - 1;
            end else
                m15wait_i = m15wait_i - 1;
                
            //missile 16
            if(m16wait_i <= 0)begin
                if(m16speed_i <= 0 && m16xcoord_i != 710)begin
                    m16xcoord_i = m16xcoord_i - 1;    
                    m16speed_i = m16speedreset_i;
                end else
                    m16speed_i = m16speed_i - 1;
            end else
                m16wait_i = m16wait_i - 1;
                
            //missile 17
            if(m17wait_i <= 0)begin
                if(m17speed_i <= 0 && m17xcoord_i != 710)begin
                    m17xcoord_i = m17xcoord_i - 1;    
                    m17speed_i = m17speedreset_i;
                end else
                    m17speed_i = m17speed_i - 1;
            end else
                m17wait_i = m17wait_i - 1;
               
            //missile 18
            if(m6wait_i <= 0)begin
                if(m18speed_i <= 0 && m18xcoord_i != 710)begin
                    m18xcoord_i = m18xcoord_i - 1;    
                    m18speed_i = m18speedreset_i;
                end else
                    m18speed_i = m18speed_i - 1;
            end else
                m18wait_i = m18wait_i - 1;
                
            //missile 19
            if(m19wait_i <= 0)begin
                if(m19speed_i <= 0 && m19xcoord_i != 710)begin
                    m19xcoord_i = m19xcoord_i - 1;    
                    m19speed_i = m19speedreset_i;
                end else
                    m19speed_i = m19speed_i - 1;
            end else
                m19wait_i = m19wait_i - 1;
                            
            //missile 20
            if(m20wait_i <= 0)begin
                if(m20speed_i <= 0 && m20xcoord_i != 710)begin
                    m20xcoord_i = m20xcoord_i - 1;    
                    m20speed_i = m20speedreset_i;
                end else
                    m20speed_i = m20speed_i - 1;
            end else
                m20wait_i = m20wait_i - 1;
                                                
            //big missile
            if(bmwait_i <= 0)begin
                if(bmxspeed_i <= 0 && bmxcoord_i != 710)begin
                    bmxcoord_i = bmxcoord_i - 1;    
                    bmxspeed_i = bmxspeedreset_i;
                end else
                    bmxspeed_i = bmxspeed_i - 1;
                    
                if(bmyspeed_i <= 0 && stage_i == 6)begin                    //stage 5 moves missile upward
                    bmycoord_i = bmycoord_i - 1;    
                    bmyspeed_i = bmyspeedreset_i;
                end else if(bmyspeed_i <= 0 && stage_i == 5)begin           //stage 4 moves missile downward
                    bmycoord_i = bmycoord_i + 1;    
                    bmyspeed_i = bmyspeedreset_i;
                end else
                    bmyspeed_i = bmyspeed_i - 1;
            end else
                bmwait_i = bmwait_i - 1;
                
            //speed changes for big missile
            if(bmxspeedchange_i <= 0)begin
                bmxspeedreset_i = bmxspeedreset_i - 3000;           //reduce speed reset value to speed up
                bmxspeedchange_i = 1000000;                         //restore counter
            end else 
                bmxspeedchange_i = bmxspeedchange_i - 1;
            if(bmyspeedchange_i <= 0)begin
                bmyspeedreset_i = bmyspeedreset_i - 3000;
                bmyspeedchange_i = 1200000;
            end else
                bmyspeedchange_i = bmyspeedchange_i - 1;
                
            if(nextstage_i <= 0 && stage_i == 2)begin               //begin stage 2 of missiles
                nextstage_i = 220000000;
                    
                m1speed_i = speed4;  
                m1speedreset_i = m1speed_i;
                m1wait_i = 0;
                m1xcoord_i = 700;
                m1ycoord_i = start1;   
                  
                m2speed_i = speed4; 
                m2speedreset_i = m2speed_i; 
                m2wait_i = 3000000;
                m2xcoord_i = 700;
                m2ycoord_i = start2;  
                
                m3speed_i = speed4;  
                m3speedreset_i = m3speed_i;
                m3wait_i = 6000000;
                m3xcoord_i = 700;
                m3ycoord_i = start3; 
                    
                m4speed_i = speed4;  
                m4speedreset_i = m4speed_i;
                m4wait_i = 9000000;
                m4xcoord_i = 700;
                m4ycoord_i = start4; 
                
                m5speed_i = speed4; 
                m5speedreset_i = m5speed_i;
                m5wait_i = 12000000;
                m5xcoord_i = 700;
                m5ycoord_i = start5; 
                 
                m6speed_i = speed4;  
                m6speedreset_i = m6speed_i;
                m6wait_i = 15000000;
                m6xcoord_i = 700;
                m6ycoord_i = start6; 
                    
                m7speed_i = speed4;  
                m7speedreset_i = m7speed_i;
                m7wait_i = 18000000;
                m7xcoord_i = 700;
                m7ycoord_i = start7;  
                               
                m8speed_i = speed4;  
                m8speedreset_i = m8speed_i;
                m8wait_i = 21000000;
                m8xcoord_i = 700;
                m8ycoord_i = start8;   
                           
                m9speed_i = speed4;  
                m9speedreset_i = m9speed_i;
                m9wait_i = 50000000;
                m9xcoord_i = 700;
                m9ycoord_i = start10;  
                
                m10speed_i = speed4;  
                m10speedreset_i = m10speed_i;
                m10wait_i = 53000000;
                m10xcoord_i = 700;
                m10ycoord_i = start9; 
                 
                m11speed_i = speed4;  
                m11speedreset_i = m11speed_i;
                m11wait_i = 56000000;
                m11xcoord_i = 700;
                m11ycoord_i = start8; 
                
                m12speed_i = speed4;  
                m12speedreset_i = m12speed_i;
                m12wait_i = 59000000;
                m12xcoord_i = 700;
                m12ycoord_i = start7; 
                
                m13speed_i = speed4;  
                m13speedreset_i = m13speed_i;
                m13wait_i = 62000000;
                m13xcoord_i = 700;
                m13ycoord_i = start6; 
                 
                m14speed_i = speed4; 
                m14speedreset_i = m14speed_i;
                m14wait_i = 65000000;
                m14xcoord_i = 700;
                m14ycoord_i = start5;   
                                    
                m15speed_i = speed4;  
                m15speedreset_i = m15speed_i;
                m15wait_i = 68000000;
                m15xcoord_i = 700;
                m15ycoord_i = start4;  
                
                m16speed_i = speed4; 
                m16speedreset_i = m16speed_i;
                m16wait_i = 71000000;
                m16xcoord_i = 700;
                m16ycoord_i = start3; 
                
                stage_i = stage_i + 1;
                
            end else if(nextstage_i <= 0 && stage_i == 3)begin      //begin stage 3 of missiles
                nextstage_i = 130000000;
                
                m1speed_i = speed5;  
                m1speedreset_i = m1speed_i;
                m1wait_i = 0;
                m1xcoord_i = 700;
                m1ycoord_i = start1;   
                
                m2speed_i = speed5;  
                m2speedreset_i = m2speed_i;
                m2wait_i = 0;
                m2xcoord_i = 700;
                m2ycoord_i = halfstart2;   
                
                m3speed_i = speed5; 
                m3speedreset_i = m3speed_i; 
                m3wait_i = 5000000;
                m3xcoord_i = 700;
                m3ycoord_i = start2;  
                
                m4speed_i = speed5;  
                m4speedreset_i = m4speed_i;
                m4wait_i = 10000000;
                m4xcoord_i = 700;
                m4ycoord_i = halfstart3; 
                
                m5speed_i = speed5;  
                m5speedreset_i = m5speed_i;
                m5wait_i = 15000000;
                m5xcoord_i = 700;
                m5ycoord_i = start3; 
                
                m6speed_i = speed5; 
                m6speedreset_i = m6speed_i;
                m6wait_i = 20000000;
                m6xcoord_i = 700;
                m6ycoord_i = halfstart4; 
                
                m7speed_i = speed5;  
                m7speedreset_i = m7speed_i;
                m7wait_i = 25000000;
                m7xcoord_i = 700;
                m7ycoord_i = start4; 
                
                m8speed_i = speed5;  
                m8speedreset_i = m8speed_i;
                m8wait_i = 30000000;
                m8xcoord_i = 700;
                m8ycoord_i = halfstart5;  
                           
                m9speed_i = speed5;  
                m9speedreset_i = m9speed_i;
                m9wait_i = 30000000;
                m9xcoord_i = 700;
                m9ycoord_i = start6;   
                       
                m10speed_i = speed5;  
                m10speedreset_i = m10speed_i;
                m10wait_i = 25000000;
                m10xcoord_i = 700;
                m10ycoord_i = halfstart7;  
                
                m11speed_i = speed5;  
                m11speedreset_i = m11speed_i;
                m11wait_i = 20000000;
                m11xcoord_i = 700;
                m11ycoord_i = start7; 
                
                m12speed_i = speed5;  
                m12speedreset_i = m12speed_i;
                m12wait_i = 15000000;
                m12xcoord_i = 700;
                m12ycoord_i = halfstart8; 
                
                m13speed_i = speed5;  
                m13speedreset_i = m13speed_i;
                m13wait_i = 10000000;
                m13xcoord_i = 700;
                m13ycoord_i = start8; 
                
                m14speed_i = speed5;  
                m14speedreset_i = m14speed_i;
                m14wait_i = 5000000;
                m14xcoord_i = 700;
                m14ycoord_i = halfstart9; 
                
                m15speed_i = speed5; 
                m15speedreset_i = m15speed_i;
                m15wait_i = 0;
                m15xcoord_i = 700;
                m15ycoord_i = start9;
                                
                m16speed_i = speed5; 
                m16speedreset_i = m16speed_i;
                m16wait_i = 0;
                m16xcoord_i = 700;
                m16ycoord_i = halfstart10;
                                                
                m17speed_i = speed5; 
                m17speedreset_i = m17speed_i;
                m17wait_i = 0;
                m17xcoord_i = 700;
                m17ycoord_i = start10;
                
                stage_i = stage_i + 1;
                
            end else if(nextstage_i <= 0 && stage_i == 4)begin      //begin stage 4 of missiles     
                nextstage_i = 80000000;                                           
                bmxspeed_i = speed2;                                         
                bmyspeed_i = speed1; 
                bmxspeedreset_i = bmxspeed_i;
                bmyspeedreset_i = bmyspeed_i;
                bmwait_i = 0;
                bmxcoord_i = 700;
                bmycoord_i = start1;    
                bmxspeedchange_i = 1000000;
                bmyspeedchange_i = nextstage_i;
                
                stage_i = stage_i + 1;         
                
            end else if(nextstage_i <= 0 && stage_i == 5)begin      //begin stage 5 of missiles     
                nextstage_i = 80000000;                                           
                bmxspeed_i = speed2;                                         
                bmyspeed_i = speed3; 
                bmxspeedreset_i = bmxspeed_i;
                bmyspeedreset_i = bmyspeed_i;
                bmwait_i = 0;
                bmxcoord_i = 700;
                bmycoord_i = start10;    
                bmxspeedchange_i = 900000;
                bmyspeedchange_i = nextstage_i;
                
                stage_i = stage_i + 1;         
                
            end else if(nextstage_i <= 0 && stage_i == 6)begin      //begin final stage
                stage_i = stage_i + 1;                              //begin end screen "stage"
                
            end else
                nextstage_i = nextstage_i - 1;
        end    
        bmcolor_i = bmcolor_i ^ 12'h730;                            //"randomize" big missile color every clock cycle                   
        bmcolor_i = bmcolor_i + 12'hF4C;
        bmcolor_i = bmcolor_i ^ 12'h09C;
        bmcolor_i = bmcolor_i - 12'hDE2;
        bmcolor_i = bmcolor_i ^ 12'hFAC;
    end
    
    //user input reader
    //In retrospect, should have been implemented with a state machine, not with whatever this is
    always @(posedge CLK, posedge arst_i)begin
        if(arst_i)begin                  
            hspeed_i = 1600000;                                                     //starting speed of hero
            hstill_i = 1;   
            hsouth_i = 0;     
        end else begin
            if(KBSTROBE)begin                                                       //only sample KBCODE on KBSTROBE
                case(KBCODE)
                    UP: begin
                        if(!hsouth_i)begin
                            if(hspeed_i > 100000)begin                              //max speed check, going upwards
                                hspeed_i = hspeed_i >> 2;                           //increase speed
                                hstill_i = 0;
                            end
                            else ;                                                  //don't speed up if at max speed
                        end else if(hsouth_i)begin
                            if(!hstill_i && hspeed_i < 400000)begin                 //min speed check, going downwards
                                hspeed_i = hspeed_i << 2;                           //decrease speed  
                                hstill_i = 0;
                            end else if(!hstill_i && hspeed_i >= 400000)begin       //min speed check, going downwards
                                hstill_i = 1;                                       //slowed down to stop
                                hspeed_i = 1600000;                                 //reset speed
                            end else if(hstill_i)begin
                                hsouth_i = ~hsouth_i;                               //if still, reverse direction   
                                hspeed_i = 400000;                                  //restore slow speed
                                hstill_i = 0;
                            end  
                        end
                    end
                    DN: begin
                        if(hsouth_i)begin
                            if(hspeed_i > 100000)begin                              //max speed check, going downwards
                                hspeed_i = hspeed_i >> 2;                           //increase speed
                                hstill_i = 0;
                            end
                            else ;                                                  //don't speed up if at max speed
                        end else if(!hsouth_i)begin
                            if(!hstill_i && hspeed_i < 400000)begin                 //min speed check, going upwards
                                hspeed_i = hspeed_i << 2;                           //decrease speed  
                                hstill_i = 0;
                            end else if(!hstill_i && hspeed_i >= 400000)begin       //min speed check, going upwards
                                hstill_i = 1;                                       //slowed down to stop
                                hspeed_i = 1600000;                                 //reset speed
                            end else if(hstill_i)begin
                                hsouth_i = ~hsouth_i;                               //if still, reverse direction   
                                hspeed_i = 400000;                                  //restore slow speed
                                hstill_i = 0;
                            end  
                        end
                    end
                endcase
            end if(hybumper_i)begin
                hstill_i = 1;                                                       //reset speed if border hit
                hspeed_i = 1000000;                                                 //restore default speed
            end
        end
    end
endmodule
