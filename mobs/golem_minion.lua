--[[
	x_mobs - Golem Minion
	Smaller stone golem minion defending deep subterranean caverns,
	mountain peaks, and rocky chasms alongside ancient Golems. Features stone
	armor, martial cross punches, player-scale stature, a seismic ground smash,
	and an earth extraction projectile attack.
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

local ROCK_SPEED = 18.0
local ROCK_RISE_TIME = 0.50
local MIN_SHOOT_DISTANCE = 5.0
local MAX_SHOOT_DISTANCE = 14.0
local MAX_FLEE_DISTANCE = 11.0
local FLEE_HP_THRESHOLD = 20
local RETURN_HP_THRESHOLD = 35

-- ============================================================================
-- Golem Minion Boulder Projectile Entity (visual = "node")
-- ============================================================================

core.register_entity("x_mobs:golem_minion_boulder", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Golem Minion Boulder"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.22, -0.22, -0.22, 0.22, 0.22, 0.22},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "node",
		visual_size = {x = 0.45, y = 0.45, z = 0.45},
		glow = 3,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "stone", "golem" },

	on_activate = function(self, staticdata, _dtime_s)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {-0.22, -0.22, -0.22, 0.22, 0.22, 0.22},
			collide_with_objects = false,
		})

		local data = (staticdata and staticdata ~= "" and core.deserialize(staticdata)) or {}
		self.node_name = data.node_name or "default:stone"
		self.node_param2 = data.node_param2 or 0
		self._aim_dir = data.aim_dir

		-- Apply visual = "node" using the sampled terrain node
		self.object:set_properties({
			visual = "node",
			node = {
				name = self.node_name,
				param1 = 0,
				param2 = self.node_param2,
			},
			visual_size = {x = 0.45, y = 0.45, z = 0.45},
		})

		-- Phase 1: Rising vertically to chest/head throwing level
		self.state = "rising"
		self.timer = 0
		self.object:set_velocity({x = 0, y = 2.7, z = 0})
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_step = function(self, dtime)
		self.timer = (self.timer or 0) + dtime

		if self.state == "rising" then
			-- Ascending trail motes
			self.trail_timer = (self.trail_timer or 0) + dtime
			if self.trail_timer >= 0.08 then
				self.trail_timer = 0
				local pos = self.object:get_pos()
				if pos then
					x_mobs.spawn_golem_rock_trail(pos, {x = 0, y = 2.7, z = 0})
				end
			end

			-- Transition to ballistic flight at apex
			if self.timer >= ROCK_RISE_TIME then
				self.state = "flying"
				self.timer = 0
				local pos = self.object:get_pos()
				local shooter = self._shooter
				local shooter_ent = shooter and shooter:is_valid() and shooter:get_luaentity()
				local target = self._target or (shooter_ent and shooter_ent.target)
				local dir = self._aim_dir or {x = 0, y = 0, z = 1}

				if pos and target and target:is_valid() then
					local tpos = target:get_pos()
					if tpos then
						-- Aim at upper body; compensate height when target is on higher ground
						local h_diff = math.max(0, tpos.y - pos.y)
						local y_offset = 1.4 + math.min(h_diff * 0.25, 0.8)
						local t_center = {x = tpos.x, y = tpos.y + y_offset, z = tpos.z}
						local t_vel = target:get_velocity() or {x = 0, y = 0, z = 0}
						dir = select(2, x_mob_core.predict_aim(pos, t_center, t_vel, ROCK_SPEED))
					end
				end

				self.object:set_velocity(vector.multiply(dir, ROCK_SPEED))
			end
			return
		end

		-- Phase 2: Flying ballistic projectile with raycast collision
		self._rot = self._rot or {x = 0, y = 0, z = 0}
		self._rot.x = (self._rot.x + 6.0 * dtime) % 6.2831853
		self._rot.z = (self._rot.z + 4.5 * dtime) % 6.2831853
		self.object:set_rotation(self._rot)

		x_mob_core.step_projectile(self, dtime, {
			rotate = false,
			lifetime = 4.5,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_golem_rock_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				-- Half damage: 4 direct damage
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 4},
				}, dir)
				proj._punched_direct = hit_obj
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				core.sound_play("x_mobs_golem_impact", {
					pos = hit_pos,
					gain = 0.85,
					max_hear_distance = 24.0,
				})

				x_mobs.spawn_golem_rock_shatter(hit_pos, self.node_name or "default:stone")

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- 1.5 Node AoE splash burst (half damage: 2 fleshy damage)
				local objs = core.get_objects_inside_radius(hit_pos, 1.5)
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
							damage_groups = {fleshy = 2},
						}, dir)

						-- Earth Anchor: heavy gravity (2.2x downward), jump suppression, mud envelop
						x_mob_core.apply_status_effect(obj, {
							id = "earth_anchor",
							type = "custom",
							duration = 3.0,
							gravity_factor = 2.2,
							jump_factor = 0.0,
							speed_factor = 0.65,
							envelop_texture = "x_mobs_mud_envelop.png",
							hud_vignette = "x_mob_core_vignette.png^[colorize:#4a3219aa",
						})
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- Golem Minion Mob Registration
-- ============================================================================

