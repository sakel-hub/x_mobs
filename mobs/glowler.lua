--[[
	x_mobs - Glowler Dragon Leader
	Author: SaKeL
	License: MIT

	Majestic aerial draconic leader mob that hovers aloft and commands a retinue
	of bioluminescent Glow Bug minions. Functions with tactical backline positioning
	analogous to the Fallen Shaman, maintaining standoff distance, summoning
	interposing meat-shields, and firing cyan plasma bursts with a 20% chance
	to unleash a catastrophic Supernova Nova blast.
--]]

local STANDOFF_MIN = 8.0
local STANDOFF_MAX = 14.0
local PLASMA_RANGE = 20.0
local PLASMA_SPEED = 16.0
local SUPERNOVA_SPEED = 12.0

local function get_minion_status(self)
	local alive_count = x_mob_core.clean_followers(self)
	local fleeing_count = 0
	local followers = self.pack_followers or self.minions or {}
	for i = 1, #followers do
		local m_obj = followers[i]
		if m_obj and m_obj:is_valid() then
			local m_ent = m_obj:get_luaentity()
			if m_ent and (m_ent.state == "fleeing" or
					(m_ent.panic_timer and m_ent.panic_timer > 0) or
					(m_ent.memory and m_ent.memory.flee_state)) then
				fleeing_count = fleeing_count + 1
			end
		end
	end
	return alive_count, fleeing_count
end

--- Spawns an interposing meat-shield minion between Glowler and target
---@param self table Mob entity instance
---@return ObjectRef|nil m_obj Spawned minion object or nil
local function spawn_resurrected_minion(self)
	x_mob_core.adopt_nearby_orphans(self, 32.0)
	local count = x_mob_core.clean_followers(self)
	local max_minions = self.pack_max_followers or 3
	if count >= max_minions then
		return nil
	end

	local pos = self.object and self.object:is_valid() and self.object:get_pos()
	if not pos then return nil end

	local tpos = self.target and x_mob_core.is_player_alive(self.target) and self.target:get_pos()
	local cpos
	local to_target

	if tpos then
		to_target = vector.direction(pos, tpos)
		to_target.y = 0
		local len = math.sqrt(to_target.x * to_target.x + to_target.z * to_target.z)
		if len > 0.01 then
			to_target = {x = to_target.x / len, y = 0, z = to_target.z / len}
		else
			to_target = {x = 0, y = 0, z = 1}
		end
		-- Spawn 1.8 blocks ahead directly between Glowler and player
		cpos = {
			x = pos.x + to_target.x * 1.8 + (math.random() - 0.5) * 0.4,
			y = pos.y,
			z = pos.z + to_target.z * 1.8 + (math.random() - 0.5) * 0.4,
		}
	else
		cpos = {x = pos.x + math.random(-2, 2), y = pos.y, z = pos.z + math.random(-2, 2)}
	end

	-- Obstacle avoidance: prevent minion spawning inside solid blocks
	cpos = x_mob_core.avoid_solid_nodes(cpos, pos, to_target)

	if not self.pack_id then
		self.pack_id = x_mob_core.generate_uuid()
	end
	local minion_static = core.serialize({hp = 16, pack_id = self.pack_id, is_follower = true})
	local m_obj = core.add_entity(cpos, "x_mobs:glowler_minion", minion_static)
	if m_obj and m_obj:is_valid() then
		x_mob_core.add_follower(self, m_obj)
		if self.target then
			local m_ent = m_obj:get_luaentity()
			if m_ent then
				m_ent.target = self.target
				m_ent.state = "walk"
			end
			if tpos and to_target then
				local yaw = core.dir_to_yaw(to_target)
				m_obj:set_yaw(yaw)
				if m_ent then
					m_ent._cur_rot = {x = 0, y = yaw, z = 0}
				end
			end
			x_mob_core.rally_followers(self, self.target)
		end
		x_mobs.spawn_glowler_summon_burst(cpos)
		x_mob_core.play_sound(self, "summon", {pos = cpos, gain = 1.0, distance = 24.0})
		self.cooldowns.resurrect = 4.0
		return m_obj
	end

	self.cooldowns.resurrect = 1.5
	return nil
end

-- ============================================================================
-- Standard Plasma Projectile (80% Basic Shot)
-- ============================================================================

