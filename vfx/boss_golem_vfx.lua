--[[
	x_mobs - Golem Boss Particle Systems
	Basalt shards, emerald runes, seismic shockwave, dust, earth clods, node raise, and rock shatter
--]]

local texpools = x_mobs.texpools
local GOLEM_SHARD_TEXPOOL = texpools.GOLEM_SHARD_TEXPOOL
local GOLEM_RUNE_TEXPOOL = texpools.GOLEM_RUNE_TEXPOOL
local GOLEM_SHOCKWAVE_TEXPOOL = texpools.GOLEM_SHOCKWAVE_TEXPOOL
local GOLEM_EARTH_TEXPOOL = texpools.GOLEM_EARTH_TEXPOOL
local GOLEM_DUST_TEXPOOL = texpools.GOLEM_DUST_TEXPOOL
local GOLEM_BOULDER_FRAG_TEXPOOL = texpools.GOLEM_BOULDER_FRAG_TEXPOOL
local GOLEM_LEVITATE_TEXPOOL = texpools.GOLEM_LEVITATE_TEXPOOL
local GOLEM_DEATH_EMBER_TEXPOOL = texpools.GOLEM_DEATH_EMBER_TEXPOOL

local get_node_tile_texture = x_mobs.get_node_tile_texture

function x_mobs.spawn_golem_hurt(pos, is_pickaxe)
	if not pos then return end
	local shard_count = is_pickaxe and 26 or 12
	local shard_speed = is_pickaxe and 4.5 or 2.6

	-- Basalt Chunks
	core.add_particlespawner({
		amount = shard_count,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.8, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 2.0, z = pos.z + 0.3},
		},
		vel = {
			min = {x = -shard_speed, y = 1.0, z = -shard_speed},
			max = {x = shard_speed, y = 4.0, z = shard_speed},
		},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -14.0, z = 0}},
		size = {min = 2.0, max = is_pickaxe and 5.2 or 3.6},
		exptime = {min = 0.8, max = 1.6},
		collisiondetection = true,
		collision_removal = false,
		texpool = GOLEM_SHARD_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.8, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 2.0, z = pos.z + 0.3},
		minvel = {x = -shard_speed, y = 1.0, z = -shard_speed},
		maxvel = {x = shard_speed, y = 4.0, z = shard_speed},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -14.0, z = 0},
		minsize = 2.0,
		maxsize = is_pickaxe and 5.2 or 3.6,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,0",
	})

	-- Emerald Runic Motes
	core.add_particlespawner({
		amount = is_pickaxe and 16 or 8,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.25, y = pos.y + 0.9, z = pos.z - 0.25},
			max = {x = pos.x + 0.25, y = pos.y + 1.9, z = pos.z + 0.25},
		},
		vel = {min = {x = -1.8, y = 0.5, z = -1.8}, max = {x = 1.8, y = 2.5, z = 1.8}},
		acc = {min = {x = 0, y = -2.0, z = 0}, max = {x = 0, y = -4.0, z = 0}},
		size = {min = 1.5, max = 3.2},
		exptime = {min = 0.6, max = 1.2},
		glow = 12,
		texpool = GOLEM_RUNE_TEXPOOL,
		minpos = {x = pos.x - 0.25, y = pos.y + 0.9, z = pos.z - 0.25},
		maxpos = {x = pos.x + 0.25, y = pos.y + 1.9, z = pos.z + 0.25},
		minvel = {x = -1.8, y = 0.5, z = -1.8},
		maxvel = {x = 1.8, y = 2.5, z = 1.8},
		minacc = {x = 0, y = -2.0, z = 0},
		maxacc = {x = 0, y = -4.0, z = 0},
		minsize = 1.5,
		maxsize = 3.2,
		minexptime = 0.6,
		maxexptime = 1.2,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,1",
	})

	-- Impact Dust Cloud
	core.add_particlespawner({
		amount = 10,
		time = 0.15,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y + 0.7, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 1.8, z = pos.z + 0.3},
		},
		vel = {min = {x = -0.8, y = -0.2, z = -0.8}, max = {x = 0.8, y = 0.8, z = 0.8}},
		acc = {min = {x = 0, y = -0.2, z = 0}, max = {x = 0, y = -0.5, z = 0}},
		size = {min = 2.4, max = 4.2},
		exptime = {min = 0.8, max = 1.5},
		texpool = GOLEM_DUST_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y + 0.7, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 1.8, z = pos.z + 0.3},
		minvel = {x = -0.8, y = -0.2, z = -0.8},
		maxvel = {x = 0.8, y = 0.8, z = 0.8},
		minacc = {x = 0, y = -0.2, z = 0},
		maxacc = {x = 0, y = -0.5, z = 0},
		minsize = 2.4,
		maxsize = 4.2,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns close-quarters fist impact particles
