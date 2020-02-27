
-- Water
local start_time = os.clock()
local do_once = false 
dataref("view_height_m", "sim/graphics/view/view_y", "readonly")

function sim()
	if os.clock() > start_time and do_once == false then
local start_time = os.clock()
local do_once = false
	set("sim/private/controls/water/fft_amp1", 2.5)
	set("sim/private/controls/water/fft_amp2", 1.5)
	set("sim/private/controls/water/fft_amp3", 16)
	set("sim/private/controls/water/fft_amp4", 150)
	set("sim/private/controls/water/fft_scale1", 4)
	set("sim/private/controls/water/fft_scale2", 60)
	if (view_height_m > 6000.0) then
		set("sim/private/controls/water/fft_scale3", 3)
		set("sim/private/controls/water/fft_scale4", 1.5)
	else
		set("sim/private/controls/water/fft_scale3", 6)
		set("sim/private/controls/water/fft_scale4", 2)
	end
	set("sim/private/controls/water/noise_speed", 25)
	set("sim/private/controls/water/noise_bias_gen_x", 2)
	set("sim/private/controls/water/noise_bias_gen_y", 1)
    do_once=true 
	end
end
do_often("sim()")