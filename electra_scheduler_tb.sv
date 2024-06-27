// Code your testbench here
// or browse Examples
module finer_granular_tb();

    parameter word_size = 16;
    parameter address_size = 12;
  	logic [2:0] len_bitmap_buffer_A;
  	logic [2:0] len_bitmap_buffer_B;
    logic [1:0]NumberOfRows_A;
  	logic [2:0]NumberOfRows_B;
    logic [address_size-1:0]nonzerobuffer_input_A;
    logic [address_size-1:0]nonzerobuffer_input_B;
  	logic [1:0]bitmap_addressA_register[2:0];
  	logic [1:0]bitmap_addressB_register[3:0];
    logic [word_size-1:0]data_out_port1;
    logic [word_size-1:0]data_out_port2;
  	logic [word_size-1:0]data_out_port3;
  	logic [word_size-1:0]data_out_port4;
    
    logic clk;


    Clock_Unit M1 (clk);
  overhead M2 (len_bitmap_buffer_A, len_bitmap_buffer_B, NumberOfRows_A, NumberOfRows_B,nonzerobuffer_input_A,nonzerobuffer_input_B,bitmap_addressA_register,bitmap_addressB_register,clk,data_out_port1,data_out_port2,data_out_port3,data_out_port4);

  wire[word_size-1:0] word0,word1,word2,word3, word4, word5, word6, word7, word8,word9, word10, word11, word12, word13, word14, word15, word16,word17, word18;
    wire[word_size-1:0] word128,word129,word130,word131,word132,word133,word134,word135,word136,word137,word138,word139,word140,word255;


    assign word0 = M2.n1.memory1[0][0];
    assign word1 = M2.n1.memory1[0][1];
    assign word2 = M2.n1.memory1[1][0];
    assign word3 = M2.n1.memory1[1][1];
    assign word4 = M2.n1.memory1[2][0];
    assign word5 = M2.n1.memory1[2][1];
    assign word6 = M2.n1.memory2[0][0];
    assign word7 = M2.n1.memory2[0][1];
    assign word8 = M2.n1.memory2[1][0];
    assign word9 = M2.n1.memory2[1][1];
    assign word10 = M2.n1.memory2[2][0];
    assign word11 = M2.n1.memory2[2][1];
    assign word12 = M2.n1.memory2[3][0];
    assign word13 = M2.n1.memory2[3][1];
    

    initial #2000 $finish;

    //flush memory
    initial begin: flushing
	 
      for (int k=0; k<=255; k=k+1) begin 
        for (int j=0; j<=255; j=j+1) begin
          M2.n1.memory1[k][j] = 0;
          M2.n1.memory2[k][j] = 0;
        end
    end
      
    end

    initial begin: Load_program
     
    len_bitmap_buffer_A = 3'd3;
    len_bitmap_buffer_B = 3'd4;
    NumberOfRows_A = 2'd3;
    NumberOfRows_B = 3'd4;
    nonzerobuffer_input_A = 2'd0;
    nonzerobuffer_input_B = 2'd0;
    bitmap_addressA_register = '{'{1,1},'{1,1},'{0,1}};
    bitmap_addressB_register = '{'{0,0},'{1,0},'{0,1},'{1,1}};
    M2.n1.memory1[0] = 16'd4;
    M2.n1.memory1[0] = 16'd7;
    M2.n1.memory2[0] = 16'd1;
    M2.n1.memory2[1] = 16'd5;
    M2.n1.memory2[2] = 16'd8;
    M2.n1.memory3[0] = 16'd2;
    M2.n1.memory3[1] = 16'd12;
    M2.n1.memory4[0] = 16'd3;
    M2.n1.memory4[1] = 16'd2;
    

    end


    initial begin
        $dumpfile("finer_granular.vcd");
        $dumpvars(0);
    end
   	initial begin
  		$display("Contents of bitmap_addressA_register:");
    	foreach (bitmap_addressA_register[i]) begin
      	$display("[%0d]: %b", i, bitmap_addressA_register[i]);
        end
        $display("Contents of bitmap_addressB_register:");
    	foreach (bitmap_addressB_register[i]) begin
      	$display("[%0d]: %b", i, bitmap_addressB_register[i]);
    	end
    end

endmodule

module Clock_Unit (output reg clock);
    parameter delay = 0;
    parameter half_cycle = 10;
    initial begin #delay clock = 0; forever #half_cycle clock = ~clock; 
    end
endmodule