---@param pos Vector Fist contact point
function x_mobs.spawn_golem_punch(pos)
	if not pos then return end
	core.add_particlespawner({
		amount = 14,
		time = 0.12,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {min = {x = -2.2, y = -1.0, z = -2.2}, max = {x = 2.2, y = 2.5, z = 2.2}},
		acc = {min = {x = 0, y = -8.0, z = 0}, max = {x = 0, y = -12.0, z = 0}},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 0.5, max = 1.1},
		collisiondetection = true,
		texpool = GOLEM_SHARD_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = -2.2, y = -1.0, z = -2.2},
		maxvel = {x = 2.2, y = 2.5, z = 2.2},
		minacc = {x = 0, y = -8.0, z = 0},
		maxacc = {x = 0, y = -12.0, z = 0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 0.5,
		maxexptime = 1.1,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,0",
	})
end

--- Spawns full ground smash wave with radial shockwave and terrain debris mapping
---@param pos Vector Ground impact center
---@param ground_node table Sampled terrain node
---@param radius number Blast radius (e.g. 4.0)
function x_mobs.spawn_golem_smash_wave(pos, ground_node, radius)
	if not pos then return end
	local rad = radius or 4.0
	local node_info = ground_node or x_mobs.sample_ground_node(pos)
	local node_name = (node_info and node_info.name) or "default:stone"
	local tile_tex = get_node_tile_texture(node_name)
	local h_vel = 4.2 * (rad / 3.0)

	-- 1. Radial Ground Shockwave
	core.add_particlespawner({
		amount = 36,
		time = 0.20,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 0.25, z = pos.z + 0.5},
		},
		vel = {
			min = {x = -h_vel, y = 0.02, z = -h_vel},
			max = {x = h_vel, y = 0.3, z = h_vel},
		},
		acc = {min = {x = 0, y = -1.0, z = 0}, max = {x = 0, y = -2.0, z = 0}},
		size = {min = 3.0, max = 5.5},
		exptime = {min = 0.6, max = 1.1},
		collisiondetection = false,
		texpool = GOLEM_SHOCKWAVE_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.05, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 0.25, z = pos.z + 0.5},
		minvel = {x = -h_vel, y = 0.02, z = -h_vel},
		maxvel = {x = h_vel, y = 0.3, z = h_vel},
		minacc = {x = 0, y = -1.0, z = 0},
		maxacc = {x = 0, y = -2.0, z = 0},
		minsize = 3.0,
		maxsize = 5.5,
		minexptime = 0.6,
		maxexptime = 1.1,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,2",
	})

	-- 2. Terrain Debris Ejection (using sampled node texture)
	core.add_particlespawner({
		amount = 32,
		time = 0.25,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		},
		vel = {
			min = {x = -3.8, y = 3.0, z = -3.8},
			max = {x = 3.8, y = 7.0, z = 3.8},
		},
		acc = {min = {x = 0, y = -12.0, z = 0}, max = {x = 0, y = -18.0, z = 0}},
		size = {min = 2.0, max = 4.2},
		exptime = {min = 0.9, max = 1.8},
		collisiondetection = true,
		collision_removal = false,
		node = {name = node_name, param2 = (node_info and node_info.param2) or 0},
		minpos = {x = pos.x - 0.6, y = pos.y + 0.1, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 0.5, z = pos.z + 0.6},
		minvel = {x = -3.8, y = 3.0, z = -3.8},
		maxvel = {x = 3.8, y = 7.0, z = 3.8},
		minacc = {x = 0, y = -12.0, z = 0},
		maxacc = {x = 0, y = -18.0, z = 0},
		minsize = 2.0,
		maxsize = 4.2,
		minexptime = 0.9,
		maxexptime = 1.8,
		texture = tile_tex,
	})

	-- 3. Runic Energy Burst
	core.add_particlespawner({
		amount = 20,
		time = 0.18,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		},
		vel = {min = {x = -2.5, y = 1.5, z = -2.5}, max = {x = 2.5, y = 4.5, z = 2.5}},
		acc = {min = {x = 0, y = -4.0, z = 0}, max = {x = 0, y = -8.0, z = 0}},
		size = {min = 1.8, max = 3.5},
		exptime = {min = 0.7, max = 1.4},
		glow = 12,
		texpool = GOLEM_RUNE_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y + 0.1, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.8, z = pos.z + 0.4},
		minvel = {x = -2.5, y = 1.5, z = -2.5},
		maxvel = {x = 2.5, y = 4.5, z = 2.5},
		minacc = {x = 0, y = -4.0, z = 0},
		maxacc = {x = 0, y = -8.0, z = 0},
		minsize = 1.8,
		maxsize = 3.5,
		minexptime = 0.7,
		maxexptime = 1.4,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,1",
	})
