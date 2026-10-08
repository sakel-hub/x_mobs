--[[
	x_mobs - Skull King
]]

local function get_minion_counts(self)
	local alive_count, followers = x_mob_core.clean_followers(self)
	local lancer_count = 0
	local archer_count = 0
	for i = 1, alive_count do
		local m_obj = followers[i]
		if m_obj and m_obj:is_valid() then
			local m_ent = m_obj:get_luaentity()
			if m_ent then
				if m_ent.name == "x_mobs:skull_lancer" then
					lancer_count = lancer_count + 1
				elseif m_ent.name == "x_mobs:skull_archer" then
					archer_count = archer_count + 1
				end
			end
		end
	end
	return alive_count, lancer_count, archer_count
end

local function spawn_minion(self)
	x_mob_core.adopt_nearby_orphans(self, 32.0)
	local alive_count, lancer_count, archer_count = get_minion_counts(self)
	local max_minions = self.pack_max_followers or 3
	if alive_count >= max_minions then return nil end

	if self.summons_count >= self.max_total_summons then return nil end

	local pos = self.object:get_pos()
	if not pos then return nil end

	local minion_name
	-- Balanced spawning between archer and lancer
	if archer_count < lancer_count then
		minion_name = "x_mobs:skull_archer"
	elseif lancer_count < archer_count then
		minion_name = "x_mobs:skull_lancer"
	else
		minion_name = math.random(1, 2) == 1 and "x_mobs:skull_lancer" or "x_mobs:skull_archer"
	end

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
		cpos = {x = pos.x + math.random(-2, 2), y = pos.y, z = pos.z + math.random(-2, 2)}
	end

	-- Obstacle avoidance: prevent minion spawning inside solid blocks
	cpos = x_mob_core.avoid_solid_nodes(cpos, pos, to_target)

	local minion_static = core.serialize({
		hp = (minion_name == "x_mobs:skull_lancer" and 25 or 20),
		pack_id = self.pack_id,
	})
	local m_obj = core.add_entity(cpos, minion_name, minion_static)
	if m_obj and m_obj:is_valid() then
		x_mob_core.add_follower(self, m_obj)
		if self.target then
			local m_ent = m_obj:get_luaentity()
			if m_ent then
				m_ent.target = self.target
				m_ent.state = "walk"
			end
			if tpos and to_target then
				m_obj:set_yaw(core.dir_to_yaw(to_target))
			end
			x_mob_core.rally_followers(self, self.target)
		end

		-- Summon particles
		x_mobs.spawn_magic_summon(cpos)
		x_mobs.spawn_bone_dust(cpos)

		x_mob_core.play_sound(self, "summon", {
			pos = cpos,
			gain = 1.0,
			distance = 32.0,
		})

		self.summons_count = self.summons_count + 1
		if self.saved_data then
			self.saved_data.summons_count = self.summons_count
		end
		self.cooldowns.summon = 1.0
		return m_obj
	end

	return nil
end

