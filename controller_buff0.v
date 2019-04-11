module controller_buff0(RE0, WE0, SelR0, SelG0, SelB0, SelBuf0, SelBlank,IncPx, ResetPx, IncLine, ResetLine, SyncVB, Buf1Empty, IncAddr0, ResetAddr0,
			PxOut, LineOut, VBOut, AIPOut, AILOut, CSDisplay, clock, reset);


output reg RE0, WE0, SelR0, SelG0, SelB0, SelBuf0, SelBlank,IncPx, ResetPx, IncLine, ResetLine, SyncVB, Buf1Empty, IncAddr0, ResetAddr0;
input [3:0] VBOut, AILOut, AIPOut, PxOut, LineOut;
input clock, reset, CSDisplay;
reg[8:0] counter;

parameter zero = 9'b0;
integer rgb_count = 0 ;



initial @(posedge clock)
begin
	counter = 9'b111111111;
	RE0 = 0; 
 	ResetAddr0 = 0;
end

always@(posedge clock or posedge reset)
begin
	if(CSDisplay)
	begin
		if(reset) counter <= 9'b111111111;
		else 
		begin
			counter = counter + 9'b01;
			rgb_count = counter%3;
		end
	  
	  	if(counter == zero)
	  	begin
			SelBlank <= 1'b1;
  		 	Buf1Empty <= 1'b1;
  		 	SyncVB <= 1'b1;
	  	end
	  	else if(counter == 1)
	  	begin
	  		SyncVB <= 1'b0;
  	  	end
	
		if(RE0)
		begin
			SelBlank <= 0;
			SelBuf0 <= 1;
			if(PxOut < AIPOut - 1)
	  		begin
	  			if(rgb_count == 0)			//Validation for Red Pixel
				begin
					SelR0 <= 1;
					SelB0 <= 0;
					SelG0 <= 0;
					SelBuf0 <= 1;
					RE0 <= 1;
					IncPx <=0;
					IncAddr0 <= 0;
				end

				else if(rgb_count == 1)			//Validation for green Pixel
				begin
					SelG0 <= 1;
					SelB0 <= 0;
					SelR0 <= 0;
					SelBuf0 <= 1;
					RE0 <= 1;
					IncAddr0 <= 1;
					IncPx <=0;
				end

				else if(rgb_count == 2)			//Validation for Blue Pixel
				begin
					SelB0 <= 1;
					SelR0 <= 0;
					SelG0 <= 0;
					SelBuf0 <= 1;
					RE0 <= 1;
					IncPx <=1;
					IncAddr0 <= 0;
				end
	 		end
			else if(PxOut == AIPOut - 1)						//Validation for Last Active Pixel
			begin
				if(rgb_count == 0)			//Validation for Red Pixel
				begin
					SelR0 <= 1;
					SelB0 <= 0;
					SelG0 <= 0;
					SelBuf0 <= 1;
					RE0 <= 1;
					IncPx <= 0;
					ResetPx <= 0;
					IncLine <= 0;
					ResetLine <= 0;
				end

				else if(rgb_count == 1)			//Validation for Green Pixel
				begin
					SelG0 <= 1;
					SelB0 <= 0;
					SelR0 <= 0;
					SelBuf0 <= 1;
					IncPx <= 0;
					ResetPx <= 0;
					IncLine <= 0;
					ResetLine <= 0;
					RE0 <= 1;
					if(LineOut == AILOut - 1)	//Check for Last Line
					begin
						ResetAddr0 <=1;
					end
				end

				else if(rgb_count == 2)			//Validation for Blue Pixel
				begin
					ResetPx <= 1;
					IncPx <= 0;
					SelB0 <= 1;
					SelR0 <= 0;
					SelG0 <= 0;
					SelBuf0 <= 1;

					if(LineOut < AILOut - 1)	//Vaidation for Not last line
					begin
						IncLine <= 1;
						SelBlank <= 0;
						ResetLine <= 0;
					end

					else if(LineOut == AILOut - 1)				//Validation for last line
					begin
						ResetLine <= 1;
					end
				end
			end   //LastPixel 

		end//else if(RE0)
		else
		begin
			if(rgb_count == 2)
			begin
				if(PxOut < AIPOut - 1)       //Verifying if Last Pixel or Not
				begin
					IncPx <=1;
					SelBlank <= 1;
				end

				else if(PxOut == AIPOut -1)			    //Verifying if Last Pixel
				begin
					if(LineOut < VBOut - 1)		//Verifying if Last Line or Not
					begin
						ResetPx <= 1;
						IncPx <= 0;
						IncLine <= 1;
						SelBlank <=1;
					end
					else if(LineOut == VBOut -1)				//Verifying if Last Line
					begin
						ResetPx <=1 ;
						ResetLine <= 1;
						IncLine <= 0;
						IncPx <= 0;
						RE0 <= 1;
					end
				end
			end
			else
			begin
				IncPx <= 0;
				ResetPx <= 0;
				ResetLine <= 0;
				IncLine <= 0;
			end
		end
	end 	//CSdisplay
end 		 //always

endmodule
