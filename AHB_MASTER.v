module ahb_master (input hclk,hresetn, hreadyout, input [31:0] hrdata, input [1:0] hresp,
output reg [31:0] haddr, hwdata, output reg hwrite,hreadyin, output reg [1:0] htrans);

reg [2:0] hburst;
reg [2:0] hsize;

task single_write();

begin
@(posedge hclk);
#1; 
begin
hwrite=1;
htrans=2'b10;
hsize=0;
hburst=0;
hreadyin=1;
haddr=32'h8000_0001;
end


@(posedge hclk);
#1;
begin
htrans=2'b00;
hwdata=8'h80;
end
end
endtask

task single_read();

begin
@(posedge hclk);
#1;
begin
hwrite=0;
htrans=2'b10;
hsize=0;
hburst=0;
hreadyin=1;
haddr=32'h8000_0001;
end

@(posedge hclk);
#1;
begin
htrans=2'b00;
end
end

endtask

endmodule
