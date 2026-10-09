--[[
	x_mobs - Nether Arachnid (Spider Mob Entity)
	Dual-Jointed glTF Multi-Track Animated Entity
	- Alternating Tetrapod Gait Walk/Run
	- Venom Bite, Web Shot, and Explosive Pounce Leap
	- Iconic Arachnid Death Curl Lifecycle
	- Venom Poisoning Spell & Envelop (20% chance, 3s duration, 6s cooldown, 1 HP/s DoT)
	- Web Slowdown Spell & Envelop (20% chance on shot, 3s duration, 6s cooldown, 50% speed slow)
]]

-- ============================================================================
-- 1. VENOM & WEB SPELL FRAMEWORKS
-- ============================================================================

-- Venom Poisoning Spell Constants
local VENOM_SPELL_CHANCE = 0.20
local VENOM_SPELL_DURATION = 3.0
local VENOM_SPELL_COOLDOWN = 6.0
local VENOM_SPELL_DPS = 1
local VENOM_SPELL_MAX_RANGE = 7.0

-- Web Slowdown Spell Constants
local WEB_SPELL_CHANCE = 0.20
local WEB_SPELL_DURATION = 3.0
local WEB_SPELL_COOLDOWN = 6.0
local WEB_SPELL_SPEED_FACTOR = 0.50

--- Casts the spider venom poisoning spell: envelops target with venom goo and starts DoT
---@param caster ObjectRef Spider entity caster
---@param target ObjectRef Target to envelop and poison
---@param chance? number Optional success chance (default: VENOM_SPELL_CHANCE = 0.20)
---@return ObjectRef|boolean result Envelop entity object or status effect result
function x_mobs.cast_venom_envelop(caster, target, chance)
	if not target or not target:is_valid() then return false end
	local tpos = target:get_pos()
	if not tpos then return false end

	-- Play visceral venom hiss & attack audio
	x_mob_core.play_sound(target, "x_mobs_spider_attack.1", {
		pos = tpos,
		gain = 0.9,
		max_hear_distance = 20.0,
	})

	-- Spawn erupting venom splash particles at victim feet
	x_mobs.spawn_venom_particles(tpos, 16)
	x_mobs.spawn_spider_venom_splatter(tpos, 16, 0.7)

	-- If victim is already webbed, trigger a venomous web synergy effect with attached burst
	if x_mob_core.has_status_effect(target, "web") or x_mob_core.is_enveloped(target, "web") then
		x_mob_core.particles.attach(target, {
			amount = 18,
			time = 0.5,
			minpos = {x = -0.35, y = 0.1, z = -0.35},
			maxpos = {x = 0.35, y = 0.9, z = 0.35},
			minvel = {x = -0.3, y = 0.2, z = -0.3},
			maxvel = {x = 0.3, y = 0.8, z = 0.3},
			texpool = x_mobs.texpools.SPIDER_WEB_TEXPOOL,
			texture = "x_mobs_spider_particles.png^[sheet:8x8:0,2",
		})
	end

	-- Apply the visual envelop, attached continuous venom particles, and DoT in lockstep
	return x_mob_core.apply_status_effect(target, {
		id = "venom",
		type = "dot",
		chance = chance or VENOM_SPELL_CHANCE,
		duration = VENOM_SPELL_DURATION,
		damage = VENOM_SPELL_DPS,
		interval = 1.0,
		damage_type = "fleshy",
		caster = caster,
		penetrate_armor = true,
		envelop_texture = "x_mobs_venom_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#1b8822aa",
		particles = x_mobs.get_venom_attached_spawner(),
	})
end

-- ============================================================================
-- WEB SLOWDOWN & ENVELOP SPELL FRAMEWORK
-- ============================================================================

