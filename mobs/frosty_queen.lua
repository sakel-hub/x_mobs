--[[
	x_mobs - Frosty Queen
	Regal sovereign of the frozen wastes and glacial caverns.
	Levitates gracefully above terrain, casting crystalline frost shards
	and ensnaring foes within an icy cocoon envelope that binds movement.
	When critically wounded, she retreats to a tactical standoff distance,
	relying on ranged blizzard barrages to defeat pursuers.
	Integrated with x_mob_core framework.

	Author: SaKeL
	License: MIT
]]

local S = core.get_translator("x_mobs")

-- Combat tuning parameters
local MELEE_RANGE = 2.6
local MIN_SHOOT_DISTANCE = 4.0
local MAX_SHOOT_DISTANCE = 16.0
local MAX_FLEE_DISTANCE = 14.0
local LOW_HP_THRESHOLD = 40
local SHARD_SPEED = 16.0
local SPELL_COOLDOWN = 12.0
local SPELL_DURATION = 6.0
local SPELL_SLOWDOWN = 0.5

-- ============================================================================
-- 1. FROST SHARD PROJECTILE ENTITY
-- ============================================================================

core.register_entity("x_mobs:frost_shard", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1"},
		visual_size = {x = 0.6, y = 0.6},
		glow = 12,
		static_save = false,
		infotext = S("Frost Shard"),
	},

	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "monster", "ice", "boss" },

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
			lifetime = 4.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity() or {x = 0, y = 0, z = 0}
					x_mobs.spawn_frosty_queen_projectile_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 5 },
				}, dir)
			end,
			on_hit = function(proj, _hit_obj, hit_pos)
				x_mob_core.play_sound(proj, "x_mobs_frosty_queen_attack.1", {
					pos = hit_pos,
					gain = 0.85,
					pitch = 1.3,
					max_hear_distance = 24.0,
				})
				x_mobs.spawn_frosty_queen_projectile_impact(hit_pos)
			end,
		})
	end,
})

-- ============================================================================
-- 2. FROST ENVELOP & SLOWDOWN MECHANICS
-- ============================================================================

--- Applies frost movement speed reduction and prevents jump for a player (players only, non-entities)
--- Spawns and attaches the frost envelop around the target
---@param _caster ObjectRef Queen caster
---@param target ObjectRef Enveloped victim
---@return ObjectRef|boolean result Envelop object or true on success
function x_mobs.cast_frost_envelop(_caster, target)
	if not target or not target:is_valid() then return false end
	local tpos = target:get_pos()
	if not tpos then return false end

	local snd = math.random() > 0.5 and "x_mobs_frosty_queen_freeze.1" or "x_mobs_frosty_queen_freeze.2"
	x_mob_core.play_sound(target, snd, {
		pos = tpos,
		gain = 0.95,
		max_hear_distance = 24.0,
	})
	x_mobs.spawn_frosty_queen_spell_freeze(tpos)

	-- Apply frost slow debuff, attached continuous frost particles, and visual ice envelop sleeve in lockstep
	return x_mob_core.apply_status_effect(target, {
		id = "frost",
		type = "slow",
		speed_factor = SPELL_SLOWDOWN,
		jump_factor = 0.0,
		duration = SPELL_DURATION,
		envelop_texture = "x_mobs_ice_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#55ccff88",
		particles = x_mobs.get_frost_attached_spawner(),
		on_remove = function(victim)
			local pos = victim:get_pos()
			if pos then
				x_mob_core.play_sound(victim, "x_mobs_frosty_queen_shatter", {
					pos = pos,
					gain = 0.9,
					max_hear_distance = 24.0,
				})
				x_mobs.spawn_frosty_queen_spell_shatter(pos)
			end
		end,
	})
end

-- ============================================================================
-- 3. COMBAT ACTION HANDLERS
-- ============================================================================

