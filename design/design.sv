//------------------------------------------------------------------------------------------
// Title         : Top Module
// File          : design.sv
// Description   : All the modules are connected except AHB Master.
//------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------
//needed for edaplayground
`include "apb_slave.sv"
`include "ahb_slave.sv"
`include "bridge_fsm.sv"
//------------------------------------------------------------------------------------------

`timescale 1ns/1ns
module top(
  input hclk,hresetn,hwrite,hready_in,
  input[1:0] htrans,
  input[31:0] haddr,hwdata,
  output hreadyout,
  output[1:0] hresp,
  output[31:0] hrdata
);
  wire hwrite_reg,valid,penable,pwrite;
  wire[31:0] prdata,haddr1,haddr2,paddr,pwdata;  
  wire[2:0] temp_selx,psel;
  
  
  ahb_slave ahb_slave1(hclk,hresetn,hwrite,hready_in,htrans,hwdata,haddr,prdata,haddr1,haddr2,hrdata,hwrite_reg,valid,hresp,temp_selx);
  bridge_fsm bridge_fsm1(hclk,hresetn,hwrite_reg,hwrite,valid,haddr,hwdata,haddr1,haddr2,prdata,temp_selx,penable,pwrite,hreadyout,psel,paddr,pwdata);
  apb_slave apb_slave1(pwrite,penable,psel,pwdata,paddr,prdata);
endmodule
  