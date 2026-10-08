--[[
	x_mobs - Golem
	Colossal ancient stone golem defending deep subterranean caverns,
	mountain peaks, and rocky chasms. Features heavy stone armor, hyper-armor
	poise, martial cross punches, a seismic ground smash with expanding shockwave,
	and a signature two-stage earth extraction projectile attack using visual="node".
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

local ROCK_SPEED = 20.0
local ROCK_RISE_TIME = 0.55
local MIN_SHOOT_DISTANCE = 7.5
local MAX_SHOOT_DISTANCE = 18.0
local MAX_FLEE_DISTANCE = 14.0
local FLEE_HP_THRESHOLD = 40
local RETURN_HP_THRESHOLD = 70

-- ============================================================================
-- Golem Boulder Projectile Entity (visual = "node")
-- ============================================================================

core.register_entity("x_mobs:golem_boulder", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Golem Boulder"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "node",
		visual_size = {x = 0.7, y = 0.7, z = 0.7},
		glow = 4,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "stone", "golem", "boss" },

	on_activate = function(self, staticdata, _dtime_s)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
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
			visual_size = {x = 0.7, y = 0.7, z = 0.7},
		})

		-- Phase 1: Rising vertically to chest/head throwing level
		self.state = "rising"
		self.timer = 0
		self.object:set_velocity({x = 0, y = 3.8, z = 0})
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
					x_mobs.spawn_golem_rock_trail(pos, {x = 0, y = 3.8, z = 0})
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
		-- Continuous rotation on world x and z axes while hurtling through the air
		self._rot = self._rot or {x = 0, y = 0, z = 0}
		self._rot.x = (self._rot.x + 5.5 * dtime) % 6.2831853
		self._rot.z = (self._rot.z + 4.0 * dtime) % 6.2831853
		self.object:set_rotation(self._rot)

		x_mob_core.step_projectile(self, dtime, {
			rotate = false,
			lifetime = 5.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_golem_rock_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 8},
				}, dir)
				proj._punched_direct = hit_obj

				-- Earth Anchor: heavy gravity (2.4x downward), jump suppression, mud envelop
				x_mob_core.apply_status_effect(hit_obj, {
					id = "earth_anchor",
					type = "custom",
					duration = 4.0,
					gravity_factor = 2.4,
					jump_factor = 0.0,
					speed_factor = 0.55,
					envelop_texture = "x_mobs_mud_envelop.png",
					hud_vignette = "x_mob_core_vignette.png^[colorize:#4a3219aa",
				})
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				-- Acoustic impact resonance
				core.sound_play("x_mobs_golem_impact", {
					pos = hit_pos,
					gain = 1.0,
					max_hear_distance = 32.0,
				})

				-- Particle shatter explosion with sampled node texture
				x_mobs.spawn_golem_rock_shatter(hit_pos, self.node_name or "default:stone")

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- 2.0 Node AoE splash burst
				local objs = core.get_objects_inside_radius(hit_pos, 2.0)
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
							damage_groups = {fleshy = 5},
						}, dir)

						-- Earth Anchor: heavy gravity (2.4x downward), jump suppression, mud envelop
						x_mob_core.apply_status_effect(obj, {
							id = "earth_anchor",
							type = "custom",
							duration = 4.0,
							gravity_factor = 2.4,
							jump_factor = 0.0,
							speed_factor = 0.55,
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
-- Golem Boss Mob Registration
-- ============================================================================

x_mob_core.register_mob("x_mobs:golem", {
	initial_properties = {
		hp_max = 160,
		infotext = S("Golem"),
		mesh = "x_mobs_golem.glb",
		textures = {
			"x_mobs_golem.png",
		},
		visual_size = {x = 7.2, y = 7.2},
		collisionbox = {-0.72, 0.0, -0.72, 0.72, 2.7, 0.72},
		selectionbox = {-0.77, 0.0, -0.77, 0.77, 2.79, 0.77},
		stepheight = 1.1,
		glow = 4,
		backface_culling = false,
	},

	-- Heavy dense basalt armor: resistant to fleshy cuts, vulnerable to pickaxe impacts
	armor_groups = { fleshy = 40, cracky = 90 },
	knockback_mult = 0.1, -- Heavy unyielding mass
	factions = { "stone", "golem", "boss" },
	mob_height = 2.7,
	eye_offset = 2.16,
	walk_speed = 2.0,
	wander_speed = 1.2,
	pursuit_speed = 3.6,
	flee_speed = 3.8,
	max_flee_distance = MAX_FLEE_DISTANCE,
	attack_range = 3.2,
	aggro_radius = 20.0,
	damage = 7,
	attack_interval = 1.6,
	death_duration = 2.0,

	health_regen = {
		flee_threshold = FLEE_HP_THRESHOLD,
		return_threshold = RETURN_HP_THRESHOLD,
		rate = 0.5,
	},

	damage_effect = { type = "none" }, -- Handled via custom stone particle bursts

	drops = {
		{ name = "default:cobble",                 min = 4, max = 12, chance = 0.90 },
		{ name = "default:stone",                  min = 2, max = 8,  chance = 0.80 },
		{ name = "default:steel_ingot",            min = 1, max = 3,  chance = 0.60 },
		{ name = "default:mese_crystal_fragment",  min = 2, max = 4,  chance = 0.50 },
		{ name = "default:obsidian_shard",         min = 1, max = 2,  chance = 0.35 },
		{ name = "default:diamond",                min = 1, max = 1,  chance = 0.15 },
	},

	sounds = {
		base = "x_mobs_golem",
		distance = 28.0,
		gain = 1.0,
		pitch_jitter = 0.05,
		attack = "x_mobs_golem_punch",
		smash = "x_mobs_golem_smash",
		hurt = "x_mobs_golem_hurt",
		death = "x_mobs_golem_death",
		random = "x_mobs_golem_idle",
		cast = "x_mobs_golem_cast",
		shoot = "x_mobs_golem_shoot",
	},

	-- 8 Clean Canonical Non-Duplicate Animation Tracks
	animations = {
		idle   = { track = "idle",   speed = 1.0, loop = true },
		walk   = { track = "walk",   speed = 1.0, loop = true },
		run    = { track = "run",    speed = 1.1, loop = true },
		punch2 = { track = "punch2", speed = 1.1, loop = false }, -- Primary melee strike
		punch  = { track = "punch",  speed = 1.0, loop = false }, -- Seismic ground smash
		shoot  = { track = "shoot",  speed = 0.8, loop = false }, -- Boulder cast & launch
		hurt   = { track = "hurt",   speed = 1.0, loop = false }, -- Kinetic recoil & left arm face cover
		death  = { track = "death",  speed = 1.0, loop = false }, -- Defeat collapse
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


	-- Hyper-armor poise prevents flinching during attack windups and boulder casting
	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 24.0)
		end
		-- When struck and flinching, immediately halt momentum to brace defensive guard
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end
		local pos = self.object:get_pos()
		if pos then
			-- Pickaxe / cracky weak point detection
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
					gain = 1.2,
					pitch = 1.25,
					distance = 26.0,
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

	-- Declarative Melee Combat Configuration:
	-- Uses a weighted multi-attack profile (80% single-target punch, 20% radial AoE ground smash).
	-- Top-level 'range' and 'max_height_diff' act as the common spatial trigger to initiate melee.
	melee = {
		range = 3.2,
		max_height_diff = 2.2,
		reach_tolerance = 0.8,
		attacks = {
			{
				-- 80% Primary Punch (punch2 track):
				-- Standard single-target strike with fleshy punch damage and impact dust VFX.
				weight = 80,
				animation = "punch2",
				anim_speed = 1.1,
				sound = "attack",
				duration = 0.7,
				cooldown = 1.4,
				delay = 0.35,
				damage = 7,
				on_strike = function(self, _target, _dir)
					local cp = self.object and self.object:is_valid() and self.object:get_pos()
					if cp then
						local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
						local fist_pos = {
							x = cp.x + fwd.x * 1.35,
							y = cp.y + 1.62,
							z = cp.z + fwd.z * 1.35,
						}
						x_mobs.spawn_golem_punch(fist_pos)
					end
				end,
			},
			{
				-- 20% Seismic Ground Smash (punch track with radial AoE shockwave):
				-- aoe = true: Area of Effect flag. Bypasses target distance and line-of-sight
				-- re-validation at impact time (delay = 0.40s). Guarantees that perform_attack
				-- detonates at the ground epicenter even if the primary victim dodged, sprinted away,
				-- or died during the windup.
				-- Mutual Exclusivity / Ignored Attributes:
				-- - 'reach_tolerance' is ignored when aoe = true (target distance is not re-checked).
				-- - 'damage' is ignored because perform_attack handles its own radial entity query
				--   (core.get_objects_inside_radius) and applies custom splash damage and knockback.
				weight = 20,
				animation = "punch",
				anim_speed = 1.0,
				sound = "smash",
				duration = 1.4,
				cooldown = 2.2,
				delay = 0.40,
				aoe = true,
				perform_attack = function(self, _target, _dir)
					local c_pos = self.object and self.object:is_valid() and self.object:get_pos()
					if not c_pos then return end

					local cur_yaw = self.object:get_yaw() or 0
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = c_pos.x + fwd.x * 1.6,
						y = c_pos.y,
						z = c_pos.z + fwd.z * 1.6,
					}

					local ground_node = x_mobs.sample_ground_node(epicenter)

					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 1.0,
						distance = 32.0,
					})

					local blast_radius = 3.8
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
								local kb_speed = 5.5
								local kb_vel = {
									x = to_victim.x * kb_speed,
									y = 3.2,
									z = to_victim.z * kb_speed,
								}
								if obj.add_velocity then
									obj:add_velocity(kb_vel)
								elseif obj.add_player_velocity then
									obj:add_player_velocity(kb_vel)
								end

								-- 8 damage AoE smash
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 8 },
								}, to_victim)

								-- Earth Anchor: heavy gravity (2.4x downward), jump suppression, mud envelop
								x_mob_core.apply_status_effect(obj, {
									id = "earth_anchor",
									type = "custom",
									duration = 4.0,
									gravity_factor = 2.4,
									jump_factor = 0.0,
									speed_factor = 0.55,
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
		cooldown = 3.5,
		fire_duration = 1.1,
		fire_delay = 0.55,
		animation = "shoot",
		sound = "cast",
		projectile = false,
		advance_on_cooldown = true,
		on_charge = function(self, pos)
			local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
			local spawn_ground_pos = {
				x = pos.x + fwd.x * 1.8,
				y = pos.y,
				z = pos.z + fwd.z * 1.8,
			}
			local ground_node = x_mobs.sample_ground_node(spawn_ground_pos)

			-- Ground rupture VFX
			x_mobs.spawn_golem_node_raise(spawn_ground_pos, ground_node)

			-- Spawn boulder entity resting above ground surface so it lifts to chest/head height
			local boulder_spawn_pos = {
				x = spawn_ground_pos.x,
				y = spawn_ground_pos.y + 0.45,
				z = spawn_ground_pos.z,
			}
			local staticdata = core.serialize({
				node_name = ground_node.name,
				node_param2 = ground_node.param2,
				aim_dir = fwd,
			})
			local boulder_obj = core.add_entity(boulder_spawn_pos, "x_mobs:golem_boulder", staticdata)
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
-- Natural Spawning Configuration (Solitary cavern & mountain golem)
-- ============================================================================

x_mob_core.register_spawn("x_mobs:golem", {
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
	chance = 3600,
	active_object_count = 1,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 14,
	min_elevation = -31000,
	max_elevation = 31000,
})