end

--- Spawns ground rupture and levitation motes when a node is pulled from the earth
---@param pos Vector Ground emergence position
---@param ground_node table Sampled terrain node
function x_mobs.spawn_golem_node_raise(pos, ground_node)
	if not pos then return end
	local node_info = ground_node or x_mobs.sample_ground_node(pos)
	local node_name = (node_info and node_info.name) or "default:stone"
	local tile_tex = get_node_tile_texture(node_name)

	-- Subterranean Clods & Earth Fragments
	core.add_particlespawner({
		amount = 22,
		time = 0.35,
		pos = {
			min = {x = pos.x - 0.45, y = pos.y - 0.1, z = pos.z - 0.45},
			max = {x = pos.x + 0.45, y = pos.y + 0.3, z = pos.z + 0.45},
		},
		vel = {min = {x = -1.2, y = 2.2, z = -1.2}, max = {x = 1.2, y = 4.5, z = 1.2}},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -14.0, z = 0}},
		size = {min = 1.8, max = 3.8},
		exptime = {min = 0.8, max = 1.5},
		collisiondetection = true,
		texpool = GOLEM_EARTH_TEXPOOL,
		minpos = {x = pos.x - 0.45, y = pos.y - 0.1, z = pos.z - 0.45},
		maxpos = {x = pos.x + 0.45, y = pos.y + 0.3, z = pos.z + 0.45},
		minvel = {x = -1.2, y = 2.2, z = -1.2},
		maxvel = {x = 1.2, y = 4.5, z = 1.2},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -14.0, z = 0},
		minsize = 1.8,
		maxsize = 3.8,
		minexptime = 0.8,
		maxexptime = 1.5,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,3",
	})

	-- Sampled Terrain Bits
	core.add_particlespawner({
		amount = 16,
		time = 0.30,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.25, z = pos.z + 0.4},
		},
		vel = {min = {x = -1.5, y = 1.8, z = -1.5}, max = {x = 1.5, y = 3.8, z = 1.5}},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -12.0, z = 0}},
		size = {min = 1.6, max = 3.2},
		exptime = {min = 0.7, max = 1.3},
		collisiondetection = true,
		minpos = {x = pos.x - 0.4, y = pos.y, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.25, z = pos.z + 0.4},
		minvel = {x = -1.5, y = 1.8, z = -1.5},
		maxvel = {x = 1.5, y = 3.8, z = 1.5},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -12.0, z = 0},
		minsize = 1.6,
		maxsize = 3.2,
		minexptime = 0.7,
		maxexptime = 1.3,
		texture = tile_tex,
	})

	-- Runic Levitation Ring Motes
	core.add_particlespawner({
		amount = 18,
		time = 0.50,
		pos = {
			min = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
			max = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		},
		vel = {min = {x = -0.4, y = 1.4, z = -0.4}, max = {x = 0.4, y = 2.8, z = 0.4}},
		acc = {min = {x = 0, y = 0.2, z = 0}, max = {x = 0, y = 0.8, z = 0}},
		size = {min = 2.0, max = 3.8},
		exptime = {min = 0.8, max = 1.6},
		glow = 12,
		texpool = GOLEM_LEVITATE_TEXPOOL,
		minpos = {x = pos.x - 0.5, y = pos.y + 0.1, z = pos.z - 0.5},
		maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
		minvel = {x = -0.4, y = 1.4, z = -0.4},
		maxvel = {x = 0.4, y = 2.8, z = 0.4},
		minacc = {x = 0, y = 0.2, z = 0},
		maxacc = {x = 0, y = 0.8, z = 0},
		minsize = 2.0,
		maxsize = 3.8,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,6",
	})
end

