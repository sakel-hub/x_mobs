--[[
	x_mobs - Fallen Shaman
]]


-- Combat spacing and spell physics
local STANDOFF_MIN = 8.0
local STANDOFF_MAX = 14.0
local FIREBALL_RANGE = 18.0
local FIREBALL_SPEED = 14.0

local function get_minion_status(self)
	local alive_count = x_mob_core.clean_followers(self)
	local fleeing_count = 0
	local followers = self.pack_followers or self.minions or {}
	for i = 1, #followers do
		local m_obj = followers[i]
		if m_obj and m_obj:is_valid() then
			local m_ent = m_obj:get_luaentity()
			if m_ent and (m_ent.state == "fleeing" or
					(m_ent.panic_timer and m_ent.panic_timer > 0) or
					(m_ent.memory and m_ent.memory.flee_state)) then
				fleeing_count = fleeing_count + 1
			end
		end
	end
	return alive_count, fleeing_count
end

--- Spawns a resurrected minion interposing between the Shaman and target
---@param self table Mob entity instance
---@return ObjectRef|nil m_obj Spawned minion object or nil
local function spawn_resurrected_minion(self)
	x_mob_core.adopt_nearby_orphans(self, 32.0)
	local count = x_mob_core.clean_followers(self)
	local max_minions = self.pack_max_followers or 3
	if count >= max_minions then
		return nil
	end

	local pos = self.object and self.object:is_valid() and self.object:get_pos()
	if not pos then return nil end

	local tpos = self.target and x_mob_core.is_player_alive(self.target) and self.target:get_pos()
	local cpos
	local to_target

	if tpos then
		to_target = vector.direction(pos, tpos)
		to_target.y = 0
		local len = math.sqrt(to_target.x * to_target.x + to_target.z * to_target.z)
		if len > 0.01 then
			to_target = {x = to_target.x / len, y = 0, z = to_target.z / len}
		else
			to_target = {x = 0, y = 0, z = 1}
		end
		-- Interposing meat-shield: spawn 1.8 blocks ahead directly between Shaman and player
		cpos = {
			x = pos.x + to_target.x * 1.8 + (math.random() - 0.5) * 0.4,
			y = pos.y,
			z = pos.z + to_target.z * 1.8 + (math.random() - 0.5) * 0.4,
		}
	else
		cpos = {x = pos.x + math.random(-2, 2), y = pos.y, z = pos.z + math.random(-2, 2)}
	end

	-- Obstacle avoidance: prevent minion spawning inside solid blocks
	cpos = x_mob_core.avoid_solid_nodes(cpos, pos, to_target)

	if not self.pack_id then
		self.pack_id = x_mob_core.generate_uuid()
	end
	local minion_static = core.serialize({hp = 15, pack_id = self.pack_id})
	local m_obj = core.add_entity(cpos, "x_mobs:fallen_minion", minion_static)
	if m_obj and m_obj:is_valid() then
		x_mob_core.add_follower(self, m_obj)
		if self.target then
			local m_ent = m_obj:get_luaentity()
			if m_ent then
				m_ent.target = self.target
				m_ent.state = "walk"
			end
			if tpos and to_target then
				local yaw = core.dir_to_yaw(to_target)
				m_obj:set_yaw(yaw)
				if m_ent then
					m_ent._cur_rot = {x = 0, y = yaw, z = 0}
				end
			end
			x_mob_core.rally_followers(self, self.target)
		end
		x_mobs.spawn_shaman_resurrect_burst(cpos)
		self.cooldowns.resurrect = 4.0
		return m_obj
	end

	return nil
end

