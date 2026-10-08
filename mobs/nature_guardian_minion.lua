--[[
	x_mobs - Nature Guardian Minion
	Vanguard forest minion defending sacred groves, rainforests,
	and old-growth woods alongside ancient Nature Guardians. Features seasonal
	autumn bark foliage, sunlight photosynthesis regeneration, player-scale stature,
	kinetic hurt recoil, and an entangling root spell that traps intruders.
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

--- Nature Guardian Minion Mob Definition
x_mob_core.register_mob("x_mobs:nature_guardian_minion", {
	initial_properties = {
		hp_max = 60,
		mesh = "x_mobs_natureguardian.glb",
		-- Seasonal autumn foliage variations created via engine HSL texture modifier
		textures = {
			{ "x_mobs_natureguardian.png^[hsl:-70:25:-5" },   -- Autumn Amber
			{ "x_mobs_natureguardian.png^[hsl:-85:30:-10" },  -- Crimson Maple
			{ "x_mobs_natureguardian.png^[hsl:-55:20:5" },    -- Golden Birch
			{ "x_mobs_natureguardian.png^[hsl:-40:35:0" },    -- Russet Oak
			{ "x_mobs_natureguardian.png^[hsl:-100:15:-15" }, -- Withered Evergreen
		},
		-- Scaled to player model size (1.80 blocks tall):
		-- visual_size {x = 5.625, y = 5.625} aligns with collisionbox bounds [-0.28, 1.52] (1.80m height)
		visual_size = { x = 5.625, y = 5.625 },
		collisionbox = { -0.42, -0.28, -0.42, 0.42, 1.52, 0.42 },
		selectionbox = { -0.46, -0.28, -0.46, 0.46, 1.60, 0.46 },
		stepheight = 1.2,
		glow = 2,
		backface_culling = false,
		infotext = S("Nature Guardian Minion"),
	},

	-- Hardwood carapace with half resistance compared to boss (takes 85% fleshy cuts, 135% axe chops)
	armor_groups = { fleshy = 85, choppy = 135 },
	knockback_mult = 0.35,
	factions = { "nature", "guardian" },
	mob_height = 1.8,
	eye_offset = 1.35,
	walk_speed = 2.2,
	wander_speed = 1.4,
	pursuit_speed = 4.0,
	attack_range = 2.1,
	aggro_radius = 18.0,
	damage = 1.5,
	attack_interval = 1.6,
	death_duration = 2.04,

	-- Passive photosynthesis: regenerates health under open sky and direct sunlight
	health_regen = {
		rate = 0.4,
		passive = true,
		flee_threshold = 0,
		return_threshold = 0,
	},

	-- Squad coordination: rallies around Nature Guardian leader
	pack = {
		role = "member",
		leader_type = "x_mobs:nature_guardian",
		leash_distance = 18.0,
		regroup_distance = 4.0,
		on_leader_lost = "fight",
	},

	cooldowns = {
		root_spell = 14.0,
	},

	damage_effect = { type = "none" },

	drops = {
		{ name = "default:apple",                 min = 1, max = 2, chance = 0.85 },
		{ name = "default:sapling",               min = 1, max = 2, chance = 0.70 },
		{ name = "default:junglesapling",         min = 1, max = 1, chance = 0.40 },
		{ name = "default:tree",                  min = 1, max = 2, chance = 0.75 },
		{ name = "default:stick",                 min = 2, max = 5, chance = 0.85 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 2, chance = 0.30 },
	},

	sounds = {
		base = "x_mobs_nature_guardian",
		distance = 20.0,
		gain = 0.85,
		pitch_jitter = 0.08,
		attack = "x_mobs_nature_guardian_attack",
		hurt = "x_mobs_nature_guardian_hurt",
		death = "x_mobs_nature_guardian_death",
		random = "x_mobs_nature_guardian_idle",
		cast = "x_mobs_nature_guardian_cast",
	},

	-- Canonical animation tracks from x_mobs_natureguardian.glb
	animations = {
		idle   = { track = "idle",   speed = 1.0, loop = true },
		walk   = { track = "walk",   speed = 1.0, loop = true },
		run    = { track = "run",    speed = 1.1, loop = true },
		attack = { track = "attack", speed = 1.0, loop = false },
		spell  = { track = "spell",  speed = 1.0, loop = false },
		hurt   = { track = "hurt",   speed = 1.0, loop = false },
		death  = { track = "death",  speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 0.65, z = 0 } },
		Head = { pivot = { x = 0, y = 1.91, z = 0 } },
		Arm_Left = { pivot = { x = -0.56, y = 1.68, z = 0 } },
		Arm_Right = { pivot = { x = 0.57, y = 1.7, z = 0 } },
		Leg_Left = { pivot = { x = -0.19, y = 0.51, z = 0 } },
		Leg_Right = { pivot = { x = 0.18, y = 0.54, z = 0 } },
	},


	--- Poise hyper-armor: prevents flinching while swinging attacks or channeling spells
	---@return boolean can_flinch
	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "casting"
	end,

	--- Handles hurt reaction and companion pack threat broadcasting
	---@param puncher? ObjectRef Attacking entity
	---@param _dmg number Damage dealt
	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 20.0)
		end
		-- When struck and flinching, immediately halt momentum to brace defensive guard
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			local is_axe = false
			if puncher and puncher:is_valid() and puncher:is_player() then
				local wielded = puncher:get_wielded_item()
				if wielded and not wielded:is_empty() then
					local iname = wielded:get_name()
					local idef = core.registered_items[iname]
					local caps = idef and idef.tool_capabilities
					if (caps and caps.groupcaps and caps.groupcaps.choppy)
							or (core.get_item_group(iname, "axe") > 0) then
						is_axe = true
					end
				end
			end
			x_mobs.spawn_nature_guardian_hurt(pos)
			if is_axe then
				x_mob_core.play_sound(self, "x_mobs_nature_guardian_hurt", {
					gain = 1.0,
					pitch = 1.35,
					distance = 20.0,
				})
			end
		end
	end,

	--- Handles death visual effects
	---@param _killer? ObjectRef Entity delivering final blow
	on_death = function(self, _killer)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			x_mobs.spawn_nature_guardian_death(pos)
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

	--- Daylight photosynthesis: grants bonus vitality when exposed to bright sky light
	---@param _hp_added number Base regen HP
	on_regen_step = function(self, _hp_added)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			local light = core.get_node_light(pos) or 0
			if light >= 12 then
				local cur_hp = self.object:get_hp()
				local max_hp = self.hp_max or 60
				if cur_hp < max_hp then
					self.object:set_hp(math.min(max_hp, cur_hp + 1))
				end
				x_mobs.spawn_nature_roots_trapped(pos)
			end
		end
	end,

	-- Declarative Melee Combat Configuration:
	-- Close-quarters hardwood strike with kinetic knockback.
	melee = {
		range = 2.1,
		max_height_diff = 1.8,
		reach_tolerance = 0.8,
		damage = 1.5,
		cooldown = 1.6,
		duration = 1.33,
		delay = 0.75,
		animation = "attack",
		anim_speed = 1.0,
		sound = "attack",
		on_strike = function(_self, target, dir)
			local tp = target and target:is_valid() and target:get_pos()
			if tp then
				x_mobs.spawn_nature_guardian_attack(tp, dir)
				local kb_vel = { x = dir.x * 2.5, y = 1.5, z = dir.z * 2.5 }
				if target.add_player_velocity then
					target:add_player_velocity(kb_vel)
				elseif target.add_velocity then
					target:add_velocity(kb_vel)
				end
			end
		end,
	},

	--- Pre-combat custom step hook: casts mid-range Entangling Roots spell from distance (5.0 - 12.0 nodes)
	--- Executed at Priority 15 in the middleware pipeline prior to declarative melee.
	---@param _dtime number Delta time in seconds
	---@return boolean handled Returns true to halt pipeline while casting
	custom_step = function(self, _dtime)
		return x_mobs.execute_nature_roots_spell(self, {
			min_dist = 5.0,
			max_dist = 12.0,
			cooldown = 14.0,
			duration = 4.5,
			eye_offset = self.eye_offset or 1.35,
			hand_dist = 0.6,
			hand_y = 1.2,
			sound_dist = 20.0,
			sound_gain = 0.9,
			slam_dist = 0.9,
			slam_y = -0.28,
			burst_gain = 0.9,
			burst_pitch = 1.1,
			burst_dist = 22.0,
			target_max_dist = 16.0,
		})
	end,
})

-- Natural Spawning: Minions spawn in forest undergrowth, groves, and rainforests
x_mob_core.register_spawn("x_mobs:nature_guardian_minion", {
	nodes = {
		"group:soil",
		"group:leaves",
		"default:dirt_with_grass",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_coniferous_litter",
		"default:dirt",
		"default:junglegrass",
	},
	chance = 2400,
	active_object_count = 3,
	group_min = 1,
	group_max = 3,
	min_light = 6,
	max_light = 15,
	min_elevation = 1,
	max_elevation = 31000,
})
