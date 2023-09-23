module fifo(rst_n,wr_clk,rd_clk,wr_en,rd_en,full_n,empty_n,data_in,data_out);

input logic        rst_n;
input logic        wr_clk;
input logic        rd_clk;
input logic        wr_en;
input logic        rd_en;
input logic [31:0] data_in;

output logic        full_n;
output logic        empty_n;
output logic [31:0] data_out;

logic [31:0] memory [7:0];
logic [2:0]  readposition; 
logic [2:0]  writeposition; 
integer      count;

assign count = (writeposition > readposition) ? writeposition - readposition : readposition - writeposition ;
assign full_n = (count==8) ? 1'b0 : 1'b1; 
assign empty_n = (count==0) ? 1'b0 : 1'b1; 

always_ff @(posedge wr_clk, negedge rst_n)
begin
    if (!rst_n) 
    begin
        readposition = 3'b0; 
        writeposition = 3'b0;

    end
    else if(wr_en)
    begin
        memory[writeposition] = data_in;
        writeposition = writeposition + 1'b1;
    end
    else if(~wr_en)
    begin
        memory[writeposition] = 32'b0;
    end

end

always_ff @(posedge rd_clk, negedge rst_n)
begin
    if (!rst_n) 
    begin
        readposition = 3'b0; 
        writeposition = 3'b0;

    end
    else if(rd_en)
    begin
        data_out = memory[readposition];
        readposition = readposition + 1'b1;

    end
    else if(~rd_en)
    begin
        data_out = 32'b0;
    end

end





endmodule