-- Register the Fireball Projectile
core.register_entity("x_mobs:shaman_fireball", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_fireball.png^[colorize:#ff4400:150"},
		visual_size = {x = 0.5, y = 0.5},
		spritediv = {x = 1, y = 4},
		initial_sprite_basepos = {x = 0, y = 0},
		glow = 14,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "fallen", "cultist" },
	on_activate = function(self, _staticdata, _dtime_s)
		self.object:set_sprite({x = 0, y = 0}, 4, 0.1, false)
		self.object:set_armor_groups({ immortal = 1 })
		self.object:set_properties({
			pointable = false,
			selectionbox = {0, 0, 0, 0, 0, 0},
			collisionbox = {0, 0, 0, 0, 0, 0},
			collide_with_objects = false,
		})
	end,
	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,
	on_rightclick = function(_self, _clicker)
	end,
	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			lifetime = 6.0,
			on_step = function(_proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					x_mobs.spawn_fireball_trail(pos)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 8, fire = 1},
				}, dir)
				proj._punched_direct = hit_obj

				-- Check spider web combustion synergy
				if x_mob_core.has_status_effect(hit_obj, "web") then
					x_mob_core.remove_status_effect(hit_obj, "web")
					local pos = hit_obj:get_pos()
					if pos then
						core.sound_play("x_mobs_fireball", {pos = pos, gain = 0.8, pitch = 1.3, max_hear_distance = 20}, true)
					end
				end

				-- Apply 1 HP DoT burning with flame envelop and water cleansing
				x_mob_core.apply_status_effect(hit_obj, {
					id = "ignite",
					type = "dot",
					chance = 0.20,
					duration = 5.0,
					damage = 1,
					interval = 1.0,
					damage_type = "fleshy",
					caster = source,
					penetrate_armor = true,
					cleanse_in_water = true,
					envelop_texture = "x_mobs_fire_envelop.png",
					particles = {
						amount = 8,
						time = 0,
						minpos = {x = -0.25, y = 0.2, z = -0.25},
						maxpos = {x = 0.25, y = 1.0, z = 0.25},
						minvel = {x = -0.15, y = 0.4, z = -0.15},
						maxvel = {x = 0.15, y = 1.2, z = 0.15},
						minacc = {x = 0, y = 0.5, z = 0},
						maxacc = {x = 0, y = 1.0, z = 0},
						texture = "x_mob_core_sparkle.png^[multiply:#FF8800",
						glow = 13,
					},
				})
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_fireball_impact(hit_pos)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Splash damage (radius 2.5 blocks)
				local objs = core.get_objects_inside_radius(hit_pos, 2.5)
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
							damage_groups = {fleshy = 8, fire = 1},
						}, dir)

						-- Splash ignite
						x_mob_core.apply_status_effect(obj, {
							id = "ignite",
							type = "dot",
							chance = 0.20,
							duration = 4.0,
							damage = 1,
							interval = 1.0,
							damage_type = "fleshy",
							caster = source,
							penetrate_armor = true,
							cleanse_in_water = true,
							envelop_texture = "x_mobs_fire_envelop.png",
							particles = {
								amount = 6,
								time = 0,
								minpos = {x = -0.25, y = 0.2, z = -0.25},
								maxpos = {x = 0.25, y = 1.0, z = 0.25},
								minvel = {x = -0.15, y = 0.4, z = -0.15},
								maxvel = {x = 0.15, y = 1.2, z = 0.15},
								texture = "x_mob_core_sparkle.png^[multiply:#FF8800",
								glow = 13,
							},
						})
					end
				end
			end,
		})
	end
})