x_mob_core.register_mob("x_mobs:skull_king", {
	initial_properties = {
		hp_max = 120,
		mesh = "x_mobs_skull_king.glb",
		textures = {
			"x_mobs_skull_king.png",
		},
		visual_size = {x = 8, y = 8},
		collisionbox = {-0.5, 0.0, -0.5, 0.5, 2.2, 0.5},
		glow = 2,
	},

	armor_groups = { fleshy = 80 },
	knockback_mult = 0.3,
	factions = { "undead", "skeleton", "boss" },
	walk_speed = 3.5,
	wander_speed = 1.5,
	wander_radius = 8.0,
	attack_range = 3.0,
	damage = 8,
	can_open_doors = true,
	can_climb = true,
	death_duration = 2.0,
	damage_effect = { type = "none" },
	health_regen = {
		rate = 3.0,
		flee_threshold = 25,
		return_threshold = 50,
	},
	on_regen_step = function(self)
		if self.object and self.object:is_valid() then
			x_mobs.spawn_regen_particles(self.object)
		end
	end,
	drops = {
		{ name = "default:gold_ingot",          min = 1, max = 3, chance = 0.80 },
		{ name = "default:mese_crystal",        min = 1, max = 2, chance = 0.50 },
		{ name = "default:diamond",             min = 1, max = 1, chance = 0.20 },
	},

	pack = {
		role = "leader",
		max_followers = 3,
		follower_type = {"x_mobs:skull_lancer", "x_mobs:skull_archer"},
		spawn_on_init = true,
		swarm_alert = true,
	},

	swarm_alert = {
		radius = 24.0,
		max_allies = 8,
	},

	cooldowns = {
		summon = 2.0,
	},

	sounds = {
		gain = 1.0,
		distance = 32.0,
		attack = "x_mobs_skull_king_attack",
		hurt = "x_mobs_skull_king_hurt",
		death = "x_mobs_skull_king_death",
		random = "x_mobs_skull_king_idle",
		summon = "x_mobs_skull_king_summon",
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.0, loop = true},
		attack = {track = "punch",  speed = 1.0, loop = false},
		punch  = {track = "punch",  speed = 1.0, loop = false},
		punch2 = {track = "punch2", speed = 1.0, loop = false},
		shoot  = {track = "shoot",  speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 1.48, z = 0 } },
		Head = { pivot = { x = 0, y = 2.32, z = 0 } },
		Arm_Left = { pivot = { x = -0.74, y = 2.52, z = 0 } },
		Hand_Left = { pivot = { x = -0.75, y = 1.6, z = 0 } },
		Arm_Right = { pivot = { x = 0.74, y = 2.52, z = 0 } },
		Hand_Right = { pivot = { x = 0.72, y = 1.54, z = 0 } },
		Wield_Item = { pivot = { x = 0.7, y = 0.92, z = -0.51 } },
		Leg_Left = { pivot = { x = -0.23, y = 1.05, z = 0 } },
		Foot_Left = { pivot = { x = -0.23, y = 0.71, z = 0 } },
		Leg_Right = { pivot = { x = 0.2, y = 1.05, z = 0 } },
		Foot_Right = { pivot = { x = 0.2, y = 0.7, z = 0 } },
	},


	can_flinch = function(self)
		return self.state ~= "summoning" and self.state ~= "attacking"
	end,

	on_activate = function(self, data)
		self.cooldowns.summon = 2.0
		self.summons_count = (data and data.summons_count) or 0
		self.max_total_summons = 24
		self.saved_data = self.saved_data or {}
		self.saved_data.summons_count = self.summons_count
	end,

	vfx = {
		hurt = { type = "bone_dust" },
		death = { type = "bone_dust" },
		despawn = { type = "bone_dust" },
	},

	on_action_end = function(self)
		if self.state == "summoning" then
			spawn_minion(self)
			x_mob_core.set_armor_groups(self, { fleshy = 80 })
		end
	end,

	melee = {
		range = 3.0,
		cooldown = 1.2,
		duration = 0.8,
		attacks = {
			{
				weight = 50,
				animation = "punch",
				anim_speed = 1.2,
				sound = "attack",
				delay = 0.4,
				damage = 8,
				on_strike = function(_self, target, _dir)
					x_mob_core.apply_status_effect(target, {
						id = "bone_shackles",
						type = "debuff",
						chance = 0.20,
						duration = 3.0,
						speed_factor = 0.0,
						jump_factor = 0.0,
						anti_heal = true,
						envelop_texture = "x_mobs_bone_envelop.png",
						hud_vignette = "x_mob_core_vignette.png^[colorize:#ddddddbb",
					})
				end,
			},
			{
				weight = 50,
				animation = "punch2",
				anim_speed = 1.2,
				sound = "attack",
				delay = 0.4,
				damage = 8,
				on_strike = function(_self, target, _dir)
					x_mob_core.apply_status_effect(target, {
						id = "bone_shackles",
						type = "debuff",
						chance = 0.20,
						duration = 3.0,
						speed_factor = 0.0,
						jump_factor = 0.0,
						anti_heal = true,
						envelop_texture = "x_mobs_bone_envelop.png",
						hud_vignette = "x_mob_core_vignette.png^[colorize:#ddddddbb",
					})
				end,
			},
		},
	},

	--- Pre-combat custom step hook: handles summoning minions when guard line is depleted
	---@param _dtime number Delta time in seconds
	custom_step = function(self, _dtime)
		if self.state == "fleeing" or (self.action_timer or 0) > 0 then
			return false
		end

		if not self.target or not x_mob_core.is_player_alive(self.target) then
			return false
		end

		local alive_minions = get_minion_counts(self)
		local max_minions = self.pack_max_followers or 3

		local can_summon = alive_minions < max_minions
			and (self.cooldowns.summon or 0) <= 0
			and (self.summons_count or 0) < (self.max_total_summons or 24)

		if can_summon then
			local pos = self.object:get_pos()
			local tpos = self.target:get_pos()
			if pos and tpos then
				self.state = "summoning"
				self.action_timer = 0.8
				x_mob_core.halt_horizontal_velocity(self)
				self.object:set_yaw(core.dir_to_yaw(vector.direction(pos, tpos)))
				x_mob_core.play_animation(self.object, "shoot", {speed = 1.0, loop = false})
				-- Defensive buff while summoning
				x_mob_core.set_armor_groups(self, { fleshy = 40 })
				return true
			end
		end

		return false
	end,
})

-- Register natural spawns via x_mob_core (undead boss, spawns at night or underground with royal retinue)
x_mob_core.register_spawn("x_mobs:skull_king", {
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
	chance = 5000,
	active_object_count = 1,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 15,
})

