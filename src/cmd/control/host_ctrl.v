module host_control(reset,
					clock,
					emmit_command,
					command_complete,
					command_index,
					command_index_check_enable,	//checks if the command index is the same for the command and the response
					command_index_error,	
					crc_check_enable,	//enable checks for response
					crc_error,			//in case there's a comprobation error (timeout_error=0) or the transmitter bit from the response is 1 (timeout_error=1)
					timeout_error,		//when 64 clock cycles go through without a response from the SD
					end_bit_error,		//when the ending bit of a response is 0
					command_complete_status,		//
					response_type,		//lengths and busy status after complete
					command_type, 		//normal, suspend, resume or abort
					response,			//issued by SD
					response_register,	//normal response, type 10
					CID,				//for type 01
					card_status_AUTO_CMD52	//for type 11 
					
);
	
	
	input wire reset,
	clock,
	command_complete,
	command_index,
	command_index_check_enable,	//checks if the command index is the same for the command and the response
	crc_check_enable,	//enable checks for response
	
	
	
	output reg command_index_error,	
	emmit_command,
	crc_error,			//in case there's a comprobation error (timeout_error=0) or the transmitter bit from the response is 1 (timeout_error=1)
	timeout_error,		//when 64 clock cycles go through without a response from the SD
	end_bit_error,		//when the ending bit of a response is 0
	command_inhibit,	//from regs, present_state
	command_complete,	//from sd_ctrl, interrupt
	command_complete_status,		//
	response_type,		//lengths and busy status after complete
	command_type, 		//normal, suspend, resume or abort
	response,			//issued by SD
	response_register,	//normal response, type 10
	CID,				//for type 01
	card_status_AUTO_CMD52
	
	reg [2:0] state;
	reg verifications_pass;
	reg verifications_end;
	
	parameter NO_RESPONSE = 0, LONG_RESPONSE = 1, NORMAL_RESPONSE = 2, AUTO_CMD_52 = 3; 
	parameter RESET = 0, IDLE = 1, EMMIT_CMD = 2, WAIT_RESPONSE = 3, VERIFICATION = 4, WRITE_REGS = 5;
	always@(posedge reset) begin
		state = 0;
	end
	
	always @(posedge clock)
		case(state)
			
			RESET:
				state <= IDLE;
			
			IDLE:
				if(command_inhibit) begin
					state <= EMMIT_CMD;
				end
			
			EMMIT_CMD:
				command <= 1;
			
			WAIT_RESPONSE:
				if(command_complete) begin
					verifications_passed <= 0;
					verifications_end <= 0;
					state <= VERIFICATION;
				end
			
			VERIFICATION:
				if(response[]==)
				
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
						response <= response_register;
					LONG_RESPONSE:
						CID <= response;
					AUTO_CMD52:
						response <= card_status_AUTO_CMD52;
				endcase
			state = IDLE;
	endcase
	
endmodule