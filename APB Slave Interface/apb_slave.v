module apb_slave_interface(input pclk,preset_n,pwrite_i,psel_i,penable_i,ss_i,receive_data_i,tip_i,input [2:0] paddr_i,
                 input [7:0] pwdata_i,miso_data_i,output mstr_o,cpol_o,cpha_o,lsbfe_o,spiswai_o,pready_o,pslverr_o,output reg spi_interrupt_request_o,output reg send_data_o,
				  output reg [7:0] prdata_o,output [2:0] sppr_o,spr_o,output reg [1:0] spi_mode_o,output reg [7:0] mosi_data_o);
				  
				reg [7:0] spi_br,spi_cr1,spi_cr2,spi_sr,spi_dr;
				 
				
				wire sptef,spif,spe,modfen,modf,ssoe,wr_enb,rd_enb,spie,sptie;
				
				parameter cr2_mask=8'b0001_1011,br_mask=8'b0111_0111,spi_run=2'b00,spi_wait=2'b01,
				           spi_stop=2'b10;
				
				reg [1:0] next_mode; 
				reg [1:0] state,next_state;
				
				parameter IDLE=2'b00,SETUP=2'b01,ENABLE=2'b10;
				
				assign sptef=(spi_dr==8'd0)?1'b1:1'b0;
				
				assign spif=(spi_dr!=8'd0)?1'b1:1'b0;
				
				//	APB Slave modes fsm
				always@(posedge pclk or negedge preset_n)
				 begin
				  if(!preset_n)
				   spi_mode_o<=spi_run;
				  else
				   spi_mode_o<=next_mode;
				 end
				always@(*)
				 begin
				  case(state)
				   spi_run:if(!spe)
				            next_mode=spi_wait;
						   else
						    next_mode=spi_run;
				   spi_wait:if(spe)
							 next_mode=spi_run;
							else if(spiswai_o)
							 next_mode=spi_stop;
							else
							 next_mode=spi_run;
					
				   spi_stop:if(!spiswai_o)
							 next_mode=spi_wait;
							else 
							 next_mode=spi_run;
				   default:next_mode=spi_run;
				  endcase
				 end
				 
				//APB protocol fsm
				always@(posedge pclk or negedge preset_n)
				 begin
				  if(!preset_n)
				   state<=IDLE;
				  else
				   state<=next_state;
				   
				 end
				
			    always@(*)
				 begin
				  case(state)
				   IDLE:if(psel_i && !penable_i)
				         next_state=SETUP;
						else
						 next_state=IDLE;
				   SETUP:if(psel_i && !penable_i)
						  next_state=SETUP;
						 else if(psel_i && penable_i)
						  next_state=ENABLE;
						 else
						  next_state=IDLE;
				   ENABLE:if(psel_i)
							next_state=SETUP;
						  else
						    next_state=IDLE;
				   default:next_state=IDLE;
				  endcase
				 end
				 
				
				assign mstr_o=spi_cr1[4];
				assign cpol_o=spi_cr1[3];
				assign cpha_o=spi_cr1[2];
				assign ssoe=spi_cr1[1];
				assign lsbfe_o=spi_cr1[0];
                assign spie=spi_cr1[7];
				assign spe=spi_cr1[6];
				assign sptie=spi_cr1[5];
				assign modfen=spi_cr2[4];
				assign spiswai_o=spi_cr2[1];
				assign sppr_o=spi_br[6:4];
				assign spr_o=spi_br[2:0];
				
				
				assign modf=(!ss_i && mstr_o && modfen && !ssoe)?1'b1:1'b0;
				
				
				assign pready_o=(state==ENABLE)?1'b1:1'b0;
				
				assign wr_enb=(pwrite_i && (state==ENABLE))//?1'b1:1'b0;
				
				assign rd_enb=(!pwrite_i&&(state==ENABLE))//?1'b1:1'b0;
				
				assign pslverr_o=(state==ENABLE)?~tip_i:1'b0;  
				
				
				//spi_cr1 register 
				
				always@(posedge pclk or negedge preset_n) 
				 begin
			      if(!preset_n)
				   spi_cr1<=8'h04;// 0000100
			      else if(wr_enb)
				   begin
					if(paddr_i==3'b000)
						spi_cr1<=pwdata_i;
					else
						spi_cr1<=spi_cr1;
				   end
		         end
				
				//spi_cr2 regiter
				
				always@(posedge pclk or negedge preset_n) 
				 begin
			      if(!preset_n)
				   spi_cr2<=8'b0;
			      else if(wr_enb)
				   begin
					if(paddr_i==3'b001)
						spi_cr2<=(pwdata_i & cr2_mask);
					else
						spi_cr2<=spi_cr2;
				   end
		         end
				  
				// br register
				always@(posedge pclk or negedge preset_n) // spi_br
		         begin
			      if(!preset_n)
				   spi_br<=8'h00;
			      else if(wr_enb)
				    begin
					 if(paddr_i==3'b010)
						spi_br<=(pwdata_i&br_mask);
					 else
						spi_br<=spi_br;
				    end
		         end
				 
				//spi_sr register 
				
				always@(*)
		         begin
			      if(!preset_n)
				    spi_sr=8'b00100000;
			      else
				    spi_sr=({spif,1'b0,sptef,modf,4'b0});
		         end
				 
				 
				//spi data register -spi_dr
				
				always@(posedge pclk or negedge preset_n)
				 begin
				  if(!preset_n)
				   spi_dr<=8'h0;
				  else
				   begin
				    if(wr_enb)
					 begin
					  if(paddr_i==3'b101)
					   spi_dr<=pwdata_i;
					  else
					   spi_dr<=spi_dr;
					 end
					else
					 begin
					  if((spi_dr==pwdata_i)&&(spi_dr!=miso_data_i)&&(spi_mode_o==2'b00 || spi_mode_o==2'b01))
					   spi_dr<=8'h0;
					  else
					   begin
					    if(receive_data_i &&(spi_mode_o==2'b00 || spi_mode_o==2'b01))
						 spi_dr<=miso_data_i;
						else
						 spi_dr<=spi_dr;
					   end
					 end
				   end
				 end
				
				//prdata_o
				always@(*)
				 begin
				  if(!rd_enb)
				   prdata_o=8'b0;
				  else
				  begin
				  case(paddr_i)
				   3'd0:prdata_o=spi_cr1;
				   3'd1:prdata_o=spi_cr2;
				   3'd2:prdata_o=spi_br;
				   3'd3:prdata_o=spi_sr;
				   3'd5:prdata_o=spi_dr;
				   default:prdata_o=0;
				  endcase
				  end
				   
				 end
				
				//spi interrupt request
				always@(*)
				 begin
				  case({spie,sptie})
				   2'b00:spi_interrupt_request_o=1'b0;
				   2'b01:spi_interrupt_request_o=sptef;
				   2'b10:spi_interrupt_request_o=(spif || modf);
				   default:spi_interrupt_request_o=(spif || modf || sptef);
				  endcase
				 end
				 
				//send data logic
				
				always@(posedge pclk or negedge preset_n)
				 begin
				  if(!preset_n)
				   send_data_o<=1'b0;
				  else
				   begin
				  
			     	  if((spi_dr == pwdata_i) && (spi_dr != miso_data_i)&&((spi_mode_o==spi_run)||(spi_mode_o==spi_wait)))
					   send_data_o<=1'b1;
					  else
					   send_data_o<=1'b0;
					 
				   end
				 end
				
				//mosi_data  logic 
				
				always@(posedge pclk or negedge preset_n)
				 begin
				  if(!preset_n)
				   mosi_data_o<=8'b0;
				  else
				   begin
				    if((spi_dr == pwdata_i) && (spi_dr != miso_data_i)&&((spi_mode_o==spi_run)||(spi_mode_o==spi_wait)))
					 mosi_data_o<=spi_dr;
					else
					 mosi_data_o<=mosi_data_o;
				   end
				 end
				 
				 
endmodule
				
				   
				
				
				
				
				
