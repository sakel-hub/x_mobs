--[[
	x_mobs - Crypt Stalker (Subterranean Apex Shadow Predator)
	Author: SaKeL
	License: MIT

	Multi-track animated glTF entity hunting in deep subterranean crypts and caverns.
	Echolocates prey in darkness with acute perception.

	Distinctive Abilities:
	  - Primary Melee Strike: Rapid Razor Claw Rend (attack) inflicting laceration bleed
	  - Secondary Melee Strike: Twin Mantis X-Slash (attack2) with critical armor penetration
	  - Supersonic Ranged Shriek: Sonic resonance pulse (shoot) disorienting and knocking back victims
	  - Passive Trait: Shadow Prowler (+25% pursuit speed and shadow mist shroud in dark caverns)
--]]

local S = core.get_translator("x_mobs")

local SHRIEK_SPEED = 22.0
local SHRIEK_RANGE = 16.0
local MIN_SHOOT_DISTANCE = 5.0
local MELEE_RANGE = 2.6

-- ============================================================================
-- 1. SUPERSONIC BANSHEE SHRIEK PROJECTILE ENTITY
-- ============================================================================

core.register_entity("x_mobs:crypt_stalker_shriek", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Crypt Stalker Shriek"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_crypt_stalker_particles.png^[sheet:8x8:0,6"},
		visual_size = {x = 0.9, y = 0.9},
		glow = 12,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "subterranean", "undead", "shadow" },

	on_activate = function(self)
		self.object:set_armor_groups({ immortal = 1 })
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			gravity = 0.5,
			drag = 0.02,
			radius = 0.75,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 3.5,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_crypt_shriek_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 8 },
				}, dir)
				proj._punched_direct = hit_obj
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_crypt_shriek_impact(hit_pos)
				core.sound_play("x_mobs_crypt_stalker_shriek", {
					pos = hit_pos,
					gain = 0.9,
					max_hear_distance = 24.0,
				}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Sonic resonance blast: 2.5 node splash radius
				local objs = core.get_objects_inside_radius(hit_pos, 2.5)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = { fleshy = 4 },
						}, dir)
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. CRYPT STALKER MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:crypt_stalker", {
	initial_properties = {
		hp_max = 55,
		description = S("Crypt Stalker"),
		mesh = "x_mobs_crypt_stalker.glb",
		textures = { "x_mobs_crypt_stalker.png" },
		-- Luanti glTF scaling: visual_size 0.70 gives ~2.01 nodes height for hunched stalker
		visual_size = {x = 0.70, y = 0.70},
		collisionbox = {-0.4, 0.0, -0.4, 0.4, 1.85, 0.4},
		selectionbox = {-0.55, 0.0, -0.55, 0.55, 2.0, 0.55},
		stepheight = 1.2,
		glow = 2,
		makes_footstep_sound = false,
	},

	factions = { "subterranean", "undead", "shadow" },
	armor_groups = { fleshy = 80, snappy = 85 },
	aggro_radius = 22.0,
	attack_range = MELEE_RANGE,
	walk_speed = 3.6,
	pursuit_speed = 5.8,
	wander_speed = 2.0,
	wander_radius = 12.0,
	scan_interval = 0.35,
	knockback_mult = 1.6,
	can_crawl = false,
	can_swim = false,
	death_duration = 1.35,
	eye_offset = 1.45,

	health_regen = {
		flee_threshold = 12,
		return_threshold = 30,
		rate = 1.2,
	},

	damage_effect = { type = "ichor" },

	drops = {
		{ name = "default:coal_lump",    min = 1, max = 4, chance = 0.75 },
		{ name = "default:flint",        min = 1, max = 2, chance = 0.60 },
		{ name = "default:iron_lump",    min = 1, max = 2, chance = 0.45 },
		{ name = "farming:string",       min = 1, max = 3, chance = 0.50 },
		{ name = "default:diamond",      min = 1, max = 1, chance = 0.08 },
	},

	animations = {
		idle    = {track = "idle",    speed = 1.0,  loop = true},
		walk    = {track = "walk",    speed = 1.0,  loop = true},
		run     = {track = "run",     speed = 1.25, loop = true},
		attack  = {track = "attack",  speed = 1.2,  loop = false},
		attack2 = {track = "attack2", speed = 1.15, loop = false},
		shoot   = {track = "shoot",   speed = 1.0,  loop = false},
		hurt    = {track = "hurt",    speed = 1.2,  loop = false},
		death   = {track = "death",   speed = 1.0,  loop = false},
	},

	bones = {
		Body      = { pivot = { x = 0,    y = 1.35, z = 0 } },
		Head      = { pivot = { x = 0,    y = 2.05, z = 0.05 } },
		Arm_Right = { pivot = { x = 0.55, y = 1.85, z = 0.05 } },
		Arm_Left  = { pivot = { x = -0.55,y = 1.85, z = 0.05 } },
		Leg_Right = { pivot = { x = 0.28, y = 1.35, z = 0 } },
		Leg_Left  = { pivot = { x = -0.28,y = 1.35, z = 0 } },
	},

	sounds = {
		distance = 22.0,
		random = { name = "x_mobs_crypt_stalker_idle", gain = 0.75, min_interval = 5.0, max_interval = 14.0 },
		attack = { name = "x_mobs_crypt_stalker_attack", gain = 0.9 },
		shoot  = { name = "x_mobs_crypt_stalker_shriek", gain = 1.0 },
		hurt   = { name = "x_mobs_crypt_stalker_hurt", gain = 0.9 },
		death  = { name = "x_mobs_crypt_stalker_death", gain = 1.0 },
	},

	cooldowns = {
		rush = 2.0,
	},

	buffs = {
		thresholds = {
			{
				id = "stalker_frenzy",
				hp_ratio = 0.30,
				cleanse = true,
				effect = "frenzy",
				sound = "x_mobs_crypt_stalker_shriek",
			},
		},
	},

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.rush = 2.0
	end,

	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 22.0)
		end
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end
	end,

	on_death = function(self, _killer)
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_crypt_stalker_death(pos)
		end
	end,

	on_step = function(self, dtime)
		-- Passive Trait: Shadow Prowler
		-- In deep dark environments (light <= 6), gain heightened pursuit speed & shadow shroud
		self._shadow_timer = (self._shadow_timer or 0) + dtime
		if self._shadow_timer >= 0.5 then
			self._shadow_timer = 0
			local pos = self.object:get_pos()
			if pos then
				local light = core.get_node_light(pos) or 0
				if light <= 6 then
					self.pursuit_speed = 6.4
					x_mobs.spawn_crypt_stalker_shadow_aura(pos)
				else
					self.pursuit_speed = 5.8
				end
			end
		end

		-- Stalker Rush: Lunging pounce surge when pursuing target at mid-range (6 to 16 blocks)
		if self.target and x_mob_core.is_player_alive(self.target) and (self.cooldowns.rush or 0) <= 0 then
			local pos = self.object:get_pos()
			local tpos = self.target:get_pos()
			if pos and tpos then
				local dist = vector.distance(pos, tpos)
				if dist >= 6.0 and dist <= 16.0 then
					self.cooldowns.rush = 8.0
					x_mob_core.apply_buff(self.object, {
						id = "stalker_rush",
						type = "buff",
						duration = 3.5,
						speed_factor = 1.45,
						envelop_texture = "x_mobs_haste_envelop.png",
					})
					core.sound_play("x_mobs_crypt_stalker_shriek", {
						pos = pos,
						gain = 0.8,
						pitch = 1.3,
						max_hear_distance = 22.0,
					}, true)
					x_mobs.spawn_crypt_stalker_slash(pos, vector.direction(pos, tpos))
				end
			end
		end
	end,

	-- =========================================================================
	-- DECLARATIVE MELEE COMBAT PROFILE
	-- Multi-attack profile:
	--   70% Razor Claw Rend (attack): Rapid slash with bleeding DoT
	--   30% Twin Mantis X-Slash (attack2): Armor puncture critical strike
	-- =========================================================================
	melee = {
		range = MELEE_RANGE,
		max_height_diff = 1.8,
		reach_tolerance = 0.6,
		attacks = {
			{
				-- 70% Razor Claw Rend
				weight = 70,
				animation = "attack",
				anim_speed = 1.2,
				sound = "attack",
				duration = 0.65,
				cooldown = 1.1,
				delay = 0.30,
				damage = 7,
				on_strike = function(self, target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local slash_pos = {
							x = cp.x + fwd.x * 1.1,
							y = cp.y + 1.2,
							z = cp.z + fwd.z * 1.1,
						}
						x_mobs.spawn_crypt_stalker_slash(slash_pos, fwd)
					end

					-- Laceration Bleed DoT: 1 damage per second for 2.5s
					if target and target:is_valid() and target:is_player() then
						x_mob_core.apply_status_effect(target, {
							id = "crypt_laceration",
							type = "dot",
							damage = 1,
							tick_rate = 1.0,
							duration = 2.5,
							hud_vignette = "x_mob_core_vignette.png^[colorize:#88041044",
						})
					end
				end,
			},
			{
				-- 30% Twin Mantis X-Slash
				weight = 30,
				animation = "attack2",
				anim_speed = 1.15,
				sound = "attack",
				duration = 0.80,
				cooldown = 2.0,
				delay = 0.35,
				damage = 12,
				on_strike = function(self, _target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local slash_pos = {
							x = cp.x + fwd.x * 1.2,
							y = cp.y + 1.25,
							z = cp.z + fwd.z * 1.2,
						}
						x_mobs.spawn_crypt_stalker_xslash(slash_pos, fwd)
					end
				end,
			},
		},
	},

	-- =========================================================================
	-- DECLARATIVE RANGED COMBAT PROFILE
	-- Supersonic banshee shriek sonic pulse
	-- =========================================================================
	shooter = {
		range = SHRIEK_RANGE,
		min_range = MIN_SHOOT_DISTANCE,
		kiting = false,
		shoot_while_retreating = false,
		state = "shooting",
		cooldown = 4.0,
		fire_duration = 1.15,
		fire_delay = 0.50,
		animation = "shoot",
		sound = "shoot",
		projectile = false,
		advance_on_cooldown = true,
		on_shoot = function(self)
			local pos = self.object:get_pos()
			local target = self.target
			if not pos or not target or not target:is_valid() then return end

			local mouth_pos = {
				x = pos.x,
				y = pos.y + 1.6,
				z = pos.z,
			}
			local tpos = target:get_pos()
			if not tpos then return end

			local target_center = {
				x = tpos.x,
				y = tpos.y + 1.2,
				z = tpos.z,
			}
			local target_vel = target:get_velocity() or {x = 0, y = 0, z = 0}
			local _, aim_dir = x_mob_core.predict_aim(mouth_pos, target_center, target_vel, SHRIEK_SPEED)

			local shriek_obj = core.add_entity(mouth_pos, "x_mobs:crypt_stalker_shriek")
			if shriek_obj and shriek_obj:is_valid() then
				shriek_obj:set_velocity(vector.multiply(aim_dir, SHRIEK_SPEED))
				local shriek_ent = shriek_obj:get_luaentity()
				if shriek_ent then
					shriek_ent._shooter = self.object
					shriek_ent._target = target
				end
			end
		end,
	},
})

-- ============================================================================
-- 3. NATURAL SPAWNING REGISTRATION
-- Underground crypts, dungeons, deep stone caverns, low light
-- ============================================================================

x_mob_core.register_spawn("x_mobs:crypt_stalker", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:desert_stone",
		"default:cobble",
		"default:mossycobble",
		"everness:cursed_stone",
		"everness:crystal_stone",
	},
	chance = 2600,
	active_object_count = 3,
	group_min = 1,
	group_max = 2,
	min_light = 0,
	max_light = 6,
	min_elevation = -31000,
	max_elevation = -20,
})