x_mob_core.register_mob("x_mobs:golem_minion", {
	initial_properties = {
		hp_max = 80,
		infotext = S("Golem Minion"),
		mesh = "x_mobs_golem.glb",
		textures = {
			"x_mobs_golem.png",
		},
		visual_size = {x = 4.8, y = 4.8},
		collisionbox = {-0.48, 0.0, -0.48, 0.48, 1.8, 0.48},
		selectionbox = {-0.52, 0.0, -0.52, 0.52, 1.86, 0.52},
		stepheight = 1.2,
		glow = 3,
		backface_culling = false,
	},

	-- Half armor resistance of boss golem (takes 70% fleshy cuts, 95% cracky pickaxe impacts)
	armor_groups = { fleshy = 70, cracky = 95 },
	knockback_mult = 0.35,
	factions = { "stone", "golem" },
	mob_height = 1.8,
	eye_offset = 1.44,
	walk_speed = 2.2,
	wander_speed = 1.4,
	pursuit_speed = 3.8,
	flee_speed = 4.0,
	max_flee_distance = MAX_FLEE_DISTANCE,
	attack_range = 2.1,
	aggro_radius = 18.0,
	damage = 3,
	attack_interval = 1.4,
	death_duration = 2.0,

	health_regen = {
		flee_threshold = FLEE_HP_THRESHOLD,
		return_threshold = RETURN_HP_THRESHOLD,
		rate = 0.5,
	},

	-- Squad coordination: rallies around ancient Golem leader
	pack = {
		role = "member",
		leader_type = "x_mobs:golem",
		leash_distance = 18.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	damage_effect = { type = "none" },

	drops = {
		{ name = "default:cobble",                 min = 2, max = 5, chance = 0.85 },
		{ name = "default:stone",                  min = 1, max = 3, chance = 0.75 },
		{ name = "default:steel_ingot",            min = 1, max = 1, chance = 0.35 },
		{ name = "default:mese_crystal_fragment",  min = 1, max = 2, chance = 0.25 },
		{ name = "default:obsidian_shard",         min = 1, max = 1, chance = 0.15 },
	},

	sounds = {
		base = "x_mobs_golem",
		distance = 22.0,
		gain = 0.85,
		pitch_jitter = 0.08,
		attack = "x_mobs_golem_punch",
		smash = "x_mobs_golem_smash",
		hurt = "x_mobs_golem_hurt",
		death = "x_mobs_golem_death",
		random = "x_mobs_golem_idle",
		cast = "x_mobs_golem_cast",
		shoot = "x_mobs_golem_shoot",
	},

	animations = {
		idle   = { track = "idle",   speed = 1.0, loop = true },
		walk   = { track = "walk",   speed = 1.0, loop = true },
		run    = { track = "run",    speed = 1.1, loop = true },
		punch2 = { track = "punch2", speed = 1.1, loop = false },
		punch  = { track = "punch",  speed = 1.0, loop = false },
		shoot  = { track = "shoot",  speed = 0.8, loop = false },
		hurt   = { track = "hurt",   speed = 1.0, loop = false },
		death  = { track = "death",  speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 1.72, z = 0 } },
		Head = { pivot = { x = 0.01, y = 3.28, z = -0.64 } },
		Arm_Left = { pivot = { x = -1.73, y = 2.19, z = -0.03 } },
		Arm_Right = { pivot = { x = 1.69, y = 2.19, z = 0.03 } },
		Leg_Left = { pivot = { x = -0.8, y = 1.09, z = -0.01 } },
		Leg_Right = { pivot = { x = 0.7, y = 1.12, z = 0.01 } },
		Hips = { pivot = { x = 0.01, y = 1.43, z = -0.33 } },
		Shoulder_Left = { pivot = { x = -1.12, y = 3.69, z = -0.02 } },
		Shoulder_Right = { pivot = { x = 1.12, y = 3.74, z = 0.02 } },
	},


	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 20.0)
		end
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end
		local pos = self.object:get_pos()
		if pos then
			local is_pickaxe = false
			if puncher and puncher:is_valid() and puncher:is_player() then
				local wielded = puncher:get_wielded_item()
				if wielded and not wielded:is_empty() then
					local iname = wielded:get_name()
					local idef = core.registered_items[iname]
					local caps = idef and idef.tool_capabilities
					if (caps and caps.groupcaps and caps.groupcaps.cracky)
							or (core.get_item_group(iname, "pickaxe") > 0) then
						is_pickaxe = true
					end
				end
			end

			x_mobs.spawn_golem_hurt(pos, is_pickaxe)
			if is_pickaxe then
				x_mob_core.play_sound(self, "hurt", {
					gain = 1.0,
					pitch = 1.35,
					distance = 22.0,
				})
			end
		end
	end,

	on_death = function(self, _killer)
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_golem_death(pos)
		end
	end,

	on_return_to_fight = function(self)
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "walk"
		else
			self.state = "idle"
			self.target = nil
		end
	end,

	melee = {
		range = 2.1,
		max_height_diff = 1.8,
		reach_tolerance = 0.6,
		attacks = {
			{
				-- 80% Primary Punch (punch2 track)
				weight = 80,
				animation = "punch2",
				anim_speed = 1.1,
				sound = "attack",
				duration = 0.7,
				cooldown = 1.2,
				delay = 0.35,
				damage = 3,
				on_strike = function(self, _target, _dir)
					local cp = self.object and self.object:is_valid() and self.object:get_pos()
					if cp then
						local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
						local fist_pos = {
							x = cp.x + fwd.x * 0.9,
							y = cp.y + 1.08,
							z = cp.z + fwd.z * 0.9,
						}
						x_mobs.spawn_golem_punch(fist_pos)
					end
				end,
			},
			{
				-- 20% Seismic Ground Smash (punch track with radial AoE shockwave):
				-- aoe = true: Area of Effect flag. Bypasses target distance and line-of-sight
				-- re-validation at impact time (delay = 0.40s). Guarantees that perform_attack
				-- detonates at the ground epicenter even if the primary victim dodged or sprinted away.
				weight = 20,
				animation = "punch",
				anim_speed = 1.0,
				sound = "smash",
				duration = 1.4,
				cooldown = 1.8,
				delay = 0.40,
				aoe = true,
				perform_attack = function(self, _target, _dir)
					local c_pos = self.object and self.object:is_valid() and self.object:get_pos()
					if not c_pos then return end

					local cur_yaw = self.object:get_yaw() or 0
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = c_pos.x + fwd.x * 1.1,
						y = c_pos.y,
						z = c_pos.z + fwd.z * 1.1,
					}

					local ground_node = x_mobs.sample_ground_node(epicenter)

					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 0.85,
						distance = 24.0,
					})

					local blast_radius = 2.6
					x_mobs.spawn_golem_smash_wave(epicenter, ground_node, blast_radius)

					local nearby = core.get_objects_inside_radius(epicenter, blast_radius)
					for i = 1, #nearby do
						local obj = nearby[i]
						local is_attached = obj.get_attach and obj:get_attach() ~= nil
						local is_victim = (obj:is_player() and x_mob_core.is_player_alive(obj))
							or (not obj:is_player() and not is_attached and not x_mob_core.are_allies(self.object, obj))
						if obj ~= self.object and is_victim then
							local op = obj:get_pos()
							if op then
								local to_victim = vector.direction(epicenter, op)
								to_victim.y = 0
								local vlen = math.sqrt(to_victim.x * to_victim.x + to_victim.z * to_victim.z)
								if vlen > 0.01 then
									to_victim = { x = to_victim.x / vlen, y = 0, z = to_victim.z / vlen }
								else
									to_victim = fwd
								end

								-- Kinetic lift & outward impulse
								local kb_speed = 3.8
								local kb_vel = {
									x = to_victim.x * kb_speed,
									y = 2.2,
									z = to_victim.z * kb_speed,
								}
								if obj.add_velocity then
									obj:add_velocity(kb_vel)
								elseif obj.add_player_velocity then
									obj:add_player_velocity(kb_vel)
								end

								-- Half damage: 4 damage AoE smash
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 4 },
								}, to_victim)

								-- Earth Anchor: heavy gravity (2.2x downward), jump suppression, mud envelop
								x_mob_core.apply_status_effect(obj, {
									id = "earth_anchor",
									type = "custom",
									duration = 3.0,
									gravity_factor = 2.2,
									jump_factor = 0.0,
									speed_factor = 0.65,
									envelop_texture = "x_mobs_mud_envelop.png",
									hud_vignette = "x_mob_core_vignette.png^[colorize:#4a3219aa",
								})
							end
						end
					end
				end,
			},
		},
	},

	shooter = {
		range = MAX_SHOOT_DISTANCE,
		min_range = MIN_SHOOT_DISTANCE,
		kiting = false,
		shoot_while_retreating = true,
		state = "shooting",
		cooldown = 3.0,
		fire_duration = 0.9,
		fire_delay = 0.50,
		animation = "shoot",
		sound = "cast",
		projectile = false,
		advance_on_cooldown = true,
		on_charge = function(self, pos)
			local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
			local spawn_ground_pos = {
				x = pos.x + fwd.x * 1.2,
				y = pos.y,
				z = pos.z + fwd.z * 1.2,
			}
			local ground_node = x_mobs.sample_ground_node(spawn_ground_pos)

			-- Ground rupture VFX
			x_mobs.spawn_golem_node_raise(spawn_ground_pos, ground_node)

			-- Spawn boulder entity resting above ground surface so it lifts to chest/head height
			local boulder_spawn_pos = {
				x = spawn_ground_pos.x,
				y = spawn_ground_pos.y + 0.35,
				z = spawn_ground_pos.z,
			}
			local staticdata = core.serialize({
				node_name = ground_node.name,
				node_param2 = ground_node.param2,
				aim_dir = fwd,
			})
			local boulder_obj = core.add_entity(boulder_spawn_pos, "x_mobs:golem_minion_boulder", staticdata)
			if boulder_obj and boulder_obj:is_valid() then
				local b_ent = boulder_obj:get_luaentity()
				if b_ent then
					b_ent._shooter = self.object
					b_ent._target = self.target
				end
			end
		end,
		on_shoot = function(self)
			x_mob_core.play_sound(self, "shoot")
		end,
	},
})

-- ============================================================================
-- Natural Spawning Configuration (Golem Minions)
-- ============================================================================

x_mob_core.register_spawn("x_mobs:golem_minion", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:desert_stone",
		"default:sandstone",
		"default:silver_sandstone",
		"default:cobble",
		"default:mossycobble",
		"group:soil",
	},
	chance = 2600,
	active_object_count = 3,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 14,
	min_elevation = -31000,
	max_elevation = 31000,
})
