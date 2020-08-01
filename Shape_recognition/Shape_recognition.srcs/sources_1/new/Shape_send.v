`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/31 12:42:58
// Design Name: 
// Module Name: Shape_send
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


module Shape_send(
    input clk_10MHz,
    input Tx_ACK,
    input Enable,
    input [7:0] data_in,
    output reg Tx_En=0,
    output reg[7:0]Send_Buffer=0,
    output reg [1:0]led=0
    );
    //Defining the sending status
    parameter Fang=8'b1111_0000;
    parameter San= 8'b1100_0011;
    parameter Yuan=8'b1100_1100;
    parameter clk_mode='d100_000_00;
    
    //Defining the sending status
    reg [3:0]Fang_Cnt=0;
    reg [3:0]San_Cnt=0;
    reg [3:0]Yuan_Cnt=0;
    reg [3:0]Default_Cnt=0;
    //Trigger pulse
    reg [1:0]Pulse_Init_Flag=0;
    reg [7:0] data_out;
    
     wire clk_delay;
    //Frequency divider
    Clk_Division data_Clk(
      .clk_100MHz(clk_10MHz),  
      .clk_mode(clk_mode),      
      .clk_out(clk_delay)       
    );
    always@(posedge clk_delay)
    begin
        if(Fang_Cnt==11|San_Cnt==11|Yuan_Cnt==11|Default_Cnt==12)
            begin 
                case(data_in)
                    Fang: data_out<=San;
                    San: data_out<=Yuan;
                    Yuan: data_out<=Fang;
                   default:  data_out<=0; 
                endcase
            end
        else  data_out<=data_out;
    end
    //Give the rising edge of the sender
    always@(posedge clk_10MHz or posedge Tx_ACK)
        begin
            if(Tx_ACK)
                begin
                    Tx_En<=~Tx_En;
                    Pulse_Init_Flag<=2;
                end
            else if(Pulse_Init_Flag==0)
                begin
                    Tx_En<=0;
                    Pulse_Init_Flag<=1;
                end
            else if(Pulse_Init_Flag[0])
                begin
                    Tx_En<=1;
                    Pulse_Init_Flag<=0;
                end
            else
                Tx_En<=0;    
        end
    //send data
    always@(posedge Tx_ACK)
        begin
            case(data_out)
                Fang:
                    begin
                        
                        case(Fang_Cnt)                                        //方形
                            0:begin Send_Buffer<=8'hFD;Fang_Cnt<=Fang_Cnt+1;led<=3;San_Cnt<=0;Yuan_Cnt<=0;Default_Cnt<=0;end
                            1:begin Send_Buffer<=8'h00;Fang_Cnt<=Fang_Cnt+1;end
                            2:begin Send_Buffer<=8'h07;Fang_Cnt<=Fang_Cnt+1;end
                            3:begin Send_Buffer<=8'h01;Fang_Cnt<=Fang_Cnt+1;end
                            4:begin Send_Buffer<=8'h00;Fang_Cnt<=Fang_Cnt+1;end
                            5:begin Send_Buffer<=8'hB7;Fang_Cnt<=Fang_Cnt+1;end
                            6:begin Send_Buffer<=8'hBD;Fang_Cnt<=Fang_Cnt+1;end
                            7:begin Send_Buffer<=8'hD0;Fang_Cnt<=Fang_Cnt+1;end
                            8:begin Send_Buffer<=8'hCE;Fang_Cnt<=Fang_Cnt+1;end
                            9:begin Send_Buffer<=8'hEF;Fang_Cnt<=Fang_Cnt+1;end
                           10:begin Send_Buffer<=8'hC1;Fang_Cnt<=Fang_Cnt+1;end
                           11:begin Send_Buffer<=0;   end
                        endcase
                    end
                San:
                    begin
                        
                        case(San_Cnt)                                            //三角
                            0:begin Send_Buffer<=8'hFD;San_Cnt<=San_Cnt+1;led<=2;Yuan_Cnt<=0;Fang_Cnt<=0;Default_Cnt<=0;end
                            1:begin Send_Buffer<=8'h00;San_Cnt<=San_Cnt+1;end
                            2:begin Send_Buffer<=8'h07;San_Cnt<=San_Cnt+1;end
                            3:begin Send_Buffer<=8'h01;San_Cnt<=San_Cnt+1;end
                            4:begin Send_Buffer<=8'h00;San_Cnt<=San_Cnt+1;end
                            5:begin Send_Buffer<=8'hC8;San_Cnt<=San_Cnt+1;end
                            6:begin Send_Buffer<=8'hFD;San_Cnt<=San_Cnt+1;end
                            7:begin Send_Buffer<=8'hBD;San_Cnt<=San_Cnt+1;end
                            8:begin Send_Buffer<=8'hC7;San_Cnt<=San_Cnt+1;end
                            9:begin Send_Buffer<=8'hB4;San_Cnt<=San_Cnt+1;end
                            10:begin Send_Buffer<=8'hC1;San_Cnt<=San_Cnt+1;end
                            11:begin Send_Buffer<=0;   end
                        endcase
                    end
                Yuan:
                    begin
                        
                        case(Yuan_Cnt)                                            //圆形
                            0:begin Send_Buffer<=8'hFD;Yuan_Cnt<=Yuan_Cnt+1;led<=1;San_Cnt<=0;Fang_Cnt<=0;Default_Cnt<=0;end
                            1:begin Send_Buffer<=8'h00;Yuan_Cnt<=Yuan_Cnt+1;end
                            2:begin Send_Buffer<=8'h07;Yuan_Cnt<=Yuan_Cnt+1;end
                            3:begin Send_Buffer<=8'h01;Yuan_Cnt<=Yuan_Cnt+1;end
                            4:begin Send_Buffer<=8'h00;Yuan_Cnt<=Yuan_Cnt+1;end
                            5:begin Send_Buffer<=8'hD4;Yuan_Cnt<=Yuan_Cnt+1;end
                            6:begin Send_Buffer<=8'hB2;Yuan_Cnt<=Yuan_Cnt+1;end
                            7:begin Send_Buffer<=8'hD0;Yuan_Cnt<=Yuan_Cnt+1;end
                            8:begin Send_Buffer<=8'hCE;Yuan_Cnt<=Yuan_Cnt+1;end
                            9:begin Send_Buffer<=8'h83;Yuan_Cnt<=Yuan_Cnt+1;end
                            10:begin Send_Buffer<=8'hC1;Yuan_Cnt<=Yuan_Cnt+1;end
                            11:begin Send_Buffer<=0;   end
                        endcase
                    end
               default:  
                   begin
                        
                        case(Default_Cnt)                                          //音量[v15]
                            0:begin Send_Buffer<=8'hFD;Default_Cnt<=Default_Cnt+1;led<=0;San_Cnt<=0;Fang_Cnt<=0;Yuan_Cnt<=0;end
                            1:begin Send_Buffer<=8'h00;Default_Cnt<=Default_Cnt+1;end
                            2:begin Send_Buffer<=8'h08;Default_Cnt<=Default_Cnt+1;end
                            3:begin Send_Buffer<=8'h01;Default_Cnt<=Default_Cnt+1;end
                            4:begin Send_Buffer<=8'h00;Default_Cnt<=Default_Cnt+1;end
                            5:begin Send_Buffer<=8'h5B;Default_Cnt<=Default_Cnt+1;end
                            6:begin Send_Buffer<=8'h76;Default_Cnt<=Default_Cnt+1;end
                            7:begin Send_Buffer<=8'h31;Default_Cnt<=Default_Cnt+1;end
                            8:begin Send_Buffer<=8'h35;Default_Cnt<=Default_Cnt+1;end
                            9:begin Send_Buffer<=8'h5D;Default_Cnt<=Default_Cnt+1;end
                            10:begin Send_Buffer<=8'h80;Default_Cnt<=Default_Cnt+1;end
                            11:begin Send_Buffer<=8'hC1;Default_Cnt<=Default_Cnt+1;end
                            12:begin Send_Buffer<=0;   end
                        endcase
                    end
            endcase
        end
endmodule
