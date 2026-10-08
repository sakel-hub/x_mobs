--[[
	x_mobs - Crystal Guardian Minion
	Vanguard crystal minion defending subterranean caverns, icy peaks,
	and crystal formations alongside Crystal Guardians. Features crystalline
	armor, regenerative core, player-scale stature, and a seismic ground smash.
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

x_mob_core.register_mob("x_mobs:crystal_guardian_minion", {
	initial_properties = {
		hp_max = 70,
		infotext = S("Crystal Guardian Minion"),
		mesh = "x_mobs_monster_guardian.glb",
		textures = {
			"x_mobs_monster_guardian.png",
		},
		visual_size = {x = 9.5, y = 9.5},
		collisionbox = {-0.5, -0.48, -0.5, 0.5, 1.33, 0.5},
		selectionbox = {-0.55, -0.48, -0.55, 0.55, 1.36, 0.55},
		stepheight = 1.2,
		glow = 3,
		backface_culling = false,
	},

	-- Half the armor protection of crystal guardian (takes 75% fleshy cuts, 85% cracky pick impacts)
	armor_groups = { fleshy = 75, cracky = 85 },
	knockback_mult = 0.35,
	factions = { "elemental", "guardian" },
	mob_height = 1.8,
	eye_offset = 1.22,
	walk_speed = 2.6,
	wander_speed = 1.5,
	pursuit_speed = 4.4,
	attack_range = 2.2,
	aggro_radius = 18.0,
	damage = 3,
	attack_interval = 1.6,
	death_duration = 2.45,

	-- Passive crystal core regeneration, never flees from combat
	health_regen = {
		rate = 0.5,
		passive = true,
		flee_threshold = 0,
		return_threshold = 0,
	},

	-- Squad coordination: rallies around Crystal Guardian leader
	pack = {
		role = "member",
		leader_type = "x_mobs:crystal_guardian",
		leash_distance = 18.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	damage_effect = { type = "none" }, -- Handled via custom crystal shard particles

	drops = {
		{ name = "default:mese_crystal_fragment", min = 1, max = 2, chance = 0.65 },
		{ name = "default:obsidian_shard",        min = 1, max = 1, chance = 0.35 },
		{ name = "everness:quartz_crystal",       min = 1, max = 2, chance = 0.50 },
		{ name = "default:ice",                   min = 1, max = 2, chance = 0.40 },
		{ name = "default:stone",                 min = 1, max = 2, chance = 0.50 },
	},

	sounds = {
		base = "x_mobs_crystal_guardian",
		distance = 20.0,
		gain = 0.85,
		pitch_jitter = 0.08,
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


	-- Poise prevents flinching during attack windups
	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "smashing"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			-- Broadcast threat to pack leader and fellow guardians
			x_mob_core.broadcast_threat(self, puncher, 20.0)
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
				-- Targeted Crystalline Weak Point: Pickaxe shatters minion crystal structure
				x_mobs.spawn_crystal_damage(pos, 16)
				x_mob_core.play_sound(self, "x_mobs_crystal_guardian_hurt", {
					gain = 0.9,
					pitch = 1.45, -- Sharp high-pitched fracture resonance
					distance = 20.0,
				})
			else
				x_mobs.spawn_crystal_damage(pos, 8)
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
		range = 2.2,
		max_height_diff = 1.8,
		reach_tolerance = 0.8,
		attacks = {
			{
				-- 80% Primary Punch (punch / attack track)
				weight = 80,
				animation = "punch",
				anim_speed = 1.0,
				sound = "attack",
				duration = 1.62,
				cooldown = 1.6,
				delay = 0.72,
				damage = 3,
				on_strike = function(_self, target, _dir)
					local tp = target and target:is_valid() and target:get_pos()
					if tp then
						x_mobs.spawn_crystal_damage(tp, 3)
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
				cooldown = 2.4,
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
						x = cp.x + to_target.x * 0.8,
						y = cp.y + 1.2,
						z = cp.z + to_target.z * 0.8,
					}
					x_mobs.spawn_crystal_smash_charge(fist_pos, self.object)
				end,
				perform_attack = function(self, _target, _dir)
					local c_pos = self.object and self.object:is_valid() and self.object:get_pos()
					if not c_pos then return end

					local cur_yaw = self.object:get_yaw() or 0
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = c_pos.x + fwd.x * 1.1,
						y = c_pos.y - 0.48, -- Ground surface level (collisionbox min_y is -0.48)
						z = c_pos.z + fwd.z * 1.1,
					}

					local ground_node = x_mobs.sample_ground_node(epicenter)

					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 0.85,
						distance = 24.0,
					})

					local gdef = core.registered_nodes[ground_node.name]
					if gdef and gdef.sounds and gdef.sounds.dug then
						core.sound_play(gdef.sounds.dug, {
							pos = epicenter,
							gain = 0.7,
							pitch = 1.05 + math.random() * 0.2,
							max_hear_distance = 20.0,
						})
					end

					-- 3.2 Node splash damage & directional outward knockback
					local blast_radius = 3.2
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

								-- Kinetic pop: 5.5 m/s horizontal knockback + 2.8 m/s vertical lift
								local kb_speed = 5.5
								local kb_vel = {
									x = to_victim.x * kb_speed,
									y = 2.8,
									z = to_victim.z * kb_speed,
								}
								if obj.add_velocity then
									obj:add_velocity(kb_vel)
								elseif obj.add_player_velocity then
									obj:add_player_velocity(kb_vel)
								end

								-- Half damage: 3 fleshy damage
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 3 },
								}, to_victim)

								-- Petrified Brittle (minion tier): slows movement to 35%, disables jumping, +20% damage taken
								x_mob_core.apply_status_effect(obj, {
									id = "crystallize",
									type = "custom",
									duration = 3.0,
									speed_factor = 0.35,
									jump_factor = 0.0,
									damage_multiplier = 1.20,
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

-- Natural World Spawning: Minions spawn in caverns, mountains, permafrost, and crystal biomes
x_mob_core.register_spawn("x_mobs:crystal_guardian_minion", {
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
	chance = 2400,
	active_object_count = 3,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
