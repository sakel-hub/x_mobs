--[[
	x_mobs - Crazy Mushroom
	Towering fungal forest boss mob that commands a retinue of Fungus Minions.
	Fires toxic spore balls at mid-range and delivers heavy martial cross punches when caught in melee.
]]

local SPORE_BALL_SPEED = 18.0
local SUMMON_COOLDOWN = 6.0

-- ============================================================================
-- Spore Ball Projectile Entity
-- ============================================================================

core.register_entity("x_mobs:spore_ball", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_mushroom_particles.png^[sheet:8x8:0,5"},
		visual_size = {x = 0.65, y = 0.65},
		glow = 12,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "fungal", "boss" },

	on_activate = function(self, _staticdata, _dtime_s)
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
			lifetime = 5.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_spore_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 7},
				}, dir)
				proj._punched_direct = hit_obj
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_spore_burst(hit_pos)
				core.sound_play("x_mobs_spore_impact", {
					pos = hit_pos,
					gain = 0.9,
					max_hear_distance = 24.0,
				})
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Area spore burst (radius 2.5 blocks)
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
							damage_groups = {fleshy = 6},
						}, dir)
					end
				end
			end,
		})
	end
})

--- Spawns a single fungus minion near the crazy mushroom boss and links it to the squad
---@param self table Crazy mushroom entity instance
---@return ObjectRef|nil m_obj Spawned minion object or nil
local function spawn_minion(self)
	x_mob_core.adopt_nearby_orphans(self, 32.0)
	local count = x_mob_core.clean_followers(self)
	local max_minions = self.pack_max_followers or 3
	if count >= max_minions then return nil end

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
		cpos = {
			x = pos.x + to_target.x * 2.0 + (math.random() - 0.5) * 1.5,
			y = pos.y,
			z = pos.z + to_target.z * 2.0 + (math.random() - 0.5) * 1.5,
		}
	else
		local angle = math.random() * math.pi * 2
		local dist = 1.8 + math.random() * 0.8
		cpos = {
			x = pos.x + math.cos(angle) * dist,
			y = pos.y,
			z = pos.z + math.sin(angle) * dist,
		}
	end

	cpos = x_mob_core.avoid_solid_nodes(cpos, pos, to_target)

	if not self.pack_id then
		local utils = x_mob_core.utils
		self.pack_id = (utils and utils.generate_uuid and utils.generate_uuid()) or "pack_mushroom"
	end
	local minion_static = core.serialize({hp = 24, pack_id = self.pack_id})
	local m_obj = core.add_entity(cpos, "x_mobs:fungus_minion", minion_static)
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

		x_mobs.spawn_fungal_summon(cpos)
		x_mob_core.play_sound(self, "summon", {
			pos = cpos,
			gain = 1.0,
			distance = 32.0,
		})
		return m_obj
	end

	return nil
end

-- ============================================================================
-- Crazy Mushroom Boss Registration
-- ============================================================================

