module apb_interfaced_spi_slave(input pclk,preset_n,pwrite_i,penable_i,psel_i,miso_i,input [2:0] paddr_i,input [7:0] pwdata_i,
                                  output ss_o,sclk_o,spi_interrupt_request_o,pready_o,pslverr_o,mosi_o,output [7:0] prdata_o);
								  
				wire receive_data,tip;
				wire [7:0] data_miso,data_mosi;
				wire mstr,cpol,cpha,lsbfe,spiswai,send_data;
				wire [2:0] sppr,spr;
				wire [1:0] spi_mode;
				
				wire miso_receive_sclk,miso_receive_sclk0,mosi_send_sclk,mosi_send_sclk0;
				wire [11:0] baudratedivisor;
				//wire [7:0] prdata;
						
				//assign prdata_o=prdata;		
				
				apb_slave_interface uut1(.pclk(pclk),.preset_n(preset_n),.pwrite_i(pwrite_i),.psel_i(psel_i),.penable_i(penable_i),.ss_i(ss_o),.receive_data_i(receive_data),.tip_i(tip),.paddr_i(paddr_i),
                 .pwdata_i(pwdata_i),.miso_data_i(data_miso),.mstr_o(mstr),.cpol_o(cpol),.cpha_o(cpha),.lsbfe_o(lsbfe),.spiswai_o(spiswai),.pready_o(pready_o),.pslverr_o(pslverr_o),.spi_interrupt_request_o(spi_interrupt_request_o),.send_data_o(send_data),
				  .prdata_o(prdata_o),.sppr_o(sppr),.spr_o(spr),.spi_mode_o(spi_mode),.mosi_data_o(data_mosi));//miso_data_i -->data_miso_o of shift reg out 
				  
				 
				spi_baud_generator uut2(.pclk(pclk),.preset_n(preset_n),.spiswai_i(spiswai),.cpol_i(cpol),.cpha_i(cpha),.ss_i(ss_o),
						.spi_mode_i(spi_mode),.sppr_i(sppr),.spr_i(spr),.sclk_o(sclk_o),.miso_receive_sck_o(miso_receive_sclk),.miso_receive_sck0_o(miso_receive_sclk0),.mosi_send_sck_o(mosi_send_sclk),
						.mosi_send_sck0_o(mosi_send_sclk0),.baudratedivisor_o(baudratedivisor));
						  
				
				shift_register uut3(.pclk(pclk),.preset_n(preset_n),.ss_i(ss_o),.send_data_i(send_data),.lsbfe_i(lsbfe),.cpha(cpha),.cpol(cpol),
                      .miso_receive_sclk_i(miso_receive_sclk),.miso_receive_sclk0_i(miso_receive_sclk0),.mosi_send_sclk_i(mosi_send_sclk),
					  .mosi_send_sclk0_i(mosi_send_sclk0),.miso_i(miso_i),.receive_data_i(receive_data),.data_mosi_i(data_mosi),.data_miso_o(data_miso),.mosi_o(mosi_o));
				
				
				spi_slave_control_select uut4(.pclk(pclk),.preset_n(preset_n),.mstr_i(mstr),.spiswai_i(spiswai),.send_data_i(send_data),.spi_mode_i(spi_mode),.baudrateDivisor_i(baudratedivisor),
								.receive_data_o(receive_data),.ss_o(ss_o),.tip_o(tip));
endmodule
