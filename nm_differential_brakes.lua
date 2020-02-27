-- Differential brakes for X-Plane 11 
-- by Nicola Marangon aka nicotum*.* with Virtual ToeBrake Additions by Peter Norman
-- v2.0
---------------------------------------------------------------------
-- Requirement:
-- 		FlyWithLua for XP11 installed

--	Description:
--		In XP10 there was the possibility to use two buttons to simulate left and right toe brakes.
--		In XP11 this commands have been removed and XP11 tries to simulate the differential brake action in a way that I don't like.
-- 		Purpose of this script is providing the user custom commands similiar to those present in XP10.
--		The script is very simple but should do the job. 
--		Every comment or suggestion is welcome.

--	Installation: 
--		Copy the script into the folder x-plane\Resources\plugins\FlyWithLua\Scripts 

--	Configuration: 
--		1) bind a button to the command "FlyWithLua/nm/differential_left_brake" for the left brake
--		2) bind a button to the command "FlyWithLua/nm/differential_right_brake" for the right brake
--		optionally:
--		3) bind a button to the command "FlyWithLua/nm/single_button_brake" for a single action brake button.
--		   note: can be used in addition to the left/right commands

--	Usage:
--		The script will apply a linear brake force to the desired brake from 0 to 100% in 2.5 seconds.
--		The default value is defined in the SECONDS_FOR_MAX_BRAKE_ACTION variable.
--		Releasing the button will simulate the releasing of the brake.
--		Brakes can be used together.
--		** Note: the script should override phisical toe brakes if present (not tested).

--  Show Brakes Info function:
--		The script implements a macro that shows simple brakes info: 
--		1) left/right brake ratio
--		2) parking brake status (B=Max, b=regular)
--		This macro is enabled by default and can be deactivated through the "Plugins->FlyWithLua->FlyWithLua Macros" menu.
--		To get rid of this function, change "activate" to "deactivate" ) in the add_macro command below.


--	Have fun!

-- Virtual ToeBrake Additions
-- The script will look for a "yaw" axis controller (rudder) and will apply toebrakes when the rudder is fully extended left or right.

-- Hold Node (re-press within 0.5 secs)
-- Hold then release and quickly hold again will hold the relevant brake at the current strength.  This works for buttons and rudder pedals
-- Hold  left brake button, then the right and release/repress the right will hold both brakes.  Lift the right and re-press within 0.5 secs and reapply the same setting. Wait longer and brakes will restart from 0.
-- Right with left works the same.
--The Single brakes button will take presedence over the left right buttons.
--When using the rudder toe braking, pressing one of the brakes buttons will "hold" .

-- Using rudder toe brakes while also holding down brake buttons should be avoided as you might get unpredictable results.


SHOW_BRAKES_INFO = false

local SECONDS_FOR_MAX_BRAKE_ACTION = 2.5

local brakes_button_start_sec = {0, 0}

create_command( 
	"FlyWithLua/nm/differential_left_brake", 
	"differential left brake", 
	"differential_brake_start(1)", 
	"differential_brake_pressed(1)", 
	"differential_brake_released(1)"
)

create_command( 
	"FlyWithLua/nm/differential_right_brake", 
	"differential right brake", 
	"differential_brake_start(3)", 
	"differential_brake_pressed(3)", 
	"differential_brake_released(3)"
)

create_command( 
	"FlyWithLua/nm/single_button_brake", 
	"single button brake", 
	"differential_brake_start(2)", 
	"differential_brake_pressed(2)", 
	"differential_brake_released(2)"
)

set("sim/operation/override/override_toe_brakes", 1)

dataref("left_brake_ratio", "sim/cockpit2/controls/left_brake_ratio", "writable")
dataref("right_brake_ratio", "sim/cockpit2/controls/right_brake_ratio", "writable")
dataref("parking_brake_ratio", "sim/cockpit2/controls/parking_brake_ratio")

dataref("total_running_time_sec", "sim/time/total_running_time_sec")

------------------------------------------------
require("graphics")

local box_center = 45
local box_bottom = 72
local box_width_full = 70
local box_height = 20
local box_text_width = 10
local box_width = (box_width_full - box_text_width) / 2

local brakes_left_bottom = box_bottom
local brakes_left_right = box_center - box_text_width / 2
local brakes_left_top = box_bottom + box_height
local brakes_left_left = brakes_left_right - box_width 

local brakes_right_bottom = box_bottom
local brakes_right_left = box_center + box_text_width / 2
local brakes_right_right = brakes_right_left + box_width
local brakes_right_top = box_bottom + box_height

	local i
	DOUBLE_TAP = true
	local axis_function_index = 0
    local yaw_axis_number = 0
	local Toe_Brakes_Are_On = 0
	local joystick_axis = dataref_table("sim/joystick/joystick_axis_values")
	local axis_functions = { "pitch", "roll", "yaw", "throttle", "collective", "left toe brake", "right toe brake", "prop",
	"mixture", "carb heat", "flaps", "thrust vector", "wing sweep", "speedbrakes", "displacement",
	"reverse", "elev trim", "ailn trim", "rudd trim", "throttle 1", "throttle 2", "throttle 3",
	"throttle 4", "prop 1", "prop 2", "prop 3", "prop 4", "mixture 1", "mixture 2",
	"mixture 3", "mixture 4", "reverse 1", "reverse 2", "reverse 3", "reverse 4", "landing gear",
	"nosewheel tiller", "backup throttle", "auto roll", "auto pitch", "view left/right", "view up/down", "view zoom" }

	local brakes_button_end_sec = {0, 0}
	local last_left_brake_ratio = 0
	local last_right_brake_ratio = 0
	local Hold_Brake_Value = false
	local last_brake = 0
	local brakes_axis_start_sec = {0, 0}
	
	brakes_button_start_sec[1] = 0
	brakes_button_start_sec[2] = 0
	brakes_button_start_sec[3] = 0
	brakes_axis_start_sec[1] = 0
	brakes_axis_start_sec[3] = 0
	brakes_button_end_sec[1] = 0
	brakes_button_end_sec[2] = 0
	brakes_button_end_sec[3] = 0
	
