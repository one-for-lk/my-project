`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 21:20:24
// Design Name: 
// Module Name: Shape_recognition
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


module Shape_recognition(
     input clk_100MHz,
    input Clk_Rx_Data_N,
    input Clk_Rx_Data_P,
    input [1:0]Rx_Data_N,
    input [1:0]Rx_Data_P,
    input Data_N,
    input Data_P,
    input UART0_Rx,
    
  //  input MISO,
   // input [1:0]Key,
    inout Camera_IIC_SDA,
    output Camera_IIC_SCL,
    output Camera_GPIO,
    output TMDS_Tx_Clk_N,
    output TMDS_Tx_Clk_P,
    output [2:0]TMDS_Tx_Data_N,
    output [2:0]TMDS_Tx_Data_P,
    output UART0_Tx,
    output [1:0]  led
//    output SCK,
//    output MOSI,
//    output CS,
//    output reg SPI_EN=1
    );
    //Clock
    wire clk_100MHz_system;
    wire clk_200MHz;
    wire clk_10MHz;
    wire clk_100MHz_out;
    wire clk_Serial_out;
    //SPI
//    reg Busy=1;
//    wire ACK;
//    wire clk_En;
   
    //MIPI Camera OV5647
    wire [23:0]RGB_Data_Src;
    wire RGB_HSync_Src;
    wire RGB_VSync_Src;
    wire RGB_VDE_Src;
    wire [10:0] hdata;
    wire [9:0] vdata;
    //RGB2GRAY
    parameter RGB2Gray_Accuracy_N=8;
    wire [7:0] Gray_Data;
    //Shape
    parameter YUZHI = 74, HANG220 = 219, HANG360 = 359, HANG500 = 499, HANG550 = 549, HANG740 = 739,TURE = 1, SMALL1 = 120, SMALL2 = 40, MIDDLES = 120, MIDDLEY = 240, BIG = 320;
    wire [7:0] data8_out;
    //UART
    wire Tx_ACK;
    wire Rx_ACK;
    wire Tx_En;
    wire [7:0]Send_Buffer;
    wire [7:0]Rx_Data;
    //IIC
    wire IIC_Rst;
    wire [7:0]Address;         //IIC communication slave device address
    wire [7:0]Data;            //IIC write data
    wire [15:0]Reg_Addr;       //Register address
    wire [7:0]IIC_Read_Data;
    wire IIC_Busy;     
    wire Reg2Addr;
    wire IIC_Write;
    reg IIC_Read=0;
    wire Camera_IIC_SDA_I;
    wire Camera_IIC_SDA_O;
    wire Camera_IIC_SDA_T;
    //HDMI
    wire [23:0]RGB_In;
    wire [11:0]Set_X;
    wire [11:0]Set_Y;
    wire [23:0]RGB_Data;
    wire RGB_HSync;
    wire RGB_VSync;
    wire RGB_VDE;
    wire clk_system;
    clk_wiz_0 clk_10(.clk_out1(clk_100MHz_system),.clk_out2(clk_200MHz),.clk_out3(clk_10MHz),.clk_in1(clk_100MHz));
    clk_wiz_1 clk_4(.clk_out1(clk_Serial_out),.clk_in1(clk_100MHz_out));
//     Clk_Division En_Generator(
//        .clk_100MHz(clk_100MHz), // input wire clk_100MHz
//        .clk_mode(1000000), // input wire [30 : 0] clk_mode
//        .clk_out(clk_En) // output wire clk_out
//    );
    //Tri-state gate
    IOBUF Camera_IIC_SDA_IOBUF
           (.I(Camera_IIC_SDA_O),
            .IO(Camera_IIC_SDA),
            .O(Camera_IIC_SDA_I),
            .T(~Camera_IIC_SDA_T));
    //Camera driver
    Driver_MIPI1 Driver_MIPI0_1(
        .clk_200MHz(clk_200MHz),
        .Clk_Rx_Data_N(Clk_Rx_Data_N),
        .Clk_Rx_Data_P(Clk_Rx_Data_P),
        .Rx_Data_N(Rx_Data_N),
        .Rx_Data_P(Rx_Data_P),
        .Data_N(Data_N),
        .Data_P(Data_P),
        .Camera_GPIO(Camera_GPIO),
        .RGB_Data(RGB_Data_Src),
        .RGB_HSync(RGB_HSync_Src),
        .RGB_VSync(RGB_VSync_Src),
        .RGB_VDE(RGB_VDE_Src),
      //  .Data(),
        .HCnt(hdata),
        .VCnt(vdata),
        .clk_100MHz_out(clk_100MHz_out)
    );
    
     RGB_To_Gray RGB2Gray(
        .RGB_Data_R(RGB_Data_Src[23:16]),              //Pixel data R
        .RGB_Data_G(RGB_Data_Src[15:8]),               //Pixel data G
        .RGB_Data_B(RGB_Data_Src[7:0]),                //Pixel data B
        .Accuracy_Num(RGB2Gray_Accuracy_N),            //Grayscale precision digits
        .Gray_Data(Gray_Data)                          //Output grayscale data
        );
     //Shape recognition
     Recognize_Top#(
        .YUZHI(YUZHI),
        .HANG220(HANG220),
        .HANG360(HANG360),
        .HANG500(HANG500),
        .HANG550(HANG550),
        .HANG740(HANG740),
         .TURE(TURE),
        .SMALL1(SMALL1),
        .SMALL2(SMALL2),
        .MIDDLES(MIDDLES),
        .MIDDLEY(MIDDLEY),
        .BIG(BIG)
     )
     Recognize_0(
       .rst_n(1),
       .vid_clk(clk_100MHz_out),
        .vid_hsync(RGB_HSync_Src),
        .vid_vsync(RGB_VSync_Src),
        .vid_active_video(RGB_VDE_Src),
        .vid_data(Gray_Data),
        .hdata(hdata),
        .vdata(vdata),
        .vid_data_out(RGB_Data),
        .vid_hsync_out(RGB_HSync),
        .vid_vsync_out(RGB_VSync),
        .vid_active_video_out(RGB_VDE),
        .data8_out(data8_out)
     );
     
     //Send
      Driver_UART UART0(
        .clk_100MHz(clk_100MHz_system),
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
        .data_in(data8_out),
        .Tx_En(Tx_En),
        .Send_Buffer(Send_Buffer),
        .led(led)
    );
     
     //SPI Master
//     SPI_Master SPI_Master0(
//        .clk_100MHz(clk_100MHz),
//        .Rst(1),
//        .En(clk_En),
//        .Busy(Busy),
//        .MISO(MISO),
//        .Data(data8_out),
//        .SCK(SCK),
//        .MOSI(MOSI),
//        .CS(CS),
//        .ACK(ACK)
//    );
       
    //RGBToDvi instantiation
    rgb2dvi_0 rgb2dvi(
        .TMDS_Clk_p(TMDS_Tx_Clk_P),
        .TMDS_Clk_n(TMDS_Tx_Clk_N),
        .TMDS_Data_p(TMDS_Tx_Data_P),
        .TMDS_Data_n(TMDS_Tx_Data_N),
        .aRst_n(1),
        .vid_pData(RGB_Data),
        .vid_pVDE(RGB_VDE),
        .vid_pHSync(RGB_HSync),
        .vid_pVSync(RGB_VSync),
        .PixelClk(clk_100MHz_out),
        .SerialClk(clk_Serial_out)
        );
    //IIC driver
    Driver_IIC Driver_IIC0(
        .clk(clk_100MHz_system),
        .Rst(IIC_Rst),
        .Addr(Address),
        .Reg_Addr(Reg_Addr),
        .Data(Data),
        .IIC_Write(IIC_Write),
        .IIC_Read(IIC_Read),
        .IIC_Read_Data(IIC_Read_Data),
        .IIC_Busy(IIC_Busy),
        .Reg_2Addr(Reg2Addr),
        .IIC_SCL(Camera_IIC_SCL),
        .IIC_SDA_In(Camera_IIC_SDA_I),
        .SDA_Dir(Camera_IIC_SDA_T),
        .SDA_Out(Camera_IIC_SDA_O)
    );
    //OV5647 camera initialization
    OV5647_Init Diver_OV5647_Init(
        .clk_10MHz(clk_10MHz),
        .IIC_Busy(IIC_Busy),
        .Addr(Address),
        .Reg_Addr(Reg_Addr),
        .Reg_Data(Data),
        .IIC_Write(IIC_Write),
        .Reg2Addr(Reg2Addr),
        .Ctrl_IIC(IIC_Rst)
        );
endmodule
