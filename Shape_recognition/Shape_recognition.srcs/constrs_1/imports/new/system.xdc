## Clock signal 100 MHz
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports clk_100MHz]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100MHz]
#MIPI
set_property PACKAGE_PIN M12 [get_ports Camera_GPIO]
set_property IOSTANDARD LVCMOS33 [get_ports Camera_GPIO]

set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS33} [get_ports Camera_IIC_SCL]
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVCMOS33} [get_ports Camera_IIC_SDA]

set_property PULLUP true [get_ports Camera_IIC_SCL]
set_property PULLUP true [get_ports Camera_IIC_SDA]

set_property INTERNAL_VREF 0.6 [get_iobanks 14]

set_property -dict {PACKAGE_PIN C10 IOSTANDARD HSUL_12} [get_ports Data_N]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD HSUL_12} [get_ports Data_P]

set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVDS_25} [get_ports Clk_Rx_Data_N]
set_property -dict {PACKAGE_PIN G11 IOSTANDARD LVDS_25} [get_ports Clk_Rx_Data_P]

set_property -dict {PACKAGE_PIN J12 IOSTANDARD LVDS_25} [get_ports {Rx_Data_N[0]}]
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVDS_25} [get_ports {Rx_Data_P[0]}]
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVDS_25} [get_ports {Rx_Data_N[1]}]
set_property -dict {PACKAGE_PIN P10 IOSTANDARD LVDS_25} [get_ports {Rx_Data_P[1]}]

create_clock -period 4.761 -name dphy_hs_clock_p -waveform {0.000 2.380} [get_ports Clk_Rx_Data_P]

#Key
#set_property PACKAGE_PIN C3 [get_ports {Key[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Key[0]}]
#set_property PACKAGE_PIN M4 [get_ports {Key[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {Key[1]}]
#led
set_property PACKAGE_PIN J1 [get_ports {led[0]}]
set_property PACKAGE_PIN A13 [get_ports {led[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PULLDOWN true [get_ports {led[0]}]
set_property PULLDOWN true [get_ports {led[1]}]


##HDMI Tx
set_property -dict {PACKAGE_PIN F4 IOSTANDARD TMDS_33} [get_ports TMDS_Tx_Clk_N]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD TMDS_33} [get_ports TMDS_Tx_Clk_P]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_N[0]}]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_P[0]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_N[1]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_P[1]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_N[2]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD TMDS_33} [get_ports {TMDS_Tx_Data_P[2]}]

#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_G_reg[6]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_B_reg[7]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_R_reg[4]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_R_reg[6]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_G_reg[6]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_B_reg[7]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_R_reg[4]/D}]
#set_false_path -from [get_pins {Image_Process_Edge/RGB_To_HSV0/HSV_Data_S_reg[2]/C}] -to [get_pins {Image_Process_Edge/HSV_To_RGB0/RGB_G_reg[4]/D}]

##SPI
#set_property PACKAGE_PIN B2 [get_ports CS]
#set_property PACKAGE_PIN M5 [get_ports MOSI]
#set_property PACKAGE_PIN L5 [get_ports MISO]
#set_property PACKAGE_PIN H13 [get_ports SCK]

#set_property IOSTANDARD LVCMOS33 [get_ports CS]
#set_property IOSTANDARD LVCMOS33 [get_ports MOSI]
#set_property IOSTANDARD LVCMOS33 [get_ports MISO]
#set_property IOSTANDARD LVCMOS33 [get_ports SCK]
##Signal Enable
#set_property PACKAGE_PIN M3 [get_ports SPI_EN]
#set_property IOSTANDARD LVCMOS33 [get_ports SPI_EN]

#Uart
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports UART0_Rx];
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports UART0_Tx];