core.register_entity("x_mobs:glowler_plasma", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_glowler_particles.png^[sheet:8x8:0,0"},
		visual_size = {x = 0.65, y = 0.65},
		glow = 14,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "dragon", "glowler" },

	on_activate = function(self, _staticdata, _dtime_s)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {0, 0, 0, 0, 0, 0},
			collide_with_objects = false,
		})
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_rightclick = function(_self, _clicker)
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			lifetime = 5.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_glowler_plasma_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 8, fire = 2},
				}, dir)
				proj._punched_direct = hit_obj

				-- Apply bioluminescent radiant ignite DoT
				x_mob_core.apply_status_effect(hit_obj, {
					id = "glow_ignite",
					type = "dot",
					chance = 0.25,
					duration = 5.0,
					damage = 1,
					interval = 1.0,
					damage_type = "fleshy",
					caster = source,
					penetrate_armor = true,
					cleanse_in_water = true,
					envelop_texture = "x_mobs_fire_envelop.png^[colorize:#00ffff:120",
					particles = {
						amount = 8,
						time = 0,
						minpos = {x = -0.25, y = 0.2, z = -0.25},
						maxpos = {x = 0.25, y = 1.0, z = 0.25},
						minvel = {x = -0.15, y = 0.4, z = -0.15},
						maxvel = {x = 0.15, y = 1.2, z = 0.15},
						minacc = {x = 0, y = 0.5, z = 0},
						maxacc = {x = 0, y = 1.0, z = 0},
						texture = "x_mob_core_sparkle.png^[colorize:#00ffff:200",
						glow = 14,
					},
				})
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_glowler_plasma_impact(hit_pos)
				core.sound_play("x_mobs_glowler_shoot", {pos = hit_pos, gain = 0.9, max_hear_distance = 24}, true)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Splash damage in 2.5m radius
				local objs = core.get_objects_inside_radius(hit_pos, 2.5)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						if dir.x == 0 and dir.y == 0 and dir.z == 0 then
							dir = {x = 0, y = 1, z = 0}
						end
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = {fleshy = 6, fire = 2},
						}, dir)

						x_mob_core.apply_status_effect(obj, {
							id = "glow_ignite",
							type = "dot",
							chance = 0.20,
							duration = 4.0,
							damage = 1,
							interval = 1.0,
							damage_type = "fleshy",
							caster = source,
							penetrate_armor = true,
							cleanse_in_water = true,
							envelop_texture = "x_mobs_fire_envelop.png^[colorize:#00ffff:120",
						})
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- Unique Supernova Nova Projectile (20% Spell Shot)
-- ============================================================================

core.register_entity("x_mobs:glowler_supernova", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_glowler_particles.png^[sheet:8x8:0,3"},
		visual_size = {x = 1.1, y = 1.1},
		glow = 14,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "dragon", "glowler" },

	on_activate = function(self, _staticdata, _dtime_s)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {0, 0, 0, 0, 0, 0},
			collide_with_objects = false,
		})
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_rightclick = function(_self, _clicker)
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			lifetime = 6.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_glowler_supernova_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 14, fire = 4},
				}, dir)
				proj._punched_direct = hit_obj

				-- Concussive knockback impulse
				if hit_obj.add_velocity then
					hit_obj:add_velocity({x = dir.x * 6.0, y = 2.4, z = dir.z * 6.0})
				end

				-- Powerful solar supernova burn DoT
				x_mob_core.apply_status_effect(hit_obj, {
					id = "supernova_blaze",
					type = "dot",
					chance = 0.60,
					duration = 6.0,
					damage = 2,
					interval = 1.0,
					damage_type = "fleshy",
					caster = source,
					penetrate_armor = true,
					cleanse_in_water = true,
					envelop_texture = "x_mobs_fire_envelop.png^[colorize:#ffaa00:150",
					hud_vignette = "x_mob_core_vignette.png^[colorize:#ffcc0088",
					particles = x_mobs.get_supernova_blaze_attached_spawner(),
				})
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_glowler_supernova_impact(hit_pos)
				core.sound_play("x_mobs_glowler_spell", {pos = hit_pos, gain = 1.0, max_hear_distance = 32}, true)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Massive 4.0m radius radiant shockwave detonation
				local objs = core.get_objects_inside_radius(hit_pos, 4.0)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						if dir.x == 0 and dir.y == 0 and dir.z == 0 then
							dir = {x = 0, y = 1, z = 0}
						end
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = {fleshy = 10, fire = 3},
						}, dir)

						if obj.add_velocity then
							obj:add_velocity({x = dir.x * 5.0, y = 2.0, z = dir.z * 5.0})
						end

						x_mob_core.apply_status_effect(obj, {
							id = "supernova_blaze",
							type = "dot",
							chance = 0.50,
							duration = 5.0,
							damage = 2,
							interval = 1.0,
							damage_type = "fleshy",
							caster = source,
							penetrate_armor = true,
							cleanse_in_water = true,
							envelop_texture = "x_mobs_fire_envelop.png^[colorize:#ffaa00:150",
							hud_vignette = "x_mob_core_vignette.png^[colorize:#ffcc0088",
						})
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- Glowler Boss Entity Registration
-- ============================================================================

