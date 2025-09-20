module wm2 (clk, reset, door_close, start, water_filled, add_detergent, cycle_timeout, drained, 
spin_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash);

input clk, reset, door_close, start, water_filled, add_detergent, cycle_timeout, drained, spin_timeout;//inputs
output reg door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash; //outputs
	
	//defining all the states
parameter CHECK_DOOR = 3'b000;
parameter FILL_WATER = 3'b001;
parameter ADD_DETERGENT = 3'b010;
parameter CYCLE = 3'b011;
parameter DRAIN_WATER = 3'b100;
parameter SPIN = 3'b101;
reg[2:0] current_state, next_state;
always@(current_state or start or door_close or water_filled or add_detergent or drained 
or cycle_timeout or spin_timeout) //defining for all states of output
	begin
case(current_state)
//intializing state 1:CHECK_DOOR
CHECK_DOOR:
if(start==1 && door_close==1) //starting machine and closing door
begin
next_state = FILL_WATER; //Next_state = FILL_WATER
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 0;
water_wash = 0;
done = 0;
end
else
begin
next_state = current_state; //next_state=current_state
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 0;
soap_wash = 0;
water_wash = 0;
done = 0;
end
//initializing state 2 : FILL_WATER
FILL_WATER:
if (water_filled==1)
begin
if(soap_wash == 0) //If FILL_WATER==1 & soap_wash==0, then next state = add_detergent
begin
next_state = add_detergent;
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
water_wash = 0;
done = 0;
end
else
begin
next_state = CYCLE; //next_state=CYCLE;
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
water_wash = 1;
done = 0;
end
end
else
begin
next_state = current_state;
motor_on = 0;
fill_valve_on = 1;
drain_valve_on = 0;
door_lock = 1;
done = 0;
end
//initializing state 3 : ADD_DETERGENT
ADD_DETERGENT:
if(add_detergent==1)
begin
next_state = CYCLE;//next_state=CYCLE
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
done = 0;
end
else
begin
next_state = current_state;
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
water_wash = 0;
done = 0;
end
//Initializing state 4: CYCLE
CYCLE:
if(cycle_timeout == 1)
begin
next_state = DRAIN_WATER;//next_state=DRAIN_WATER
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
done = 0;
end
else
begin
next_state = current_state;
motor_on = 1;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
//soap_wash = 1;
done = 0;
end
//initializing state 5 : DRAIN_WATER
DRAIN_WATER:
if(drained==1)
 begin
if(water_wash==0)
begin
next_state = FILL_WATER;//next_state = FILL_WATER
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
done = 0;
end
else
begin
next_state = SPIN; //next_state=SPIN
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
water_wash = 1;
done = 0;
end
end
else
begin
next_state = current_state;
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 1;
door_lock = 1;
soap_wash = 1;
done = 0;
end
//initializing state 6 : SPIN
SPIN:
if(spin_timeout==1)
begin
next_state = CHECK_DOOR; //next_state=CHECK_DOOR
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 0;
door_lock = 1;
soap_wash = 1;
water_wash = 1;
done = 1;
end
else
begin
next_state = current_state;
motor_on = 0;
fill_valve_on = 0;
drain_valve_on = 1;
door_lock = 1;
soap_wash = 1;
water_wash = 1;
done = 0;
end
default: next_state = CHECK_DOOR;	//DEFAULT STATE :CHECK_DOOR			
endcase
end
always@(posedge clk or negedge reset)
begin
if(reset)
begin
current_state<=3'b000;
end
else
begin
current_state<=next_state;
end
end
endmodule
