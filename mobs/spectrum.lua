--[[
	x_mobs - Spectrum Demon
	Floating dark spectrum entity haunting caverns and shadowed wilderness.
	Levitates smoothly above terrain, firing ectoplasmic void orbs from a distance
	and striking with phantom claw swipes when in close combat. Executes tactical
	retreats when critically injured, regenerating dark energy before returning
	to re-engage foes.
	Integrated with x_mob_core framework.
]]

local S = core.get_translator("x_mobs")

-- Combat tuning parameters
local MIN_SHOOT_DISTANCE = 4.0
local MAX_SHOOT_DISTANCE = 16.0
local MAX_FLEE_DISTANCE = 14.0
local MELEE_RANGE = 2.4
local FLEE_HP_THRESHOLD = 20
local RETURN_HP_THRESHOLD = 45
local ORB_SPEED = 14.0

--- Applies void_miasma debuff: 1 HP DoT, low-gravity float, void envelop, and caster lifesteal
---@param target ObjectRef Struck victim
---@param caster ObjectRef Entity dealing the miasma
local function apply_void_miasma(target, caster)
	if not target or not target:is_valid() then return end
	x_mob_core.apply_status_effect(target, {
		id = "void_miasma",
		type = "custom",
		chance = 0.20,
		damage = 1,
		interval = 1.5,
		duration = 6.0,
		gravity_factor = 0.3,
		speed_factor = 0.7,
		caster = caster,
		envelop_texture = "x_mobs_void_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#11002290",
		on_tick = function(_t, c)
			if c and c:is_valid() then
				local cur_hp = c:get_hp()
				local max_hp = 60
				local ent = c:get_luaentity()
				if ent and not ent._dead and not ent.is_dead and ent.state ~= "dying" then
					if ent.initial_properties and ent.initial_properties.hp_max then
						max_hp = ent.initial_properties.hp_max
					end
					if cur_hp > 0 and cur_hp < max_hp then
						c:set_hp(math.min(max_hp, cur_hp + 1))
						x_mob_core.indicate_regen(c)
					end
				end
			end
		end,
	})
end

-- ============================================================================
-- 1. SPECTRUM ORB PROJECTILE ENTITY
-- ============================================================================

core.register_entity("x_mobs:spectrum_orb", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_spectrum_particles.png^[sheet:8x8:0,5"},
		visual_size = {x = 0.5, y = 0.5},
		glow = 12,
		static_save = false,
		infotext = S("Spectrum Orb"),
	},

	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "monster", "demon", "spectrum", "undead" },

	--- Initializes projectile properties
	---@param _staticdata string Serialized static parameters
	---@param _dtime_s number Time delta
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

	--- Stepped trajectory updating with trail particles and collision resolution
	---@param dtime number Delta time in seconds
	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			lifetime = 5.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_spectrum_orb_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 6 },
				}, dir)
				proj._punched_direct = hit_obj
				apply_void_miasma(hit_obj, source)
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				core.sound_play("x_mobs_spectrum_shoot.1", {
					pos = hit_pos,
					gain = 0.8,
					pitch = 1.2,
					max_hear_distance = 24.0,
				})
				x_mobs.spawn_spectrum_orb_impact(hit_pos)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- 2.0 block radius AoE splash burst
				local objs = core.get_objects_inside_radius(hit_pos, 2.0)
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
							damage_groups = { fleshy = 4 },
						}, dir)
						apply_void_miasma(obj, source)
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. MOB REGISTRATION: SPECTRUM DEMON
-- ============================================================================

