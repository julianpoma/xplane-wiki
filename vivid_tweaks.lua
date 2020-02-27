--------------------------------
--	VIVID SKY TWEAKS | SmC12  --
--		 v1.1.0               --
--------------------------------

-- CHECK YOUR EXISTING LUA SCRIPTS FOR ANY CONFLICTS WITH THESE SETTINGS OR YOU MAY SEE BROKEN RESULTS OR PERFORMANCE LOSS --

-- Terrain
set("sim/private/controls/skyc/dsf_cutover_scale", 1.5) -- fixes mountain geometry glitches in fog
set("sim/private/controls/skyc/dsf_fade_ratio", 0.75) -- related to above and blends low-res DSF textures in distance
set("sim/private/controls/dome/sun_glare_dist_dome_rat", 0.85) -- prevent sun disappearing
set("sim/private/controls/park/static_plane_build_dis", 3000.00) -- static planes dis, default 9000, potential fps gain
set("sim/private/controls/planet/hires_steps", 500) -- fix holes in low-res terrain mesh
set("sim/private/controls/planet/hires_steps_extra", 500) -- fix holes in low-res terrain mesh

-- General Shadows
set("sim/private/controls/fbo/shadow_cam_size", 2048.0) -- -- reduce jagged shadows, can increase to 4096 or 8192 
set( "sim/private/controls/shadow/csm_split_interior", 3) -- improves cockpit shadow detail (4 is best)
set("sim/private/controls/shadow/cockpit_near_adjust", 1.0) -- remove blocky cockpit shadows, max 4 (1 is best)
set("sim/private/controls/shadow/cockpit_near_proxy", 2.0) -- improve aircraft shadow LOD (wings etc.)

-- Lights
set("sim/private/controls/lights/exponent_far", 0.46) -- brighter lights

-- The ultimate mod lights
set("sim/private/controls/lights/scale_near", 0.1)
set("sim/private/controls/lights/scale_far", 1)
set("sim/private/controls/lights/dist_near", 200)
set("sim/private/controls/lights/dist_far", 8500)
set("sim/private/controls/lights/exponent_near", 0.5)
set("sim/private/controls/lights/bloom_near", 100)
set("sim/private/controls/lights/bloom_far", 2500)

-- Fog Vis
set("sim/private/controls/fog/fog_be_gone", 1.0)

-- Plane rendering
set("sim/private/controls/park/static_plane_density", 2.00)

--------------------------------
-- WARNING: The following settings are disabled by default. 
-- These settings can improve the low-res "brown mush" from distant terrain. However, you may 
-- also see some performance loss and potentially missing sun at certain viewing angles. 
-- You can experiment with the settings in-sim using DataRefEditor art controls. 
-- To enable, remove the "--" at the beginning of the lines. 
--------------------------------
 
--set("sim/private/controls/skyc/max_dsf_vis_ever", 150000.00) -- cutoff limit before low-res terrain is used. Default 100000. 
--set("sim/private/controls/skyc/min_dsf_vis_ever", 130000.00) -- min detail range (terrain only, not objects). Default 20000. Cannot be higher than max_dsf_vis_ever. 