x_mob_core.register_mob("x_mobs:crazy_mushroom", {
	initial_properties = {
		hp_max = 140,
		mesh = "x_mobs_crazy_mushroom.glb",
		textures = {
			"x_mobs_crazy_mushroom.png",
		},
		visual_size = {x = 8, y = 8},
		collisionbox = {-0.6, 0.0, -0.6, 0.6, 2.5, 0.6},
		glow = 3,
	},

	armor_groups = { fleshy = 90 },
	knockback_mult = 0.35,
	factions = { "fungal", "boss" },
	walk_speed = 3.0,
	wander_speed = 1.4,
	wander_radius = 8.0,
	attack_range = 3.0,
	damage = 4,
	can_open_doors = true,
	can_climb = true,
	death_duration = 2.4,
	damage_effect = { type = "none" },
	health_regen = {
		rate = 3.0,
		flee_threshold = 42,
		return_threshold = 70,
	},
	drops = {
		{ name = "flowers:mushroom_red",   min = 2, max = 5, chance = 0.90 },
		{ name = "flowers:mushroom_brown", min = 2, max = 5, chance = 0.90 },
		{ name = "default:mese_crystal",   min = 1, max = 2, chance = 0.60 },
		{ name = "default:diamond",        min = 1, max = 1, chance = 0.30 },
	},

	pack = {
		role = "leader",
		max_followers = 3,
		follower_type = "x_mobs:fungus_minion",
		spawn_on_init = true,
	},

	cooldowns = {
		summon = 2.0,
		shoot = 2.0,
	},

	sounds = {
		gain = 1.0,
		distance = 32.0,
		attack = "x_mobs_mushroom_attack",
		hurt = "x_mobs_mushroom_hurt",
		death = "x_mobs_mushroom_death",
		random = "x_mobs_mushroom_idle",
		shoot = "x_mobs_mushroom_shoot",
		summon = "x_mobs_mushroom_summon",
	},

	animations = {
		idle   = {track = "stand",  speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "punch",  speed = 1.2, loop = false},
		punch  = {track = "punch",  speed = 1.2, loop = false},
		shoot  = {track = "shoot",  speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 1.0, z = 0 } },
		Head = { pivot = { x = 0, y = 2.2, z = 0 } },
	},

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.summon = self.cooldowns.summon or 2.0
		self.cooldowns.shoot = self.cooldowns.shoot or 2.0
		x_mob_core.adopt_nearby_orphans(self, 32.0)
	end,

	can_flinch = function(self)
		return self.state ~= "summoning" and self.state ~= "attacking" and self.state ~= "shooting"
	end,

	vfx = {
		hurt = { type = "mushroom_hurt", scale = 1.0 },
		death = { type = "mushroom_death", scale = 1.0 },
		despawn = { type = "mushroom_dissolve", scale = 1.8 },
	},

	on_action_end = function(self)
		if self.state == "summoning" then
			spawn_minion(self)
			self.cooldowns.summon = SUMMON_COOLDOWN
		end
	end,

	on_step = function(self, dtime)
		local alive_minions = x_mob_core.clean_followers(self)
		local max_minions = self.pack_max_followers or 3

		local pos = self.object:get_pos()
		if not pos then return end

		-- No combat target: summon missing minions one by one at leisure or wander
		if not self.target then
			if alive_minions < max_minions and (self.cooldowns.summon or 0) <= 0 then
				x_mob_core.adopt_nearby_orphans(self, 32.0)
				alive_minions = x_mob_core.clean_followers(self)
				if alive_minions < max_minions then
					self.state = "summoning"
					self.action_timer = 0.8
					x_mob_core.halt_horizontal_velocity(self)
					x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
					return
				end
			end
			x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
			return
		end

		local tpos = self.target:get_pos()
		if not tpos then return end

		local dist = vector.distance(pos, tpos)
		local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 2.1), z = pos.z}
		local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
		local los = x_mob_core.line_of_sight(eye_pos, target_eye)

		-- 1. MELEE ENGAGEMENT: Player caught up or reached close-quarters (dist <= 3.0 blocks)
		-- Halts retreat immediately and defends with heavy cross punch
		if dist <= self.attack_range and los then
			if (self.attack_cooldown or 0) <= 0 then
				self.state = "attacking"
				self.action_timer = 0.7
				self.attack_cooldown = 1.0
				x_mob_core.halt_horizontal_velocity(self)

				local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
				self.object:set_yaw(yaw)
				self._cur_rot = {x = 0, y = yaw, z = 0}

				x_mob_core.play_animation(self.object, "punch", {speed = 1.2, loop = false})
				x_mob_core.play_sound(self, "attack")

				x_mob_core.schedule(self, 0.35, "scheduled_action", function()
					if self.target and x_mob_core.is_player_alive(self.target) then
						local cp = self.object:get_pos()
						local tp = self.target:get_pos()
						if cp and tp and vector.distance(cp, tp) <= self.attack_range + 0.6 then
							local pe1 = {x = cp.x, y = cp.y + (self.eye_offset or 2.1), z = cp.z}
							local pe2 = {x = tp.x, y = tp.y + 1.5, z = tp.z}
							if x_mob_core.line_of_sight(pe1, pe2) then
								self.target:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = {fleshy = self.damage or 9},
								}, vector.direction(cp, tp))
							end
						end
					end
				end)
				return
			else
				-- On melee cooldown: stand ground in combat ready stance facing opponent
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
		end

		-- 2. TACTICAL RETREAT WHEN LOW ON HEALTH (HP < 30%)
		if self.state == "fleeing" then
			if dist < 12.0 and alive_minions > 0 then
				x_mob_core.retreat_from(self, tpos, 2.8)
				x_mob_core.play_animation(self.object, "walk", {speed = 1.0, loop = true})
				return
			else
				-- Safe distance reached behind minion vanguard: hold position and regenerate
				x_mob_core.halt_horizontal_velocity(self)
				local face_yaw = core.dir_to_yaw(vector.direction(pos, tpos))
				self.object:set_yaw(face_yaw)
				self._cur_rot = {x = 0, y = face_yaw, z = 0}
				x_mob_core.play_animation(self.object, "idle", {speed = 1.0, loop = true})
				return
			end
		end

		-- Summon reinforcements one by one when minion count falls below max
		if alive_minions < max_minions and (self.cooldowns.summon or 0) <= 0 and dist > 3.5 then
			self.state = "summoning"
			self.action_timer = 0.8
			x_mob_core.halt_horizontal_velocity(self)
			self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
			x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
			return
		end

		-- 4. MID-RANGE COMBAT: Kiting & Ranged Spore Blast (3.0 < dist <= 16.0 blocks)
		if los and dist <= 16.0 then
			-- Can shoot spore ball right now
			if (self.cooldowns.shoot or 0) <= 0 then
				self.state = "shooting"
				self.action_timer = 0.9
				self.cooldowns.shoot = 2.4
				x_mob_core.halt_horizontal_velocity(self)

				local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
				self.object:set_yaw(yaw)
				self._cur_rot = {x = 0, y = yaw, z = 0}

				x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
				x_mob_core.play_sound(self, "shoot")

				x_mob_core.schedule(self, 0.45, "scheduled_action", function()
					if self.target and x_mob_core.is_player_alive(self.target) then
						local cp = self.object:get_pos()
						local tp = self.target:get_pos()
						if cp and tp then
							local origin = {x = cp.x, y = cp.y + 1.8, z = cp.z}
							local tgt_center = {x = tp.x, y = tp.y + 1.2, z = tp.z}
							local t_vel = self.target:get_velocity() or {x = 0, y = 0, z = 0}
							local dir = select(2, x_mob_core.predict_aim(origin, tgt_center, t_vel, SPORE_BALL_SPEED))

							local s_yaw = core.dir_to_yaw(dir)
							self.object:set_yaw(s_yaw)
							self._cur_rot = {x = 0, y = s_yaw, z = 0}

							local spawn_pos = {
								x = origin.x + dir.x * 0.8,
								y = origin.y + dir.y * 0.8,
								z = origin.z + dir.z * 0.8,
							}
							local sp = core.add_entity(spawn_pos, "x_mobs:spore_ball")
							if sp and sp:is_valid() then
								local sp_ent = sp:get_luaentity()
								if sp_ent then
									sp_ent._shooter = self.object
								end
								sp:set_velocity(vector.multiply(dir, SPORE_BALL_SPEED))
							end
						end
					end
				end)
				return
			end

			-- On shoot cooldown: if player is approaching (dist < 5.5 blocks), kite backwards
			-- Notice: retreat speed (2.8) is slower than player speed (4.0+), allowing players to catch up
			if dist < 5.5 then
				x_mob_core.retreat_from(self, tpos, 2.8)
				x_mob_core.play_animation(self.object, "walk", {speed = 1.0, loop = true})
				return
			else
				-- At comfortable mid-range: face player and hold tactical firing stance
				x_mob_core.halt_horizontal_velocity(self)
				local yaw = core.dir_to_yaw(vector.direction(pos, tpos))
				self.object:set_yaw(yaw)
				self._cur_rot = {x = 0, y = yaw, z = 0}
				if self.state ~= "idle" then
					self.state = "idle"
					x_mob_core.play_animation(self.object, "idle", {speed = 1.0, loop = true})
				end
				return
			end
		end

		-- 5. DISTANT TARGET (> 16 blocks or obstructed): push forward steadily
		x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0)
	end
})

-- Register natural spawns via x_mob_core (forest/cave biome boss)
x_mob_core.register_spawn("x_mobs:crazy_mushroom", {
	nodes = {
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt",
		"group:soil",
		"group:stone",
	},
	chance = 4500,
	active_object_count = 1,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 12,
})
