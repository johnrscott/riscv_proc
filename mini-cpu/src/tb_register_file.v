`timescale 1 ns/10 ps

module tb_register_file();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   wire [xlen-1:0] rs1_data, rs2_data;
   reg [4:0] rs1, rs2, rd;
   reg [xlen-1:0] rd_data;
   reg 		  write_en, clk, rstn;

   integer 	  n;
   
   register_file #(.xlen(xlen)) uut
     (.rs1_data(rs1_data), .rs2_data(rs2_data),
      .rs1(rs1), .rs2(rs2), 
      .rd(rd), .rd_data(rd_data),
      .write_en(write_en),
      .clk(clk), .rstn(rstn));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      rs1 = 0;
      rs2 = 0;
      rd = 0;
      rd_data = 0;
      write_en = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end
   
   initial begin

      // Wait for first clock edge
      #period
      
      // Check initial reset
      #period;
      for (n=0; n<32; n=n+1) begin	 
	 rs1 = n;
	 rs2 = n;
	 if (rs1_data !== 0)
	   $error("Expected all registers zero in first reset");
	 if (rs2_data !== 0)
	   $error("Expected all registers zero in first reset");
      end
      
      // Try to do a write in reset (should not write)
      rd = 5;
      rd_data = 10;
      write_en = 1;
      #period;
      for (n=0; n<32; n=n+1) begin	 
	 rs1 = n;
	 rs2 = n;
	 if (rs1_data !== 0)
	   $error("Expected write to fail while in reset");
	 if (rs2_data !== 0)
	   $error("Expected write to fail while in reset");
      end
      rd = 0;
      rd_data = 0;
      write_en = 0;
      
      // Lift reset, check all registers are zero
      rstn = 1;
      #period;
      for (n=0; n<32; n=n+1) begin	 
	 rs1 = n;
	 rs2 = n;
	 if (rs1_data !== 0)
	   $error("Expected registers initially zero out of reset");
	 if (rs2_data !== 0)
	   $error("Expected registers initially zero out of reset");
      end
      
      // Write a value and check read (note attempt to write 1 to x0)
      write_en = 1;
      for (n=0; n<32; n=n+1) begin	 
	 rd = n;
	 rd_data = n + 1;
	 #period;	 
      end
      write_en = 0;
      
      // Check values of x1-x31
      for (n=1; n<32; n=n+1) begin	 
	 rs1 = n;
	 rs2 = n;
	 if (rs1_data !== n+1)
	   $error("Expected registers equal to previously written values");
	 if (rs2_data !== n+1)
	   $error("Expected registers equal to previously written values");
      end

      // Check x0 is still zero
      rs1 = 0;
      rs2 = 0;
      if (rs1_data !== 0)
	$error("Expected x0 = 0 after attempt to write");
      if (rs2_data !== 0)
	$error("Expected x0 = 0 after attempt to write");
   
      // Check reset brings registers back to zero
      rstn = 0;
      #period;
      for (n=0; n<32; n=n+1) begin	 
	 rs1 = n;
	 rs2 = n;
	 if (rs1_data !== 0)
	   $error("Expected all registers zero in second reset");
	 if (rs2_data !== 0)
	   $error("Expected all registers zero in second reset");
      end
      
      
   end

   
   
endmodule
