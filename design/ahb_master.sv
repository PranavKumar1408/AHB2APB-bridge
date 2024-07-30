//------------------------------------------------------------------------------------------
// Title         : AHB Master
// File          : ahb_master.sv
// Description   : Tasks for single read and write, and 4 beat burst
//                 increment read and  write.
//------------------------------------------------------------------------------------------

`timescale 1ns/1ns
module ahb_master(input hclk,hresetn,hreadyout,input[31:0] hrdata, output reg[31:0] haddr,hwdata,output reg hwrite,hready_in,output reg[1:0] htrans);
  reg[2:0] hburst, hsize;
  
  task single_write();
    @(posedge hclk)
    begin
      #1
    
      haddr=32'h 8000_0000;
      hwrite=1'b1;
      hready_in=1'b1;
      htrans=2'd2;
      hsize=0;//1 byte tranfers
      hburst=0;
    end
    
    @(posedge hclk)
    begin
      #1
      hwdata={$random}%256;
      htrans=0;
    end
  endtask
  
  task single_read();
    @(posedge hclk)
    begin
      #1
    
      haddr=32'h 8000_0000;
      hwrite=1'b0;
      hready_in=1'b1;
      htrans=2'd2;
      hsize=0;
      hburst=0;
    end
    
    @(posedge hclk)
    begin
      #1      
      htrans=0;
    end
  endtask
  
  
 task burst_4_incr_write(); 
begin
 @(posedge hclk)
 #1;
 begin
  hwrite=1;
  htrans=2'd2;
  hsize=0;
  hburst=0;
  hready_in=1;
  haddr=32'h8000_0000;
 end

 @(posedge hclk)
 #1;
 begin
  haddr=haddr+1'b1;
  hwdata={$random}%256;//0-255 {} gives +ve values
  htrans=2'd3;
 end
  
  
  
 @(posedge hclk)
 #1;
 begin
  haddr=haddr+1'b1; 
  hwdata={$random}%256;
  htrans=2'd3;
 end
  
  @(posedge hclk)//wait one cycle
  begin
  end

 @(posedge hclk)
 #1;
 begin
  haddr=haddr+1'b1; 
  hwdata={$random}%256;
  htrans=2'd3;
 end
  
  @(posedge hclk)//wait one cycle
  begin
  end

 @(posedge hclk)
 #1;
 begin
  hwdata={$random}%256;
  htrans=2'd0; //idle state 
 end
end
endtask
 
  
task burst_4_incr_read();
begin
 @(posedge hclk)
 #1;
 begin
  hwrite=0;
  htrans=2'd2;
  hsize=0;
  hburst=0;
  hready_in=1;
  haddr=32'h8000_0000;
 end
 
   @(posedge hclk)
   #1;
   begin
    haddr=haddr+1'b1;     
    htrans=2'd3;
   end
  
  @(posedge hclk)//wait one cycle
  begin
  end

   @(posedge hclk)
   #1;
   begin
    haddr=haddr+1'b1; 
    htrans=2'd3;
   end
  
 @(posedge hclk)//wait one cycle
  begin
  end

 @(posedge hclk)
 #1;
 begin
  haddr=haddr+1'b1; 
  htrans=2'd3; 
 end
  
  @(posedge hclk)//wait one cycle
  begin
  end
 
 @(posedge hclk)
  begin
  htrans=2'd0;//idle state
  end

end
endtask  
  
endmodule
    
  
    
    