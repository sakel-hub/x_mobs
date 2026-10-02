--[[
	x_mobs - Skull Lancer
]]

x_mob_core.register_mob("x_mobs:skull_lancer", {
	initial_properties = {
		hp_max = 25,
		mesh = "x_mobs_skull_lancer.glb",
		textures = {
			"x_mobs_skull_lancer.png",
		},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.85, 0.35},
		glow = 2,
	},

	knockback_mult = 0.3,
	factions = { "undead", "skeleton" },
	walk_speed = 3.8,
	pursuit_speed = 5.2,
	wander_speed = 2.0,
	wander_radius = 8.0,
	attack_range = 2.5,
	damage = 5,
	health_regen = {
		flee_threshold = 0,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.8,
	damage_effect = { type = "none" },
	drops = {
		{ name = "default:stick",       min = 1, max = 3, chance = 0.75 },
		{ name = "default:coal_lump",   min = 1, max = 1, chance = 0.35 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:skull_king",
		leash_distance = 18.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	sounds = {
		gain = 0.85,
		distance = 24.0,
		attack = "x_mobs_lancer_attack",
		hurt = "x_mobs_skull_hurt",
		death = "x_mobs_skull_death",
		random = "x_mobs_skull_idle",
	},

	animations = {
		idle   = {track = "stand",  speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "attack", speed = 1.0, loop = false},
		death  = {track = "die",    speed = 1.0, loop = false},
	},

	vfx = {
		hurt = { type = "bone_dust" },
		death = { type = "bone_dust" },
		despawn = { type = "bone_dust" },
	},

	on_step = function(self, dtime)
		if not self.target then
			x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
			return
		end

		local pos = self.object:get_pos()
		local tpos = self.target:get_pos()
		if not pos or not tpos then return end

		local dist = vector.distance(pos, tpos)
		local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 1.5), z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
		local attack_los = x_mob_core.line_of_sight(eye_pos, target_eye)

		if attack_los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			self.state = "attacking"
			self.action_timer = 0.5
			self.attack_cooldown = 1.2
			x_mob_core.halt_horizontal_velocity(self)

			local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
			self.object:set_yaw(yaw)
			self._cur_rot = {x = 0, y = yaw, z = 0}

			x_mob_core.play_animation(self.object, "attack", {speed = 1.3, loop = false})
			x_mob_core.play_sound(self, "attack")

			x_mob_core.schedule(self, 0.25, "scheduled_action", function()
				if self.target and x_mob_core.is_player_alive(self.target) then
					local cp = self.object:get_pos()
					local tp = self.target:get_pos()
					if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.5 then
						local c_eye = {x = cp.x, y = cp.y + (self.eye_offset or 1.5), z = cp.z}
						local t_eye = {x = tp.x, y = tp.y + 1.5, z = tp.z}
						if x_mob_core.line_of_sight(c_eye, t_eye) then
							self.target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = self.damage or 5},
							}, vector.direction(cp, tp))
						end
					end
				end
			end)
			return
		end

		-- In melee striking range but on attack cooldown
		if attack_los and dist <= self.attack_range and (self.attack_cooldown or 0) > 0 then
			local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
			self.object:set_yaw(yaw)
			self._cur_rot = {x = 0, y = yaw, z = 0}
			x_mob_core.halt_horizontal_velocity(self)
			if self.state ~= "idle" then
				self.state = "idle"
				x_mob_core.play_animation(self.object, "idle", {speed = 1.0, loop = true})
			end
			return
		end

		x_mob_core.step_move_or_idle(self, dtime, "walk", 1.2)
	end
})

-- Register natural spawns via x_mob_core (skeleton lancer vanguard, patrols in small units)
x_mob_core.register_spawn("x_mobs:skull_lancer", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:desert_stone",
		"default:dirt",
		"default:gravel",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:cursed_stone_carved",
		"everness:coral_bones_block",
		"everness:coral_bones_brick",
		"everness:forsaken_desert_stone",
		"everness:forsaken_tundra_dirt_with_grass",
	},
	chance = 2000,
	active_object_count = 4,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 15,
})