--- Spawns trailing dust and crumbling motes behind the flying boulder
---@param pos Vector Current projectile position
---@param vel Vector Current projectile velocity
function x_mobs.spawn_golem_rock_trail(pos, vel)
	if not pos then return end
	local opp_x = (vel and vel.x and -vel.x * 0.15) or 0
	local opp_y = (vel and vel.y and -vel.y * 0.15) or 0
	local opp_z = (vel and vel.z and -vel.z * 0.15) or 0

	core.add_particlespawner({
		amount = 4,
		time = 0.05,
		pos = {
			min = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
			max = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		},
		vel = {
			min = {x = opp_x - 0.3, y = opp_y - 0.3, z = opp_z - 0.3},
			max = {x = opp_x + 0.3, y = opp_y + 0.3, z = opp_z + 0.3},
		},
		acc = {min = {x = 0, y = -1.0, z = 0}, max = {x = 0, y = -3.0, z = 0}},
		size = {min = 1.4, max = 2.8},
		exptime = {min = 0.4, max = 0.8},
		texpool = GOLEM_DUST_TEXPOOL,
		minpos = {x = pos.x - 0.2, y = pos.y - 0.2, z = pos.z - 0.2},
		maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
		minvel = {x = opp_x - 0.3, y = opp_y - 0.3, z = opp_z - 0.3},
		maxvel = {x = opp_x + 0.3, y = opp_y + 0.3, z = opp_z + 0.3},
		minacc = {x = 0, y = -1.0, z = 0},
		maxacc = {x = 0, y = -3.0, z = 0},
		minsize = 1.4,
		maxsize = 2.8,
		minexptime = 0.4,
		maxexptime = 0.8,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns rock shattering particles and dust cloud on projectile impact
---@param pos Vector Impact coordinate
---@param node_name string Name of the sampled node
function x_mobs.spawn_golem_rock_shatter(pos, node_name)
	if not pos then return end
	local tile_tex = get_node_tile_texture(node_name)

	-- 1. Sampled Node Shards
	core.add_particlespawner({
		amount = 28,
		time = 0.20,
		pos = {
			min = {x = pos.x - 0.35, y = pos.y - 0.35, z = pos.z - 0.35},
			max = {x = pos.x + 0.35, y = pos.y + 0.35, z = pos.z + 0.35},
		},
		vel = {min = {x = -4.5, y = 1.0, z = -4.5}, max = {x = 4.5, y = 5.5, z = 4.5}},
		acc = {min = {x = 0, y = -12.0, z = 0}, max = {x = 0, y = -18.0, z = 0}},
		size = {min = 2.2, max = 4.6},
		exptime = {min = 0.8, max = 1.6},
		collisiondetection = true,
		collision_removal = false,
		minpos = {x = pos.x - 0.35, y = pos.y - 0.35, z = pos.z - 0.35},
		maxpos = {x = pos.x + 0.35, y = pos.y + 0.35, z = pos.z + 0.35},
		minvel = {x = -4.5, y = 1.0, z = -4.5},
		maxvel = {x = 4.5, y = 5.5, z = 4.5},
		minacc = {x = 0, y = -12.0, z = 0},
		maxacc = {x = 0, y = -18.0, z = 0},
		minsize = 2.2,
		maxsize = 4.6,
		minexptime = 0.8,
		maxexptime = 1.6,
		texture = tile_tex,
	})

	-- 2. Heavy Boulder Fragments
	core.add_particlespawner({
		amount = 18,
		time = 0.18,
		pos = {
			min = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
			max = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		},
		vel = {min = {x = -3.5, y = 1.5, z = -3.5}, max = {x = 3.5, y = 4.5, z = 3.5}},
		acc = {min = {x = 0, y = -10.0, z = 0}, max = {x = 0, y = -16.0, z = 0}},
		size = {min = 2.5, max = 5.0},
		exptime = {min = 0.7, max = 1.4},
		collisiondetection = true,
		texpool = GOLEM_BOULDER_FRAG_TEXPOOL,
		minpos = {x = pos.x - 0.3, y = pos.y - 0.3, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 0.3, z = pos.z + 0.3},
		minvel = {x = -3.5, y = 1.5, z = -3.5},
		maxvel = {x = 3.5, y = 4.5, z = 3.5},
		minacc = {x = 0, y = -10.0, z = 0},
		maxacc = {x = 0, y = -16.0, z = 0},
		minsize = 2.5,
		maxsize = 5.0,
		minexptime = 0.7,
		maxexptime = 1.4,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,5",
	})

	-- 3. Shatter Dust Veil
	core.add_particlespawner({
		amount = 16,
		time = 0.22,
		pos = {
			min = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
			max = {x = pos.x + 0.4, y = pos.y + 0.5, z = pos.z + 0.4},
		},
		vel = {min = {x = -1.8, y = 0.2, z = -1.8}, max = {x = 1.8, y = 1.6, z = 1.8}},
		acc = {min = {x = 0, y = -0.5, z = 0}, max = {x = 0, y = -1.2, z = 0}},
		size = {min = 3.0, max = 5.5},
		exptime = {min = 0.9, max = 1.7},
		texpool = GOLEM_DUST_TEXPOOL,
		minpos = {x = pos.x - 0.4, y = pos.y - 0.2, z = pos.z - 0.4},
		maxpos = {x = pos.x + 0.4, y = pos.y + 0.5, z = pos.z + 0.4},
		minvel = {x = -1.8, y = 0.2, z = -1.8},
		maxvel = {x = 1.8, y = 1.6, z = 1.8},
		minacc = {x = 0, y = -0.5, z = 0},
		maxacc = {x = 0, y = -1.2, z = 0},
		minsize = 3.0,
		maxsize = 5.5,
		minexptime = 0.9,
		maxexptime = 1.7,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,4",
	})
end

--- Spawns complete structural collapse VFX on Golem death
---@param pos Vector Golem death origin coordinate
function x_mobs.spawn_golem_death(pos)
	if not pos then return end

	-- Collapsing Basalt Chunks
	core.add_particlespawner({
		amount = 45,
		time = 0.6,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.3, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 2.5, z = pos.z + 0.8},
		},
		vel = {min = {x = -3.2, y = 1.2, z = -3.2}, max = {x = 3.2, y = 4.8, z = 3.2}},
		acc = {min = {x = 0, y = -9.81, z = 0}, max = {x = 0, y = -15.0, z = 0}},
		size = {min = 2.5, max = 5.5},
		exptime = {min = 1.2, max = 2.4},
		collisiondetection = true,
		collision_removal = false,
		texpool = GOLEM_SHARD_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + 0.3, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 2.5, z = pos.z + 0.8},
		minvel = {x = -3.2, y = 1.2, z = -3.2},
		maxvel = {x = 3.2, y = 4.8, z = 3.2},
		minacc = {x = 0, y = -9.81, z = 0},
		maxacc = {x = 0, y = -15.0, z = 0},
		minsize = 2.5,
		maxsize = 5.5,
		minexptime = 1.2,
		maxexptime = 2.4,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,0",
	})

	-- Dissipating Runic Soul Embers
	core.add_particlespawner({
		amount = 30,
		time = 0.8,
		pos = {
			min = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
			max = {x = pos.x + 0.6, y = pos.y + 2.4, z = pos.z + 0.6},
		},
		vel = {min = {x = -0.8, y = 1.2, z = -0.8}, max = {x = 0.8, y = 3.2, z = 0.8}},
		acc = {min = {x = 0, y = 0.4, z = 0}, max = {x = 0, y = 1.2, z = 0}},
		size = {min = 1.8, max = 3.6},
		exptime = {min = 1.5, max = 2.8},
		glow = 14,
		texpool = GOLEM_DEATH_EMBER_TEXPOOL,
		minpos = {x = pos.x - 0.6, y = pos.y + 0.5, z = pos.z - 0.6},
		maxpos = {x = pos.x + 0.6, y = pos.y + 2.4, z = pos.z + 0.6},
		minvel = {x = -0.8, y = 1.2, z = -0.8},
		maxvel = {x = 0.8, y = 3.2, z = 0.8},
		minacc = {x = 0, y = 0.4, z = 0},
		maxacc = {x = 0, y = 1.2, z = 0},
		minsize = 1.8,
		maxsize = 3.6,
		minexptime = 1.5,
		maxexptime = 2.8,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,7",
	})

	-- Massive Dust Veil
	core.add_particlespawner({
		amount = 25,
		time = 0.5,
		pos = {
			min = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
			max = {x = pos.x + 0.8, y = pos.y + 1.6, z = pos.z + 0.8},
		},
		vel = {min = {x = -1.4, y = 0.2, z = -1.4}, max = {x = 1.4, y = 1.5, z = 1.4}},
		acc = {min = {x = 0, y = -0.3, z = 0}, max = {x = 0, y = -0.8, z = 0}},
		size = {min = 3.5, max = 6.5},
		exptime = {min = 1.2, max = 2.2},
		texpool = GOLEM_DUST_TEXPOOL,
		minpos = {x = pos.x - 0.8, y = pos.y + 0.2, z = pos.z - 0.8},
		maxpos = {x = pos.x + 0.8, y = pos.y + 1.6, z = pos.z + 0.8},
		minvel = {x = -1.4, y = 0.2, z = -1.4},
		maxvel = {x = 1.4, y = 1.5, z = 1.4},
		minacc = {x = 0, y = -0.3, z = 0},
		maxacc = {x = 0, y = -0.8, z = 0},
		minsize = 3.5,
		maxsize = 6.5,
		minexptime = 1.2,
		maxexptime = 2.2,
		texture = "x_mobs_golem_particles.png^[sheet:8x8:0,4",
	})
end
