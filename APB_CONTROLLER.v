module apb_controller (input hclk,hresetn,hwrite_reg,hwrite,valid,
input [31:0]haddr,hwdata,hwdata1,hwdata2,haddr1,haddr2,pr_data, 
input [2:0] temp_selx, 
output reg penable, pwrite, 
output reg hr_readyout,
output reg [2:0] psel, 
output reg [31:0] paddr,pwdata);

parameter ST_IDLE=3'b000,
 ST_READ=3'b001,
 ST_RENABLE=3'b010,
 ST_WWAIT=3'b011,
 ST_WRITE=3'b100,
 ST_WRITEP=3'b101,
 ST_WENABLE=3'b110,
 ST_WENABLEP=3'b111;
reg [2:0] PS,NS;

always @(posedge hclk)
begin
 if (!hresetn)
 PS<=ST_IDLE;
 else
 PS<=NS;
end

always @(*)
begin
 NS=ST_IDLE;
 case(PS)
 ST_IDLE : 
 if(valid==1&&hwrite==1)
 NS=ST_WWAIT;
 else if(valid==1&&hwrite==0)
 NS=ST_READ;
 else if(valid==0)
 NS=ST_IDLE;
 ST_READ: NS=ST_RENABLE;
 ST_RENABLE: 
 if(valid==1&&hwrite==1)
 NS=ST_WWAIT;
 else if(valid==1&&hwrite==0)
 NS=ST_READ;
 else if(valid==0)
 NS=ST_IDLE;
 ST_WWAIT: 
 if (valid==1)
 NS=ST_WRITEP;
 else if(valid==0)
 NS=ST_WRITE;
 ST_WRITE:
 if (valid==1)
 NS=ST_WENABLEP;
 else if(valid==0)
 NS=ST_WENABLE;
 ST_WRITEP: NS=ST_WENABLEP;
 
 ST_WENABLEP:
 if (valid==1&&hwrite_reg==1)
 NS=ST_WRITEP;
 else if (valid==0&&hwrite_reg==1)
 NS=ST_WRITE;
 else if(hwrite_reg==0)
 NS=ST_READ;
 ST_WENABLE:
 if (valid==1 && hwrite==1)
 NS=ST_WWAIT;
 else if (valid==1 && hwrite==0)
 NS=ST_READ;
 else
 NS=ST_IDLE;
 endcase
end
reg penable_temp,pwrite_temp,hr_readyout_temp;
reg [2:0] psel_temp;
reg [31:0] paddr_temp,pwdata_temp;
always @(*)
begin
case(PS)

ST_IDLE: begin
 if(valid==1&&hwrite==0)
 begin
 paddr_temp=haddr;
 pwrite_temp=hwrite;
 psel_temp=temp_selx;
 penable_temp=0;
 hr_readyout_temp=0;
 end
 else if(valid==1&&hwrite==1)
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
 end

ST_READ: begin
 penable_temp=1;
 hr_readyout_temp=1;
 end

ST_RENABLE: begin
 if(valid==1&&hwrite==0)
 begin
 paddr_temp=haddr;
 pwrite_temp=hwrite;
 psel_temp=temp_selx;
 penable_temp=0;
 hr_readyout_temp=0;
 end
 else if(valid==1&&hwrite==1)
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
 end

ST_WWAIT: begin
 paddr_temp=haddr1;
 pwdata_temp=hwdata;
 pwrite_temp=hwrite;
 psel_temp=temp_selx;
 penable_temp=0;
 hr_readyout_temp=0;
 end

ST_WRITE:begin
 penable_temp=1;
 hr_readyout_temp=1; 
 end

ST_WRITEP:
 begin
 penable_temp=1;
 hr_readyout_temp=1; 
 end

ST_WENABLE:
 begin
 hr_readyout_temp=1; 
 penable_temp=0;
 psel_temp=0;
 end

ST_WENABLEP:
 begin
 paddr_temp=haddr2;
 hr_readyout_temp=0; 
 pwdata_temp=hwdata; 
 penable_temp=1; 
 end
 endcase
end

always @(posedge hclk)
begin
 if(!hresetn)
 begin
 paddr<=0;
 pwdata<=0;
 pwrite<=0;
 psel<=0;
 penable<=0;
 hr_readyout<=1;
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