--- Executes the Frost Envelop special spell (12s cooldown, 6s freeze duration)
---@param mob table Mob instance
---@param pos Vector Mob position
---@param _to_target Vector Normalized vector to target
---@param face_yaw number Facing yaw angle in radians
local function perform_frosty_queen_spell(mob, pos, _to_target, face_yaw)
	mob.state = "casting"
	mob.action_timer = 0.9
	mob.cooldowns = mob.cooldowns or {}
	mob.cooldowns.spell = SPELL_COOLDOWN

	mob.object:set_yaw(face_yaw)
	mob._cur_rot = { x = 0, y = face_yaw, z = 0 }
	x_mob_core.halt_horizontal_velocity(mob)

	x_mob_core.play_animation(mob.object, "shoot", { speed = 1.0, loop = false, force = true })
	x_mob_core.play_sound(mob, "shoot")
	x_mobs.spawn_frosty_queen_spell_cast(pos)

	x_mob_core.schedule(mob, 0.45, "frosty_queen_envelop_cast", function()
		if mob.target and x_mob_core.is_player_alive(mob.target) then
			x_mobs.cast_frost_envelop(mob.object, mob.target)
		end
	end)
end

-- ============================================================================
-- 4. MOB REGISTRATION: FROSTY QUEEN
-- ============================================================================

