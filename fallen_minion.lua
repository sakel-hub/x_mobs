--[[
	x_mobs - Fallen Minion
]]

x_mob_core.register_mob("x_mobs:fallen_minion", {
	initial_properties = {
		hp_max = 15,
		mesh = "x_mobs_fallen_minion.glb",
		textures = {
			"x_mobs_fallen_minion.png",
		},
		visual_size = {x = 6, y = 6},
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.2, 0.35},
		glow = 2,
	},

	factions = { "fallen", "cultist" },
	walk_speed = 3.5,
	pursuit_speed = 5.0,
	flee_speed = 6.0,
	wander_speed = 2.0,
	wander_radius = 8.0,
	max_flee_distance = 15.0,
	health_regen = {
		flee_threshold = 5,
		return_threshold = 12,
		rate = 0.5,
	},
	can_climb = true,
	can_open_doors = true,
	death_duration = 1.4,
	drops = {
		{ name = "default:stick",       min = 1, max = 3, chance = 0.75 },
		{ name = "default:torch",       min = 1, max = 2, chance = 0.35 },
		{ name = "default:flint",       min = 1, max = 1, chance = 0.40 },
		{ name = "default:coal_lump",   min = 1, max = 1, chance = 0.35 },
		{ name = "default:clay_lump",   min = 1, max = 2, chance = 0.30 },
		{ name = "default:gravel",      min = 1, max = 2, chance = 0.25 },
	},

	pack = {
		role = "member",
		leader_type = "x_mobs:fallen_shaman",
		leash_distance = 18.0,
		regroup_distance = 4.0,
	},

	sounds = {
		gain = 0.85,
		hurt = "x_mobs_minion",
		death = "x_mobs_minion_death",
		random = "x_mobs_minion",
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		attack = {track = "attack", speed = 1.0, loop = false},
		flee   = {track = "flee",   speed = 1.2, loop = true},
		hurt   = {track = "hurt",   speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.6, z = 0 } },
		Head = { pivot = { x = 0, y = 1.8, z = 0 } },
		Arm_Left = { pivot = { x = -0.55, y = 1.6, z = 0 } },
		Arm_Right = { pivot = { x = 0.55, y = 1.6, z = 0 } },
		Wield_Item = true,
		Leg_Left = { pivot = { x = -0.2, y = 1.0, z = 0 } },
		Leg_Right = { pivot = { x = 0.2, y = 1.0, z = 0 } },
	},

	vfx = {
		death = { type = "flame", scale = 1.0 },
	},

	pack_cowardice = { radius = 12.0, duration = 4.0 },

	on_return_to_fight = function(self)
		local fpos = x_mob_core.mob_memory.get_fight_pos(self)
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "walk"
		elseif fpos then
			self.state = "returning"
			self.nav_target_pos = fpos
		elseif self.leader_obj and self.leader_obj:is_valid() then
			self.state = "regrouping"
			self.target = nil
		else
			self.state = "idle"
			self.target = nil
		end
	end,

	on_step = function(self, dtime)
		-- Fleeing logic (low HP or active panic)
		local hr = self.health_regen
		local flee_thresh = (hr and hr.flee_threshold) or 5
		local ret_thresh = (hr and hr.return_threshold) or 12
		local is_fleeing = (self.state == "fleeing")
			or (self.panic_timer and self.panic_timer > 0)
			or (self.memory and self.memory.flee_state)
			or (self.hp <= flee_thresh and self.target ~= nil)

		if is_fleeing then
			self.state = "fleeing"
			if self.memory then
				self.memory.flee_state = true
			end

			-- Stop fleeing if panic expired and health recovered above return threshold
			local panic_active = self.panic_timer and self.panic_timer > 0
			local health_recovered = (self.hp >= ret_thresh)
			local health_safe = (self.hp > flee_thresh)

			if not panic_active and (health_recovered or (health_safe and not (self.memory and self.memory.flee_hp_lock))) then
				if self.memory then
					self.memory.flee_state = false
					self.memory.flee_hp_lock = nil
					x_mob_core.mob_memory.clear_danger_memory(self)
				end
				self:on_return_to_fight()
			elseif self.hp <= flee_thresh and self.memory then
				self.memory.flee_hp_lock = true
			end

			-- Leash panic: prevent minion from fleeing beyond leash distance from Shaman
			local within_leash, s_pos = x_mob_core.check_leash(self)
			if not within_leash and s_pos then
				self.panic_timer = nil
				if self.memory then
					self.memory.flee_state = false
					self.memory.flee_hp_lock = nil
					x_mob_core.mob_memory.clear_danger_memory(self)
				end
				self:on_return_to_fight()
			end

			if self.state == "fleeing" then
				x_mob_core.step_move_or_idle(self, dtime, "flee", 1.3)
				return
			end
		end

		if self.state == "returning" then
			local fpos = x_mob_core.mob_memory.get_fight_pos(self)
			local pos = self.object:get_pos()
			if fpos and pos then
				local dx = pos.x - fpos.x
				local dz = pos.z - fpos.z
				if (dx * dx + dz * dz) <= 4.0 then
					x_mob_core.mob_memory.clear_fight_pos(self)
					self.nav_target_pos = nil
					self.state = (self.leader_obj and self.leader_obj:is_valid()) and "regrouping" or "idle"
				else
					self.nav_target_pos = fpos
					x_mob_core.step_move_or_idle(self, dtime, "walk", 1.2)
					return
				end
			else
				self.state = "idle"
				self.nav_target_pos = nil
			end
		end

		if self.state == "regrouping" then
			if x_mob_core.step_regroup(self, dtime, "walk", 1.25) then
				return
			end
			self.state = "idle"
		end

		if not self.target then
			x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
			return
		end

		local pos = self.object:get_pos()
		local tpos = self.target:get_pos()
		if not pos or not tpos then return end
		local dist = vector.distance(pos, tpos)
		local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 1.2), z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.2, z = tpos.z}
		local attack_los = x_mob_core.line_of_sight(eye_pos, target_eye)

		if attack_los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			self.state = "attacking"
			self.action_timer = 0.5
			self.attack_cooldown = 1.5
			x_mob_core.halt_horizontal_velocity(self)

			local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
			self.object:set_yaw(yaw)
			self._cur_rot = {x = 0, y = yaw, z = 0}

			x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})

			x_mob_core.schedule(self, 0.25, "scheduled_action", function()
				if self.target and x_mob_core.is_player_alive(self.target) then
					local cp = self.object:get_pos()
					local tp = self.target:get_pos()
					if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.5 then
						local c_eye = {x = cp.x, y = cp.y + (self.eye_offset or 1.2), z = cp.z}
						local t_eye = {x = tp.x, y = tp.y + 1.2, z = tp.z}
						if x_mob_core.line_of_sight(c_eye, t_eye) then
							self.target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = 4},
							}, vector.direction(cp, tp))
						end
					end
				end
			end)
			return
		end

		-- In melee striking range but on attack cooldown: hold ground and face target without colliding
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

-- Register natural spawns via x_mob_core (fallen cultist minions roaming in small packs)
x_mob_core.register_spawn("x_mobs:fallen_minion", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:dirt",
		"default:desert_stone",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:cursed_stone_carved",
	},
	chance = 2400,
	active_object_count = 5,
	group_min = 2,
	group_max = 4,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
