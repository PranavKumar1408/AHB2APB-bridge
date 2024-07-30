//------------------------------------------------------------------------------------------
// Title         : AHB2APB Bridge
// File          : bridge_fsm.sv
// Description   : Finite State Machine for the Bridge Module.
//------------------------------------------------------------------------------------------
`timescale 1ns/1ns
module bridge_fsm(input hclk,hresetn,hwrite_reg,hwrite,valid, input[31:0] haddr,hwdata,haddr1,haddr2,pr_data,input [2:0] temp_sel, output reg penable,pwrite,output reg hr_readyout, output reg[2:0]psel, output reg[31:0]paddr,pwdata);
  
  reg penable_temp,pwrite_temp,hr_readyout_temp;
  reg [2:0] psel_temp;
  reg [31:0] paddr_temp,pwdata_temp;
  
  parameter  ST_IDLE=3'b000,ST_READ=3'b001,ST_WWAIT=3'b010,ST_WRITE=3'b011,ST_WRITEP=3'b100,ST_RENABLE=3'b101,ST_WENABLE=3'b110,
  ST_WENABLEP=3'b111;
  
  reg[2:0] present_state,next_state;
  //next state logic
  always@(*)
    begin
      case(present_state)
        ST_IDLE:
          begin
            if(~valid)
              next_state=ST_IDLE;
            else if(hwrite==1 && valid==1)
              next_state=ST_WWAIT;
            else if(hwrite==0 && valid==1)
              next_state=ST_READ;
          end
        ST_READ:
          begin
            next_state=ST_RENABLE;
          end
        ST_WWAIT:
          begin
            if(~valid)
              next_state=ST_WRITE;
            else
              next_state=ST_WRITEP;
          end
        ST_WRITE:
          begin
            if(~valid)
              next_state=ST_WENABLE;
            else
              next_state=ST_WENABLEP;
          end
        ST_WRITEP:
          begin
            next_state=ST_WENABLEP;
          end
        ST_RENABLE:
          begin
            if(~valid)
              next_state=ST_IDLE;
            else if(valid==1 && hwrite==0)
              next_state=ST_READ;
            else
              next_state=ST_WWAIT;
          end
        ST_WENABLE:
          begin
            if(~valid)
              next_state=ST_IDLE;
            else if(hwrite==1)
              next_state=ST_WWAIT;
            else
              next_state=ST_READ;
          end
        ST_WENABLEP:
          begin
            if(~hwrite_reg)
              next_state=ST_READ;
            else if(~valid)
              next_state=ST_WRITE;
            else
              next_state=ST_WRITEP;
          end
      endcase
    end
  
  always@(posedge hclk)
    begin
      if(~hresetn)
        begin
        present_state=ST_IDLE;
        next_state=ST_IDLE;
        end
      else 
        present_state=next_state;
    end
  //output logic
  always@(*)
	begin
  	case(present_state)
ST_IDLE: if(valid==1 && hwrite==0) 
                begin
                 paddr_temp=haddr;
                 pwrite_temp=hwrite;
                 psel_temp=temp_sel;
                 penable_temp=0;
                 hr_readyout_temp=0;
                end
                else if(valid==1 && hwrite==1)
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end
                else
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end
ST_READ: begin
                 penable_temp=1;
                 hr_readyout_temp=1;
                 end

ST_RENABLE:if(valid==1 && hwrite==0) 
                begin
                 paddr_temp=haddr;
                 pwrite_temp=hwrite;
                 psel_temp=temp_sel;
                 penable_temp=0;
                 hr_readyout_temp=0;
                end
                else if(valid==1 && hwrite==1)
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end
                else
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end


ST_WWAIT:begin
                   paddr_temp=haddr1; //1 cycle delay of haddr
                   pwdata_temp=hwdata;
                   pwrite_temp=hwrite;
                   psel_temp=temp_sel;
                   penable_temp=0;
                   hr_readyout_temp=0;
                   end
            
ST_WRITEP: begin
                       hr_readyout_temp=1;
                       penable_temp=1;
                       end

ST_WENABLEP: begin
             paddr_temp=haddr2; 
             pwdata_temp=hwdata;
             pwrite_temp=hwrite;
             psel_temp=temp_sel;
             penable_temp=0;
             hr_readyout_temp=0;
             end
             
ST_WENABLE:     if(valid==1 && hwrite==0) 
                begin
                 paddr_temp=haddr;
                 pwrite_temp=hwrite;
                 psel_temp=temp_sel;
                 penable_temp=0;
                 hr_readyout_temp=0;
                end
                else if(valid==1 && hwrite==1)
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end
                else
                begin
                 psel_temp=0;
                 penable_temp=0;
                 hr_readyout_temp=1;
                end

                       
                    
ST_WRITE: begin
                 penable_temp=1;
                 hr_readyout_temp=1;
                end

endcase
end

//temporary values are passed to actual signals if there is no reset

always@(posedge hclk)
begin
  if(~hresetn)
begin
paddr<=0;
pwdata<=0;
pwrite<=0;
psel<=0;
penable<=0;
hr_readyout=1;
end

else
begin
paddr<=paddr_temp;
pwdata<=pwdata_temp;
pwrite<=pwrite_temp;
psel<=psel_temp;
penable<=penable_temp;
hr_readyout<=hr_readyout_temp;
end
end
  
endmodule
  
              
            
            
        
              
  