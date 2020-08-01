`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/11 14:19:51
// Design Name: 
// Module Name: UART_Demo
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


module UART_Demo(
    input clk_100MHz,
    input UART0_Rx,
    output UART0_Tx
    );
    //clock
    wire clk_100MHz_System;
    wire clk_10MHz;
    
    wire Tx_ACK;
    wire Rx_ACK;
    wire Tx_En;
    wire [7:0]Send_Buffer;
    wire [7:0]Rx_Data;
    
    
    parameter clk_mode='d100_000_00/2;
    parameter Fang=8'b1111_0000;
    parameter San= 8'b1100_0011;
    parameter Yuan=8'b1100_1100;
    wire clk_delay;
    reg [7:0] data_in=Fang;
    //Frequency divider
    clk_wiz_0 clk_10(.clk_out1(clk_100MHz_System),.clk_out2(clk_10MHz),.clk_in1(clk_100MHz));
//    Clk_Division data_Clk(
//      .clk_100MHz(clk_100MHz),  // input wire clk_100MHz
//      .clk_mode(clk_mode),      // input wire [30 : 0] clk_mode
//      .clk_out(clk_delay)        // output wire clk_out
//    );
//    always@(posedge clk_delay)
//    begin
//        case(data_in)
//            Fang: data_in<=San;
//            San: data_in<=Yuan;
//            Yuan: data_in<=Fang;
//           default:  data_in<=Fang; 
//        endcase
//    end
    
    Driver_UART UART0(
        .clk_100MHz(clk_100MHz_System),
        .Rst(1),
        .En_Rx(1),
        .En_Tx(Tx_En),
        .Baud_Rate(9600),
        .Rx(UART0_Rx),
        .Tx_Data(Send_Buffer),
        .Tx(UART0_Tx),
        .Rx_Data(Rx_Data),
        .Rx_ACK(Rx_ACK),
        .Tx_ACK(Tx_ACK)
        );
     Shape_send  Shape_send_0(
        .clk_10MHz(clk_10MHz),
        .Tx_ACK(Tx_ACK),
        .Enable(1),
        .data_out(data_in),
        .Tx_En(Tx_En),
        .Send_Buffer(Send_Buffer)
    );
//    UART_Send UART_Send0(
//        .clk_10MHz(clk_10MHz),
//        .Tx_ACK(Tx_ACK),
//        .Enable(1),
//        .Temp_Data(0),
//        .Gyro_Data_X(0),
//        .Gyro_Data_Y(0),
//        .Gyro_Data_Z(0),
//        .Mag_Data_X(0),
//        .Mag_Data_Y(0),
//        .Mag_Data_Z(0),
//        .Tx_En(Tx_En),
//        .Send_Buffer(Send_Buffer)
//        );
endmodule