--- Casts the spider web envelop spell: envelops target with spider web and slows player to 50% for 3s
---@param _caster? ObjectRef Spider entity caster
---@param target ObjectRef Target player or entity to envelop and slow
---@param chance? number Optional success chance (default: WEB_SPELL_CHANCE = 0.20)
---@return ObjectRef|boolean result Envelop entity object or status effect result
function x_mobs.cast_web_envelop(_caster, target, chance)
	if not target or not target:is_valid() then return false end
	local tpos = target:get_pos()
	if not tpos then return false end

	-- Play visceral web shot audio
	x_mob_core.play_sound(target, "x_mobs_spider_web", {
		pos = tpos,
		gain = 0.9,
		max_hear_distance = 20.0,
	})

	-- Spawn web particles at victim position
	x_mobs.spawn_web_particles(tpos, { x = 0, y = 1, z = 0 })

	-- If victim is already poisoned, trigger a venomous web synergy effect with attached burst
	if x_mob_core.has_status_effect(target, "venom") or x_mob_core.is_enveloped(target, "venom") then
		x_mob_core.particles.attach(target, {
			amount = 20,
			time = 0.5,
			minpos = {x = -0.35, y = 0.2, z = -0.35},
			maxpos = {x = 0.35, y = 1.0, z = 0.35},
			minvel = {x = -0.4, y = 0.2, z = -0.4},
			maxvel = {x = 0.4, y = 0.9, z = 0.4},
			texpool = x_mobs.texpools.SPIDER_VENOM_TEXPOOL,
			texture = "x_mobs_spider_particles.png^[sheet:8x8:0,1",
		})
	end

	-- Apply the visual web envelop, attached continuous web particles, and slowdown in lockstep
	return x_mob_core.apply_status_effect(target, {
		id = "web",
		type = "slow",
		chance = chance or WEB_SPELL_CHANCE,
		speed_factor = WEB_SPELL_SPEED_FACTOR,
		duration = WEB_SPELL_DURATION,
		envelop_texture = "x_mobs_web_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#ffffff77",
		particles = x_mobs.get_web_attached_spawner(),
	})
end

