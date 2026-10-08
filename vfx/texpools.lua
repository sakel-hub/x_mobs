--[[
	x_mobs - Monster Particle Texpool Registries
	Declarative texpools, color palettes, and frame definitions
--]]

x_mobs.texpools = {}
local texpools = x_mobs.texpools

texpools.SPIDER_CHITIN_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.5, 1.6},
		alpha_tween = {1.0, 0.5, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.5, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

texpools.SPIDER_WEB_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {1.6, 0.7},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {1.8, 0.8},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {1.4, 0.6},
		alpha_tween = {0.85, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {1.7, 0.7},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {0.85, 0.0},
	},
}

texpools.SPIDER_VENOM_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.6, 0.4},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.5, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {1.7, 0.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.4, 0.35},
		alpha_tween = {1.0, 0.0, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.3, 0.4},
		alpha_tween = {1.0, 0.0, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.2, 0.25},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

texpools.SPIDER_EYE_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.8, 0.3},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.5, 0.25},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:6,3",
		blend = "add",
		scale_tween = {1.3, 0.2},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

texpools.SPIDER_POISON_CLOUD_TEXPOOL = {
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:3,3",
		blend = "alpha",
		scale_tween = {1.0, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.4, 3.4},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:5,3",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_spider_particles.png^[sheet:8x8:7,3",
		blend = "alpha",
		scale_tween = {1.0, 2.5},
		alpha_tween = {0.8, 0.2, start = 0.4},
	},
}


--- Spawns silk web burst particles when spider shoots web
---@param pos Vector Starting position
---@param dir Vector Direction vector


texpools.DEATH_FLAME_TEXPOOL = {
	{
		name = "x_mobs_flame_sheet.png",
		blend = "add",
		scale_tween = {
			{x = 0.55, y = 1.0},
			{x = 0.55, y = 1.0},
		},
		animation = {
			type = "vertical_frames",
			aspect_w = 32,
			aspect_h = 64,
			length = 1.35,
		},
	},
}

local DEATH_SPARK_ANIMATION = {
	type = "vertical_frames",
	aspect_w = 16,
	aspect_h = 16,
	length = 0.6,
}

texpools.DEATH_SPARK_TEXPOOL = {
	{
		name = "x_mobs_fireball.png",
		blend = "add",
		animation = DEATH_SPARK_ANIMATION,
	},
}


texpools.CHITIN_SHATTER_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
}

texpools.WING_SHRED_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.95, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
}

texpools.ICHOR_BURST_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.2, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.4, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {2.2, 1.0},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.5, 0.9},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
}

texpools.ICHOR_DISSOLVE_TEXPOOL = {
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.0, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.4, 3.4},
		alpha_tween = {0.9, 0.25, start = 0.45},
	},
	{
		name = "x_mobs_armored_bug_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.8, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.5},
	},
}

--- Spawns sharp fractured chitin armor plate shards bursting outward with physical bounce
---@param pos Vector Center impact position
---@param count? integer Number of shards to spawn (default 16)
---@param scale? number Scale multiplier (default 1.0)


texpools.BUG_CARAPACE_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.7, 1.0},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
}

texpools.BUG_WING_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.95, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {1.9, 1.1},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.7, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {0.95, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.6, 0.9},
		alpha_tween = {0.90, 0.30, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.7, 0.95},
		alpha_tween = {0.90, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:7,1",
		blend = "alpha",
		scale_tween = {1.6, 0.9},
		alpha_tween = {0.85, 0.30, start = 0.6},
	},
}

texpools.BUG_ICHOR_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.0, 0.8},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.2, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {2.0, 0.9},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {2.2, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {1.9, 0.8},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {1.8, 0.75},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,2",
		blend = "alpha",
		scale_tween = {1.7, 0.7},
		alpha_tween = {1.0, 0.35, start = 0.55},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:7,2",
		blend = "alpha",
		scale_tween = {2.1, 0.85},
		alpha_tween = {1.0, 0.4, start = 0.55},
	},
}