x_mob_core.register_mob("x_mobs:frosty_queen", {
	initial_properties = {
		hp_max = 120,
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.35, 0.0, -0.35, 0.35, 1.75, 0.35},
		visual = "mesh",
		mesh = "x_mobs_frosty_queen.glb",
		textures = {
			"x_mobs_frosty_queen.png",
		},
		-- Visual scale 7.8 aligns model height (2.179 units in glb * 0.78 = 1.70m) with player model:
		visual_size = {x = 7.8, y = 7.8},
		glow = 5,
		infotext = S("Frosty Queen"),
		backface_culling = false,
	},

	armor_groups = { fleshy = 70 },
	knockback_mult = 0.5,
	factions = { "monster", "ice", "boss" },
	mob_height = 1.7,
	eye_offset = 1.47,
	is_floating = true,
	hover_offset = 0.6,
	combat_hover_offset = 0.2,
	combat_standoff = 1.8,
	walk_speed = 2.4,
	wander_speed = 1.8,
	pursuit_speed = 4.0,
	flee_speed = 4.4,
	max_flee_distance = MAX_FLEE_DISTANCE,
	attack_range = MELEE_RANGE,
	aggro_radius = 22.0,
	damage = 7,
	attack_interval = 1.4,
	death_duration = 1.8,
	can_swim = false,
	disallow_water = true,

	-- Health regeneration: Tactical Disengage & Vulnerable Channel
	health_regen = {
		enabled = true,
		rate = 0.8,
		passive = true,
		flee_threshold = LOW_HP_THRESHOLD,
		return_threshold = 80,
		burst_duration = 3.5,
		channel_duration = 3.0,
		safe_distance = 12.0,
		heal_amount = 40,
		flee_speed = 4.4,
	},

	damage_effect = { type = "none" },

	drops = {
		{ name = "default:ice",                   min = 2, max = 5, chance = 0.90 },
		{ name = "default:snowblock",             min = 2, max = 4, chance = 0.80 },
		{ name = "default:diamond",               min = 1, max = 2, chance = 0.25 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 3, chance = 0.40 },
	},

	sounds = {
		base = "x_mobs_frosty_queen",
		distance = 24.0,
		gain = 1.0,
		pitch_jitter = 0.05,
		attack = "x_mobs_frosty_queen_attack",
		shoot = "x_mobs_frosty_queen_shoot",
		hurt = "x_mobs_frosty_queen_hurt",
		death = "x_mobs_frosty_queen_death",
		random = "x_mobs_frosty_queen_idle",
	},

	-- All 7 canonical animation tracks authored with corrected kinematics
	animations = {
		idle   = { track = "idle",  speed = 1.0, loop = true },
		walk   = { track = "walk",  speed = 1.0, loop = true },
		run    = { track = "run",   speed = 1.2, loop = true },
		attack = { track = "punch", speed = 1.1, loop = false },
		punch  = { track = "punch", speed = 1.1, loop = false },
		shoot  = { track = "shoot", speed = 1.0, loop = false },
		spell  = { track = "shoot", speed = 1.0, loop = false },
		hurt   = { track = "hurt",  speed = 1.0, loop = false },
		death  = { track = "death", speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 1.0268, z = 0 } },
		Head = { pivot = { x = 0, y = 1.0655, z = 0 } },
		Arm_Right = { pivot = { x = 0.0307, y = 1.3995, z = 0 } },
		Arm_Left  = { pivot = { x = -0.0068, y = 1.4276, z = 0 } },
		Hip = { pivot = { x = 0, y = 1.4835, z = 0 } },
	},

	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting" and self.state ~= "casting"
	end,

	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 24.0)
		end
		if self.state == "flinching" then
			x_mob_core.halt_horizontal_velocity(self)
		end
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_frosty_queen_hurt(pos)
		end
	end,

	on_death = function(self, _killer)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			x_mobs.spawn_frosty_queen_death(pos)
		end
	end,

	on_return_to_fight = function(self)
		self.state = "idle"
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "combat"
		end
	end,

	melee = {
		range = MELEE_RANGE,
		max_height_diff = 1.8,
		damage = 7,
		cooldown = 1.4,
		duration = 0.7,
		delay = 0.35,
		animation = "punch",
		sound = "attack",
		on_strike = function(self, _target, _dir)
			local cp = self.object and self.object:is_valid() and self.object:get_pos()
			if cp then
				local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
				local punch_pos = {
					x = cp.x + fwd.x * 0.7,
					y = cp.y + 1.1,
					z = cp.z + fwd.z * 0.7,
				}
				x_mobs.spawn_frosty_queen_projectile_impact(punch_pos)
			end
		end,
	},

	shooter = {
		projectile = "x_mobs:frost_shard",
		range = MAX_SHOOT_DISTANCE,
		min_range = MIN_SHOOT_DISTANCE,
		retreat_speed = 1.0,
		velocity = SHARD_SPEED,
		damage = 4,
		cooldown = 2.8,
		fire_duration = 0.8,
		fire_delay = 0.4,
		predict_aim = true,
		animation = "shoot",
		sound = "shoot",
		on_charge = function(self, pos)
			if self.object and self.object:is_valid() then
				x_mobs.spawn_frosty_queen_shoot_charge(pos, self.object)
			end
		end,
	},

	--- Pre-combat custom step hook: handles ambient snow trail and unique boss spell
	---@param dtime number Delta time in seconds
	---@param _moveresult? table Engine movement result
	---@param _def? table Mob definition table
	custom_step = function(self, dtime, _moveresult, _def)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if not pos then return false end

		-- Ambient floating trail particles (snowflakes & cold vapor)
		self.trail_timer = (self.trail_timer or 0) + dtime
		if self.trail_timer >= 0.25 then
			self.trail_timer = 0
			x_mobs.spawn_frosty_queen_trail(pos)
		end

		-- Yield to core tactical retreat and health channel when fleeing/healing
		if self.state == "fleeing" or self.state == "channeling" then
			return false
		end

		if not self.target or not x_mob_core.is_player_alive(self.target) then
			return false
		end

		local tpos = self.target:get_pos()
		if not tpos then return false end

		local dist = vector.distance(pos, tpos)
		local to_target = vector.direction(pos, tpos)
		to_target.y = 0
		local face_yaw = core.dir_to_yaw(to_target)

		self.cooldowns = self.cooldowns or {}

		-- Unique Boss Spell: Frost Envelop (12s cooldown, 4.5m - 16m range)
		if (self.cooldowns.spell or 0) <= 0 and dist >= MIN_SHOOT_DISTANCE and dist <= MAX_SHOOT_DISTANCE then
			local eye_pos = { x = pos.x, y = pos.y + (self.eye_offset or 1.47), z = pos.z }
			local target_eye = { x = tpos.x, y = tpos.y + 1.2, z = tpos.z }
			if x_mob_core.line_of_sight(eye_pos, target_eye) then
				perform_frosty_queen_spell(self, pos, to_target, face_yaw)
				return true
			end
		end

		return false -- Proceed to pipeline hooks: tactical_retreat (17), melee (18), shooter (20)
	end,
})

core.log("action", "[x_mobs] Frosty Queen registered successfully.")
