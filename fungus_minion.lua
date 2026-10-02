--[[
	x_mobs - Fungus Minion
	Aggressive, fast fungal vanguard minion that protects and rallies around the Crazy Mushroom boss.
]]

x_mob_core.register_mob("x_mobs:fungus_minion", {
	initial_properties = {
		hp_max = 24,
		mesh = "x_mobs_fungus_minion.glb",
		textures = {
			"x_mobs_fungus_minion.png",
		},
		visual_size = {x = 9, y = 9},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 0.9, 0.35},
		glow = 2,
	},

	armor_groups = { fleshy = 100 },
	knockback_mult = 0.5,
	factions = { "fungal" },
	walk_speed = 3.6,
	pursuit_speed = 5.2,
	wander_speed = 1.8,
	wander_radius = 8.0,
	attack_range = 2.0,
	damage = 2,
	health_regen = {
		flee_threshold = 0,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.5,
	damage_effect = { type = "none" },
	drops = {
		{ name = "flowers:mushroom_red",   min = 1, max = 2, chance = 0.50 },
		{ name = "flowers:mushroom_brown", min = 1, max = 2, chance = 0.50 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:crazy_mushroom",
		leash_distance = 20.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	sounds = {
		gain = 0.85,
		distance = 24.0,
		attack = "x_mobs_fungus_attack",
		hurt = "x_mobs_fungus_hurt",
		death = "x_mobs_fungus_death",
		random = "x_mobs_fungus_idle",
	},

	animations = {
		idle   = {track = "stand",  speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "punch",  speed = 1.3, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.4, z = 0 } },
		Head = { pivot = { x = 0, y = 0.8, z = 0 } },
	},

	vfx = {
		hurt = { type = "fungus_hurt" },
		death = { type = "fungus_death" },
		despawn = { type = "fungus_dissolve", scale = 0.85 },
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
		local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.8), z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.2, z = tpos.z}
		local attack_los = x_mob_core.line_of_sight(eye_pos, target_eye)

		-- Melee Strike
		if attack_los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			self.state = "attacking"
			self.action_timer = 0.5
			self.attack_cooldown = 1.0
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
						local c_eye = {x = cp.x, y = cp.y + (self.eye_offset or 0.8), z = cp.z}
						local t_eye = {x = tp.x, y = tp.y + 1.2, z = tp.z}
						if x_mob_core.line_of_sight(c_eye, t_eye) then
							self.target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = self.damage or 4},
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

		-- Rapid sprint pursuit towards target
		local move_anim = dist > 4.0 and "run" or "walk"
		local move_speed_mult = dist > 4.0 and 1.44 or 1.0
		x_mob_core.step_move_or_idle(self, dtime, move_anim, move_speed_mult)
	end
})

-- Register natural spawns via x_mob_core
x_mob_core.register_spawn("x_mobs:fungus_minion", {
	nodes = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt",
		"group:soil",
		"group:stone",
	},
	chance = 2000,
	active_object_count = 4,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 12,
})
