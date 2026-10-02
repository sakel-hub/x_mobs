--[[
	x_mobs - Crystal Guardian
	Towering crystalline golem guardian defending subterranean caverns,
	icy peaks, and crystal formations. Features high armor, regenerative core,
	and a devastating seismic ground smash with expanding shockwave particles.
	Integrated with x_mob_core framework.
]]
x_mob_core.register_mob("x_mobs:crystal_guardian", {
	initial_properties = {
		hp_max = 140,
		mesh = "x_mobs_ice_monster_guardian.glb",
		textures = {
			"x_mobs_ice_monster_guardian.png",
		},
		visual_size = {x = 14, y = 14},
		collisionbox = {-0.75, -0.7, -0.75, 0.75, 1.95, 0.75},
		selectionbox = {-0.8, -0.7, -0.8, 0.8, 2.0, 0.8},
		stepheight = 1.2,
		glow = 4,
		backface_culling = false,
	},

	-- High defense: Heavy basalt & crystal carapace
	-- Resistant to fleshy cuts (swords), vulnerable to pickaxe cracky impacts
	armor_groups = { fleshy = 50, cracky = 70 },
	knockback_mult = 0, -- Heavy unyielding mass
	factions = { "elemental", "guardian" },
	mob_height = 2.65,
	eye_offset = 1.8,
	walk_speed = 2.4,
	wander_speed = 1.4,
	pursuit_speed = 4.2,
	attack_range = 3.0,
	aggro_radius = 20.0,
	damage = 6,
	attack_interval = 2.0, -- Slower, deliberate heavy attacks
	death_duration = 2.45,

	-- Stalwart guardian: never flees from combat, passive crystal core regeneration
	health_regen = {
		rate = 1.0,
		passive = true,
		flee_threshold = 0,
		return_threshold = 0,
	},

	damage_effect = { type = "none" }, -- Handled via custom crystal shard particles

	drops = {
		{ name = "default:mese_crystal_fragment", min = 2, max = 5, chance = 0.85 },
		{ name = "default:mese_crystal",          min = 1, max = 2, chance = 0.40 },
		{ name = "default:obsidian_shard",        min = 1, max = 3, chance = 0.60 },
		{ name = "default:diamond",               min = 1, max = 1, chance = 0.15 },
		{ name = "everness:quartz_crystal",       min = 2, max = 4, chance = 0.80 },
		{ name = "default:ice",                   min = 1, max = 3, chance = 0.50 },
		{ name = "default:stone",                 min = 1, max = 4, chance = 0.70 },
	},

	sounds = {
		base = "x_mobs_crystal_guardian",
		distance = 26.0,
		gain = 1.0,
		pitch_jitter = 0.06,
		attack = "x_mobs_crystal_guardian_attack",
		hurt = "x_mobs_crystal_guardian_hurt",
		death = "x_mobs_crystal_guardian_death",
		random = "x_mobs_crystal_guardian_idle",
		smash = "x_mobs_crystal_guardian_smash",
	},

	animations = {
		idle    = { track = "idle",    speed = 1.0, loop = true },
		stand   = { track = "stand",   speed = 1.0, loop = true },
		walk    = { track = "walk",    speed = 1.0, loop = true },
		run     = { track = "run",     speed = 1.1, loop = true },
		attack  = { track = "attack",  speed = 1.0, loop = false },
		punch   = { track = "punch",   speed = 1.0, loop = false },
		attack2 = { track = "attack2", speed = 1.0, loop = false },
		smash   = { track = "smash",   speed = 1.0, loop = false },
		hurt    = { track = "hurt",    speed = 1.0, loop = false },
		death   = { track = "death",   speed = 1.0, loop = false },
		die     = { track = "die",     speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.19, z = 0 } },
		Head = { pivot = { x = 0, y = 0.68, z = -0.28 } },
		Arm_Left = { pivot = { x = 0, y = 0.90, z = -0.20 } },
		Arm_Right = { pivot = { x = 0, y = 0.19, z = 0 } },
		Hand_Left = { pivot = { x = 0, y = 0.19, z = 0 } },
		Hand_Right = { pivot = { x = 0, y = 0.28, z = -0.01 } },
		Foot_Left = { pivot = { x = 0, y = 0.96, z = -0.23 } },
		Foot_Right = { pivot = { x = 0, y = 0.96, z = -0.23 } },
	},

	-- Hyper-armor: poise prevents flinching during attack windups
	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "smashing"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			-- Twin Guardian bond: broadcast threat to paired companion within radius
			x_mob_core.broadcast_threat(self, puncher, 24.0)
		end
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			-- Inspect puncher weapon to detect pickaxe / cracky weak point strike
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

			if is_pickaxe then
				-- Targeted Crystalline Weak Point: Pickaxe shatters the crystal structure
				-- Emits a violent burst of crystal shards and a crisp resonant fracture sound
				x_mobs.spawn_crystal_damage(pos, 28)
				x_mob_core.play_sound(self, "x_mobs_crystal_guardian_hurt", {
					gain = 1.0,
					pitch = 1.35, -- Sharp crystalline fracture resonance
					distance = 24.0,
				})
			else
				-- Standard flesh/blunt hit
				x_mobs.spawn_crystal_damage(pos, 14)
			end
		end
	end,

	on_death = function(self, _killer)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			x_mobs.spawn_crystal_death(pos)
		end
	end,

	on_regen_step = function(self)
		if self.object and self.object:is_valid() then
			x_mobs.spawn_crystal_regen(self.object)
		end
	end,

	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		if not pos then return end

		-- No active target: scan for players or maintain ambient wander
		if not self.target or not x_mob_core.is_player_alive(self.target) then
			self.target = nil
			local player = x_mob_core.scan_for_player(self, self.aggro_radius or 20.0)
			if player then
				x_mob_core.set_target(self, player)
				x_mob_core.broadcast_threat(self, player, 24.0)
			else
				x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
				return
			end
		end

		local tpos = self.target:get_pos()
		if not tpos then
			self.target = nil
			return
		end

		local dist = vector.distance(pos, tpos)
		local eye_pos = { x = pos.x, y = pos.y + (self.eye_offset or 1.5), z = pos.z }
		local target_eye = { x = tpos.x, y = tpos.y + 1.5, z = tpos.z }
		local los = x_mob_core.line_of_sight(eye_pos, target_eye)

		-- Attack selection when target is within striking distance
		if los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			local to_target = vector.direction(pos, tpos)
			to_target.y = 0
			local len = math.sqrt(to_target.x * to_target.x + to_target.z * to_target.z)
			if len > 0.01 then
				to_target = { x = to_target.x / len, y = 0, z = to_target.z / len }
			else
				to_target = { x = 0, y = 0, z = 1 }
			end
			local face_yaw = core.dir_to_yaw(to_target)
			self.object:set_yaw(face_yaw)
			self._cur_rot = { x = 0, y = face_yaw, z = 0 }
			x_mob_core.halt_horizontal_velocity(self)

			-- 20% Chance: Ground Smash (attack2 / smash)
			if math.random() <= 0.20 then
				self.state = "smashing"
				self.action_timer = 2.04
				self.attack_cooldown = 2.6
				x_mob_core.play_animation(self.object, "smash", { speed = 1.0, loop = false, force = true })

				-- Charging crystal motes converge during 1.1s windup
				local fist_pos = { x = pos.x + to_target.x * 1.2, y = pos.y + 1.8, z = pos.z + to_target.z * 1.2 }
				x_mobs.spawn_crystal_smash_charge(fist_pos, self.object)

				-- Scheduled impact at t = 1.1s (exact impact keyframe)
				x_mob_core.schedule(self, 1.1, "ground_smash_impact", function()
					if not self.object or not self.object:is_valid() then return end
					local c_pos = self.object:get_pos()
					if not c_pos then return end

					local cur_yaw = self.object:get_yaw() or face_yaw
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = c_pos.x + fwd.x * 1.6,
						y = c_pos.y - 0.7, -- Ground surface level (collisionbox min_y is -0.7)
						z = c_pos.z + fwd.z * 1.6,
					}

					-- Sample terrain node directly under impact epicenter for debris mapping
					local ground_node = x_mobs.sample_ground_node(epicenter)

					-- Heavy seismic ground slam sound
					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 1.0,
						distance = 32.0,
					})

					-- Layered acoustic terrain response (plays surface node's dug impact sound)
					local gdef = core.registered_nodes[ground_node.name]
					if gdef and gdef.sounds and gdef.sounds.dug then
						core.sound_play(gdef.sounds.dug, {
							pos = epicenter,
							gain = 0.8,
							pitch = 0.9 + math.random() * 0.2,
							max_hear_distance = 26.0,
						})
					end

					-- 5.0 Node splash damage & directional outward knockback
					local blast_radius = 5.0

					-- Multi-layer particle shockwave (plane attractor + crystal spikes + terrain debris mapping + dust)
					x_mobs.spawn_crystal_smash_wave(epicenter, ground_node, blast_radius)

					local nearby = core.get_objects_inside_radius(epicenter, blast_radius)
					for i = 1, #nearby do
						local obj = nearby[i]
						local is_victim = (obj:is_player() and x_mob_core.is_player_alive(obj))
							or (not obj:is_player() and not x_mob_core.are_allies(self.object, obj))
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

								-- Kinetic pop: 8.5 m/s horizontal knockback + 4.2 m/s vertical lift
								local kb_speed = 8.5
								local kb_vel = {
									x = to_victim.x * kb_speed,
									y = 4.2,
									z = to_victim.z * kb_speed,
								}
								if obj.add_velocity then
									obj:add_velocity(kb_vel)
								elseif obj.add_player_velocity then
									obj:add_player_velocity(kb_vel)
								end

								-- Splash damage: 6 damage with damage flash
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 6 },
								}, to_victim)
							end
						end
					end
				end)
				return
			else
				-- 80% Chance: Standard Heavy Punch (punch / attack)
				self.state = "attacking"
				self.action_timer = 1.62
				self.attack_cooldown = 2.0 -- Slower melee interval compared to typical mobs
				x_mob_core.play_animation(self.object, "punch", { speed = 1.0, loop = false, force = true })
				x_mob_core.play_sound(self, "attack")

				-- Scheduled punch hit at t = 0.72s (strike connect keyframe)
				x_mob_core.schedule(self, 0.72, "melee_punch_hit", function()
					if not self.object or not self.object:is_valid() then return end
					if self.target and x_mob_core.is_player_alive(self.target) then
						local cp = self.object:get_pos()
						local tp = self.target:get_pos()
						if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.6 then
							local pe1 = { x = cp.x, y = cp.y + (self.eye_offset or 1.5), z = cp.z }
							local pe2 = { x = tp.x, y = tp.y + 1.5, z = tp.z }
							if x_mob_core.line_of_sight(pe1, pe2) then
								local p_dir = vector.direction(cp, tp)
								self.target:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 6 },
								}, p_dir)
								x_mobs.spawn_crystal_damage(tp, 6)
							end
						end
					end
				end)
				return
			end
		end

		-- Target within range but attacks currently cooling down: hold stance and track target
		if los and dist <= self.attack_range and (self.attack_cooldown or 0) > 0 then
			local to_target = vector.direction(pos, tpos)
			to_target.y = 0
			local face_yaw = core.dir_to_yaw(to_target)
			self.object:set_yaw(face_yaw)
			self._cur_rot = { x = 0, y = face_yaw, z = 0 }
			x_mob_core.halt_horizontal_velocity(self)
			if self.state ~= "idle" then
				self.state = "idle"
				x_mob_core.play_animation(self.object, "idle", { speed = 1.0, loop = true })
			end
			return
		end

		-- Target out of striking reach: heavy pursuit run
		x_mob_core.step_move_or_idle(self, dtime, "run", 1.1, "idle")
	end,
})

-- Natural World Spawning: Spawns in pairs in deep caves, mountains, permafrost, and crystal biomes
x_mob_core.register_spawn("x_mobs:crystal_guardian", {
	nodes = {
		"group:stone",
		"group:sand",
		"group:everness_sand",
		"default:stone",
		"default:desert_stone",
		"default:permafrost",
		"default:ice",
		"default:cave_ice",
		"everness:crystal_stone",
		"everness:crystal_sand",
		"everness:crystal_moss_block",
		"everness:dirt_with_crystal_grass",
		"everness:crystal_cobble",
		"everness:crystal_stone_brick",
	},
	chance = 3200,
	active_object_count = 2,
	group_min = 2,
	group_max = 2,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
