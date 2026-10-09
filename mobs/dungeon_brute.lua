--[[
	x_mobs - Dungeon Brute (Colossal Armored Dungeon Enforcer)
	Author: SaKeL
	License: MIT

	Multi-track animated glTF entity patrolling subterranean strongholds and vault ruins.
	Wields massive iron pauldrons, pulverizing knuckle strikes, and seismic tremor slams.

	Distinctive Abilities:
	  - Primary Melee Strike: Iron Knuckle Punch (punch) dealing crushing kinetic blows
	  - Secondary Melee Strike: Tremor Execution Slam (punch2) triggering a radial ground fissure shockwave
	  - Ranged Boulder Throw: Seismic Boulder Hurl (shoot) launching high-velocity tumbling rocks
	  - Passive Trait: Heavy Iron Cuirass (damage resistance and reactive Staggering War Cry)
--]]

local S = core.get_translator("x_mobs")

local BOULDER_SPEED = 18.0
local BOULDER_RANGE = 18.0
local MIN_SHOOT_DISTANCE = 6.0
local MELEE_RANGE = 3.0

-- ============================================================================
-- 1. SEISMIC BOULDER PROJECTILE ENTITY (visual = "node")
-- ============================================================================

core.register_entity("x_mobs:dungeon_brute_boulder", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Dungeon Brute Boulder"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "node",
		node = { name = "default:stone" },
		visual_size = {x = 0.65, y = 0.65, z = 0.65},
		glow = 2,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "subterranean", "iron", "brute" },

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({ immortal = 1 })
		local data = (staticdata and staticdata ~= "" and core.deserialize(staticdata)) or {}
		self.node_name = data.node_name or "default:stone"
		self.object:set_properties({
			visual = "node",
			node = {
				name = self.node_name,
				param1 = 0,
				param2 = 0,
			},
			visual_size = {x = 0.65, y = 0.65, z = 0.65},
		})
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_step = function(self, dtime)
		-- Continuous tumbling rotation in flight
		self._rot = self._rot or {x = 0, y = 0, z = 0}
		self._rot.x = (self._rot.x + 6.0 * dtime) % 6.2831853
		self._rot.z = (self._rot.z + 4.5 * dtime) % 6.2831853
		self.object:set_rotation(self._rot)

		x_mob_core.step_projectile(self, dtime, {
			gravity = 7.0,
			drag = 0.04,
			radius = 0.75,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 4.0,
			rotate = false,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_dungeon_brute_boulder_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 10 },
				}, dir)
				proj._punched_direct = hit_obj
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_dungeon_brute_boulder_impact(hit_pos)
				core.sound_play("x_mobs_golem_impact", {
					pos = hit_pos,
					gain = 0.95,
					max_hear_distance = 26.0,
				}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- 2.2 node splash fragmentation radius
				local objs = core.get_objects_inside_radius(hit_pos, 2.2)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = { fleshy = 5 },
						}, dir)
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. DUNGEON BRUTE MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:dungeon_brute", {
	initial_properties = {
		hp_max = 75,
		description = S("Dungeon Brute"),
		mesh = "x_mobs_dungeon_brute.glb",
		textures = { "x_mobs_dungeon_brute.png" },
		-- Luanti glTF scaling: visual_size 0.75 gives ~2.11 nodes height for broad armored brute
		visual_size = {x = 0.75, y = 0.75},
		collisionbox = {-0.5, 0.0, -0.5, 0.5, 1.95, 0.5},
		selectionbox = {-0.65, 0.0, -0.65, 0.65, 2.1, 0.65},
		stepheight = 1.2,
		glow = 1,
		makes_footstep_sound = true,
	},

	factions = { "subterranean", "iron", "brute" },
	armor_groups = { fleshy = 65, cracky = 50, level = 2 },
	aggro_radius = 20.0,
	attack_range = MELEE_RANGE,
	walk_speed = 3.2,
	pursuit_speed = 5.2,
	wander_speed = 1.8,
	wander_radius = 10.0,
	scan_interval = 0.4,
	knockback_mult = 0.65,
	can_crawl = false,
	can_swim = false,
	death_duration = 1.5,
	eye_offset = 1.6,

	damage_effect = { type = "basalt" },

	buffs = {
		thresholds = {
			{
				id = "iron_fortitude",
				hp_ratio = 0.40,
				cleanse = true,
				effect = "ironhide",
				sound = "x_mobs_dungeon_brute_slam",
				vfx = function(pos)
					x_mobs.spawn_dungeon_brute_warcry(pos)
				end,
			},
		},
		triggers = {
			{
				id = "reactive_carapace",
				event = "on_heavy_damage",
				threshold_damage = 8,
				cooldown = 12.0,
				effect = "carapace",
				sound = "x_mobs_dungeon_brute_hurt",
			},
		},
	},

	drops = {
		{ name = "default:steel_ingot",  min = 1, max = 3, chance = 0.65 },
		{ name = "default:iron_lump",    min = 2, max = 5, chance = 0.85 },
		{ name = "default:cobble",       min = 4, max = 8, chance = 0.90 },
		{ name = "default:tin_lump",     min = 1, max = 3, chance = 0.40 },
		{ name = "default:copper_lump",  min = 1, max = 2, chance = 0.35 },
		{ name = "default:gold_lump",    min = 1, max = 1, chance = 0.20 },
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0,  loop = true},
		walk   = {track = "walk",   speed = 1.0,  loop = true},
		run    = {track = "run",    speed = 1.2,  loop = true},
		punch  = {track = "punch",  speed = 1.1,  loop = false},
		punch2 = {track = "punch2", speed = 0.95, loop = false},
		shoot  = {track = "shoot",  speed = 1.0,  loop = false},
		hurt   = {track = "hurt",   speed = 1.1,  loop = false},
		death  = {track = "death",  speed = 1.0,  loop = false},
	},

	bones = {
		Body      = { pivot = { x = 0,    y = 1.39, z = 0 } },
		Head      = { pivot = { x = 0,    y = 2.10, z = 0.05 } },
		Arm_Right = { pivot = { x = 1.05, y = 1.95, z = 0 } },
		Arm_Left  = { pivot = { x = -1.05,y = 1.95, z = 0 } },
		Leg_Right = { pivot = { x = 0.42, y = 1.35, z = 0 } },
		Leg_Left  = { pivot = { x = -0.42,y = 1.35, z = 0 } },
	},

	sounds = {
		distance = 26.0,
		random = { name = "x_mobs_dungeon_brute_idle", gain = 0.85, min_interval = 6.0, max_interval = 16.0 },
		attack = { name = "x_mobs_dungeon_brute_punch", gain = 0.95 },
		smash  = { name = "x_mobs_dungeon_brute_slam", gain = 1.0 },
		shoot  = { name = "x_mobs_dungeon_brute_throw", gain = 0.95 },
		hurt   = { name = "x_mobs_dungeon_brute_hurt", gain = 0.95 },
		death  = { name = "x_mobs_dungeon_brute_death", gain = 1.0 },
	},

	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting"
	end,

	on_hurt = function(self, puncher, dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 24.0)
		end
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end

		-- Passive Trait: Staggering War Cry
		-- 25% chance when suffering heavy damage (>= 6) to roar and repel melee attackers
		if dmg >= 6 and (self._warcry_cd or 0) <= 0 and math.random(1, 100) <= 25 then
			self._warcry_cd = 6.0
			local pos = self.object:get_pos()
			if pos then
				x_mobs.spawn_dungeon_brute_warcry(pos)
				core.sound_play("x_mobs_dungeon_brute_slam", {
					pos = pos,
					gain = 0.9,
					max_hear_distance = 22.0,
				}, true)

				local nearby = core.get_objects_inside_radius(pos, 3.5)
				for i = 1, #nearby do
					local obj = nearby[i]
					if obj and obj:is_valid() and obj ~= self.object
							and x_mob_core.is_valid_projectile_target(self, obj) then
						local opos = obj:get_pos()
						if opos then
							local dir = vector.direction(pos, opos)
							dir.y = 0.3
							local v = vector.multiply(vector.normalize(dir), 6.0)
							obj:add_velocity(v)
						end
					end
				end
			end
		end
	end,

	on_death = function(self, _killer)
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_dungeon_brute_death(pos)
		end
	end,

	on_step = function(self, dtime)
		if (self._warcry_cd or 0) > 0 then
			self._warcry_cd = self._warcry_cd - dtime
		end

		-- Footstep dust effects while marching
		if self.state == "walk" or self.state == "run" then
			self._step_timer = (self._step_timer or 0) + dtime
			if self._step_timer >= 0.5 then
				self._step_timer = 0
				local pos = self.object:get_pos()
				if pos then
					x_mobs.spawn_dungeon_brute_step(pos)
				end
			end
		end
	end,

	-- =========================================================================
	-- DECLARATIVE MELEE COMBAT PROFILE
	-- Multi-attack profile:
	--   75% Iron Knuckle Strike (punch track): High damage single-target blow
	--   25% Tremor Execution Slam (punch2 track, aoe = true): Ground rupture shockwave
	-- =========================================================================
	melee = {
		range = MELEE_RANGE,
		max_height_diff = 2.0,
		reach_tolerance = 0.7,
		attacks = {
			{
				-- 75% Iron Knuckle Strike
				weight = 75,
				animation = "punch",
				anim_speed = 1.1,
				sound = "attack",
				duration = 0.75,
				cooldown = 1.3,
				delay = 0.35,
				damage = 9,
				on_strike = function(self, _target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local fist_pos = {
							x = cp.x + fwd.x * 1.3,
							y = cp.y + 1.4,
							z = cp.z + fwd.z * 1.3,
						}
						x_mobs.spawn_dungeon_brute_punch_impact(fist_pos, fwd)
					end
				end,
			},
			{
				-- 25% Tremor Execution Slam (AoE radial ground rupture)
				weight = 25,
				animation = "punch2",
				anim_speed = 0.95,
				sound = "smash",
				duration = 1.25,
				cooldown = 2.5,
				delay = 0.45,
				aoe = true,
				perform_attack = function(self, _target, _dir)
					local cp = self.object:get_pos()
					if not cp then return end

					local cur_yaw = self.object:get_yaw() or 0
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = cp.x + fwd.x * 1.5,
						y = cp.y,
						z = cp.z + fwd.z * 1.5,
					}

					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 1.0,
						distance = 30.0,
					})

					local blast_radius = 3.5
					x_mobs.spawn_dungeon_brute_tremor_slam(epicenter)

					local nearby = core.get_objects_inside_radius(epicenter, blast_radius)
					for i = 1, #nearby do
						local obj = nearby[i]
						if obj and obj:is_valid() and obj ~= self.object
								and x_mob_core.is_valid_projectile_target(self, obj) then
							local op = obj:get_pos()
							if op then
								local to_victim = vector.direction(epicenter, op)
								to_victim.y = 0.4
								local kb_vel = vector.multiply(vector.normalize(to_victim), 5.5)
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 8 },
								}, to_victim)
								obj:add_velocity(kb_vel)

								if obj:is_player() then
									x_mob_core.apply_status_effect(obj, {
										id = "tremor_stagger",
										type = "slow",
										speed_factor = 0.50,
										duration = 3.0,
										hud_vignette = "x_mob_core_vignette.png^[colorize:#40352b77",
									})
								end
							end
						end
					end
				end,
			},
		},
	},

	-- =========================================================================
	-- DECLARATIVE RANGED COMBAT PROFILE
	-- Seismic boulder throw
	-- =========================================================================
	shooter = {
		range = BOULDER_RANGE,
		min_range = MIN_SHOOT_DISTANCE,
		kiting = false,
		shoot_while_retreating = false,
		state = "shooting",
		cooldown = 4.5,
		fire_duration = 1.25,
		fire_delay = 0.60,
		animation = "shoot",
		sound = "shoot",
		projectile = false,
		advance_on_cooldown = true,
		on_shoot = function(self)
			local pos = self.object:get_pos()
			local target = self.target
			if not pos or not target or not target:is_valid() then return end

			local cur_yaw = self.object:get_yaw() or 0
			local fwd = core.yaw_to_dir(cur_yaw)
			local hand_pos = {
				x = pos.x + fwd.x * 1.2,
				y = pos.y + 1.8,
				z = pos.z + fwd.z * 1.2,
			}
			local tpos = target:get_pos()
			if not tpos then return end

			local target_center = {
				x = tpos.x,
				y = tpos.y + 1.2,
				z = tpos.z,
			}
			local target_vel = target:get_velocity() or {x = 0, y = 0, z = 0}
			local _, aim_dir = x_mob_core.predict_aim(hand_pos, target_center, target_vel, BOULDER_SPEED)

			local staticdata = core.serialize({
				node_name = "default:stone",
			})
			local boulder_obj = core.add_entity(hand_pos, "x_mobs:dungeon_brute_boulder", staticdata)
			if boulder_obj and boulder_obj:is_valid() then
				boulder_obj:set_velocity(vector.multiply(aim_dir, BOULDER_SPEED))
				local b_ent = boulder_obj:get_luaentity()
				if b_ent then
					b_ent._shooter = self.object
					b_ent._target = target
				end
			end
		end,
	},
})

-- ============================================================================
-- 3. NATURAL SPAWNING REGISTRATION
-- Subterranean dungeons, stronghold vaults, deep stone caverns
-- ============================================================================

x_mob_core.register_spawn("x_mobs:dungeon_brute", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:desert_stone",
		"default:cobble",
		"default:mossycobble",
		"everness:cursed_stone",
		"everness:crystal_stone",
	},
	chance = 3200,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 8,
	min_elevation = -31000,
	max_elevation = -40,
})
