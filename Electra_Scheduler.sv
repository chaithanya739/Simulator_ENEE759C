// Code your design here
// Code your design here
// Code your design here // define count_A0, count_A1 in the module I guess also count_B 
module overhead (len_bitmap_buffer_A,len_bitmap_buffer_B,NumberOfRows_A, NumberOfRows_B,nonzerobuffer_input_A,nonzerobuffer_input_B,bitmap_addressA_register,bitmap_addressB_register,clk,data_out_port1,data_out_port2,data_out_port3,data_out_port4);
    parameter address_size = 12;
    parameter word_size = 16;
    input logic [2:0] len_bitmap_buffer_A;
    input logic [2:0] len_bitmap_buffer_B;
    input logic [address_size-1:0] nonzerobuffer_input_A;
    input logic [address_size-1:0] nonzerobuffer_input_B;
  	input logic  [1:0]bitmap_addressA_register[2:0];
  	input logic  [1:0]bitmap_addressB_register[3:0];
    input logic clk;
    input logic [1:0] NumberOfRows_A;
  	input logic [2:0] NumberOfRows_B;
    output logic [word_size-1:0] data_out_port1;
    output logic [word_size-1:0] data_out_port2;
  	output logic [word_size-1:0] data_out_port3;
  	output logic [word_size-1:0] data_out_port4;
    logic [address_size-1:0] nonzerobuffer_output_B_addresscount0; // this is the address_count0 which has to go to the cache memory0 for getting the values of B vector
    logic [address_size-1:0] nonzerobuffer_output_B_addresscount1; // this is the address_count1 which has to go to the cache memory1 for getting the values of B vector
    logic [address_size-1:0] nonzerobuffer_output_A_addresscount0; // this is the address_count0 which has to go to the cache memory0 for getting the values of A vector
    logic [address_size-1:0] nonzerobuffer_output_A_addresscount1; // this is the address_count1 which has to go to the cache memory1 for getting the values of A vector

  	logic  [1:0]a[2:0] = '{default:0}; 
  	logic  [1:0]b[3:0] = '{default:0};
  	logic  [3:0] i = '{default:0};
  	logic  [3:0] j = '{default:0};
  	logic  [1:0]count = '{default:0};
  	logic [1:0]bitmap_addressA_register_temp[2:0];
  	logic [1:0]bitmap_addressB_register_temp[3:0];
  	assign bitmap_addressA_register_temp = bitmap_addressA_register;
    assign bitmap_addressB_register_temp = bitmap_addressB_register;
  	
  	initial begin
      foreach (a[k]) begin
        $display("Contents of a:");
        $display ("[%0d]: %b",k,a[k]);
      end
      foreach (b[k]) begin
        $display("Contents of b:");
        $display ("[%0d]: %b",k,b[k]);
       end
    end
  	
	
  always @ (posedge clk) begin //seperate combinational and flip flop block increment in flip flop block and assign in comb block
    j <= j+1; //since j is non blocking 
  end
  
  always@(*) begin
    a[i][0] = bitmap_addressA_register_temp[i][0];
    a[i][1] = bitmap_addressA_register_temp[i][1];
    b[j][0] = bitmap_addressB_register_temp[j][0];
    b[j][1] = bitmap_addressB_register_temp[j][1];
  end
  
  always@(*) begin
      count = a[i] & b[j];
    $monitor("[$monitor] time=%0t count=%0b a[i] =%0b b[j] = %0b",$time,count,a[i],b[j]); 
  end
  
  always @(*) begin
    if (j == 4) begin
      i <= i+1;
      j <= 0;
    end
  end
    
  scheduler s1 (count,clk,nonzerobuffer_input_B,nonzerobuffer_input_A,nonzerobuffer_output_B_addresscount0,nonzerobuffer_output_B_addresscount1,nonzerobuffer_output_A_addresscount0,nonzerobuffer_output_A_addresscount1,NumberOfRows_B,NumberOfRows_A);
  nonzerodata n1 (data_out_port1,data_out_port2,data_out_port3,data_out_port4,16'd0,16'd0,16'd0,16'd0,nonzerobuffer_output_B_addresscount0,nonzerobuffer_output_B_addresscount1,nonzerobuffer_output_A_addresscount0,nonzerobuffer_output_A_addresscount1,clk,1'b0);
endmodule            


//Now once they reach the required limit assign them zero.
module scheduler(count,clk,nonzerobuffer_input_B,nonzerobuffer_input_A,nonzerobuffer_output_B_addresscount0,nonzerobuffer_output_B_addresscount1,nonzerobuffer_output_A_addresscount0,nonzerobuffer_output_A_addresscount1,NumberOfRows_B,NumberOfRows_A);
    parameter address_size = 12;
  	parameter word_size = 16;
    parameter NumberOfANDs = 2;
    parameter NumberofMuls = 4;
  	input logic clk;
  	input logic [1:0]count;
  	input logic [2:0] NumberOfRows_B;
    input logic [1:0] NumberOfRows_A;
    input logic [address_size-1:0] nonzerobuffer_input_A; // this is the address which has to come from test bench
    input logic [address_size-1:0] nonzerobuffer_input_B; // this is the address which has to come from test bench
    output logic [address_size-1:0] nonzerobuffer_output_B_addresscount0; // this is the address_count0 which has to go to the cache memory0 for getting the values of B vector
    output logic [address_size-1:0] nonzerobuffer_output_B_addresscount1; // this is the address_count1 which has to go to the cache memory1 for getting the values of B vector
    output logic [address_size-1:0] nonzerobuffer_output_A_addresscount0; // this is the address_count0 which has to go to the cache memory0 for getting the values of A vector
    output logic [address_size-1:0] nonzerobuffer_output_A_addresscount1; // this is the address_count1 which has to go to the cache memory1 for getting the values of A vector
  	logic [address_size-1:0] nonzerobuffer_output_B_addresscount0_temp = '{default:0}; // we will temperaory store the values and later during sending the output we will assign it to the required ports 0or1 based on AND gates.
  	logic [address_size-1:0] nonzerobuffer_output_B_addresscount1_temp = '{default:0};
  	logic [address_size-1:0] nonzerobuffer_output_A_addresscount0_temp = '{default:0};
  	logic [address_size-1:0] nonzerobuffer_output_A_addresscount1_temp = '{default:0};
  	logic s0=0;
  	logic s1=0;
  	logic [1:0]s2=2'b00;
  	integer count_B = 0;
  	integer count_A0 = 0;
  	integer count_A1 = 0;
    assign nonzerobuffer_input_B_temp = nonzerobuffer_input_B;
    assign nonzerobuffer_input_A_temp = nonzerobuffer_input_A;
  	logic [1:0] count0;
  	logic [1:0] count1;
  	logic [1:0] count2;
  	logic [1:0] count3;
  	logic [1:0] count4;
  	logic [1:0] count5;
  	logic [1:0] count6;
  	logic [1:0] count7;
  	logic [1:0] count0bar;
  	logic [1:0] count1bar;
  	logic [1:0] count2bar;
  	logic [1:0] count3bar;
  	logic [1:0] count4bar;
  	logic [1:0] count5bar;
  	logic [1:0] count6bar;
  	logic [1:0] count7bar;
  	logic rst0=0,rst1=0,rst2=0,rst3=0,rst4=0,rst5=0,rst6=0,rst7=0,rst8=0,rst9=0;
  	logic q0,q1;
  	logic q0bar,q1bar;
  
  	Mod2upcounter m0 (count0,count0bar,clk,rst0);  
  	Mod2upcounter m1 (count1,count1bar,clk,rst1);
  	Mod2upcounter m2 (count2,count2bar,clk,rst2);
  	Mod2upcounter m3 (count3,count3bar,clk,rst3);
  	Mod2upcounter m4 (count4,count4bar,clk,rst4);
  	Mod2upcounter m5 (count5,count5bar,clk,rst5);
  	Mod2upcounter m6 (count6,count6bar,clk,rst6);
  	Mod2upcounter m7 (count7,count7bar,clk,rst7);

  tff tf0 (q0,q0bar,clk,rst8,q0bar);
  tff tf1 (q1,q1bar,clk,rst9,q1bar);
  
  always @ (posedge clk) begin
    if(count0 == 2'b11) begin
      	rst0=0;
      	
    end
    if(count1 == 2'b11) begin
      	rst1=0;
      	
    end
    if(count2 == 2'b11) begin
      	rst2=0;
      	
    end
    if(count3 == 2'b11) begin
      	rst3=0;
    end
    if(count4 == 2'b11) begin
      	rst4=0;
      	
      if (q0 == 0 && s0 == 0) begin
        rst8=1;
        s0 = 1;
      end
      else if(q1 == 0 && s0 == 0) begin
        rst9=1;
        
        s0=1;
      end
        s0=0;
    end
    
    if(count5 == 2'b11) begin
      	rst5=0;
      if (q0 == 0 && s0 == 0) begin
        rst8=1;
        s0 = 1;
      end
      else if(q1 == 0 && s0 == 0) begin
        rst9=1;
        s0=1;
      end
        s0=0;
    end
    
    if(count6 == 2'b11) begin
      	rst6=0;
      	
      if (q0 == 0 && s0 == 0) begin
        rst8=1;
        s0 = 1;
      end
      else if(q1 == 0 && s0 == 0) begin
        rst9=1;
        s0=1;
      end
        s0=0;
    end
    if(count7 == 2'b11) begin
      	rst7=0;
      	
      if (q0 == 0 && s0 == 0) begin
        rst8=1;
        s0 = 1;
      end
      else if(q1 == 0 && s0 == 0) begin
        rst9=1;
        s0=1;
      end
        s0=0;
    end
    if(q0 == 1) begin
      	rst8=0;
      	
    end
    if(q1 == 1) begin
      	rst9=0;
    end

    if (count == 2'b01) begin
      if (count0 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst0 = 1;
      	  s1 = 1;
        end
      else if(count1 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst1 = 1;
      	  s1 = 1;
        end
      else if(count2 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst2 = 1;
      	  s1 = 1;
        end
      else if(count3 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst3 = 1;
      	  s1 = 1;
        end
      s1=0;
    end
    else if (count == 2'b10) begin
      if (count0 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst0 = 1;
      	  s1 = 1;
        end
      else if(count1 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst1 = 1;
      	  s1 = 1;
        end
      else if(count2 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst2 = 1; 
      	  s1 = 1;
        end
      else if(count3 == 2'b00 && s1 == 0) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
      	  count_B = count_B + 1;
      	  count_A1 = count_A1 + 1;
      	  rst3 = 1;
      	  s1 = 1;
        end
	  s1=0;
    end
    else if (count == 2'b11) begin
        count_B = count_B + 1;
      	count_A0 = count_A0+1;
      	count_A1 = count_A1+1;
      if (count0 == 2'b00 && count4 == 2'b00 && (s2 == 2'b00 || s2 == 2'b01)) begin
        rst0 = 1;
        rst4 = 1;
        if (s2 == 2'b00) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        end
        else if(s2==2'b01) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
        end
        s2 = s2 + 2'b01;
      end
      if (count1 == 2'b00 && count5 == 2'b00 && (s2 == 2'b00 || s2 == 2'b01)) begin
        nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        rst1 = 1;
        rst5 = 1;
        if (s2 == 2'b00) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        end
        else if(s2==2'b01) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
        end
        s2 = s2 + 2'b01;
      end
      if (count2 == 2'b00 && count6 == 2'b00 && (s2 == 2'b00 || s2 == 2'b01)) begin
        nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        rst2 = 1;
        rst6 = 1;
        if (s2 == 2'b00) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        end
        else if(s2==2'b01) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
        end
        s2 = s2 + 2'b01;
      end
      if (count3 == 2'b00 && count7 == 2'b00 && (s2 == 2'b00 || s2 == 2'b01)) begin
        nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        rst3 = 1;
        rst7 = 1;
        if (s2 == 2'b00) begin
          nonzerobuffer_output_B_addresscount0_temp = nonzerobuffer_output_B_addresscount0_temp + 1;
        end
        else if(s2==2'b01) begin
          nonzerobuffer_output_B_addresscount1_temp = nonzerobuffer_output_B_addresscount1_temp + 1;
        end
        s2 = s2 + 2'b01;
      end 
     s2 = 2'b00;
   end
   if (count == 2'b00) begin
      count_B = count_B + 1;
    end

    if (count_B == NumberOfRows_B)  begin
      count_B = 0;
      nonzerobuffer_output_B_addresscount0_temp = 0;
      nonzerobuffer_output_B_addresscount1_temp = 0;
      if (count_A0 != 0) begin
      	nonzerobuffer_output_A_addresscount0_temp = nonzerobuffer_output_A_addresscount0_temp+1;
      end
      else if (count_A0 == 0) begin
        nonzerobuffer_output_A_addresscount0_temp = nonzerobuffer_output_A_addresscount0_temp;
      end
      if (count_A1 != 0) begin
        nonzerobuffer_output_A_addresscount1_temp = nonzerobuffer_output_A_addresscount1_temp+1;
      end
      else if (count_A1 == 0) begin
        nonzerobuffer_output_A_addresscount1_temp = nonzerobuffer_output_A_addresscount1_temp;
      end      
    end
  end
    
  always @(posedge clk) begin
    nonzerobuffer_output_B_addresscount0 <= nonzerobuffer_output_B_addresscount0_temp;
  	nonzerobuffer_output_B_addresscount1 <= nonzerobuffer_output_B_addresscount1_temp;
  	nonzerobuffer_output_A_addresscount0 <= nonzerobuffer_output_A_addresscount0_temp;
  	nonzerobuffer_output_A_addresscount1 <= nonzerobuffer_output_A_addresscount1_temp;
  end
    
endmodule


module nonzerodata (data_out_port1,data_out_port2,data_out_port3,data_out_port4,data_in_port1,data_in_port2,data_in_port3,data_in_port4,nonzerobuffer_output_B_addresscount0,nonzerobuffer_output_B_addresscount1,nonzerobuffer_output_A_addresscount0,nonzerobuffer_output_A_addresscount1,clk,write);
        parameter address_size = 12;
        parameter memory_size = 256;
        parameter word_size = 16;

        output logic [word_size-1:0] data_out_port1;
        output logic [word_size-1:0] data_out_port2;
  		output logic [word_size-1:0] data_out_port3;
  		output logic [word_size-1:0] data_out_port4;
  		input logic [word_size-1:0] data_in_port1;
  		input logic [word_size-1:0] data_in_port2;
  		input logic [word_size-1:0] data_in_port3;
  		input logic [word_size-1:0] data_in_port4;
        input logic [address_size-1:0] nonzerobuffer_output_B_addresscount0;
        input logic [address_size-1:0] nonzerobuffer_output_B_addresscount1;
        input logic [address_size-1:0] nonzerobuffer_output_A_addresscount0;
        input logic [address_size-1:0] nonzerobuffer_output_A_addresscount1;
        input logic clk,write;

  		logic [word_size-1:0] memory1[address_size-1:0];
  		logic [word_size-1:0] memory2[address_size-1:0];
  		logic [word_size-1:0] memory3[address_size-1:0];
  		logic [word_size-1:0] memory4[address_size-1:0];
  
  		assign data_out_port1 = memory1[nonzerobuffer_output_B_addresscount0];
  		assign data_out_port2 = memory2[nonzerobuffer_output_B_addresscount1];
  		assign data_out_port3 = memory3[nonzerobuffer_output_A_addresscount0];
  		assign data_out_port4 = memory4[nonzerobuffer_output_A_addresscount1];
  

  		always @(posedge clk) begin
          if(write) begin 
            memory1[nonzerobuffer_output_B_addresscount0] <= data_in_port1;
          end
  		end
  		always @(posedge clk) begin
          if(write) begin 
            memory2[nonzerobuffer_output_B_addresscount1] <= data_in_port2;
          end
        end
        always @(posedge clk) begin
          if(write) begin 
            memory3[nonzerobuffer_output_A_addresscount0] <= data_in_port3;
          end
        end
        always @(posedge clk) begin
          if(write) begin 
            memory4[nonzerobuffer_output_A_addresscount1] <= data_in_port4;
          end
        end
endmodule

        
        
module Mod2upcounter(out,outbar,clk,rst);
  input clk, rst;
  output [1:0] out, outbar;
  
  tff td0(out[0],outbar[0],clk     ,rst,outbar[0]);
  tff td1(out[1],outbar[1],outbar[0],rst,outbar[1]);

  
endmodule

module tff(q,qbar,clk,rst,d);
	output reg q;
	output qbar;
	input clk, rst;
	input d;

	assign qbar = ~q;

  // NOTE it is important to mention the edge for each of the parameter
  // if it is not mentioned default is all edges i.e. positive and negative edges
  always @(posedge clk, negedge rst)
	begin
      	if (!rst)
			q <= 0;
		else
			q <= d;
	end
endmodule