------------------------------------------------
function show_brakes()

	if (SHOW_BRAKES_INFO == false) then
		return
	end
	
	if left_brake_ratio == 0 and right_brake_ratio == 0 and parking_brake_ratio == 0 then
		return
	end

	graphics.set_color(1, 0, 0, 0.7)

	graphics.draw_rectangle(
		brakes_left_right - box_width * left_brake_ratio, brakes_left_bottom, brakes_left_right, brakes_left_top)

	graphics.draw_rectangle(
		brakes_right_left, brakes_right_bottom, brakes_right_left + box_width * right_brake_ratio, brakes_right_top)

	graphics.set_color(1, 1, 1, 1)

	graphics.draw_line(brakes_left_left, brakes_left_bottom, brakes_right_right, brakes_right_bottom)
	graphics.draw_line(brakes_right_right, brakes_right_bottom, brakes_right_right, brakes_right_top)
	graphics.draw_line(brakes_right_right, brakes_right_top, brakes_left_left, brakes_left_top)
	graphics.draw_line(brakes_left_left, brakes_left_bottom, brakes_left_left, brakes_left_top)

	if parking_brake_ratio > 0 then
	
		graphics.set_color(1, 1, 1, 0.7)
		if parking_brake_ratio == 1 then
			draw_string_Helvetica_10(brakes_left_right + 1, brakes_left_bottom + 5, 'B')
		else
			draw_string_Helvetica_10(brakes_left_right + 1, brakes_left_bottom + 5, 'b')
		end
	end

end

function ProcessRudderAxisValue()

    if(joystick_axis[yaw_axis_number] < 0.06 ) then  --  apply left brake if less than this value.  Tune this value to your hardware
		if(brakes_axis_start_sec[1] == 0) then 
			differential_brake_start(1)
			Toe_Brakes_Are_On = 1
		end
		differential_brake_pressed(1)
	 else
		if(joystick_axis[yaw_axis_number] > 0.84) then --  apply right brake if greater than this value.  Tune this value to your hardware
			if(brakes_axis_start_sec[3] == 0) then
				differential_brake_start(3)
				Toe_Brakes_Are_On = 1
			end	
			differential_brake_pressed(3)				
		else
			if(Toe_Brakes_Are_On == 1) then
				differential_brake_released(2) -- Otherwise, just release both brakes
				Toe_Brakes_Are_On = 0
			end
		end
	 end
	 
end
------------------------------------------------
for i = 0, 499 do -- find the yaw axis number
		axis_function_index = get( "sim/joystick/joystick_axis_assignments", i )
		if axis_function_index > 0 then
			if axis_functions[axis_function_index] == "yaw" then
				yaw_axis_number = i
				break
			end 
		end	
	end

add_macro ("Brakes: Enable Double Tap", "DOUBLE_TAP = true", "DOUBLE_TAP = false", "activate" )
add_macro ("Brakes: Show info when applied", "SHOW_BRAKES_INFO = true", "SHOW_BRAKES_INFO = false", "activate" )

do_every_draw("ProcessRudderAxisValue()")
-- do_every_draw("show_brakes()")
	
------------------------------------------------

function min(v1, v2)
   if (v1 < v2) then
      result = v1
   else
      result = v2
   end

   return result 
end

------------------------------------------------
function differential_brake_start(brake)
			
	if Toe_Brakes_Are_On == 1 then
		left_brake_ratio = last_left_brake_ratio
		right_brake_ratio = last_right_brake_ratio
		last_brake = brake
		Hold_Brake_Value = true
		return
	end
	
	if((total_running_time_sec - brakes_button_end_sec[brake]) > 0.5 or last_brake ~= brake or DOUBLE_TAP == false) then
	
		if Hold_Brake_Value == true then
			for i = 1,3 do
				brakes_button_start_sec[i] = total_running_time_sec
			end
		else
			brakes_button_start_sec[brake] = total_running_time_sec
		end
		
		
		brakes_axis_start_sec[brake] = total_running_time_sec
		
		last_left_brake_ratio = 0
		last_right_brake_ratio = 0	

		last_brake = brake
		Hold_Brake_Value = false
		
	else
	
		left_brake_ratio = last_left_brake_ratio
		right_brake_ratio = last_right_brake_ratio
		
		Hold_Brake_Value = true
	end
end

------------------------------------------------
function differential_brake_pressed(brake)
	
	if Hold_Brake_Value == false then
		if brake <= 2 then	
			left_brake_ratio = min(1, (total_running_time_sec - brakes_button_start_sec[brake]) / SECONDS_FOR_MAX_BRAKE_ACTION)
			last_left_brake_ratio = left_brake_ratio
		end
	
		if brake >= 2 then
			right_brake_ratio = min(1, (total_running_time_sec - brakes_button_start_sec[brake]) / SECONDS_FOR_MAX_BRAKE_ACTION)	
			last_right_brake_ratio = right_brake_ratio			
		end
	end
	
end

------------------------------------------------
function differential_brake_released(brake)

	left_brake_ratio = 0
	right_brake_ratio = 0
				
	for i = 1,3 do		
		brakes_axis_start_sec[i] = 0
		brakes_button_end_sec[i]  = total_running_time_sec
	end
		
end