-- ============================================================================
-- 2. SPIDER MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:spider", {
	initial_properties = {
		hp_max = 40,
		mesh = "x_mobs_spider.glb",
		textures = {
			"x_mobs_spider.png",
		},
		visual_size = {x = 0.48, y = 0.48},
		collisionbox = {-0.22, 0.0, -0.22, 0.22, 0.28, 0.22},
		selectionbox = {-0.54, -0.41, -0.54, 0.54, 0.41, 0.54},
		stepheight = 1.2,
		glow = 5,
	},

	factions = { "insectoid", "spider" },
	armor_groups = { fleshy = 80 },
	aggro_radius = 18.0,
	attack_range = 2.4,
	walk_speed = 3.8,
	pursuit_speed = 5.5,
	wander_speed = 2.2,
	wander_radius = 12.0,
	scan_interval = 0.35,
	knockback_mult = 2.0,
	can_crawl = true,
	can_swim = false,
	health_regen = {
		flee_threshold = 10,
		return_threshold = 24,
	},
	damage_effect = { type = "ichor" },
	eye_offset = 0.64,
	drops = {
		{ name = "farming:string",          min = 1, max = 3, chance = 0.85 },
		{ name = "farming:cotton",          min = 1, max = 2, chance = 0.45 },
		{ name = "vessels:glass_bottle",    min = 1, max = 1, chance = 0.25 },
		{ name = "default:flint",           min = 1, max = 1, chance = 0.40 },
		{ name = "default:coal_lump",       min = 1, max = 2, chance = 0.50 },
		{ name = "default:clay_lump",       min = 1, max = 2, chance = 0.35 },
		{ name = "flowers:mushroom_brown",  min = 1, max = 1, chance = 0.30 },
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.2, loop = true},
		bite   = {track = "bite",   speed = 1.0, loop = false},
		pounce = {track = "pounce", speed = 1.1, loop = false},
		web    = {track = "web",    speed = 1.0, loop = false},
		hurt   = {track = "hurt",   speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Body = { pivot = { x = 0, y = 5.0, z = 0 } },
		Head = { pivot = { x = 0, y = 5.0, z = -2.5 } },
		Abdomen = { pivot = { x = 0, y = 5.4, z = 2.2 } },
	},

	vfx = {
		hurt = { type = "venom", count = 8 },
		death = {
			{ type = "spider_death", scale = 0.8 },
		},
		despawn = { type = "spider_dissolve", scale = 0.8 },
	},

	sounds = {
		distance = 20.0,
		random = { name = "x_mobs_spider_random", gain = 0.75, min_interval = 6.0, max_interval = 16.0 },
		attack = { name = "x_mobs_spider_attack", gain = 0.85 },
		hurt   = { name = "x_mobs_spider_hurt", gain = 0.9 },
		death  = { name = "x_mobs_spider_death", gain = 1.0 },
		pounce = { name = "x_mobs_spider_pounce", gain = 0.9 },
		web    = { name = "x_mobs_spider_web", gain = 0.85 },
	},

	swarm_alert = {enabled = true, radius = 12.0, max_allies = 3},

	cooldowns = {
		bite = 0,
		pounce = 2.5,
		web = 4.0,
		drop = 0,
		venom_spell = 0,
		web_spell = 0,
	},

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.bite = 0
		self.cooldowns.pounce = 2.5
		self.cooldowns.web = 4.0
		self.cooldowns.drop = 0
		self.cooldowns.venom_spell = 0
		self.cooldowns.web_spell = 0
	end,

	can_flinch = function(self)
		return self.state ~= "pouncing" and self.state ~= "biting"
			and self.state ~= "casting_venom" and self.state ~= "webbing"
	end,

	on_hurt = function(self, _puncher, dmg)
		-- Release wall/ceiling adherence if struck by heavy knockback
		if dmg >= 6 and self._cur_rot and (math.abs(self._cur_rot.x) > 0.4 or math.abs(self._cur_rot.z) > 0.4) then
			self.on_wall_or_ceiling = false
			self._has_wall_cbox = false
			self._cur_rot = {x = 0, y = self.object:get_yaw() or 0, z = 0}
			self.object:set_rotation(self._cur_rot)
			self.object:set_acceleration({x = 0, y = -9.81, z = 0})
			self.object:set_properties({
				collisionbox = {-0.28, 0.0, -0.28, 0.28, 0.36, 0.28},
				selectionbox = {-0.68, -0.52, -0.68, 0.68, 0.52, 0.68},
			})
			if self.path_state then
				self.path_state.waypoints = nil
				self.path_state.index = 1
			end
		end
	end,

	on_action_end = function(self)
		if self.state == "pouncing" then
			-- Settle leap momentum on landing: zero horizontal, clamp any residual upward velocity
			x_mob_core.halt_horizontal_velocity(self)
		end
	end,


	transitions = {
		{
			from = "*",
			to = "dropping",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or (self.cooldowns.drop or 0) > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local cur_z = self._cur_rot and self._cur_rot.z or 0
				local is_on_ceiling = math.abs(cur_z - math.pi) < 0.8 or math.abs(cur_z + math.pi) < 0.8
				if not is_on_ceiling then return false end

				local flat_dist = math.sqrt((pos.x - tpos.x)^2 + (pos.z - tpos.z)^2)
				local dy = tpos.y - pos.y
				return flat_dist <= 3.5 and dy <= -2.0 and dy >= -10.0
			end,
			on_transition = function(self)
				self:perform_ceiling_drop(self.target:get_pos())
			end
		},
		{
			from = "*",
			to = "pouncing",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or self.cooldowns.pounce > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				local dy = tpos.y - pos.y
				local can_pounce_elev = (dy >= -9.0 and dy <= 2.0)
				if not can_pounce_elev or dist < 4.5 or dist > 10.5 then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.64), z = pos.z}
				local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
				if not x_mob_core.line_of_sight(eye_pos, target_eye) then return false end

				local target_ground = core.get_node({
					x = math.floor(tpos.x + 0.5),
					y = math.floor(tpos.y - 0.5),
					z = math.floor(tpos.z + 0.5),
				})
				local tg_def = core.registered_nodes[target_ground.name]
				return tg_def and (tg_def.walkable or (tg_def.liquidtype and tg_def.liquidtype ~= "none"))
			end,
			on_transition = function(self)
				self:perform_pounce(self.target:get_pos())
			end
		},
		{
			from = "*",
			to = "web_shooting",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or self.cooldowns.web > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				if dist < 5.0 or dist > 13.0 then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.64), z = pos.z}
				local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
				return x_mob_core.line_of_sight(eye_pos, target_eye)
			end,
			on_transition = function(self)
				self:perform_web_shot(self.target:get_pos())
			end
		},
		{
			from = "*",
			to = "biting",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or self.cooldowns.bite > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				if dist > (self.attack_range or 2.4) then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.64), z = pos.z}
				local target_eye = {x = tpos.x, y = tpos.y + 1.5, z = tpos.z}
				return x_mob_core.line_of_sight(eye_pos, target_eye)
			end,
			on_transition = function(self)
				self:perform_bite(self.target)
			end
		}
	},

	--- Pre-combat custom ability hook: evaluates 20% venom poisoning spell (6s cooldown, 3s duration, 1 HP/s)
	---@param dtime number Delta time in seconds
	---@param _moveresult? table Movement result
	---@param _def? table Mob definition
	---@return boolean handled True if custom ability handled step
	custom_step = function(self, dtime, _moveresult, _def)
		if self.state == "fleeing" or (self.action_timer or 0) > 0 then
			return false
		end

		if not self.target or not x_mob_core.is_player_alive(self.target) then
			return false
		end

		self.cooldowns = self.cooldowns or {}
		if (self.cooldowns.venom_spell or 0) > 0 then
			return false
		end

		local pos = self.object:get_pos()
		local tpos = self.target:get_pos()
		if not pos or not tpos then return false end

		local dist = vector.distance(pos, tpos)
		if dist > VENOM_SPELL_MAX_RANGE then
			return false
		end

		local eye_pos = { x = pos.x, y = pos.y + (self.eye_offset or 0.64), z = pos.z }
		local target_eye = { x = tpos.x, y = tpos.y + 1.2, z = tpos.z }
		if not x_mob_core.line_of_sight(eye_pos, target_eye) then
			return false
		end

		-- Periodic evaluation interval so check is evaluated per decision cycle (every 1.0s)
		self._venom_check_timer = (self._venom_check_timer or 0) + dtime
		if self._venom_check_timer < 1.0 then
			return false
		end
		self._venom_check_timer = 0

		self:perform_venom_spell(self.target)
		return true
	end,

	on_step = function(self, dtime)
		if self.state == "fleeing" then
			local return_thresh = self.return_hp_threshold or 24
			if (self.memory and not self.memory.flee_state) or (self.hp and self.hp >= return_thresh) then
				self.state = "idle"
				if self.memory then self.memory.flee_state = false end
			else
				x_mob_core.step_move_or_idle(self, dtime, "run", 1.15)
			end
			return
		end

		if not self.target then
			x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
			return
		end

		local pos = self.object:get_pos()
		local target_pos = self.target:get_pos()
		if not pos or not target_pos then return end
		local dist = vector.distance(pos, target_pos)

		-- Predator Skitter: Surges with haste when closing in on webbed prey
		self._skitter_timer = (self._skitter_timer or 0) + dtime
		if self._skitter_timer >= 0.5 then
			self._skitter_timer = 0
			if dist <= 14.0 and x_mob_core.has_status_effect(self.target, "web") then
				if not x_mob_core.has_status_effect(self.object, "haste") then
					x_mob_core.apply_status_effect(self.object, {
						id = "haste",
						type = "buff",
						category = "buff",
						duration = 3.0,
						speed_factor = 1.35,
						envelop_texture = "x_mobs_haste_envelop.png",
						particles = {
							amount = 10,
							time = 0.2,
							pos = {
								min = {x = pos.x - 0.3, y = pos.y + 0.1, z = pos.z - 0.3},
								max = {x = pos.x + 0.3, y = pos.y + 0.5, z = pos.z + 0.3},
							},
							vel = {min = {x = -0.5, y = 0.2, z = -0.5}, max = {x = 0.5, y = 0.8, z = 0.5}},
							acc = {min = {x = -0.1, y = 0.1, z = -0.1}, max = {x = 0.1, y = 0.3, z = 0.1}},
							size = {min = 1.0, max = 2.0},
							exptime = {min = 0.3, max = 0.6},
							minpos = {x = pos.x - 0.3, y = pos.y + 0.1, z = pos.z - 0.3},
							maxpos = {x = pos.x + 0.3, y = pos.y + 0.5, z = pos.z + 0.3},
							minvel = {x = -0.5, y = 0.2, z = -0.5},
							maxvel = {x = 0.5, y = 0.8, z = 0.5},
							minsize = 1.0,
							maxsize = 2.0,
							minexptime = 0.3,
							maxexptime = 0.6,
							texture = "x_mobs_haste_envelop.png",
							glow = 10,
							collisiondetection = false,
						},
					})
					x_mob_core.sound.play(self, "web")
				end
			end
		end

		-- Dynamic speed scaling based on distance
		self.pursuit_speed = (dist > 8.0) and 5.5 or 3.8
		local is_skittering = x_mob_core.has_status_effect(self.object, "haste")
		local move_anim = (is_skittering or self.pursuit_speed > 4.5) and "run" or "walk"
		local anim_speed = is_skittering and 1.4 or ((move_anim == "run") and 1.25 or 1.0)
		x_mob_core.step_move_or_idle(self, dtime, move_anim, anim_speed)
	end,

	perform_venom_spell = function(self, target)
		self.state = "casting_venom"
		self.action_timer = 0.8
		self.cooldowns.venom_spell = VENOM_SPELL_COOLDOWN
		self.cooldowns.bite = 0.8

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		else
			x_mob_core.halt_horizontal_velocity(self)
		end

		local pos = self.object:get_pos()
		local tpos = target:get_pos()
		if not on_surface and pos and tpos then
			local b_yaw = core.dir_to_yaw(vector.direction(pos, tpos))
			self._cur_rot = {x = 0, y = b_yaw, z = 0}
			self.object:set_rotation(self._cur_rot)
		end

		x_mob_core.play_animation(self.object, "bite", {speed = 1.0, loop = false})
		x_mob_core.sound.play(self, "attack")
		if pos then
			x_mobs.spawn_venom_particles(pos, 12)
		end

		-- Scheduled spell cast release at fang flare (~0.35s)
		x_mob_core.schedule(self, 0.35, "venom_spell_cast", function()
			if not x_mob_core.is_player_alive(target) then return end
			local cur_pos = self.object:get_pos()
			local cur_tpos = target:get_pos()
			if not cur_pos or not cur_tpos then return end
			if vector.distance(cur_pos, cur_tpos) <= VENOM_SPELL_MAX_RANGE + 1.0 then
				x_mobs.cast_venom_envelop(self.object, target)
			end
		end)
	end,

	perform_bite = function(self, target)
		self.state = "biting"
		self.action_timer = 0.625
		self.cooldowns.bite = 1.5

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		else
			x_mob_core.halt_horizontal_velocity(self)
		end
		x_mob_core.play_animation(self.object, "bite", {speed = 1.0, loop = false})
		x_mob_core.sound.play(self, "attack")

		local tpos = target:get_pos()
		if not on_surface and tpos then
			local bpos = self.object:get_pos()
			if bpos then
				local b_yaw = core.dir_to_yaw(vector.direction(bpos, tpos))
				self._cur_rot = {x = 0, y = b_yaw, z = 0}
				self.object:set_rotation(self._cur_rot)
			end
		end
		if tpos then
			x_mobs.spawn_venom_particles(tpos, 10)
		end

		-- Strike damage timing at fang clamping (frame 116 = ~0.33s into 0.625s)
		x_mob_core.schedule(self, 0.33, "scheduled_action", function()
			if not x_mob_core.is_player_alive(target) then return end
			local cur_pos = self.object:get_pos()
			local cur_tpos = target:get_pos()
			if not cur_tpos then return end
			if vector.distance(cur_pos, cur_tpos) <= (self.attack_range or 2.4) + 0.6 then
				target:punch(self.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 5},
				}, vector.direction(cur_pos, cur_tpos))
				x_mobs.spawn_venom_particles(cur_tpos, 16)

				-- Melee bite synergy: 20% chance to trigger venom poisoning spell if off cooldown
				if (self.cooldowns.venom_spell or 0) <= 0 then
					local res = x_mobs.cast_venom_envelop(self.object, target)
					if res then
						self.cooldowns.venom_spell = VENOM_SPELL_COOLDOWN
					end
				end
			end
		end)
	end,

	perform_pounce = function(self, target_pos)
		self.state = "pouncing"
		self.action_timer = 0.833
		self.cooldowns.pounce = 4.0
		self.cooldowns.bite = 0.5

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.on_wall_or_ceiling = false
			self._has_wall_cbox = false
			self.object:set_properties({
				collisionbox = {-0.28, 0.0, -0.28, 0.28, 0.36, 0.28},
				selectionbox = {-0.68, -0.52, -0.68, 0.68, 0.52, 0.68},
			})
		end

		x_mob_core.play_animation(self.object, "pounce", {speed = 1.0, loop = false})
		x_mob_core.sound.play(self, "pounce")

		local pos = self.object:get_pos()
		local pounce_dir = vector.direction(pos, target_pos)
		local pounce_dist = vector.distance(pos, target_pos)
		local leap_speed = math.min(math.max(pounce_dist / 0.8, 6.0), 12.0)

		local pounce_yaw = core.dir_to_yaw(pounce_dir)
		self._cur_rot = {x = 0, y = pounce_yaw, z = 0}
		self.object:set_rotation(self._cur_rot)

		local dy = target_pos.y - pos.y
		local initial_vy
		if dy < -2.0 then
			-- Downward leap from wall or elevated ledge
			self.object:set_acceleration({x = 0, y = -14.0, z = 0})
			initial_vy = math.max(-8.0, dy * 0.7 + 1.5)
		else
			-- Standard predatory ground leap
			self.object:set_acceleration({x = 0, y = -16.0, z = 0})
			initial_vy = 3.0 + math.min(math.max(dy * 0.4, -0.8), 1.2)
		end

		self.object:set_velocity({
			x = pounce_dir.x * leap_speed,
			y = initial_vy,
			z = pounce_dir.z * leap_speed,
		})

		x_mobs.spawn_spider_skitter(pos)

		-- Landing impact & slam damage
		x_mob_core.schedule(self, 0.55, "scheduled_action", function()
			local land_pos = self.object:get_pos()
			x_mobs.spawn_spider_skitter(land_pos)

			if self.target and x_mob_core.is_player_alive(self.target) then
				local tpos = self.target:get_pos()
				if tpos and vector.distance(land_pos, tpos) <= (self.attack_range or 2.4) + 1.0 then
					self.target:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 7},
					}, vector.direction(land_pos, tpos))
					x_mobs.spawn_venom_particles(tpos, 12)
				end
			end
		end)
	end,

	perform_ceiling_drop = function(self, target_pos)
		self.state = "pouncing"
		self.action_timer = 0.85
		self.cooldowns.drop = 5.0
		self.cooldowns.pounce = 3.0
		self.cooldowns.bite = 0.5

		-- Orient downwards towards target
		self._cur_rot = {x = -math.pi / 2, y = self.object:get_yaw() or 0, z = 0}
		self.object:set_rotation(self._cur_rot)

		-- Apply heavy downward gravity for plunge attack
		self.object:set_acceleration({x = 0, y = -14.0, z = 0})

		local pos = self.object:get_pos()
		local dx = target_pos.x - pos.x
		local dz = target_pos.z - pos.z
		self.object:set_velocity({
			x = dx * 1.5,
			y = -3.5,
			z = dz * 1.5,
		})

		x_mob_core.play_animation(self.object, "pounce", {speed = 1.2, loop = false})
		x_mob_core.sound.play(self, "pounce")
		x_mobs.spawn_spider_skitter(pos)

		-- Touchdown impact & area silk slam
		x_mob_core.schedule(self, 0.48, "scheduled_action", function()
			local land_pos = self.object:get_pos()
			x_mobs.spawn_spider_skitter(land_pos)
			x_mobs.spawn_venom_particles(land_pos, 16)

			-- Reset to upright ground rotation
			self._cur_rot = {x = 0, y = self.object:get_yaw() or 0, z = 0}
			self.object:set_rotation(self._cur_rot)
			self.object:set_acceleration({x = 0, y = -9.81, z = 0})

			if self.target and x_mob_core.is_player_alive(self.target) then
				local cur_tpos = self.target:get_pos()
				if cur_tpos and vector.distance(land_pos, cur_tpos) <= 2.8 then
					self.target:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 7},
					}, vector.direction(land_pos, cur_tpos))
				end
			end
		end)
	end,

	perform_web_shot = function(self, target_pos)
		self.state = "webbing"
		self.action_timer = 0.75
		self.cooldowns.web = 5.5

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			-- Maintain firm kinematic lock to wall/ceiling without falling
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		else
			x_mob_core.halt_horizontal_velocity(self)
		end
		x_mob_core.play_animation(self.object, "web", {speed = 1.0, loop = false})
		x_mob_core.sound.play(self, "web")

		local pos = self.object:get_pos()
		local web_dir = vector.direction(pos, target_pos)
		if not on_surface then
			local w_yaw = core.dir_to_yaw(web_dir)
			self._cur_rot = {x = 0, y = w_yaw, z = 0}
			self.object:set_rotation(self._cur_rot)
		end

		-- Pulse 1: First comb stroke with Leg L4 over spinneret (~0.22s / frame 159)
		x_mob_core.schedule(self, 0.22, "scheduled_action", function()
			local cur_pos = self.object:get_pos()
			x_mobs.spawn_web_particles(cur_pos, web_dir)
		end)

		-- Pulse 2: Second comb stroke with Leg R4 over spinneret & impact (~0.45s / frame 167)
		x_mob_core.schedule(self, 0.45, "scheduled_action", function()
			local cur_pos = self.object:get_pos()
			x_mobs.spawn_web_particles(cur_pos, web_dir)

			if self.target and x_mob_core.is_player_alive(self.target) then
				local tpos = self.target:get_pos()
				if tpos and vector.distance(cur_pos, tpos) <= 14.0 then
					-- Snare player: slight damage + viscous silk net wrap
					self.target:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 3},
					}, web_dir)
					x_mobs.spawn_web_particles(tpos, {x = 0, y = 1, z = 0})

					-- Cast web slow spell (3s duration, 50% speed, 20% proc chance)
					if (self.cooldowns.web_spell or 0) <= 0 then
						local res = x_mobs.cast_web_envelop(self.object, self.target)
						if res then
							self.cooldowns.web_spell = WEB_SPELL_COOLDOWN
						end
					end
				end
			end
		end)
	end,
})

-- Register natural spawns via x_mob_core (spawns in dim, shaded, and dark environments, groups of 1-3)
x_mob_core.register_spawn("x_mobs:spider", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:dirt_with_grass",
		"default:stone",
		"default:dirt",
		"default:desert_stone",
		"default:sand",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:dirt_with_coral_grass",
		"everness:forsaken_tundra_dirt_with_grass",
	},
	chance = 1800,
	active_object_count = 5,
	group_min = 1,
	group_max = 3,
	min_light = 0,
	max_light = 15,
})
