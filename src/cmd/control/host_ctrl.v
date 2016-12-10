module host_control(reset,
					clock,
					emmit_command,				//to sd_ctrl
					command_complete,			//from sd_ctrl
					response,					//issued by SD
					error_interrupt,				//whenever there's an error, must be set on high
					command_index,				//indez for the command
					command_index_check_enable,	//checks if the command index is the same for the command and the response
					command_index_error,	
					crc_check_enable,			//enable checks for response
					crc_error,					//in case there's a comprobation error (timeout_error=0) or the transmitter bit from the response is 1 (timeout_error=1)
					end_bit_error,				//when the ending bit of a response is 0
					end_bit_check_enable,		//when the ending bit of a response is 0
					command_complete_interrupt,	//register, must be set on high when the command has been properly emmited and an answer received (in case there should be one)
					response_type,				//lengths and busy status after complete
					command_type, 				//normal, suspend, resume or abort
					response_register,			//normal response, type 10
					CID,						//for type 01
					card_status_AUTO_CMD52		//for type 11 
					
);
	
	
	input wire reset,
	clock,
	command_complete,
	command_index,
	command_index_check_enable,	//checks if the command index is the same for the command and the response
	crc_check_enable,			//enable checks for response
	command_inhibit,			//from regs, present_state
	command_complete,			//from sd_ctrl, interrupt
	response,					//issued by SD
	command_type, 				//normal, suspend, resume or abort
	response_type,				//lengths and busy status after complete
	
	
	
	output reg command_index_error,	
	command_complete_interrupt,			 
	emmit_command,
	crc_error,
	timeout_error,		//when 64 clock cycles go through without a response from the SD
	command_complete_status,		//
	end_bit_error,		//when the ending bit of a response is 0
	response_register,	//normal response, type 10
	CID,				//for type 01
	card_status_AUTO_CMD52
	
	reg [2:0] state;
	reg verifications_pass;
	reg verifications_end;
	
	parameter NO_RESPONSE = 0, LONG_RESPONSE = 1, NORMAL_RESPONSE = 2, AUTO_CMD_52 = 3; 
	parameter RESET = 0, IDLE = 1, EMMIT_CMD = 2, WAIT_RESPONSE = 3, VERIFICATION = 4, WRITE_REGS = 5;
	
	always @(*) begin
		if(reset) begin
			state = RESET;
		end
	end
	
	always @(posedge clock)
		case(state)
			
			RESET:
				state <= IDLE;
				reset <= 0;
			
			IDLE:
				if(command_inhibit) begin
					state <= EMMIT_CMD;
				end
			
			EMMIT_CMD:
				command <= 1;
				state <= WAIT_RESPONSE;
			
			WAIT_RESPONSE:
				if(command_complete) begin
					command <= 0;
					verifications_passed <= 0;
					verifications_end <= 0;
					state <= VERIFICATION;
				end
			
			VERIFICATION:
				case(response_type)
					NO_RESPONSE:
						state <= IDLE;
						command_complete_interrupt <= 1;
					
					NORMAL_RESPONSE || AUTO_CMD52:
						if(response[0]==0) begin 
							if(end_bit_check_enable) begin
								verifications_end <= 1;
								verifications_passed <= 0;
							end
						end
					if(response[45:40]!=command_index) begin 
							if(end_bit_check_enable) begin
								verifications_end <= 1;
								verifications_passed <= 0;
							end
						end
										
					LONG_RESPONSE:
						if(response[0]==0) begin 
							if(end_bit_check_enable) begin
								verifications_end <= 1;
								verifications_passed <= 0;
							end
						end
				endcase
				
				if(verifications_end) begin
					if(verification_passed) begin
						state <= WRITE_REGS;
					end else begin
						state <= IDLE;
					end
				end
			
			WRITE_REGS:
				case(command_type)
					NORMAL_RESPONSE:
						response_register <= response;
					LONG_RESPONSE:
						CID <= response;
					AUTO_CMD52:
						card_status_AUTO_CMD52 <= response;
				endcase
			state = IDLE;
	endcase
	
endmodule