x_mob_core.register_mob("x_mobs:glowler", {
	initial_properties = {
		hp_max = 90,
		mesh = "x_mobs_glowler.glb",
		textures = {
			"x_mobs_glowler.png",
		},
		-- Luanti glTF scaling: 10 units = 1 node. At {x=1, y=1}, 23-unit wingspan = 2.3 blocks
		visual_size = {x = 1.0, y = 1.0},
		collisionbox = {-0.8, 0.0, -0.8, 0.8, 1.2, 0.8},
		glow = 4,
	},

	armor_groups = { fleshy = 85 },
	factions = { "dragon", "glowler", "airborne" },
	wander_radius = 10.0,
	attack_range = 2.6,
	is_floating = true,
	hover_offset = 1.6,
	walk_speed = 3.6,
	pursuit_speed = 5.2,
	wander_speed = 2.0,
	flee_speed = 5.0,
	death_duration = 1.88,
	damage_effect = { type = "none" },

	health_regen = {
		flee_threshold = 24,
		rate = 2.0,
	},

	drops = {
		{ name = "default:diamond",               min = 1, max = 1, chance = 0.35 },
		{ name = "default:mese_crystal",          min = 1, max = 2, chance = 0.65 },
		{ name = "default:gold_ingot",            min = 1, max = 2, chance = 0.40 },
		{ name = "default:gold_lump",             min = 2, max = 4, chance = 0.75 },
		{ name = "default:flint",                 min = 1, max = 3, chance = 0.60 },
		{ name = "default:clay_lump",             min = 2, max = 4, chance = 0.50 },
		{ name = "vessels:glass_bottle",          min = 1, max = 2, chance = 0.40 },
		{ name = "farming:string",                min = 2, max = 4, chance = 0.70 },
	},

	pack = {
		role = "leader",
		follower_type = "x_mobs:glowler_minion",
		max_followers = 3,
		spawn_on_init = true,
	},

	buffs = {
		auras = {
			{
				id = "solar_radiance",
				interval = 6.0,
				radius = 22.0,
				target = "pack_followers",
				effect = "solar_surge",
				sound = "x_mobs_glowler_spell",
				vfx = function(pos)
					core.add_particlespawner({
						amount = 16,
						time = 0.15,
						pos = {
							min = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
							max = {x = pos.x + 0.5, y = pos.y + 0.8, z = pos.z + 0.5},
						},
						vel = { min = {x = -2.0, y = 0.5, z = -2.0}, max = {x = 2.0, y = 1.5, z = 2.0} },
						acc = { min = {x = -0.5, y = 0.1, z = -0.5}, max = {x = 0.5, y = 0.5, z = 0.5} },
						size = { min = 1.5, max = 2.5 },
						exptime = { min = 0.6, max = 1.0 },
						minpos = {x = pos.x - 0.5, y = pos.y + 0.2, z = pos.z - 0.5},
						maxpos = {x = pos.x + 0.5, y = pos.y + 0.8, z = pos.z + 0.5},
						minvel = {x = -2.0, y = 0.5, z = -2.0},
						maxvel = {x = 2.0, y = 1.5, z = 2.0},
						minsize = 1.5,
						maxsize = 2.5,
						minexptime = 0.6,
						maxexptime = 1.0,
						texture = "x_mobs_radiance_envelop.png",
						glow = 14,
						collisiondetection = false,
					})
				end,
			},
		},
		thresholds = {
			{
				id = "draconic_fury",
				hp_ratio = 0.35,
				cleanse = true,
				effect = "frenzy",
				sound = "x_mobs_glowler_spell",
				vfx = function(pos)
					core.add_particlespawner({
						amount = 24,
						time = 0.2,
						pos = {
							min = {x = pos.x - 0.8, y = pos.y, z = pos.z - 0.8},
							max = {x = pos.x + 0.8, y = pos.y + 1.5, z = pos.z + 0.8},
						},
						vel = { min = {x = -3.0, y = 1.0, z = -3.0}, max = {x = 3.0, y = 4.0, z = 3.0} },
						acc = { min = {x = -1.0, y = -1.0, z = -1.0}, max = {x = 1.0, y = 0.5, z = 1.0} },
						size = { min = 2.0, max = 3.5 },
						exptime = { min = 0.8, max = 1.4 },
						minpos = {x = pos.x - 0.8, y = pos.y, z = pos.z - 0.8},
						maxpos = {x = pos.x + 0.8, y = pos.y + 1.5, z = pos.z + 0.8},
						minvel = {x = -3.0, y = 1.0, z = -3.0},
						maxvel = {x = 3.0, y = 4.0, z = 3.0},
						minsize = 2.0,
						maxsize = 3.5,
						minexptime = 0.8,
						maxexptime = 1.4,
						texture = "x_mobs_frenzy_envelop.png",
						glow = 14,
						collisiondetection = false,
					})
				end,
			},
		},
	},

	cooldowns = {
		cast = 2.0,
		resurrect = 3.0,
	},

	sounds = {
		distance = 24.0,
		random = "x_mobs_glowler",
		attack = { name = "x_mobs_glowler_attack", gain = 0.9, pitch = 1.0 },
		shoot  = { name = "x_mobs_glowler_shoot",  gain = 0.9, pitch = 1.0 },
		hurt   = { name = "x_mobs_glowler_hurt",   gain = 0.85, pitch = 1.0 },
		death  = { name = "x_mobs_glowler_death",  gain = 1.0, pitch = 1.0 },
		summon = { name = "x_mobs_glowler_summon", gain = 1.0, pitch = 1.0 },
	},

	vfx = {
		hurt = { type = "glowler_hurt", scale = 1.0 },
		death = { type = "glowler_death", scale = 1.2 },
	},

	animations = {
		idle      = {track = "idle",      speed = 1.0, loop = true},
		walk      = {track = "walk",      speed = 1.0, loop = true},
		run       = {track = "run",       speed = 1.2, loop = true},
		attack    = {track = "attack",    speed = 1.2, loop = false},
		shoot     = {track = "shoot",     speed = 1.0, loop = false},
		death     = {track = "death",     speed = 1.0, loop = false},
	},

	bones = {
		Body          = { pivot = { x = 0, y = 0.6, z = 0 } },
		Head          = { pivot = { x = 0, y = 1.2, z = 1.0 } },
		Neck          = { pivot = { x = 0, y = 0.9, z = 0.5 } },
		Jaw           = { pivot = { x = 0, y = 1.0, z = 1.2 } },
		Arm_Left      = { pivot = { x = -1.2, y = 0.8, z = 0.2 } },
		Arm_Right     = { pivot = { x = 1.2, y = 0.8, z = 0.2 } },
		Leg_Left      = { pivot = { x = -0.4, y = 0.4, z = -0.4 } },
		Leg_Right     = { pivot = { x = 0.4, y = 0.4, z = -0.4 } },
		Tail          = { pivot = { x = 0, y = 0.5, z = -0.8 } },
		Tail_Fin      = { pivot = { x = 0, y = 0.5, z = -1.6 } },
		Spines        = { pivot = { x = 0, y = 1.0, z = 0 } },
		Back          = { pivot = { x = 0, y = 0.8, z = -0.2 } },
		Antenna_Left  = { pivot = { x = -0.3, y = 1.5, z = 1.2 } },
		Antenna_Right = { pivot = { x = 0.3, y = 1.5, z = 1.2 } },
	},

	can_flinch = function(self)
		return self.state ~= "resurrecting"
	end,

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.cast = 2.0
		self.cooldowns.resurrect = 3.0
		x_mob_core.adopt_nearby_orphans(self, 32.0)
		x_mob_core.particles.attach(self.object, x_mobs.get_glowler_ambient_spawner())
	end,

	on_hurt = function(self, puncher, _dmg)
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_glowler_hurt_burst(pos)
		end

		if self.state == "resurrecting" then
			-- Backfire pushback on attacker disrupting resurrection
			if puncher and puncher:is_valid() and pos then
				local ppos = puncher:get_pos()
				if ppos and vector.distance(pos, ppos) <= 3.5 then
					local push_dir = vector.direction(pos, ppos)
					push_dir.y = 0
					local plen = math.sqrt(push_dir.x * push_dir.x + push_dir.z * push_dir.z)
					if plen > 0.01 then
						push_dir = {x = push_dir.x / plen, y = 0, z = push_dir.z / plen}
					else
						push_dir = {x = 0, y = 0, z = 1}
					end
					puncher:add_velocity({x = push_dir.x * 4.5, y = 1.8, z = push_dir.z * 4.5})
					puncher:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 4, fire = 2},
					}, push_dir)
				end
				-- Distress call: summon all minions to swarm attacker
				x_mob_core.rally_followers(self, puncher)
				self.target = puncher
			end

			-- Abort action-lock and initiate tactical sprint flee
			self.action_timer = nil
			self.state = "fleeing"
			self.panic_timer = 3.0
			self.cooldowns.resurrect = 5.0
			if self.memory then
				self.memory.flee_state = true
			end
			x_mob_core.play_animation(self.object, "run", {speed = 1.2, loop = true, force = true})
		end
	end,

	on_death = function(self, _puncher)
		x_mob_core.particles.clear_target(self.object)
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_glowler_death_vfx(pos)
		end
	end,

	on_action_end = function(self)
		if self.state == "resurrecting" then
			spawn_resurrected_minion(self)
		end
	end,

	perform_shoot = function(self, pos, tpos)
		-- 20% chance to trigger unique Supernova Nova blast
		local is_supernova = (math.random() <= 0.20)
		local proj_name = is_supernova and "x_mobs:glowler_supernova" or "x_mobs:glowler_plasma"
		local proj_speed = is_supernova and SUPERNOVA_SPEED or PLASMA_SPEED

		self.state = "shooting"
		self.action_timer = 1.0
		self.cooldowns.cast = is_supernova and 4.2 or 3.2
		x_mob_core.rally_followers(self, self.target)
		x_mob_core.halt_horizontal_velocity(self)
		self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
		x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})

		if is_supernova then
			core.sound_play("x_mobs_glowler_spell", {pos = pos, gain = 0.9, max_hear_distance = 28}, true)
		else
			core.sound_play("x_mobs_glowler_shoot", {pos = pos, gain = 0.85, max_hear_distance = 24}, true)
		end

		x_mob_core.schedule(self, 0.45, "scheduled_action", function()
			if self.target and x_mob_core.is_player_alive(self.target) then
				local cp = self.object:get_pos()
				local tp = self.target:get_pos()
				if cp and tp then
					local origin = {x = cp.x, y = cp.y + 0.8, z = cp.z}
					local tgt_center = {x = tp.x, y = tp.y + 1.0, z = tp.z}
					local t_vel = self.target:get_velocity()
					local dir = select(2, x_mob_core.predict_aim(origin, tgt_center, t_vel, proj_speed))

					local yaw = core.dir_to_yaw(dir)
					self.object:set_yaw(yaw)
					self._cur_rot = {x = 0, y = yaw, z = 0}

					local spawn_pos = {
						x = origin.x + dir.x * 1.1,
						y = origin.y + dir.y * 1.1,
						z = origin.z + dir.z * 1.1,
					}
					local proj = core.add_entity(spawn_pos, proj_name)
					if proj and proj:is_valid() then
						local p_ent = proj:get_luaentity()
						if p_ent then
							p_ent._shooter = self.object
						end
						proj:set_velocity(vector.multiply(dir, proj_speed))
					end
				end
			end
		end)
	end,

	on_step = function(self, dtime)
		if self.panic_timer and self.panic_timer > 0 then
			self.panic_timer = math.max(0, self.panic_timer - dtime)
		end

		local alive_minions, fleeing_minions = get_minion_status(self)
		local max_minions = self.pack_max_followers or 3
		local flee_thresh = (self.health_regen and self.health_regen.flee_threshold) or 24

		-- Retreat when low HP, accompanied by fleeing minions, or defenseless
		if self.hp <= flee_thresh and self.target ~= nil then
			self.state = "fleeing"
			self.panic_timer = math.max(self.panic_timer or 0, 3.0)
			if self.memory then self.memory.flee_state = true end
		elseif alive_minions > 0 and fleeing_minions >= alive_minions then
			self.state = "fleeing"
			self.panic_timer = math.max(self.panic_timer or 0, 3.5)
			if self.memory then self.memory.flee_state = true end
		elseif alive_minions == 0 and self.target and (self.cooldowns.resurrect or 0) > 0 then
			local cp = self.object:get_pos()
			local tp = self.target:get_pos()
			if cp and tp and vector.distance(cp, tp) < STANDOFF_MIN then
				self.state = "fleeing"
				self.panic_timer = math.max(self.panic_timer or 0, 2.5)
				if self.memory then self.memory.flee_state = true end
			end
		end

		if self.state == "fleeing" then
			local cp = self.object and self.object:is_valid() and self.object:get_pos()
			local tp = self.target and self.target:is_valid() and self.target:get_pos()
			local target_dist = (cp and tp) and vector.distance(cp, tp) or 999

			-- 1. Emergency Melee Defense while fleeing
			local ep = cp and {x = cp.x, y = cp.y + (self.eye_offset or 1.2), z = cp.z}
			local tep = tp and {x = tp.x, y = tp.y + 1.5, z = tp.z}
			local flee_melee_los = ep and tep and x_mob_core.line_of_sight(ep, tep)
			if flee_melee_los and target_dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 and cp and tp then
				self.state = "attacking"
				self.action_timer = 0.5
				self.attack_cooldown = 1.5
				x_mob_core.halt_horizontal_velocity(self)
				self.object:set_yaw(core.dir_to_yaw(vector.direction(cp, tp)))
				x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})

				x_mob_core.schedule(self, 0.25, "scheduled_action", function()
					if self.target and x_mob_core.is_player_alive(self.target) then
						local p1 = self.object:get_pos()
						local p2 = self.target:get_pos()
						if p1 and p2 and vector.distance(p1, p2) <= self.attack_range + 0.6 then
							local pe1 = {x = p1.x, y = p1.y + (self.eye_offset or 1.2), z = p1.z}
							local pe2 = {x = p2.x, y = p2.y + 1.5, z = p2.z}
							if x_mob_core.line_of_sight(pe1, pe2) then
								self.target:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = {fleshy = 7, fire = 2},
								}, vector.direction(p1, p2))
							end
						end
					end
				end)
				return
			end

			-- 2. Mobile Rearguard Summon
			if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
				local m_spawned = spawn_resurrected_minion(self)
				if m_spawned then
					alive_minions = alive_minions + 1
					if self.hp > flee_thresh then
						self.panic_timer = nil
						self.state = "walk"
						if self.memory then self.memory.flee_state = false end
					end
				end
			end

			-- Check panic timer expiration
			if self.panic_timer and self.panic_timer <= 0 then
				self.panic_timer = nil
				if self.hp > flee_thresh and (alive_minions > 0 and fleeing_minions == 0 or target_dist >= STANDOFF_MIN) then
					self.state = "idle"
					if self.memory then self.memory.flee_state = false end
				end
			end

			if self.state == "fleeing" then
				x_mob_core.step_move_or_idle(self, dtime, "run", 1.2)
				return
			end
		end

		local pos = self.object:get_pos()
		if not pos then return end

		-- No target: summon missing minions at leisure or wander
		if not self.target then
			if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
				x_mob_core.adopt_nearby_orphans(self, 32.0)
				alive_minions = x_mob_core.clean_followers(self)
				if alive_minions < max_minions then
					self.state = "resurrecting"
					self.action_timer = 1.2
					x_mob_core.halt_horizontal_velocity(self)
					x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
					x_mobs.spawn_glowler_summon_burst(pos)
					return
				end
			end
			x_mob_core.step_wander_or_idle(self, dtime)
			return
		end

		local tpos = self.target:get_pos()
		if not tpos then return end

		local dist = vector.distance(pos, tpos)
		local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 1.2), z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
		local los = x_mob_core.line_of_sight(eye_pos, target_eye)

		-- 1. Emergency Melee Bite Defense when trapped in close combat
		if los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			self.state = "attacking"
			self.action_timer = 0.6
			self.attack_cooldown = 1.5
			x_mob_core.halt_horizontal_velocity(self)
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
			x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})

			x_mob_core.schedule(self, 0.3, "scheduled_action", function()
				if self.target and x_mob_core.is_player_alive(self.target) then
					local cp = self.object:get_pos()
					local tp = self.target:get_pos()
					if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.5 then
						local pe1 = {x = cp.x, y = cp.y + (self.eye_offset or 1.2), z = cp.z}
						local pe2 = {x = tp.x, y = tp.y + 1.5, z = tp.z}
						if x_mob_core.line_of_sight(pe1, pe2) then
							self.target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = 8, fire = 2},
							}, vector.direction(cp, tp))
						end
					end
				end
			end)
			return
		end

		-- 2. Close Pressure Kiting (Player inside danger zone: dist < STANDOFF_MIN)
		if dist < STANDOFF_MIN then
			-- Meat shield priority: summon an interposing minion
			if alive_minions < max_minions and (self.cooldowns.resurrect or 0) <= 0 then
				local m_spawned = spawn_resurrected_minion(self)
				if m_spawned then
					if self.hp > flee_thresh then
						self.state = "walk"
						if self.memory then self.memory.flee_state = false end
					end
				end
			elseif alive_minions == 0 and (self.cooldowns.resurrect or 0) > 0 then
				-- Defenseless: panic sprint flee
				self.state = "fleeing"
				self.panic_timer = math.max(self.panic_timer or 0, 2.5)
				if self.memory then self.memory.flee_state = true end
				x_mob_core.step_move_or_idle(self, dtime, "run", 1.2)
				return
			end

			-- Fire projectile if summon on cooldown or minions intact
			if los and dist > self.attack_range and dist <= PLASMA_RANGE and (self.cooldowns.cast or 0) <= 0 then
				self:perform_shoot(pos, tpos)
				return
			end

			local retreated = x_mob_core.retreat_from(self, tpos, self.flee_speed or 5.0)
			if retreated then
				if self.state ~= "walk" then
					self.state = "walk"
					x_mob_core.play_animation(self.object, "walk", {speed = 1.2, loop = true})
				end
			else
				if los and dist <= PLASMA_RANGE and (self.cooldowns.cast or 0) <= 0 then
					self:perform_shoot(pos, tpos)
					return
				end
				x_mob_core.step_move_or_idle(self, dtime, "walk", 1.2)
			end
			return
		end

		-- 3. Safe Standoff or Broken LOS: Channel Resurrection Ritual
		if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
			self.state = "resurrecting"
			self.action_timer = 1.2
			x_mob_core.halt_horizontal_velocity(self)
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
			x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
			x_mobs.spawn_glowler_summon_burst(pos)
			return
		end

		-- 4. Broken line of sight: navigate towards player
		if not los then
			x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0)
			return
		end

		-- 5. Standoff Zone (8.0 to 14.0 blocks) - Backline Caster & Fireball Channel
		if dist >= STANDOFF_MIN and dist <= STANDOFF_MAX then
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))

			if dist <= PLASMA_RANGE and (self.cooldowns.cast or 0) <= 0 then
				self:perform_shoot(pos, tpos)
				return
			end

			x_mob_core.halt_horizontal_velocity(self)
			if self.state ~= "idle" then
				self.state = "idle"
				x_mob_core.play_animation(self.object, "idle", {speed = 1.0, loop = true})
			end
			return
		end

		-- 6. Target Beyond Standoff Range (> 14 blocks) - Advance towards backline position
		x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0)
	end,
})

-- Register natural spawns via x_mob_core (Glowler dragon leader)
x_mob_core.register_spawn("x_mobs:glowler", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:dirt",
		"default:desert_stone",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:crystal_stone",
	},
	chance = 3500,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