texpools.BUG_DISSOLVE_TEXPOOL = {
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:1,3",
		blend = "alpha",
		scale_tween = {1.0, 2.6},
		alpha_tween = {0.80, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.2, 3.0},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:3,3",
		blend = "alpha",
		scale_tween = {1.1, 2.7},
		alpha_tween = {0.85, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.0, 2.5},
		alpha_tween = {0.80, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:5,3",
		blend = "alpha",
		scale_tween = {1.0, 2.4},
		alpha_tween = {0.75, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:6,3",
		blend = "alpha",
		scale_tween = {1.2, 2.9},
		alpha_tween = {0.80, 0.2, start = 0.45},
	},
	{
		name = "x_mobs_bug_particles.png^[sheet:8x8:7,3",
		blend = "alpha",
		scale_tween = {0.9, 2.2},
		alpha_tween = {0.70, 0.15, start = 0.45},
	},
}

--- Spawns organic insect carapace shards and leg segments
---@param pos Vector Center impact position
---@param count? integer Number of shards to spawn (default 12)
---@param scale? number Scale multiplier (default 1.0)


texpools.CRYSTAL_SHARD_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,0",
		blend = "add",
		scale_tween = {1.6, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,0",
		blend = "add",
		scale_tween = {1.8, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,0",
		blend = "add",
		scale_tween = {2.0, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,0",
		blend = "add",
		scale_tween = {1.4, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,0",
		blend = "add",
		scale_tween = {1.7, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,0",
		blend = "add",
		scale_tween = {1.5, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:7,0",
		blend = "add",
		scale_tween = {1.6, 0.3},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.CRYSTAL_SMASH_WAVE_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,1",
		blend = "add",
		scale_tween = {1.0, 3.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,1",
		blend = "add",
		scale_tween = {1.2, 3.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,1",
		blend = "add",
		scale_tween = {1.4, 3.0},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,1",
		blend = "add",
		scale_tween = {1.3, 3.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,1",
		blend = "add",
		scale_tween = {1.5, 3.6},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,1",
		blend = "add",
		scale_tween = {1.1, 3.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:6,1",
		blend = "add",
		scale_tween = {1.4, 4.0},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.CRYSTAL_ROCK_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {1.5, 0.8},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,2",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,2",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.5, start = 0.6},
	},
}

texpools.CRYSTAL_SPARKLE_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.5, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.6, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,3",
		blend = "add",
		scale_tween = {1.4, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,3",
		blend = "add",
		scale_tween = {1.3, 0.15},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:5,3",
		blend = "add",
		scale_tween = {1.8, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:7,3",
		blend = "add",
		scale_tween = {1.5, 0.2},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.CRYSTAL_DUST_TEXPOOL = {
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {1.2, 3.2},
		alpha_tween = {0.8, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {1.5, 3.6},
		alpha_tween = {0.75, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {1.3, 3.0},
		alpha_tween = {0.85, 0.0, start = 0.35},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:3,4",
		blend = "alpha",
		scale_tween = {1.6, 3.8},
		alpha_tween = {0.8, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_crystal_guardian_particles.png^[sheet:8x8:4,4",
		blend = "alpha",
		scale_tween = {1.1, 2.8},
		alpha_tween = {0.7, 0.0, start = 0.4},
	},
}

--- Spawns sharp amethyst crystal shards and basalt chips on hit
---@param pos Vector World impact position
---@param count? integer Number of particles (default: 14)


texpools.MUSHROOM_CAP_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.5, 1.6},
		alpha_tween = {1.0, 0.5, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.45, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.65},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.5, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

texpools.MUSHROOM_STEM_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {1.9, 1.1},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {2.1, 1.2},
		alpha_tween = {1.0, 0.4, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {2.0, 1.1},
		alpha_tween = {1.0, 0.35, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.7, 0.9},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,1",
		blend = "alpha",
		scale_tween = {1.6, 0.8},
		alpha_tween = {1.0, 0.3, start = 0.6},
	},
}

texpools.MUSHROOM_SPORE_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,2",
		blend = "add",
		scale_tween = {1.5, 2.6},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,2",
		blend = "add",
		scale_tween = {1.4, 2.8},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,2",
		blend = "add",
		scale_tween = {1.6, 2.7},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,2",
		blend = "add",
		scale_tween = {1.3, 2.5},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,2",
		blend = "add",
		scale_tween = {1.7, 3.0},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,2",
		blend = "add",
		scale_tween = {1.2, 2.4},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,2",
		blend = "add",
		scale_tween = {1.5, 2.9},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,2",
		blend = "add",
		scale_tween = {1.4, 2.5},
		alpha_tween = {1.0, 0.0, start = 0.4},
	},
}

texpools.MUSHROOM_BLOOM_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,3",
		blend = "add",
		scale_tween = {1.2, 3.0},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,3",
		blend = "add",
		scale_tween = {1.4, 3.2},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,3",
		blend = "add",
		scale_tween = {1.1, 2.8},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,3",
		blend = "add",
		scale_tween = {1.5, 3.5},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,3",
		blend = "add",
		scale_tween = {1.3, 3.1},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,3",
		blend = "add",
		scale_tween = {1.0, 2.6},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,3",
		blend = "add",
		scale_tween = {1.4, 3.3},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,3",
		blend = "add",
		scale_tween = {1.2, 2.9},
		alpha_tween = {1.0, 0.0, start = 0.5},
	},
}

texpools.MUSHROOM_SLIME_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {1.6, 0.7},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {1.4, 0.5},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,4",
		blend = "alpha",
		scale_tween = {1.7, 0.65},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,4",
		blend = "alpha",
		scale_tween = {1.3, 0.5},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,4",
		blend = "alpha",
		scale_tween = {1.5, 0.6},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,4",
		blend = "alpha",
		scale_tween = {1.2, 0.45},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,4",
		blend = "alpha",
		scale_tween = {1.4, 0.55},
		alpha_tween = {1.0, 0.2, start = 0.5},
	},
}

texpools.MUSHROOM_SMOKE_TEXPOOL = {
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:0,6",
		blend = "alpha",
		scale_tween = {1.6, 3.2},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:1,6",
		blend = "alpha",
		scale_tween = {1.8, 3.5},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:2,6",
		blend = "alpha",
		scale_tween = {1.5, 3.0},
		alpha_tween = {0.75, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:3,6",
		blend = "alpha",
		scale_tween = {1.9, 3.6},
		alpha_tween = {0.85, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:4,6",
		blend = "alpha",
		scale_tween = {1.4, 2.9},
		alpha_tween = {0.75, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:5,6",
		blend = "alpha",
		scale_tween = {1.7, 3.3},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:6,6",
		blend = "alpha",
		scale_tween = {1.3, 2.7},
		alpha_tween = {0.7, 0.0, start = 0.3},
	},
	{
		name = "x_mobs_mushroom_particles.png^[sheet:8x8:7,6",
		blend = "alpha",
		scale_tween = {1.5, 3.1},
		alpha_tween = {0.8, 0.0, start = 0.3},
	},
}

--- Spawns scattered cap debris, stem fibers, and a violet spore burst upon mushroom taking damage
---@param pos Vector Impact position
---@param scale? number Scale multiplier (default 1.0)


texpools.NATURE_LEAF_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {2.2, 1.4},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {2.0, 1.3},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {2.4, 1.5},
		alpha_tween = {1.0, 0.25},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {1.8, 1.1},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.9, 1.2},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,0",
		blend = "alpha",
		scale_tween = {1.5, 0.9},
		alpha_tween = {1.0, 0.15},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,0",
		blend = "alpha",
		scale_tween = {1.4, 0.8},
		alpha_tween = {1.0, 0.15},
	},
}

texpools.NATURE_BARK_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,1",
		blend = "alpha",
		scale_tween = {2.0, 1.2},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,1",
		blend = "alpha",
		scale_tween = {2.2, 1.3},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,1",
		blend = "alpha",
		scale_tween = {2.5, 1.5},
		alpha_tween = {1.0, 0.4},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,1",
		blend = "alpha",
		scale_tween = {2.4, 1.4},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,1",
		blend = "alpha",
		scale_tween = {2.1, 1.2},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,1",
		blend = "alpha",
		scale_tween = {2.6, 1.6},
		alpha_tween = {1.0, 0.4},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,1",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.25},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,1",
		blend = "alpha",
		scale_tween = {2.0, 1.1},
		alpha_tween = {1.0, 0.25},
	},
}

texpools.NATURE_RUNE_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,2",
		blend = "add",
		scale_tween = {2.0, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,2",
		blend = "add",
		scale_tween = {2.2, 0.7},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,2",
		blend = "add",
		scale_tween = {2.0, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,2",
		blend = "add",
		scale_tween = {2.4, 0.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,2",
		blend = "add",
		scale_tween = {1.8, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,2",
		blend = "add",
		scale_tween = {2.1, 0.7},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,2",
		blend = "add",
		scale_tween = {1.9, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,2",
		blend = "add",
		scale_tween = {2.2, 0.6},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.NATURE_SOIL_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.8, 1.0},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,3",
		blend = "alpha",
		scale_tween = {2.0, 1.1},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {2.3, 1.3},
		alpha_tween = {1.0, 0.25},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,3",
		blend = "alpha",
		scale_tween = {2.5, 1.4},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,3",
		blend = "alpha",
		scale_tween = {1.9, 1.0},
		alpha_tween = {1.0, 0.2},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,3",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.25},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,3",
		blend = "alpha",
		scale_tween = {2.4, 1.3},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,3",
		blend = "alpha",
		scale_tween = {2.6, 1.5},
		alpha_tween = {1.0, 0.3},
	},
}

texpools.NATURE_ROOT_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {2.0, 1.1},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {2.4, 1.3},
		alpha_tween = {1.0, 0.35},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,4",
		blend = "alpha",
		scale_tween = {2.3, 1.2},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,4",
		blend = "alpha",
		scale_tween = {2.1, 1.0},
		alpha_tween = {1.0, 0.25},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,4",
		blend = "alpha",
		scale_tween = {2.5, 1.4},
		alpha_tween = {1.0, 0.35},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,4",
		blend = "alpha",
		scale_tween = {2.2, 1.2},
		alpha_tween = {1.0, 0.3},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,4",
		blend = "alpha",
		scale_tween = {2.4, 1.3},
		alpha_tween = {1.0, 0.35},
	},
}

texpools.NATURE_MOTE_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,5",
		blend = "add",
		scale_tween = {1.8, 0.4},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,5",
		blend = "add",
		scale_tween = {2.0, 0.5},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,5",
		blend = "add",
		scale_tween = {2.2, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,5",
		blend = "add",
		scale_tween = {2.5, 0.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,5",
		blend = "add",
		scale_tween = {1.7, 0.4},
		alpha_tween = {0.85, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,5",
		blend = "add",
		scale_tween = {2.1, 0.5},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,5",
		blend = "add",
		scale_tween = {2.3, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,5",
		blend = "add",
		scale_tween = {2.6, 0.8},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.NATURE_CRACK_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,6",
		blend = "alpha",
		scale_tween = {2.4, 1.4},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,6",
		blend = "alpha",
		scale_tween = {2.6, 1.5},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,6",
		blend = "alpha",
		scale_tween = {2.8, 1.6},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,6",
		blend = "alpha",
		scale_tween = {3.0, 1.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,6",
		blend = "alpha",
		scale_tween = {2.5, 1.4},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,6",
		blend = "alpha",
		scale_tween = {2.7, 1.5},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,6",
		blend = "alpha",
		scale_tween = {2.9, 1.7},
		alpha_tween = {0.95, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,6",
		blend = "alpha",
		scale_tween = {3.2, 1.9},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.NATURE_SLASH_TEXPOOL = {
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:0,7",
		blend = "add",
		scale_tween = {2.5, 0.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:1,7",
		blend = "add",
		scale_tween = {2.6, 0.9},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:2,7",
		blend = "add",
		scale_tween = {2.4, 0.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:3,7",
		blend = "add",
		scale_tween = {2.8, 1.0},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:4,7",
		blend = "add",
		scale_tween = {2.5, 0.8},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:5,7",
		blend = "add",
		scale_tween = {2.7, 0.9},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:6,7",
		blend = "add",
		scale_tween = {2.4, 0.7},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_nature_guardian_particles.png^[sheet:8x8:7,7",
		blend = "add",
		scale_tween = {2.8, 1.0},
		alpha_tween = {1.0, 0.0},
	},
}

--- Spawns quick wooden punch impact sparks and scattering autumn leaves
---@param pos Vector Impact world coordinates
---@param dir? Vector Direction vector of punch force


texpools.GOLEM_SHARD_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,0",
		blend = "alpha",
		scale_tween = {1.5, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,0",
		blend = "alpha",
		scale_tween = {1.6, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,0",
		blend = "alpha",
		scale_tween = {1.8, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:3,0",
		blend = "alpha",
		scale_tween = {1.4, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:4,0",
		blend = "alpha",
		scale_tween = {1.7, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:5,0",
		blend = "alpha",
		scale_tween = {1.5, 0.4},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.GOLEM_RUNE_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,1",
		blend = "add",
		scale_tween = {1.2, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,1",
		blend = "add",
		scale_tween = {1.4, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,1",
		blend = "add",
		scale_tween = {1.3, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:3,1",
		blend = "add",
		scale_tween = {1.1, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:4,1",
		blend = "add",
		scale_tween = {1.5, 0.4},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.GOLEM_SHOCKWAVE_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,2",
		blend = "alpha",
		scale_tween = {1.0, 3.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,2",
		blend = "alpha",
		scale_tween = {1.0, 3.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,2",
		blend = "alpha",
		scale_tween = {1.2, 3.8},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:3,2",
		blend = "alpha",
		scale_tween = {1.2, 4.0},
		alpha_tween = {0.8, 0.0},
	},
}

texpools.GOLEM_EARTH_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,3",
		blend = "alpha",
		scale_tween = {1.4, 0.4},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,3",
		blend = "alpha",
		scale_tween = {1.3, 0.3},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,3",
		blend = "alpha",
		scale_tween = {1.5, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:3,3",
		blend = "alpha",
		scale_tween = {1.2, 0.3},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.GOLEM_DUST_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,4",
		blend = "alpha",
		scale_tween = {0.8, 2.8},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,4",
		blend = "alpha",
		scale_tween = {0.9, 3.2},
		alpha_tween = {0.85, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,4",
		blend = "alpha",
		scale_tween = {1.0, 3.5},
		alpha_tween = {0.8, 0.0},
	},
}

texpools.GOLEM_BOULDER_FRAG_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,5",
		blend = "alpha",
		scale_tween = {1.8, 0.5},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,5",
		blend = "alpha",
		scale_tween = {2.0, 0.6},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,5",
		blend = "alpha",
		scale_tween = {1.6, 0.4},
		alpha_tween = {1.0, 0.0},
	},
}

texpools.GOLEM_LEVITATE_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,6",
		blend = "add",
		scale_tween = {0.8, 2.0},
		alpha_tween = {0.9, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,6",
		blend = "add",
		scale_tween = {0.9, 2.2},
		alpha_tween = {0.85, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,6",
		blend = "add",
		scale_tween = {1.0, 2.5},
		alpha_tween = {0.8, 0.0},
	},
}

texpools.GOLEM_DEATH_EMBER_TEXPOOL = {
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:0,7",
		blend = "add",
		scale_tween = {1.5, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:1,7",
		blend = "add",
		scale_tween = {1.3, 0.2},
		alpha_tween = {1.0, 0.0},
	},
	{
		name = "x_mobs_golem_particles.png^[sheet:8x8:2,7",
		blend = "add",
		scale_tween = {1.4, 0.3},
		alpha_tween = {1.0, 0.0},
	},
}

--- Spawns impact shards and fracture dust when Golem is struck
---@param pos Vector Impact world coordinate
---@param is_pickaxe boolean True if struck with cracky tool (pickaxe)


texpools.SPECTRUM_SHROUD_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,0",
	  blend = "alpha", scale_tween = {1.8, 0.8}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,0",
	  blend = "alpha", scale_tween = {1.9, 0.9}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,0",
	  blend = "alpha", scale_tween = {2.0, 1.0}, alpha_tween = {1.0, 0.25} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,0",
	  blend = "alpha", scale_tween = {1.6, 0.7}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,0",
	  blend = "alpha", scale_tween = {1.7, 0.8}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,0",
	  blend = "alpha", scale_tween = {2.1, 1.0}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,0",
	  blend = "alpha", scale_tween = {1.4, 0.6}, alpha_tween = {0.9, 0.15} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,0",
	  blend = "alpha", scale_tween = {1.2, 0.5}, alpha_tween = {0.8, 0.1} },
}

texpools.SPECTRUM_SPARK_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,1",
	  blend = "add", scale_tween = {1.8, 0.3}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,1",
	  blend = "add", scale_tween = {1.7, 0.4}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,1",
	  blend = "add", scale_tween = {1.9, 0.3}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,1",
	  blend = "add", scale_tween = {1.5, 0.2}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,1",
	  blend = "add", scale_tween = {1.6, 0.3}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,1",
	  blend = "add", scale_tween = {1.8, 0.4}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,1",
	  blend = "add", scale_tween = {1.3, 0.2}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,1",
	  blend = "add", scale_tween = {1.1, 0.1}, alpha_tween = {0.8, 0.0} },
}

texpools.SPECTRUM_GLYPH_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,2",
	  blend = "add", scale_tween = {2.2, 1.0}, alpha_tween = {0.95, 0.1} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,2",
	  blend = "add", scale_tween = {2.0, 0.9}, alpha_tween = {0.90, 0.1} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,2",
	  blend = "add", scale_tween = {2.3, 1.1}, alpha_tween = {0.95, 0.15} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,2",
	  blend = "add", scale_tween = {1.9, 0.8}, alpha_tween = {0.90, 0.1} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,2",
	  blend = "add", scale_tween = {2.1, 1.0}, alpha_tween = {0.90, 0.1} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,2",
	  blend = "add", scale_tween = {1.8, 0.7}, alpha_tween = {0.85, 0.05} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,2",
	  blend = "add", scale_tween = {1.5, 0.6}, alpha_tween = {0.80, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,2",
	  blend = "add", scale_tween = {1.3, 0.4}, alpha_tween = {0.75, 0.0} },
}

texpools.SPECTRUM_CLAW_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,3",
	  blend = "add", scale_tween = {2.6, 1.2}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,3",
	  blend = "add", scale_tween = {2.6, 1.2}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,3",
	  blend = "add", scale_tween = {2.8, 1.4}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,3",
	  blend = "add", scale_tween = {2.5, 1.1}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,3",
	  blend = "add", scale_tween = {2.2, 0.9}, alpha_tween = {0.95, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,3",
	  blend = "alpha", scale_tween = {2.0, 0.8}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,3",
	  blend = "alpha", scale_tween = {1.8, 0.7}, alpha_tween = {0.8, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,3",
	  blend = "alpha", scale_tween = {1.5, 0.5}, alpha_tween = {0.7, 0.0} },
}

texpools.SPECTRUM_SMOKE_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,4",
	  blend = "alpha", scale_tween = {1.6, 3.2}, alpha_tween = {0.85, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,4",
	  blend = "alpha", scale_tween = {1.8, 3.5}, alpha_tween = {0.80, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,4",
	  blend = "alpha", scale_tween = {2.0, 3.8}, alpha_tween = {0.75, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,4",
	  blend = "alpha", scale_tween = {2.2, 4.0}, alpha_tween = {0.70, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,4",
	  blend = "alpha", scale_tween = {1.5, 3.0}, alpha_tween = {0.65, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,4",
	  blend = "alpha", scale_tween = {1.4, 2.8}, alpha_tween = {0.60, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,4",
	  blend = "alpha", scale_tween = {1.2, 2.5}, alpha_tween = {0.55, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,4",
	  blend = "alpha", scale_tween = {1.0, 2.2}, alpha_tween = {0.50, 0.0} },
}

texpools.SPECTRUM_ORB_CORE_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,5",
	  blend = "add", scale_tween = {2.2, 0.6}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,5",
	  blend = "add", scale_tween = {2.2, 0.7}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,5",
	  blend = "add", scale_tween = {2.5, 0.8}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,5",
	  blend = "add", scale_tween = {2.0, 0.5}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,5",
	  blend = "add", scale_tween = {1.9, 0.5}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,5",
	  blend = "add", scale_tween = {1.7, 0.4}, alpha_tween = {0.95, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,5",
	  blend = "add", scale_tween = {1.4, 0.3}, alpha_tween = {0.90, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,5",
	  blend = "add", scale_tween = {1.2, 0.2}, alpha_tween = {0.85, 0.0} },
}

texpools.SPECTRUM_WISP_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,6",
	  blend = "alpha", scale_tween = {1.4, 2.2}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,6",
	  blend = "alpha", scale_tween = {1.4, 2.2}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,6",
	  blend = "add", scale_tween = {1.6, 2.4}, alpha_tween = {0.95, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,6",
	  blend = "alpha", scale_tween = {1.5, 2.3}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,6",
	  blend = "alpha", scale_tween = {1.3, 2.0}, alpha_tween = {0.85, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,6",
	  blend = "alpha", scale_tween = {1.2, 1.8}, alpha_tween = {0.8, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,6",
	  blend = "alpha", scale_tween = {1.0, 1.6}, alpha_tween = {0.75, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,6",
	  blend = "alpha", scale_tween = {0.9, 1.4}, alpha_tween = {0.7, 0.0} },
}

texpools.SPECTRUM_ASH_TEXPOOL = {
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:0,7",
	  blend = "add", scale_tween = {1.8, 0.4}, alpha_tween = {0.95, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:1,7",
	  blend = "add", scale_tween = {1.7, 0.3}, alpha_tween = {0.95, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:2,7",
	  blend = "alpha", scale_tween = {1.6, 0.3}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:3,7",
	  blend = "alpha", scale_tween = {1.5, 0.2}, alpha_tween = {0.85, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:4,7",
	  blend = "alpha", scale_tween = {1.3, 0.2}, alpha_tween = {0.8, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:5,7",
	  blend = "alpha", scale_tween = {1.1, 0.15}, alpha_tween = {0.75, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:6,7",
	  blend = "alpha", scale_tween = {1.0, 0.1}, alpha_tween = {0.7, 0.0} },
	{ name = "x_mobs_spectrum_particles.png^[sheet:8x8:7,7",
	  blend = "alpha", scale_tween = {0.8, 0.05}, alpha_tween = {0.6, 0.0} },
}

--- Spawns floating idle trail behind spectrum mob
---@param pos Vector Position


texpools.ELDER_CLOTH_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,0",
	  blend = "alpha", scale_tween = {1.8, 1.2}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,0",
	  blend = "alpha", scale_tween = {1.6, 1.1}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,0",
	  blend = "alpha", scale_tween = {1.5, 1.0}, alpha_tween = {1.0, 0.5} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,0",
	  blend = "alpha", scale_tween = {1.4, 0.9}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:4,0",
	  blend = "alpha", scale_tween = {1.3, 0.8}, alpha_tween = {1.0, 0.3} },
}

texpools.ELDER_CANE_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,1",
	  blend = "alpha", scale_tween = {1.6, 1.1}, alpha_tween = {1.0, 0.5} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,1",
	  blend = "alpha", scale_tween = {1.5, 1.0}, alpha_tween = {1.0, 0.5} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,1",
	  blend = "alpha", scale_tween = {1.4, 0.9}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,1",
	  blend = "alpha", scale_tween = {1.3, 0.8}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:4,1",
	  blend = "alpha", scale_tween = {1.2, 0.7}, alpha_tween = {1.0, 0.3} },
}

texpools.ELDER_HAIR_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,2",
	  blend = "alpha", scale_tween = {1.5, 1.1}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,2",
	  blend = "alpha", scale_tween = {1.4, 1.0}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,2",
	  blend = "alpha", scale_tween = {1.3, 0.9}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,2",
	  blend = "alpha", scale_tween = {1.2, 0.8}, alpha_tween = {1.0, 0.2} },
}

texpools.ELDER_SPARKS_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,3",
	  blend = "add", scale_tween = {1.8, 0.8}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,3",
	  blend = "add", scale_tween = {1.6, 0.7}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,3",
	  blend = "add", scale_tween = {1.5, 0.6}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,3",
	  blend = "add", scale_tween = {1.4, 0.5}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:4,3",
	  blend = "add", scale_tween = {1.2, 0.4}, alpha_tween = {1.0, 0.1} },
}

texpools.ELDER_SMOKE_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,4",
	  blend = "alpha", scale_tween = {1.5, 3.2}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,4",
	  blend = "alpha", scale_tween = {1.4, 3.0}, alpha_tween = {0.85, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,4",
	  blend = "alpha", scale_tween = {1.3, 2.8}, alpha_tween = {0.8, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,4",
	  blend = "alpha", scale_tween = {1.2, 2.6}, alpha_tween = {0.75, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:4,4",
	  blend = "alpha", scale_tween = {1.0, 2.2}, alpha_tween = {0.7, 0.0} },
}

texpools.ELDER_BLAST_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,5",
	  blend = "add", scale_tween = {2.0, 5.0}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,5",
	  blend = "add", scale_tween = {2.5, 5.5}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,5",
	  blend = "add", scale_tween = {1.8, 4.2}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,5",
	  blend = "add", scale_tween = {1.5, 3.8}, alpha_tween = {0.95, 0.0} },
}

texpools.ELDER_FLAME_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,6",
	  blend = "add", scale_tween = {2.0, 1.2}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,6",
	  blend = "add", scale_tween = {1.8, 1.0}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,6",
	  blend = "add", scale_tween = {1.6, 0.9}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,6",
	  blend = "add", scale_tween = {1.4, 0.8}, alpha_tween = {1.0, 0.1} },
}

texpools.ELDER_DUST_TEXPOOL = {
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:0,7",
	  blend = "alpha", scale_tween = {1.5, 1.0}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:1,7",
	  blend = "alpha", scale_tween = {1.4, 0.9}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:2,7",
	  blend = "alpha", scale_tween = {1.2, 0.8}, alpha_tween = {1.0, 0.4} },
	{ name = "x_mobs_elder_particles.png^[sheet:8x8:3,7",
	  blend = "alpha", scale_tween = {1.0, 0.6}, alpha_tween = {1.0, 0.2} },
}

--- Spawns kinetic hurt recoil debris: robe shreds, cane splinters, and beard hair
---@param pos Vector Center impact position
---@param scale? number Scale multiplier (default 1.0)


texpools.FROSTY_QUEEN_SNOW_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,0",
	  blend = "alpha", scale_tween = {1.2, 0.8}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,0",
	  blend = "alpha", scale_tween = {1.1, 0.7}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,0",
	  blend = "alpha", scale_tween = {1.3, 0.9}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,0",
	  blend = "add", scale_tween = {1.2, 0.6}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:4,0",
	  blend = "alpha", scale_tween = {1.0, 0.6}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:5,0",
	  blend = "add", scale_tween = {1.1, 0.7}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:6,0",
	  blend = "alpha", scale_tween = {0.9, 0.5}, alpha_tween = {0.9, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:7,0",
	  blend = "add", scale_tween = {0.8, 0.4}, alpha_tween = {1.0, 0.1} },
}

texpools.FROSTY_QUEEN_SHARDS_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1",
	  blend = "add", scale_tween = {1.4, 0.8}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,1",
	  blend = "add", scale_tween = {1.3, 0.7}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,1",
	  blend = "add", scale_tween = {1.2, 0.6}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,1",
	  blend = "add", scale_tween = {1.1, 0.5}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:4,1",
	  blend = "add", scale_tween = {1.3, 0.7}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:5,1",
	  blend = "add", scale_tween = {1.0, 0.5}, alpha_tween = {1.0, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:6,1",
	  blend = "add", scale_tween = {0.9, 0.4}, alpha_tween = {0.9, 0.2} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:7,1",
	  blend = "add", scale_tween = {0.8, 0.3}, alpha_tween = {0.9, 0.1} },
}

texpools.FROSTY_QUEEN_MIST_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,2",
	  blend = "alpha", scale_tween = {1.2, 2.8}, alpha_tween = {0.8, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,2",
	  blend = "alpha", scale_tween = {1.3, 3.0}, alpha_tween = {0.75, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,2",
	  blend = "alpha", scale_tween = {1.1, 2.5}, alpha_tween = {0.7, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,2",
	  blend = "alpha", scale_tween = {1.0, 2.2}, alpha_tween = {0.65, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:4,2",
	  blend = "alpha", scale_tween = {0.9, 2.0}, alpha_tween = {0.6, 0.0} },
}

texpools.FROSTY_QUEEN_SPARKLE_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,3",
	  blend = "add", scale_tween = {1.8, 0.6}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,3",
	  blend = "add", scale_tween = {1.6, 0.5}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,3",
	  blend = "add", scale_tween = {1.5, 0.5}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,3",
	  blend = "add", scale_tween = {1.3, 0.4}, alpha_tween = {1.0, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:4,3",
	  blend = "add", scale_tween = {1.2, 0.4}, alpha_tween = {1.0, 0.1} },
}

texpools.FROSTY_QUEEN_CHUNKS_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,4",
	  blend = "alpha", scale_tween = {1.4, 0.9}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,4",
	  blend = "alpha", scale_tween = {1.3, 0.8}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,4",
	  blend = "alpha", scale_tween = {1.2, 0.8}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,4",
	  blend = "alpha", scale_tween = {1.1, 0.7}, alpha_tween = {1.0, 0.3} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:4,4",
	  blend = "alpha", scale_tween = {1.0, 0.6}, alpha_tween = {1.0, 0.3} },
}

texpools.FROSTY_QUEEN_RUNES_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,5",
	  blend = "add", scale_tween = {1.5, 3.5}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,5",
	  blend = "add", scale_tween = {1.8, 4.0}, alpha_tween = {0.9, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,5",
	  blend = "add", scale_tween = {1.6, 3.8}, alpha_tween = {1.0, 0.0} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,5",
	  blend = "add", scale_tween = {1.4, 3.2}, alpha_tween = {0.9, 0.0} },
}

texpools.FROSTY_QUEEN_WISPS_TEXPOOL = {
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:0,7",
	  blend = "add", scale_tween = {1.4, 0.9}, alpha_tween = {0.9, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:1,7",
	  blend = "add", scale_tween = {1.3, 0.8}, alpha_tween = {0.85, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:2,7",
	  blend = "add", scale_tween = {1.2, 0.7}, alpha_tween = {0.8, 0.1} },
	{ name = "x_mobs_frosty_queen_particles.png^[sheet:8x8:3,7",
	  blend = "add", scale_tween = {1.1, 0.6}, alpha_tween = {0.8, 0.1} },
}

--- Spawns ambient sub-zero snowflakes and drifting cold mist around hovering queen
---@param pos Vector Center body position


