--[[
	x_mobs - Heated Sword (Volcanic Magma Greatsword Elemental)
	Author: SaKeL
	License: MIT

	Multi-track animated glTF hovering boss/elite elemental patrolling subterranean
	magma chambers, volcanic abysses, and deep obsidian vaults.
	Floats gracefully above the floor with an incandescent living flame tail, wielding
	a serrated volcanic greatsword with devastating thermal cleaves, seismic ground
	rupture slams, and infernal pyre entrapment spells.

	Distinctive Abilities:
	  - Primary Melee Strike: Blazing Greatsword Cleave (punch) dealing thermal slashes and burning DoT
	  - Secondary Melee Strike: Volcanic Fissure Slam (punch2) unleashing an explosive radial magma rupture
	  - Ranged Fireball: Magma Core Orb (shoot) launching explosive molten fireballs with shrapnel splash
	  - Boss Spell: Infernal Pyre Envelop (spell) trapping foes in a roaring flame pillar with continuous burn
	  - Hovering Locomotion: Levitates with living flame tail respiration; water vulnerability if submerged
	  - Tactical Mobility: Disengages when critically wounded to channel volcanic furnace rejuvenation
--]]

local S = core.get_translator("x_mobs")

local MELEE_RANGE = 2.8
local MIN_SHOOT_DISTANCE = 4.5
local MAX_SHOOT_DISTANCE = 16.0
local MAX_FLEE_DISTANCE = 14.0
local LOW_HP_THRESHOLD = 30
local FIREBALL_SPEED = 18.0
local SPELL_COOLDOWN = 12.0
local SPELL_DURATION = 5.0
local SPELL_SLOWDOWN = 0.50

-- ============================================================================
-- 1. MAGMA FIREBALL PROJECTILE ENTITY
-- ============================================================================

core.register_entity("x_mobs:heated_sword_fireball", {
	initial_properties = {
		hp_max = 1,
		infotext = S("Magma Fireball"),
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_fireball.png"},
		visual_size = {x = 0.85, y = 0.85},
		glow = 14,
		static_save = false,
	},
	armor_groups = { immortal = 1 },
	_is_arrow = true,
	_is_projectile = true,
	factions = { "monster", "fire", "elemental" },

	on_activate = function(self)
		self.object:set_armor_groups({ immortal = 1 })
	end,

	on_punch = function(_self, _puncher, _time_from_last_punch, _tool_capabilities, _dir)
		return true
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			gravity = 0.4,
			drag = 0.02,
			radius = 0.75,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 3.5,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_heated_sword_fireball_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 6, fire = 3 },
				}, dir)
				proj._punched_direct = hit_obj

				-- Ignite target with burning status effect (DoT 1 dmg/s for 3s)
				if hit_obj:is_player() then
					x_mob_core.apply_status_effect(hit_obj, {
						id = "magma_burn",
						type = "dot",
						damage = 1,
						tick_rate = 1.0,
						duration = 3.0,
						hud_vignette = "x_mob_core_vignette.png^[colorize:#ff440055",
					})
				end
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_heated_sword_fireball_impact(hit_pos)
				core.sound_play("x_mobs_heated_sword_smash", {
					pos = hit_pos,
					gain = 0.85,
					pitch = 1.2,
					max_hear_distance = 24.0,
				}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Explosive thermal blast radius (2.2 nodes)
				local objs = core.get_objects_inside_radius(hit_pos, 2.2)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = { fleshy = 4, fire = 2 },
						}, dir)
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. INFERNAL PYRE ENVELOP SPELL
-- ============================================================================

--- Envelops target in a roaring pillar of flame with movement slow and burning DoT
---@param _caster ObjectRef Heated sword caster
---@param target ObjectRef Enveloped victim
---@return boolean|table result Status effect handle
function x_mobs.cast_fire_envelop(_caster, target)
	if not target or not target:is_valid() then return false end
	local tpos = target:get_pos()
	if not tpos then return false end

	x_mob_core.play_sound(target, "x_mobs_heated_sword_spell", {
		pos = tpos,
		gain = 1.0,
		max_hear_distance = 26.0,
	})
	x_mobs.spawn_heated_sword_spell_ignite(tpos)

	return x_mob_core.apply_status_effect(target, {
		id = "infernal_pyre",
		type = "dot",
		damage = 2,
		tick_rate = 1.0,
		speed_factor = SPELL_SLOWDOWN,
		jump_factor = 0.50,
		duration = SPELL_DURATION,
		envelop_texture = "x_mobs_fire_envelop.png",
		hud_vignette = "x_mob_core_vignette.png^[colorize:#ff440088",
		particles = x_mobs.get_fire_attached_spawner(),
		on_remove = function(victim)
			local pos = victim:get_pos()
			if pos then
				x_mob_core.play_sound(victim, "x_mobs_heated_sword_smash", {
					pos = pos,
					gain = 0.85,
					pitch = 1.3,
					max_hear_distance = 22.0,
				})
				x_mobs.spawn_heated_sword_spell_burst(pos)
			end
		end,
	})
