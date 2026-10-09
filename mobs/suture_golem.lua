--[[
	x_mobs - Suture Golem (Necrotic Flesh-Iron Juggernaut)
	Author: SaKeL
	License: MIT

	Multi-track animated glTF entity patrolling subterranean crypts and ossuary ruins.
	A hulking undead brute forged from stitched flesh, heavy iron wire, and surgical hooks.

	Distinctive Abilities:
	  - Primary Melee: Cleaver Hook Sweep dealing slashing kinetic damage
	  - Secondary Melee: Double-Fist Ground Rupture (AoE) triggering a radial bile shockwave & knockup
	  - Ranged Lob: Necrotic Bile Vomit launching toxic globules inflicting Necrotic Decay DoT
	  - Passive Trait: Stitch Regeneration knitting torn flesh and sutures when critically injured
--]]

local S = core.get_translator("x_mobs")

local BILE_SPEED = 16.0
local BILE_RANGE = 16.0
local MIN_SHOOT_DISTANCE = 5.0
local MELEE_RANGE = 3.2

-- ============================================================================
-- 1. NECROTIC BILE PROJECTILE ENTITY
-- ============================================================================

core.register_entity("x_mobs:suture_golem_bile", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Necrotic Bile"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = { "x_mobs_suture_golem_particles.png^[sheet:8x8:0,0" },
		visual_size = {x = 0.8, y = 0.8},
		glow = 10,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "undead", "golem", "subterranean" },

	on_activate = function(self)
		self.object:set_armor_groups({ immortal = 1 })
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			gravity = 6.0,
			drag = 0.03,
			radius = 0.65,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 3.5,
			rotate = true,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_suture_golem_bile_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 7 },
				}, dir)
				proj._punched_direct = hit_obj

				-- Inflict Necrotic Decay: 2 damage/sec for 4 seconds + 35% slow + toxic green vignette
				if hit_obj:is_player() then
					x_mob_core.apply_status_effect(hit_obj, {
						id = "necrotic_decay",
						type = "poison",
						damage = 2,
						interval = 1.0,
						duration = 4.0,
						speed_factor = 0.65,
						hud_vignette = "x_mob_core_vignette.png^[colorize:#225505aa",
					})
				end
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_suture_golem_bile_impact(hit_pos)
				core.sound_play("x_mobs_spider_shoot.1", {
					pos = hit_pos,
					gain = 0.85,
					max_hear_distance = 22.0,
				}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- 2.2 node splash radius
				local objs = core.get_objects_inside_radius(hit_pos, 2.2)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= proj.object and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = { fleshy = 4 },
						}, dir)

						if obj:is_player() then
							x_mob_core.apply_status_effect(obj, {
								id = "necrotic_decay",
								type = "poison",
								damage = 1,
								interval = 1.0,
								duration = 3.0,
								speed_factor = 0.75,
								hud_vignette = "x_mob_core_vignette.png^[colorize:#225505aa",
							})
						end
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. SUTURE GOLEM MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:suture_golem", {
	initial_properties = {
		hp_max = 85,
		description = S("Suture Golem"),
		mesh = "x_mobs_suture_golem.glb",
		textures = { "x_mobs_suture_golem_texture.png" },
		-- Luanti glTF scaling: visual_size 0.75 gives ~2.07 nodes height for heavy stitched juggernaut
		visual_size = {x = 0.75, y = 0.75},
		collisionbox = {-0.45, 0.0, -0.45, 0.45, 1.95, 0.45},
		selectionbox = {-0.55, 0.0, -0.55, 0.55, 2.05, 0.55},
		stepheight = 1.2,
		glow = 2,
		makes_footstep_sound = true,
	},

	factions = { "undead", "golem", "subterranean" },
	armor_groups = { fleshy = 85, cracky = 60, level = 2 },
	aggro_radius = 18.0,
	attack_range = MELEE_RANGE,
	walk_speed = 2.4,
	pursuit_speed = 4.2,
	wander_speed = 1.6,
	wander_radius = 8.0,
	scan_interval = 0.4,
	knockback_mult = 0.50,
	can_crawl = false,
	can_swim = false,
	death_duration = 1.5,
	eye_offset = 1.6,

	damage_effect = { type = "flesh" },

	drops = {
		{ name = "default:steel_ingot",  min = 1, max = 3, chance = 0.60 },
		{ name = "default:iron_lump",    min = 2, max = 4, chance = 0.75 },
		{ name = "default:cobble",       min = 3, max = 6, chance = 0.80 },
		{ name = "default:coal_lump",    min = 1, max = 3, chance = 0.50 },
		{ name = "default:tin_lump",     min = 1, max = 2, chance = 0.35 },
	},

	animations = {
		idle   = {track = "idle",   speed = 0.9,  loop = true},
		walk   = {track = "walk",   speed = 1.0,  loop = true},
		run    = {track = "run",    speed = 1.2,  loop = true},
		punch  = {track = "attack", speed = 1.0,  loop = false},
		shoot  = {track = "shoot",  speed = 1.0,  loop = false},
		hurt   = {track = "hurt",   speed = 1.1,  loop = false},
		death  = {track = "death",  speed = 1.0,  loop = false},
	},

	bones = {
		Body      = { pivot = { x = 0,    y = 1.25, z = 0 } },
		Head      = { pivot = { x = 0,    y = 2.05, z = 0 } },
		Arm_Right = { pivot = { x = 0.95, y = 1.85, z = 0 } },
		Arm_Left  = { pivot = { x = -0.95,y = 1.85, z = 0 } },
		Leg_Right = { pivot = { x = 0.42, y = 1.10, z = 0 } },
		Leg_Left  = { pivot = { x = -0.42,y = 1.10, z = 0 } },
	},

	sounds = {
		distance = 26.0,
		random = { name = "x_mobs_suture_golem_idle", gain = 0.85, min_interval = 6.0, max_interval = 16.0 },
		attack = { name = "x_mobs_suture_golem_attack.1", gain = 0.95 },
		smash  = { name = "x_mobs_suture_golem_attack.2", gain = 1.0 },
		shoot  = { name = "x_mobs_suture_golem_vomit", gain = 0.95 },
		hurt   = { name = "x_mobs_suture_golem_hurt", gain = 0.95 },
		death  = { name = "x_mobs_suture_golem_death", gain = 1.0 },
	},

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
			x_mobs.spawn_suture_golem_death(pos)
		end
	end,

	on_step = function(self, dtime)
		if (self._regen_cd or 0) > 0 then
			self._regen_cd = self._regen_cd - dtime
		end

		-- Passive Trait: Stitch Regeneration
		-- Knits wounds when HP <= 30 (out of 85), restoring +16 HP over 3s
		local hp = self.object:get_hp()
		if hp > 0 and hp <= 30 and (self._regen_cd or 0) <= 0 then
			self._regen_cd = 16.0
			local pos = self.object:get_pos()
			if pos then
				x_mobs.spawn_suture_golem_regen(pos)
				core.sound_play("x_mobs_suture_golem_idle.1", {
					pos = pos,
					gain = 0.9,
					max_hear_distance = 20.0,
				}, true)
				self.object:set_hp(math.min(self.hp_max or 85, hp + 16))
			end
		end

		-- Footstep mud & bile flecks
		if self.state == "walk" or self.state == "run" then
			self._step_timer = (self._step_timer or 0) + dtime
			if self._step_timer >= 0.5 then
				self._step_timer = 0
				local pos = self.object:get_pos()
				if pos then
					x_mobs.spawn_suture_golem_step(pos)
				end
			end
		end
	end,

	-- =========================================================================
	-- DECLARATIVE MELEE COMBAT PROFILE
	-- Multi-attack profile:
	--   70% Cleaver Hook Sweep (punch track): Single-target high-damage slash
	--   30% Double-Fist Ground Rupture (punch track, aoe = true): Ground shockwave & knockup
	-- =========================================================================
	melee = {
		range = MELEE_RANGE,
		max_height_diff = 2.0,
		reach_tolerance = 0.7,
		attacks = {
			{
				-- 70% Cleaver Hook Sweep
				weight = 70,
				animation = "punch",
				anim_speed = 1.0,
				sound = "attack",
				duration = 0.75,
				cooldown = 1.4,
				delay = 0.35,
				damage = 9,
				on_strike = function(self, _target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local hook_pos = {
							x = cp.x + fwd.x * 1.2,
							y = cp.y + 1.4,
							z = cp.z + fwd.z * 1.2,
						}
						x_mobs.spawn_suture_golem_cleave(hook_pos, fwd)
					end
				end,
			},
			{
				-- 30% Double-Fist Ground Rupture
				weight = 30,
				animation = "punch",
				anim_speed = 0.9,
				sound = "smash",
				duration = 1.0,
				cooldown = 2.8,
				delay = 0.50,
				damage = 12,
				aoe = true,
				aoe_radius = 2.6,
				aoe_full_damage = false,
				on_strike = function(self, _target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local slam_pos = {
							x = cp.x + fwd.x * 1.1,
							y = cp.y + 0.1,
							z = cp.z + fwd.z * 1.1,
						}
						x_mobs.spawn_suture_golem_ground_rupture(slam_pos)

						-- Knockup upward velocity to nearby hostiles
						local nearby = core.get_objects_inside_radius(slam_pos, 2.6)
						for i = 1, #nearby do
							local obj = nearby[i]
							if obj and obj:is_valid() and obj ~= self.object
									and x_mob_core.is_valid_projectile_target(self, obj) then
								local v = obj:get_velocity() or {x = 0, y = 0, z = 0}
								obj:add_velocity({x = 0, y = 4.5 - v.y * 0.4, z = 0})
							end
						end
					end
				end,
			},
		},
	},

	-- =========================================================================
	-- DECLARATIVE RANGED COMBAT PROFILE
	-- Necrotic Bile Vomit
	-- =========================================================================
	shooter = {
		range = BILE_RANGE,
		min_range = MIN_SHOOT_DISTANCE,
		kiting = false,
		shoot_while_retreating = false,
		state = "shooting",
		cooldown = 4.0,
		fire_duration = 1.0,
		fire_delay = 0.50,
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
			local mouth_pos = {
				x = pos.x + fwd.x * 0.9,
				y = pos.y + 1.9,
				z = pos.z + fwd.z * 0.9,
			}
			local tpos = target:get_pos()
			if not tpos then return end

			local target_center = {
				x = tpos.x,
				y = tpos.y + 1.0,
				z = tpos.z,
			}
			local target_vel = target:get_velocity() or {x = 0, y = 0, z = 0}
			local _, aim_dir = x_mob_core.predict_aim(mouth_pos, target_center, target_vel, BILE_SPEED)

			local bile_obj = core.add_entity(mouth_pos, "x_mobs:suture_golem_bile")
			if bile_obj and bile_obj:is_valid() then
				bile_obj:set_velocity(vector.multiply(aim_dir, BILE_SPEED))
				local b_ent = bile_obj:get_luaentity()
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
-- Subterranean crypts, catacombs, ossuaries, deep dungeon corridors
-- ============================================================================

x_mob_core.register_spawn("x_mobs:suture_golem", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:cobble",
		"default:mossycobble",
		"everness:cursed_stone",
	},
	chance = 3500,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 6,
	min_elevation = -31000,
	max_elevation = -25,
})
