--[[
	x_mobs - Monster Particle & Visual FX Loader
	Modular particle systems following SOLID architecture:
	- texpools.lua: Texture sheets, palettes, and particle frame definitions
	- particles_base.lua: Node surface sampling, target resolution, and VFX dispatchers
	- spider_vfx.lua: Spider webs, venom DoT, skittering, and attached spawners
	- undead_vfx.lua: Shaman resurrect aura, fireballs, and bone dust
	- insect_vfx.lua: Armored bug and flying insect carapaces, ichor, and wings
	- boss_crystal_vfx.lua: Crystal Guardian shards, shockwaves, and death nova
	- fungus_vfx.lua: Crazy mushroom and fungus spores, blooms, and summons
	- boss_nature_guardian_vfx.lua: Nature Guardian punches, attacks, and entangling roots
	- boss_golem_vfx.lua: Golem basalt shards, seismic shockwaves, and rock trails
	- arcane_vfx.lua: Spectrum void demon and Elder ambush stalker effects
	- boss_frosty_queen_vfx.lua: Frosty Queen crystalline trails, ice novae, and freeze shroud
--]]

local modpath = core.get_modpath("x_mobs")
local vfx_path = modpath .. "/vfx"

dofile(vfx_path .. "/texpools.lua")
dofile(vfx_path .. "/particles_base.lua")
dofile(vfx_path .. "/spider_vfx.lua")
dofile(vfx_path .. "/undead_vfx.lua")
dofile(vfx_path .. "/insect_vfx.lua")
dofile(vfx_path .. "/boss_crystal_vfx.lua")
dofile(vfx_path .. "/fungus_vfx.lua")
dofile(vfx_path .. "/boss_nature_guardian_vfx.lua")
dofile(vfx_path .. "/boss_golem_vfx.lua")
dofile(vfx_path .. "/arcane_vfx.lua")
dofile(vfx_path .. "/boss_frosty_queen_vfx.lua")