end

--- Executes the Infernal Pyre special spell (12s cooldown, 5s burn duration)
---@param mob table Mob instance
---@param pos Vector Mob position
---@param _to_target Vector Normalized vector to target
---@param face_yaw number Facing yaw angle in radians
local function perform_heated_sword_spell(mob, pos, _to_target, face_yaw)
	mob.state = "casting"
	mob.action_timer = 1.0
	mob.cooldowns = mob.cooldowns or {}
	mob.cooldowns.spell = SPELL_COOLDOWN

	mob.object:set_yaw(face_yaw)
	mob._cur_rot = { x = 0, y = face_yaw, z = 0 }
	x_mob_core.halt_horizontal_velocity(mob)

	x_mob_core.play_animation(mob.object, "shoot", { speed = 1.0, loop = false, force = true })
	x_mob_core.play_sound(mob, "spell")
	x_mobs.spawn_heated_sword_spell_cast(pos)

	x_mob_core.schedule(mob, 0.45, "heated_sword_envelop_cast", function()
		if mob.target and x_mob_core.is_player_alive(mob.target) then
			x_mobs.cast_fire_envelop(mob.object, mob.target)
		end
	end)
end

-- ============================================================================
-- 3. HEATED SWORD MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:heated_sword", {
	initial_properties = {
		hp_max = 95,
		description = S("Heated Greatsword"),
		mesh = "x_mobs_heated_sword.glb",
		textures = { "x_mobs_heated_sword.png" },
		-- Visual scale 9.5 aligns model height (1.856 units in glb * 0.95 = 1.76 nodes)
		visual_size = {x = 9.5, y = 9.5},
		collisionbox = {-0.4, 0.0, -0.4, 0.4, 1.8, 0.4},
		selectionbox = {-0.5, 0.0, -0.5, 0.5, 1.9, 0.5},
		stepheight = 1.2,
		glow = 7,
		infotext = S("Heated Greatsword"),
		makes_footstep_sound = false,
	},

	factions = { "monster", "fire", "elemental" },
	armor_groups = { fleshy = 65, cracky = 50, fire = 0 },
	knockback_mult = 0.6,
	mob_height = 1.8,
	eye_offset = 1.55,
	is_floating = true,
	hover_offset = 0.6,
	combat_hover_offset = 0.2,
	combat_standoff = 2.0,
	walk_speed = 2.8,
	pursuit_speed = 4.8,
	wander_speed = 2.0,
	flee_speed = 5.0,
	max_flee_distance = MAX_FLEE_DISTANCE,
	attack_range = MELEE_RANGE,
	aggro_radius = 22.0,
	death_duration = 1.4,
	can_swim = false,
	disallow_water = true,

	-- Health regeneration: Tactical Disengage & Volcanic Furnace Channel
	health_regen = {
		enabled = true,
		rate = 1.0,
		passive = true,
		flee_threshold = LOW_HP_THRESHOLD,
		return_threshold = 70,
		burst_duration = 3.5,
		channel_duration = 3.0,
		safe_distance = 12.0,
		heal_amount = 35,
		flee_speed = 5.0,
	},

	damage_effect = { type = "none" },

	buffs = {
		thresholds = {
			{
				id = "molten_overdrive",
				hp_ratio = 0.35,
				cleanse = true,
				effect = "frenzy",
				sound = "x_mobs_heated_sword_spell",
				vfx = function(pos)
					x_mobs.spawn_heated_sword_smash(pos)
				end,
			},
		},
		triggers = {
			{
				id = "magma_shield",
				event = "on_heavy_damage",
				threshold_damage = 10,
				cooldown = 14.0,
				effect = "barrier",
				sound = "x_mobs_heated_sword_hurt",
			},
		},
	},

	drops = {
		{ name = "default:obsidian_shard", min = 2, max = 5, chance = 0.85 },
		{ name = "default:coal_lump",       min = 2, max = 6, chance = 0.90 },
		{ name = "default:flint",           min = 1, max = 3, chance = 0.60 },
		{ name = "default:copper_lump",     min = 1, max = 2, chance = 0.45 },
		{ name = "default:diamond",         min = 1, max = 1, chance = 0.15 },
	},

	animations = {
		idle   = { track = "idle",   speed = 1.0, loop = true },
		walk   = { track = "walk",   speed = 1.0, loop = true },
		run    = { track = "run",    speed = 1.2, loop = true },
		attack = { track = "punch",  speed = 1.1, loop = false },
		punch  = { track = "punch",  speed = 1.1, loop = false },
		punch2 = { track = "punch2", speed = 1.0, loop = false },
		shoot  = { track = "shoot",  speed = 1.0, loop = false },
		spell  = { track = "shoot",  speed = 1.0, loop = false },
		hurt   = { track = "hurt",   speed = 1.1, loop = false },
		death  = { track = "death",  speed = 1.0, loop = false },
	},

	bones = {
		Body           = { pivot = { x = 0, y = 0.93, z = 0 } },
		Head           = { pivot = { x = 0, y = 1.55, z = 0 } },
		Shoulder_Right = { pivot = { x = 0.55, y = 1.45, z = 0 } },
		Arm_Right      = { pivot = { x = 0.78, y = 1.35, z = 0 } },
		Shoulder_Left  = { pivot = { x = -0.55, y = 1.45, z = 0 } },
		Arm_Left       = { pivot = { x = -0.72, y = 1.35, z = 0 } },
		Spine          = { pivot = { x = 0, y = 1.50, z = 0 } },
		Tail           = { pivot = { x = 0, y = 0.32, z = 0 } },
	},

	sounds = {
		distance = 26.0,
		random = { name = "x_mobs_heated_sword_idle", gain = 0.85, min_interval = 5.0, max_interval = 14.0 },
		attack = { name = "x_mobs_heated_sword_swing", gain = 0.95 },
		smash  = { name = "x_mobs_heated_sword_smash", gain = 1.0 },
		shoot  = { name = "x_mobs_heated_sword_shoot", gain = 0.95 },
		spell  = { name = "x_mobs_heated_sword_spell", gain = 1.0 },
		hurt   = { name = "x_mobs_heated_sword_hurt", gain = 0.9 },
		death  = { name = "x_mobs_heated_sword_death", gain = 1.0 },
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
			x_mobs.spawn_heated_sword_hurt(pos)
		end
	end,

	on_activate = function(self)
		x_mob_core.particles.attach(self.object, x_mobs.get_heated_sword_ambient_spawner())
	end,

	on_death = function(self, _killer)
		x_mob_core.particles.clear_target(self.object)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if pos then
			x_mobs.spawn_heated_sword_death(pos)
		end
	end,

	on_return_to_fight = function(self)
		self.state = "idle"
		if self.target and x_mob_core.is_player_alive(self.target) then
			self.state = "combat"
		end
	end,

	-- =========================================================================
	-- DECLARATIVE MELEE COMBAT PROFILE
	-- Multi-attack profile:
	--   65% Blazing Cleave (punch): Wide horizontal arc inflicting burning DoT
	--   35% Volcanic Fissure Slam (punch2, aoe = true): Ground rupture shockwave
	-- =========================================================================
	melee = {
		range = MELEE_RANGE,
		max_height_diff = 1.8,
		reach_tolerance = 0.6,
		attacks = {
			{
				-- 65% Blazing Greatsword Cleave
				weight = 65,
				animation = "punch",
				anim_speed = 1.1,
				sound = "attack",
				duration = 0.70,
				cooldown = 1.3,
				delay = 0.35,
				damage = 8,
				on_strike = function(self, _target, dir)
					local cp = self.object:get_pos()
					if cp then
						local fwd = dir or core.yaw_to_dir(self.object:get_yaw() or 0)
						local swing_pos = {
							x = cp.x + fwd.x * 1.1,
							y = cp.y + 1.2,
							z = cp.z + fwd.z * 1.1,
						}
						x_mobs.spawn_heated_sword_swing(swing_pos, fwd)
					end
				end,
			},
			{
				-- 35% Volcanic Fissure Slam (AoE radial ground rupture)
				weight = 35,
				animation = "punch2",
				anim_speed = 1.0,
				sound = "smash",
				duration = 1.2,
				cooldown = 2.8,
				delay = 0.45,
				aoe = true,
				perform_attack = function(self, _target, _dir)
					local cp = self.object:get_pos()
					if not cp then return end

					local cur_yaw = self.object:get_yaw() or 0
					local fwd = core.yaw_to_dir(cur_yaw)
					local epicenter = {
						x = cp.x + fwd.x * 1.3,
						y = cp.y,
						z = cp.z + fwd.z * 1.3,
					}

					x_mob_core.play_sound(self, "smash", {
						pos = epicenter,
						gain = 1.0,
						distance = 28.0,
					})

					local blast_radius = 3.2
					x_mobs.spawn_heated_sword_smash(epicenter)

					local nearby = core.get_objects_inside_radius(epicenter, blast_radius)
					for i = 1, #nearby do
						local obj = nearby[i]
						if obj and obj:is_valid() and obj ~= self.object
								and x_mob_core.is_valid_projectile_target(self, obj) then
							local op = obj:get_pos()
							if op then
								local to_victim = vector.direction(epicenter, op)
								to_victim.y = 0.45
								local kb_vel = vector.multiply(vector.normalize(to_victim), 4.5)
								obj:punch(self.object, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = 10, fire = 4 },
								}, to_victim)
								obj:add_velocity(kb_vel)
							end
						end
					end
				end,
			},
		},
	},

	-- =========================================================================
	-- DECLARATIVE RANGED COMBAT PROFILE
	-- Magma fireball launch
	-- =========================================================================
	shooter = {
		projectile = "x_mobs:heated_sword_fireball",
		range = MAX_SHOOT_DISTANCE,
		min_range = MIN_SHOOT_DISTANCE,
		retreat_speed = 1.0,
		velocity = FIREBALL_SPEED,
		damage = 6,
		cooldown = 3.5,
		fire_duration = 0.9,
		fire_delay = 0.45,
		predict_aim = true,
		animation = "shoot",
		sound = "shoot",
		on_charge = function(self, pos)
			if self.object and self.object:is_valid() then
				x_mobs.spawn_heated_sword_shoot_charge(pos, self.object)
			end
		end,
	},

	-- =========================================================================
	-- CUSTOM STEP HOOK: AMBIENT TRAIL, WATER VULNERABILITY & BOSS SPELL
	-- =========================================================================
	custom_step = function(self, dtime, _moveresult, _def)
		local pos = self.object and self.object:is_valid() and self.object:get_pos()
		if not pos then return false end

		-- 1. Water extinguish vulnerability: takes 5 damage/sec when submerged
		self.water_timer = (self.water_timer or 0) + dtime
		if self.water_timer >= 1.0 then
			self.water_timer = 0
			local node = core.get_node(pos)
			local nodedef = core.registered_nodes[node.name]
			if nodedef and (nodedef.liquidtype == "flowing" or nodedef.liquidtype == "source")
					and string.find(node.name, "water") then
				self.object:punch(self.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = { fleshy = 5 },
				}, {x = 0, y = 1, z = 0})
				core.sound_play("x_mobs_heated_sword_hurt", {
					pos = pos,
					gain = 0.9,
					pitch = 1.4,
				}, true)
				x_mobs.spawn_heated_sword_hurt(pos)
			end
		end

		-- 3. Yield to core tactical retreat and health channel when fleeing/healing
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

		-- 4. Unique Boss Spell: Infernal Pyre Envelop (12s cooldown, 4.5m - 16m range)
		if (self.cooldowns.spell or 0) <= 0 and dist >= MIN_SHOOT_DISTANCE and dist <= MAX_SHOOT_DISTANCE then
			local eye_pos = { x = pos.x, y = pos.y + (self.eye_offset or 1.55), z = pos.z }
			local target_eye = { x = tpos.x, y = tpos.y + 1.2, z = tpos.z }
			if x_mob_core.line_of_sight(eye_pos, target_eye) then
				perform_heated_sword_spell(self, pos, to_target, face_yaw)
				return true
			end
		end

		return false -- Proceed to pipeline hooks: tactical_retreat, melee, shooter
	end,
})

-- ============================================================================
-- 4. NATURAL SPAWNING REGISTRATION
-- Deep subterranean lava caverns, magma chambers, nether depths
-- ============================================================================

x_mob_core.register_spawn("x_mobs:heated_sword", {
	nodes = {
		"group:stone",
		"default:stone",
		"default:desert_stone",
		"default:obsidian",
		"everness:cursed_stone",
	},
	chance = 2800,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 12,
	min_elevation = -31000,
	max_elevation = -80,
})

core.log("action", "[x_mobs] Heated Greatsword elemental registered successfully.")
