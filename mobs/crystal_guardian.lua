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
		mesh = "x_mobs_monster_guardian.glb",
		textures = {
			"x_mobs_monster_guardian.png",
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

	-- Squad coordination: rallies Vanguard Crystal Minions
	pack = {
		role = "leader",
		call_reinforcements = true,
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
		walk    = { track = "walk",    speed = 1.0, loop = true },
		run     = { track = "walk",    speed = 1.2, loop = true },
		attack  = { track = "attack",  speed = 1.0, loop = false },
		punch   = { track = "attack",  speed = 1.0, loop = false },
		attack2 = { track = "attack2", speed = 1.0, loop = false },
		smash   = { track = "attack2", speed = 1.0, loop = false },
		hurt    = { track = "hurt",    speed = 1.0, loop = false },
		death   = { track = "death",   speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.19, z = 0 } },
		Head = { pivot = { x = 0, y = 0.88, z = -0.29 } },
		Arm_Left = { pivot = { x = 0, y = 0.19, z = 0 } },
		Shoulder_Left = { pivot = { x = -0.57, y = 0.93, z = 0 } },
		Arm_Right = { pivot = { x = 0, y = 0.19, z = 0 } },
		Shoulder_Right = { pivot = { x = 0.64, y = 0.95, z = 0 } },
		Leg_Left = { pivot = { x = -0.28, y = 0.14, z = 0 } },
		Leg_Right = { pivot = { x = 0.28, y = 0.16, z = 0 } },
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

	on_return_to_fight = function(self)
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "walk"
		else
			self.state = "idle"
			self.target = nil
		end
	end,

	melee = {
		range = 3.0,
		max_height_diff = 2.2,
		reach_tolerance = 0.8,
		attacks = {
			{
				-- 80% Primary Heavy Punch (punch / attack track)
				weight = 80,
				animation = "punch",
				anim_speed = 1.0,
				sound = "attack",
				duration = 1.62,
				cooldown = 2.0,
				delay = 0.72,
				damage = 6,
				on_strike = function(_self, target, _dir)
					local tp = target and target:is_valid() and target:get_pos()
					if tp then
						x_mobs.spawn_crystal_damage(tp, 6)
					end
				end,
			},
			{
				-- 20% Seismic Ground Smash (smash / attack2 track with radial AoE shockwave):
				-- aoe = true: Area of Effect flag. Bypasses target distance and line-of-sight
				-- re-validation at impact time (delay = 1.1s). Guarantees perform_attack execution
				-- at the epicenter even if the primary victim dodged or sprinted away during windup.
				weight = 20,
				animation = "smash",
				anim_speed = 1.0,
				sound = "smash",
				duration = 2.04,
				cooldown = 2.6,
				delay = 1.1,
				aoe = true,
				on_start = function(self, target)
					local cp = self.object and self.object:is_valid() and self.object:get_pos()
					if not cp then return end
					local to_target = { x = 0, y = 0, z = 1 }
					if target and target:is_valid() then
						local tp = target:get_pos()
						if tp then
							to_target = vector.direction(cp, tp)
							to_target.y = 0
							local len = math.sqrt(to_target.x * to_target.x + to_target.z * to_target.z)
							if len > 0.01 then
								to_target = { x = to_target.x / len, y = 0, z = to_target.z / len }
							end
						end
					else
						to_target = core.yaw_to_dir(self.object:get_yaw() or 0)
					end
					local fist_pos = {
						x = cp.x + to_target.x * 1.2,
						y = cp.y + 1.8,
						z = cp.z + to_target.z * 1.2,
					}
					x_mobs.spawn_crystal_smash_charge(fist_pos, self.object)
				end,
				perform_attack = function(self, _target, _dir)
					local c_pos = self.object and self.object:is_valid() and self.object:get_pos()
					if not c_pos then return end

					local cur_yaw = self.object:get_yaw() or 0
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

								-- Petrified Brittle: slows movement to 15%, disables jumping, +35% damage taken
								x_mob_core.apply_status_effect(obj, {
									id = "crystallize",
									type = "custom",
									duration = 4.0,
									speed_factor = 0.15,
									jump_factor = 0.0,
									damage_multiplier = 1.35,
									envelop_texture = "x_mobs_crystal_envelop.png",
									hud_vignette = "x_mob_core_vignette.png^[colorize:#88ffff99",
								})
							end
						end
					end
				end,
			},
		},
	},
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
