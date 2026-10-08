--[[
	x_mobs - Nature Guardian
	Ancient colossal forest protector defending sacred groves, rainforests,
	and old-growth woods. Features seasonal autumn bark foliage, sunlight
	photosynthesis regeneration, devastating wood swings, and an entangling
	root spell that immobilizes intruders at their feet via physical roots.
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

--- Casts the entangling roots spell on a target: plays ground burst audio, VFX, and applies root status effect
---@param target ObjectRef Target player or entity
---@param duration? number Spell duration in seconds (default 6.0)
---@return ObjectRef|boolean result Status effect result
function x_mobs.cast_root_entangle(target, duration)
	if not target or not target:is_valid() then return false end
	local tpos = target:get_pos()
	if not tpos then return false end

	local dur = duration or 6.0

	-- Play ground emergence audio and burst particles at target position
	x_mob_core.play_sound(target, "x_mobs_root_burst", {
		pos = tpos,
		gain = 1.0,
		pitch = 0.95,
		max_hear_distance = 24.0,
	})
	x_mobs.spawn_nature_roots_burst(tpos)

	return x_mob_core.apply_status_effect(target, {
		id = "nature_roots",
		type = "root",
		duration = dur,
		envelop_texture = "x_mobs_roots_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#2e5a1e88",
		particles = x_mobs.get_roots_attached_spawner(),
		on_remove = function(victim)
			local pos = victim:get_pos()
			if pos then
				x_mob_core.play_sound(victim, "x_mobs_root_break", {
					pos = pos,
					gain = 1.0,
					pitch = 1.0,
					max_hear_distance = 24.0,
				})
				x_mobs.spawn_nature_roots_shatter(pos)
			end
		end,
	})
end

--- Executes the Entangling Roots distance spell from range
---@param self table Mob entity instance
---@param cfg table Configuration options
---@return boolean handled True if spell was cast
function x_mobs.execute_nature_roots_spell(self, cfg)
	if self.state == "flinching" or (self.action_timer or 0) > 0 then
		return false
	end

	if not self.target or not x_mob_core.is_player_alive(self.target) then
		return false
	end

	local pos = self.object and self.object:is_valid() and self.object:get_pos()
	local tpos = self.target:get_pos()
	if not pos or not tpos then return false end

	self.cooldowns = self.cooldowns or {}
	if (self.cooldowns.root_spell or 0) > 0 then
		return false
	end

	local dist = vector.distance(pos, tpos)
	if dist < cfg.min_dist or dist > cfg.max_dist then
		return false
	end

	local eye_pos = { x = pos.x, y = pos.y + (cfg.eye_offset or self.eye_offset or 1.8), z = pos.z }
	local target_eye = { x = tpos.x, y = tpos.y + 1.5, z = tpos.z }
	if not x_mob_core.line_of_sight(eye_pos, target_eye) then
		return false
	end

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

	self.state = "casting"
	self.action_timer = 2.0
	self.cooldowns.root_spell = cfg.cooldown
	x_mob_core.play_animation(self.object, "spell", { speed = 1.0, loop = false, force = true })
	x_mob_core.play_sound(self, "cast", { distance = cfg.sound_dist, gain = cfg.sound_gain })

	local hand_pos = {
		x = pos.x + to_target.x * cfg.hand_dist,
		y = pos.y + cfg.hand_y,
		z = pos.z + to_target.z * cfg.hand_dist,
	}
	x_mobs.spawn_nature_guardian_cast_charge(hand_pos, self.object)

	-- Scheduled slam impact keyframe at t = 1.0s (frame 30 ground strike in spell track)
	x_mob_core.schedule(self, 1.0, "spell_ground_impact", function()
		if not self.object or not self.object:is_valid() then return end
		local cpos = self.object:get_pos()
		if not cpos then return end

		local cyaw = self.object:get_yaw() or face_yaw
		local fwd = core.yaw_to_dir(cyaw)
		local slam_pos = {
			x = cpos.x + fwd.x * cfg.slam_dist,
			y = cpos.y + cfg.slam_y,
			z = cpos.z + fwd.z * cfg.slam_dist,
		}
		x_mobs.spawn_nature_roots_burst(slam_pos)
		x_mob_core.play_sound(self, "x_mobs_root_burst", {
			pos = slam_pos,
			gain = cfg.burst_gain,
			pitch = cfg.burst_pitch,
			max_hear_distance = cfg.burst_dist,
		})

		-- Erupt roots directly around victim feet via core envelop system
		if self.target and self.target:is_valid() and x_mob_core.is_player_alive(self.target) then
			local tp = self.target:get_pos()
			if tp and vector.distance(cpos, tp) <= cfg.target_max_dist
					and not x_mob_core.has_status_effect(self.target, "nature_roots") then
				x_mobs.cast_root_entangle(self.target, cfg.duration)
			end
		end
	end)

	return true
end

--- Nature Guardian Mob Definition
x_mob_core.register_mob("x_mobs:nature_guardian", {
	initial_properties = {
		hp_max = 120,
		mesh = "x_mobs_natureguardian.glb",
		-- Seasonal autumn foliage variations created via engine HSL texture modifier
		textures = {
			{ "x_mobs_natureguardian.png^[hsl:-70:25:-5" },   -- Autumn Amber
			{ "x_mobs_natureguardian.png^[hsl:-85:30:-10" },  -- Crimson Maple
			{ "x_mobs_natureguardian.png^[hsl:-55:20:5" },    -- Golden Birch
			{ "x_mobs_natureguardian.png^[hsl:-40:35:0" },    -- Russet Oak
			{ "x_mobs_natureguardian.png^[hsl:-100:15:-15" }, -- Withered Evergreen
		},
		-- Scale 10:1 ratio aligns glTF (10 units = 1 node) with model authored at 1m = 1 unit:
		-- Dimensions: feet at Y = -0.50, head at Y = 2.70, width 1.38, depth 0.88,
		-- perfectly fitting collisionbox {-0.75, -0.5, -0.75, 0.75, 2.7, 0.75}.
		visual_size = {x = 10, y = 10},
		collisionbox = {-0.75, -0.5, -0.75, 0.75, 2.7, 0.75},
		selectionbox = {-0.8, -0.5, -0.8, 0.8, 2.85, 0.8},
		stepheight = 1.2,
		glow = 2,
		backface_culling = false,
		infotext = S("Nature Guardian"),
	},

	-- Ancient hardwood carapace: resilient to slashing cuts, highly vulnerable to axes
	armor_groups = { fleshy = 65, choppy = 120 },
	knockback_mult = 0.15,
	factions = { "nature", "guardian" },
	mob_height = 3.2,
	eye_offset = 2.4,
	walk_speed = 2.0,
	wander_speed = 1.2,
	pursuit_speed = 3.8,
	attack_range = 3.2,
	aggro_radius = 20.0,
	damage = 2.5,
	attack_interval = 1.8,
	death_duration = 2.04,

	-- Passive photosynthesis: regenerates health under open sky and direct sunlight
	health_regen = {
		rate = 0.75,
		passive = true,
		flee_threshold = 0,
		return_threshold = 0,
	},

	damage_effect = { type = "none" },

	drops = {
		{ name = "default:apple",         min = 2, max = 5, chance = 0.90 },
		{ name = "default:sapling",       min = 1, max = 3, chance = 0.75 },
		{ name = "default:junglesapling", min = 1, max = 2, chance = 0.50 },
		{ name = "default:tree",          min = 2, max = 4, chance = 0.80 },
		{ name = "default:stick",         min = 3, max = 8, chance = 0.85 },
		{ name = "default:mese_crystal",  min = 1, max = 2, chance = 0.35 },
		{ name = "default:diamond",       min = 1, max = 1, chance = 0.15 },
	},

	sounds = {
		base = "x_mobs_nature_guardian",
		distance = 26.0,
		gain = 1.0,
		pitch_jitter = 0.06,
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

	cooldowns = {
		root_spell = 12.0,
	},

	--- Handles hurt reaction and companion pack threat broadcasting
	---@param puncher? ObjectRef Attacking entity
	---@param _dmg number Damage dealt
	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 24.0)
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
					pitch = 1.2,
					distance = 24.0,
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
				local max_hp = self.hp_max or 120
				if cur_hp < max_hp then
					self.object:set_hp(math.min(max_hp, cur_hp + 1))
				end
				x_mobs.spawn_nature_roots_trapped(pos)
			end
		end
	end,

	-- Declarative Melee Combat Configuration:
	-- Close-quarters colossal hardwood strike with kinetic knockback.
	melee = {
		range = 3.2,
		max_height_diff = 2.4,
		reach_tolerance = 0.8,
		damage = 7,
		cooldown = 1.8,
		duration = 1.33,
		delay = 0.75,
		animation = "attack",
		anim_speed = 1.0,
		sound = "attack",
		on_strike = function(_self, target, dir)
			local tp = target and target:is_valid() and target:get_pos()
			if tp then
				x_mobs.spawn_nature_guardian_attack(tp, dir)
				local kb_speed = 3.5
				local kb_vel = { x = dir.x * kb_speed, y = 2.0, z = dir.z * kb_speed }
				if target.add_player_velocity then
					target:add_player_velocity(kb_vel)
				elseif target.add_velocity then
					target:add_velocity(kb_vel)
				end
			end
		end,
	},

	--- Pre-combat custom step hook: casts mid-range Entangling Roots spell from distance (6.0 - 16.0 nodes)
	--- Executed at Priority 15 in the middleware pipeline prior to declarative melee.
	---@param _dtime number Delta time in seconds
	---@return boolean handled Returns true to halt pipeline while casting
	custom_step = function(self, _dtime)
		return x_mobs.execute_nature_roots_spell(self, {
			min_dist = 6.0,
			max_dist = 16.0,
			cooldown = 12.0,
			duration = 6.0,
			eye_offset = self.eye_offset or 2.4,
			hand_dist = 1.0,
			hand_y = 2.0,
			sound_dist = 28.0,
			sound_gain = 1.0,
			slam_dist = 1.5,
			slam_y = -0.5,
			burst_gain = 1.0,
			burst_pitch = 0.85,
			burst_dist = 26.0,
			target_max_dist = 20.0,
		})
	end,
})

-- Natural Spawning: Spawns in guarded pairs across forests, old-growth groves, and rainforests
x_mob_core.register_spawn("x_mobs:nature_guardian", {
	nodes = {
		"group:soil",
		"group:leaves",
		"default:dirt_with_grass",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_coniferous_litter",
		"default:dirt",
		"default:junglegrass",
	},
	chance = 3200,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 6,
	max_light = 15,
	min_elevation = 1,
	max_elevation = 31000,
})
