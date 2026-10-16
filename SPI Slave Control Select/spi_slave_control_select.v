module spi_slave_control_select(input pclk ,preset_n,mstr_i,spiswai_i,send_data_i,input [1:0] spi_mode_i,input [11:0] baudrateDivisor_i,
								output reg receive_data_o,ss_o,output tip_o);
						    
							wire [15:0] target;
							reg [15:0] count;
							reg rcv;
							assign tip_o=~ss_o;
							
							assign target=(16*(baudrateDivisor_i/2));
							//receive data 
							always@(posedge pclk or negedge preset_n)
							 begin
							  if(!preset_n)
							   receive_data_o<=1'b0;
							  else
							   receive_data_o<=rcv;
							 end 
							
							//rcv 
							
							always@(posedge pclk or negedge preset_n)
							 begin
							  if(!preset_n)
  							   begin
							   rcv<=1'b0;
							   ss_o<=1'b1;
							   count<=16'hffff;
							   end
							  else
							   begin
							    if(!spiswai_i && mstr_i && (spi_mode_i==2'b00 || spi_mode_i==2'b01) )
								 begin
								  if(send_data_i)
								   begin
								    ss_o<=1'b0;
								    count<=16'b0;
								    rcv<=1'b0;
								   end
								  else if(count<=target-1)
								   begin
								    ss_o<=1'b0;
								    count<=count+1'b1;
								    rcv<=0;
								   end
								  else
								   begin
                                    count <= 16'hffff;
                                    ss_o  <= 1'b1;
                                    rcv   <= 1'b1;
								   end
								 end
								else
								 begin
								  rcv<=1'b0;
								  ss_o<=1'b1;
								  count<=16'hffff;
								 end
							   end
							 end
endmodule 
							 
							
							
