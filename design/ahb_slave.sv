//------------------------------------------------------------------------------------------
// Title         : AHB Slave
// File          : ahb_slave.sv
// Description   : Logic for valid bit, temporary select, and pipelining.
//------------------------------------------------------------------------------------------

`timescale 1ns/1ns
module ahb_slave(input hclk,hresetn,hwrite,hready_in,input [1:0] htrans,input [31:0] hwdata,haddr,prdata, output reg[31:0] haddr1,haddr2,output [31:0] hrdata,output reg hwrite_reg,valid,output[1:0] hresp, output reg[2:0] temp_selx);
  always@(*)
    begin
      if((haddr>=32'h8000_0000) && (haddr<=32'h8c00_0000) && (htrans==2'd2 || htrans==2'd3) && (hready_in==1))
        valid=1;
      else
        valid=0;
    end
  
  always@(*)
    begin
      if(haddr>=32'h8000_0000 && haddr<32'h8400_0000)
        temp_selx=3'b001;
      else if(haddr>=32'h8400_0000 && haddr<32'h8800_0000)
        temp_selx=3'b010;
      else if(haddr>=32'h8800_0000 && haddr<32'h8c00_0000)
        temp_selx=3'b100;
      else
        temp_selx=3'b000;
    end
  
  assign hrdata=prdata;
  assign hresp=0;
  
  //pipeline logic
  //haddr1, haddr2 are delayed versions of haddr, which are when wait states are inserted
  
  always@(posedge hclk)
    begin
      if(~hresetn)
        begin
          haddr1<=0;
          haddr2<=0;
        end
      else
        begin
          haddr1<=haddr;
          haddr2<=haddr1;
        end
    end
  
  always@(posedge hclk)
    begin
      if(~hresetn)        
          hwrite_reg<=0;        
      else
        hwrite_reg<=hwrite;
    end
endmodule
  
  
  
      
      
        
      