x_mob_core.register_mob("x_mobs:fallen_shaman", {
	initial_properties = {
		hp_max = 45,
		mesh = "x_mobs_fallen_shaman.glb",
		textures = {
			"x_mobs_fallen_shaman.png",
		},
		visual_size = {x = 8, y = 8},
		glow = 2,
	},

	armor_groups = { fleshy = 90 },
	factions = { "fallen", "cultist" },
	wander_radius = 8.0,
	attack_range = 2.5,
	flee_speed = 4.2,
	health_regen = {
		flee_threshold = 15,
	},
	can_open_doors = true,
	can_climb = true,
	death_duration = 1.4,
	damage_effect = { type = "blood", scale = 1.1 },
	drops = {
		{ name = "default:gold_lump",           min = 1, max = 2, chance = 0.65 },
		{ name = "default:gold_ingot",          min = 1, max = 1, chance = 0.25 },
		{ name = "default:book",                min = 1, max = 1, chance = 0.40 },
		{ name = "default:paper",               min = 1, max = 3, chance = 0.55 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 3, chance = 0.50 },
		{ name = "default:flint",               min = 1, max = 2, chance = 0.50 },
		{ name = "vessels:glass_bottle",        min = 1, max = 2, chance = 0.35 },
		{ name = "flowers:mushroom_red",        min = 1, max = 1, chance = 0.30 },
	},

	pack = {
		role = "leader",
		follower_type = "x_mobs:fallen_minion",
		max_followers = 3,
		spawn_on_init = true,
	},

	cooldowns = {
		cast = 2.0,
		resurrect = 3.0,
	},

	sounds = {
		distance = 20.0,
		hurt = { name = "x_mobs_minion", pitch = 0.75 },
		death = { name = "x_mobs_minion_death", pitch = 0.75 },
	},

	animations = {
		idle      = {track = "idle",      speed = 1.0, loop = true},
		walk      = {track = "walk",      speed = 1.0, loop = true},
		attack    = {track = "attack",    speed = 1.0, loop = false},
		flee      = {track = "flee",      speed = 1.2, loop = true},
		hurt      = {track = "hurt",      speed = 1.0, loop = false},
		death     = {track = "death",     speed = 1.0, loop = false},
		cast      = {track = "cast",      speed = 1.0, loop = false},
		resurrect = {track = "resurrect", speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.6, z = 0 } },
		Head = { pivot = { x = 0, y = 1.8, z = 0 } },
		Arm_Left = { pivot = { x = -0.55, y = 1.6, z = 0 } },
		Arm_Right = { pivot = { x = 0.55, y = 1.6, z = 0 } },
		Wield_Item = { pivot = { x = 0.55, y = 0.7, z = 0 } },
		Leg_Left = { pivot = { x = -0.2, y = 1.0, z = 0 } },
		Leg_Right = { pivot = { x = 0.2, y = 1.0, z = 0 } },
	},


	can_flinch = function(self)
		return self.state ~= "resurrecting"
	end,

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.cast = 2.0
		self.cooldowns.resurrect = 3.0
		x_mob_core.adopt_nearby_orphans(self, 32.0)
	end,

	vfx = {
		death = { type = "flame", scale = 1.4 },
	},

	on_hurt = function(self, puncher, _dmg)
		if self.state == "resurrecting" then
			local pos = self.object:get_pos()
			if pos then
				x_mobs.spawn_shaman_interrupted_burst(pos)
			end

			-- Emergency backfire pushback on melee attacker
			if puncher and puncher:is_valid() and pos then
				local ppos = puncher:get_pos()
				if ppos and vector.distance(pos, ppos) <= 3.5 then
					local push_dir = vector.direction(pos, ppos)
					push_dir.y = 0
					local plen = math.sqrt(push_dir.x * push_dir.x + push_dir.z * push_dir.z)
					if plen > 0.01 then
						push_dir = {x = push_dir.x / plen, y = 0, z = push_dir.z / plen}
					else
						push_dir = {x = 0, y = 0, z = 1}
					end
					puncher:add_velocity({x = push_dir.x * 4.5, y = 1.8, z = push_dir.z * 4.5})
					puncher:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 3, fire = 1},
					}, push_dir)
				end
				-- Distress call: summon all minions to swarm and bodyblock the attacker
				x_mob_core.rally_followers(self, puncher)
				self.target = puncher
			end

			-- Abort action-lock and initiate tactical sprint flee
			self.action_timer = nil
			self.state = "fleeing"
			self.panic_timer = 3.0
			self.cooldowns.resurrect = 5.0
			if self.memory then
				self.memory.flee_state = true
			end
			x_mob_core.play_animation(self.object, "flee", {speed = 1.2, loop = true, force = true})
		end
	end,

	on_action_end = function(self)
		if self.state == "resurrecting" then
			spawn_resurrected_minion(self)
		end
	end,

	perform_cast = function(self, pos, tpos)
		self.state = "casting"
		self.action_timer = 0.8
		self.cooldowns.cast = 3.5
		x_mob_core.rally_followers(self, self.target)
		x_mob_core.halt_horizontal_velocity(self)
		self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
		x_mob_core.play_animation(self.object, "cast", {speed = 1.0, loop = false})

		x_mob_core.schedule(self, 0.4, "scheduled_action", function()
			if self.target and x_mob_core.is_player_alive(self.target) then
				local cp = self.object:get_pos()
				local tp = self.target:get_pos()
				if cp and tp then
					local origin = {x = cp.x, y = cp.y + 1.4, z = cp.z}
					local tgt_center = {x = tp.x, y = tp.y + 1.0, z = tp.z}
					local t_vel = self.target:get_velocity()
					local dir = select(2, x_mob_core.predict_aim(origin, tgt_center, t_vel, FIREBALL_SPEED))

					local yaw = core.dir_to_yaw(dir)
					self.object:set_yaw(yaw)
					self._cur_rot = {x = 0, y = yaw, z = 0}

					local spawn_pos = {
						x = origin.x + dir.x * 0.8,
						y = origin.y + dir.y * 0.8,
						z = origin.z + dir.z * 0.8,
					}
					local fb = core.add_entity(spawn_pos, "x_mobs:shaman_fireball")
					if fb and fb:is_valid() then
						local fb_ent = fb:get_luaentity()
						if fb_ent then
							fb_ent._shooter = self.object
						end
						fb:set_velocity(vector.multiply(dir, FIREBALL_SPEED))
					end
				end
			end
		end)
	end,

	on_step = function(self, dtime)
		if self.panic_timer and self.panic_timer > 0 then
			self.panic_timer = math.max(0, self.panic_timer - dtime)
		end

		local alive_minions, fleeing_minions = get_minion_status(self)
		local max_minions = self.pack_max_followers or 3
		local flee_thresh = (self.health_regen and self.health_regen.flee_threshold) or 15

		-- Shaman retreats when low HP, alongside fleeing minions, or when defenseless
		if self.hp <= flee_thresh and self.target ~= nil then
			self.state = "fleeing"
			self.panic_timer = math.max(self.panic_timer or 0, 3.0)
			if self.memory then self.memory.flee_state = true end
		elseif alive_minions > 0 and fleeing_minions >= alive_minions then
			self.state = "fleeing"
			self.panic_timer = math.max(self.panic_timer or 0, 3.5)
			if self.memory then self.memory.flee_state = true end
		elseif alive_minions == 0 and self.target and (self.cooldowns.resurrect or 0) > 0 then
			local cp = self.object:get_pos()
			local tp = self.target:get_pos()
			if cp and tp and vector.distance(cp, tp) < STANDOFF_MIN then
				self.state = "fleeing"
				self.panic_timer = math.max(self.panic_timer or 0, 2.5)
				if self.memory then self.memory.flee_state = true end
			end
		end

		if self.state == "fleeing" then
			local cp = self.object and self.object:is_valid() and self.object:get_pos()
			local tp = self.target and self.target:is_valid() and self.target:get_pos()
			local target_dist = (cp and tp) and vector.distance(cp, tp) or 999

			-- 1. Emergency Melee Defense (Whirl and strike if pursued into close melee while fleeing)
			local ep = cp and {x = cp.x, y = cp.y + (self.eye_offset or 1.5), z = cp.z}
			local tep = tp and {x = tp.x, y = tp.y + 1.5, z = tp.z}
			local flee_melee_los = ep and tep and x_mob_core.line_of_sight(ep, tep)
			if flee_melee_los and target_dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 and cp and tp then
				self.state = "attacking"
				self.action_timer = 0.5
				self.attack_cooldown = 1.5
				x_mob_core.halt_horizontal_velocity(self)
				self.object:set_yaw(core.dir_to_yaw(vector.direction(cp, tp)))
				x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})

				x_mob_core.schedule(self, 0.25, "scheduled_action", function()
					if self.target and x_mob_core.is_player_alive(self.target) then
						local p1 = self.object:get_pos()
						local p2 = self.target:get_pos()
						if p1 and p2 and vector.distance(p1, p2) <= self.attack_range + 0.6 then
							local pe1 = {x = p1.x, y = p1.y + (self.eye_offset or 1.5), z = p1.z}
							local pe2 = {x = p2.x, y = p2.y + 1.5, z = p2.z}
							if x_mob_core.line_of_sight(pe1, pe2) then
								self.target:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = {fleshy = 6},
								}, vector.direction(p1, p2))
							end
						end
					end
				end)
				return
			end

			-- 2. Mobile Rearguard Summon: raise a minion in his wake while fleeing
			if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
				local m_spawned = spawn_resurrected_minion(self)
				if m_spawned then
					alive_minions = alive_minions + 1
					-- Dynamic Panic Recovery: if Shaman is not critically wounded, restore combat stance
					if self.hp > flee_thresh then
						self.panic_timer = nil
						self.state = "walk"
						if self.memory then self.memory.flee_state = false end
						-- Fall through to combat logic below instead of fleeing blindly
					end
				end
			end

			-- Check panic timer expiration
			if self.panic_timer and self.panic_timer <= 0 then
				self.panic_timer = nil
				if self.hp > flee_thresh and (alive_minions > 0 and fleeing_minions == 0 or target_dist >= STANDOFF_MIN) then
					self.state = "idle"
					if self.memory then self.memory.flee_state = false end
				end
			end

			if self.state == "fleeing" then
				x_mob_core.step_move_or_idle(self, dtime, "flee", 1.2)
				return
			end
		end

		local pos = self.object:get_pos()
		if not pos then return end

		-- No combat target: resurrect missing minions at leisure or wander
		if not self.target then
			if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
				x_mob_core.adopt_nearby_orphans(self, 32.0)
				alive_minions = x_mob_core.clean_followers(self)
				if alive_minions < max_minions then
					self.state = "resurrecting"
					self.action_timer = 1.2
					x_mob_core.halt_horizontal_velocity(self)
					x_mob_core.play_animation(self.object, "resurrect", {speed = 1.0, loop = false})
					x_mobs.spawn_shaman_resurrect_particles(pos)
					return
				end
			end
			x_mob_core.step_wander_or_idle(self, dtime)
			return
		end

		local tpos = self.target:get_pos()
		if not tpos then return end

		local dist = vector.distance(pos, tpos)
		local eye_pos = {x = pos.x, y = pos.y + self.eye_offset, z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
		local los = x_mob_core.line_of_sight(eye_pos, target_eye)

		-- 1. Emergency Melee Defense (Staff strike when trapped in close combat)
		if los and dist <= self.attack_range and (self.attack_cooldown or 0) <= 0 then
			self.state = "attacking"
			self.action_timer = 0.6
			self.attack_cooldown = 1.5
			x_mob_core.halt_horizontal_velocity(self)
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
			x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})

			x_mob_core.schedule(self, 0.3, "scheduled_action", function()
				if self.target and x_mob_core.is_player_alive(self.target) then
					local cp = self.object:get_pos()
					local tp = self.target:get_pos()
					if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.5 then
						local pe1 = {x = cp.x, y = cp.y + (self.eye_offset or 1.5), z = cp.z}
						local pe2 = {x = tp.x, y = tp.y + 1.5, z = tp.z}
						if x_mob_core.line_of_sight(pe1, pe2) then
							self.target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {fleshy = 6},
							}, vector.direction(cp, tp))
						end
					end
				end
			end)
			return
		end

		-- 2. Close Pressure Kiting (Player pushed past minions into danger zone: dist < STANDOFF_MIN)
		-- Caster MUST NOT channel stationary resurrection here! Priority is interposing meat-shield & separation.
		if dist < STANDOFF_MIN then
			-- Meat wall priority: if minions are missing, instantly summon an interposing meat-shield
			if alive_minions < max_minions and (self.cooldowns.resurrect or 0) <= 0 then
				local m_spawned = spawn_resurrected_minion(self)
				if m_spawned then
					if self.hp > flee_thresh then
						self.state = "walk"
						if self.memory then self.memory.flee_state = false end
					end
				end
			elseif alive_minions == 0 and (self.cooldowns.resurrect or 0) > 0 then
				-- Completely defenseless (no meat wall and summon on cooldown): panic sprint flee
				self.state = "fleeing"
				self.panic_timer = math.max(self.panic_timer or 0, 2.5)
				if self.memory then self.memory.flee_state = true end
				x_mob_core.step_move_or_idle(self, dtime, "flee", 1.2)
				return
			end

			-- Fireball attack if meat wall is intact or summon on cooldown
			if los and dist > self.attack_range and dist <= FIREBALL_RANGE and (self.cooldowns.cast or 0) <= 0 then
				self:perform_cast(pos, tpos)
				return
			end

			local retreated = x_mob_core.retreat_from(self, tpos, self.flee_speed or 4.2)
			if retreated then
				if self.state ~= "walk" then
					self.state = "walk"
					x_mob_core.play_animation(self.object, "walk", {speed = 1.2, loop = true})
				end
			else
				-- Backed against wall or obstacle: cast spell if ready, or navigate around obstacle
				if los and dist <= FIREBALL_RANGE and (self.cooldowns.cast or 0) <= 0 then
					self:perform_cast(pos, tpos)
					return
				end
				x_mob_core.step_move_or_idle(self, dtime, "walk", 1.2)
			end
			return
		end

		-- 3. Safe Standoff or Broken LOS: Channel Resurrection Ritual
		-- Triggered only when target is at safe distance (dist >= STANDOFF_MIN) or behind walls (not los)
		if (self.cooldowns.resurrect or 0) <= 0 and alive_minions < max_minions then
			self.state = "resurrecting"
			self.action_timer = 1.2
			x_mob_core.halt_horizontal_velocity(self)
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
			x_mob_core.play_animation(self.object, "resurrect", {speed = 1.0, loop = false})
			x_mobs.spawn_shaman_resurrect_particles(pos)
			return
		end

		-- 4. If line of sight is broken: navigate towards player
		if not los then
			x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0)
			return
		end

		-- 5. Standoff Zone (8.0 to 14.0 blocks) - Backline Caster & Fireball Channel
		if dist >= STANDOFF_MIN and dist <= STANDOFF_MAX then
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))

			if dist <= FIREBALL_RANGE and (self.cooldowns.cast or 0) <= 0 then
				self:perform_cast(pos, tpos)
				return
			end

			-- Hold stationary backline formation
			x_mob_core.halt_horizontal_velocity(self)
			if self.state ~= "idle" then
				self.state = "idle"
				x_mob_core.play_animation(self.object, "idle", {speed = 1.0, loop = true})
			end
			return
		end

		-- 6. Target Beyond Standoff Range (> 14 blocks) - Advance towards backline position
		x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0)
	end
})

-- Register natural spawns via x_mob_core (fallen cultist shaman, leads minions in dark caverns or night)
x_mob_core.register_spawn("x_mobs:fallen_shaman", {
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
	chance = 3500,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
	min_elevation = -31000,
	max_elevation = 31000,
})