x_mob_core.register_mob("x_mobs:spectrum", {
	initial_properties = {
		hp_max = 60,
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.85, 0.35},
		selectionbox = {-0.4, 0.0, -0.4, 0.4, 1.95, 0.4},
		visual = "mesh",
		mesh = "x_mobs_spectrum.glb",
		textures = {
			"x_mobs_spectrum.png",
		},
		-- Scale 10:1 ratio aligns glTF (10 units = 1 node) with model authored at 1m = 1 unit:
		visual_size = {x = 10, y = 10},
		glow = 4,
		infotext = S("Spectrum"),
		backface_culling = false,
	},

	armor_groups = { fleshy = 70 },
	knockback_mult = 0.6,
	factions = { "monster", "demon", "spectrum", "undead" },
	mob_height = 1.85,
	eye_offset = 1.45,
	is_floating = true,
	hover_offset = 1.4,
	combat_hover_offset = 0.35,
	combat_standoff = 1.7,
	walk_speed = 2.4,
	wander_speed = 1.6,
	pursuit_speed = 4.2,
	flee_speed = 4.8,
	max_flee_distance = MAX_FLEE_DISTANCE,
	attack_range = MELEE_RANGE,
	aggro_radius = 20.0,
	damage = 6,
	attack_interval = 1.4,
	death_duration = 1.8,

	-- Health regeneration: Tactical Disengage & Vulnerable Channel
	health_regen = {
		enabled = true,
		rate = 0.8,
		passive = true,
		flee_threshold = FLEE_HP_THRESHOLD,
		return_threshold = RETURN_HP_THRESHOLD,
		burst_duration = 3.5,
		channel_duration = 3.0,
		safe_distance = 12.0,
		heal_amount = 25,
		flee_speed = 4.8,
	},

	damage_effect = { type = "none" },

	drops = {
		{ name = "default:obsidian_shard",        min = 1, max = 2, chance = 0.50 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 2, chance = 0.40 },
		{ name = "default:coal_lump",             min = 1, max = 3, chance = 0.60 },
	},

	sounds = {
		base = "x_mobs_spectrum",
		distance = 24.0,
		gain = 1.0,
		pitch_jitter = 0.05,
		attack = "x_mobs_spectrum_attack",
		shoot = "x_mobs_spectrum_shoot",
		hurt = "x_mobs_spectrum_hurt",
		death = "x_mobs_spectrum_death",
		random = "x_mobs_spectrum_idle",
	},

	-- Canonical non-duplicate model animation tracks
	animations = {
		idle   = { track = "idle",   speed = 1.0, loop = true },
		walk   = { track = "walk",   speed = 1.0, loop = true },
		run    = { track = "run",    speed = 1.2, loop = true },
		attack = { track = "attack", speed = 1.1, loop = false },
		shoot  = { track = "shoot",  speed = 1.0, loop = false },
		hurt   = { track = "hurt",   speed = 1.0, loop = false },
		death  = { track = "death",  speed = 1.0, loop = false },
	},

	bones = {
		Body = { pivot = { x = 0, y = 1.45, z = 0 } },
		Head = { pivot = { x = 0, y = 1.52, z = 0 } },
		Arm_Left = { pivot = { x = 0.41, y = 1.45, z = 0 } },
		Arm_Right = { pivot = { x = -0.4, y = 1.45, z = 0 } },
	},


	can_flinch = function(self)
		return self.state ~= "attacking" and self.state ~= "shooting"
	end,

	--- Damage reaction callback
	---@param puncher? ObjectRef Attacker reference
	---@param _dmg number Damage dealt
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
			x_mobs.spawn_spectrum_hurt(pos)
		end
	end,

	--- Death callback
	---@param _killer? ObjectRef Slaying entity or player
	on_death = function(self, _killer)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			x_mobs.spawn_spectrum_death(pos)
		end
	end,

	--- Health recovery callback: clears flee state and returns to combat
	on_return_to_fight = function(self)
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "walk"
		else
			self.state = "idle"
			self.target = nil
		end
	end,

	melee = {
		range = MELEE_RANGE,
		max_height_diff = 1.8,
		damage = 6,
		cooldown = 1.4,
		duration = 0.7,
		delay = 0.35,
		animation = "attack",
		sound = "attack",
		on_strike = function(self, target, _dir)
			local cp = self.object and self.object:is_valid() and self.object:get_pos()
			if cp then
				local fwd = core.yaw_to_dir(self.object:get_yaw() or 0)
				local claw_pos = {
					x = cp.x + fwd.x * 0.9,
					y = cp.y + 1.2,
					z = cp.z + fwd.z * 0.9,
				}
				x_mobs.spawn_spectrum_claw_strike(claw_pos, fwd)
			end
			if target and target:is_valid() then
				apply_void_miasma(target, self.object)
			end
		end,
	},

	shooter = {
		projectile = "x_mobs:spectrum_orb",
		range = MAX_SHOOT_DISTANCE,
		min_range = MIN_SHOOT_DISTANCE,
		retreat_speed = 1.2,
		velocity = ORB_SPEED,
		damage = 6,
		cooldown = 3.2,
		fire_duration = 0.8,
		fire_delay = 0.4,
		predict_aim = true,
		animation = "shoot",
		sound = "shoot",
		on_charge = function(self, pos)
			if self.object and self.object:is_valid() then
				x_mobs.spawn_spectrum_shoot_charge(pos, self.object)
			end
		end,
	},

	--- Pre-combat custom step hook: handles ambient trail particles
	---@param dtime number Delta time in seconds
	---@param _moveresult? table Engine movement result
	---@param _def? table Mob definition table
	custom_step = function(self, dtime, _moveresult, _def)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if not pos then return false end

		-- Ambient floating trail particles
		self.trail_timer = (self.trail_timer or 0) + dtime
		if self.trail_timer >= 0.25 then
			self.trail_timer = 0
			x_mobs.spawn_spectrum_trail(pos)
		end

		return false -- Proceed to pipeline hooks: tactical_retreat (17), melee (18), shooter (20)
	end,
})

-- ============================================================================
-- 4. GENERAL NATURAL SPAWNING (UP TO 3 MOBS)
-- ============================================================================

x_mob_core.register_spawn("x_mobs:spectrum", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:desert_stone",
		"default:cobble",
		"default:mossycobble",
		"group:soil",
		"default:dirt_with_grass",
		"default:dirt_with_dry_grass",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_coniferous_litter",
	},
	chance = 5000,
	active_object_count = 3,
	group_min = 1,
	group_max = 2,
	min_light = 0,
	max_light = 10,
	min_elevation = -31000,
	max_elevation = 31000,
})
