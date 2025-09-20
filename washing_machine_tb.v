module wm2_tb();
reg clk, reset, door_close, start, water_filled, add_detergent, cycle_timeout, water_drained, spin_timeout;
wire door_lock, motor_on, fill_value_on, drain_value_on, done, soap_wash, water_wash; 
		
wm2 dut (clk, reset, door_close, start, water_filled, add_detergent, cycle_timeout, 
water_drained, spin_timeout, door_lock, motor_on, fill_value_on, drain_value_on, done, soap_wash, water_wash);
initial
begin
	    clk = 0;
		reset = 1;
		start = 0;
		door_close = 0;
		water_filled = 0;
		water_drained = 0;
		add_detergent = 0;
		cycle_timeout = 0;
		spin_timeout = 0;
		
		#5 reset=0;
		#5 start=1;door_close=1;
		#10 water_filled=1;
		#10 add_detergent=1;
		//water_filled=0;
		#10 cycle_timeout=1;
		//add_detergent=0;
		#10 water_drained=1;
		//cycle_timeout=0;
		#10 spin_timeout=1;
		//water_drained=0;
		
		/*
		
		#0 reset = 0;
		#2 start = 1;
		#4 door_close = 1;
		#3 water_filled = 1;
		#3 add_detergent = 1;
		#2 cycle_timeout = 1;
		#2 water_drained = 1; 
		#3 spin_timeout = 1;
		*/
	end
	
	always
	begin
		#5 clk = ~clk;
	end
	
	initial
	begin
		$monitor("Time=%d, Clock=%b, Reset=%b, start=%b, door_close=%b, water_filled=%b, add_detergent=%b, cycle_timeout=%b, water_drained=%b, spin_timeout=%b, door_lock=%b, motor_on=%b, fill_valve_on=%b, drain_valve_on=%b, soap_wash=%b, water_wash=%b, done=%b"
             ,$time, clk, reset, start, door_close, water_filled, add_detergent, cycle_timeout, water_drained, spin_timeout, door_lock, motor_on, fill_value_on, drain_value_on, soap_wash, water_wash, done);
	end
endmodule
