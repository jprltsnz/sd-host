module sd_ctrl(reset,
			   clock,
			   sd_in,
			   sd_out,
			   emmit_command,
			   command_timeout,
			   response_ready,
			   serialize_complete,
			   deserialize_complete,
			   enable_serializer,
			   enable_deserializer,
			   reset_serializer
			   
			  );
	input reset, clock, deserialize_complete, serialize_complete, emmit_command, deserialize_complete;
	output reg enable_serializer, enable_deserializer, reset_serializer, response_ready;
	input [135:0] sd_in;
	output [47:0] sd_out;
	
	parameter RESET = 0, IDLE = 1, HOST_TO_SD_TRANSF = 2, WAIT_RESPONSE = 3, SD_TO_HOST_TRANSF = 4;
	
	reg [2:0] state;
	
	reg [5:0] timeout_counter;
	
	always@(posedge reset) begin
		state = 0;
	end
	
	always @(posedge clock)
		case(state)
			
			RESET:
				reset_serializer <= 1;
				reset_deserializer <= 1;
				state <= IDLE;
				counter <= 0;
			
			IDLE:
				response_ready <= 0;
				reset_serializer <= 0;			// so it doesn't stay in 1
				if(emmit_command) begin
					state <= HOST_TO_SD_TRANSF; // host_control says to start sending command
				end
			
			HOST_TO_SD_TRANSF:
				enable_serializer <= 1;		// start serializing
				if(serialize_complete) begin
					state <= WAIT_RESPONSE;
				end
			
			WAIT_RESPONSE:
				enable_serializer <= 0;
				reset_serializer <= 1;
				counter = counter + 1;
				if(counter == 63) begin
					command_timeout <=1;
					state <= IDLE;
				end else begin
					if(pad_to_deserializer) begin
						enable_deserializer <=1;
						state <= SD_TO_HOST_TRANSF;
					end
				end
			
			SD_TO_HOST_TRANSF:
				counter <= 0;
				if(deserialize_complete) begin
					response_ready <= 1;
					state <= IDLE;
				end
				
				
				
				
		
	endcase
	
endmodule