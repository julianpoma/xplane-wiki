-------------------------
--	VIVID SKY | SmC12  --
--		 v1.1.0        --
-------------------------

-- Sun
set("sim/private/controls/dome/sun_gain_1_hdr", 0.85) -- sun glare strength
set("sim/private/controls/dome/sun_gain_2_hdr", 2.35) -- sun brightness

-- Clouds
set("sim/private/controls/clouds/first_res_3d", 3) -- puffier clouds, reduces "bowl effect" in cloud layers
set("sim/private/controls/clouds/plot_radius", 1.1) -- increased cloud volume
set("sim/private/controls/clouds/overdraw_control", 0.75) -- helps to reduce cloud flicker
set("sim/private/controls/clouds/ambient_gain", 1.12) -- less blinding in direct sun
set("sim/private/controls/clouds/diffuse_gain", 0.9) -- darker at night/sunst
set("sim/private/controls/clouds/spec_gain", 4.0) -- sun power through clouds
set("sim/private/controls/clouds/light_curve_ratio", 0.95) -- cloud volume light top/dark base
set("sim/private/controls/clouds/light_curve_power", 1.2) -- cloud volume light top/dark base
set("sim/private/controls/clouds/check_z_hdr", 0.0) -- fix cloud terrain intersection

-- Atmosphere
set("sim/private/controls/atmo/atmo_scale_raleigh", 14)
set("sim/private/controls/atmo/scatter_raleigh_r",2.00)
set("sim/private/controls/atmo/scatter_raleigh_g", 7.00) 
set("sim/private/controls/atmo/scatter_raleigh_b", 17.50) 
set("sim/private/controls/atmo/inscatter_gain_raleigh", 1.75)
set("sim/private/controls/skyc/tone_ratio_clean", 0.15)
set("sim/private/controls/skyc/tone_ratio_hialt", 1.25) 
set("sim/private/controls/skyc/tone_ratio_mount", 1.1) 

-- Cloud Shadows
set("sim/private/controls/clouds/shad_radius", 0.6) -- increased volume
set("sim/private/controls/clouds/cloud_shadow_lighten_ratio", 0.94) -- darker shadow, max 1.0
set("sim/private/controls/clouds/shad_alpha_dry", 0.6) -- darker shadow
set("sim/private/controls/clouds/shad_alpha_wet", 1.0) -- darker shadow
set("sim/private/controls/clouds/limit_far",  0.4) -- reduce shadow flicker, blockiness and increase detail 
set("sim/private/controls/clouds/shadow_size", 2048.0)  -- reduce shadow flicker, possibly not used in 11.35
