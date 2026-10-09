--[[
	x_mobs - Chasm Weaver (Subterranean Arachnid Predator)
	Author: SaKeL
	License: MIT

	Multi-Track Animated glTF Entity with 4 Distinct Tarantula Phenotypes:
	  1. Brazilian Jewel Tarantula (Typhochlaena seladonia) - Living gemstone
	  2. Indian Ornamental Tarantula (Poecilotheria regalis) - Ash-white starburst mandala
	  3. Antilles Pinktoe Tarantula (Caribena versicolor) - Seafoam teal and bubblegum pink scopulae
	  4. Subterranean Chasm Weaver (Flagship obsidian and emerald carapace)

	Distinctive Abilities:
	  - Alternating Tripod Crawling & Wall Climbing
	  - Threat Display & Impaling Melee Strike (attack)
	  - Predatory Pounce Leap with Silk Anchor
	  - High-Velocity Silk Web Bolt Shooting (shoot)
	  - 20% Chance: Iridescent Jewel Spore (Massive Area Acid-Silk Detonation)
	  - Defensive Urticating Setae Bristle Discharge on Heavy Impact
--]]

local BOLT_SPEED = 18.0
local BOLT_RANGE = 18.0
local JEWEL_SPORE_SPEED = 14.0
local MELEE_RANGE = 2.4
local POUNCE_MIN_DIST = 4.5
local POUNCE_MAX_DIST = 11.0

-- ============================================================================
-- 1. PROJECTILE ENTITIES (SILK BOLT & IRIDESCENT JEWEL SPORE)
-- ============================================================================

core.register_entity("x_mobs:chasm_weaver_bolt", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mobs_spider_particles.png^[sheet:8x8:0,2"},
		visual_size = {x = 0.75, y = 0.75},
		glow = 8,
	},

	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			gravity = 4.0,
			drag = 0.05,
			radius = 0.65,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 4.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.04 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_chasm_silk_bolt_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 5},
				}, dir)
				proj._punched_direct = hit_obj

				-- Apply web slowdown envelop (50% speed for 3s)
				x_mobs.cast_web_envelop(source, hit_obj, 1.0)
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_chasm_silk_bolt_impact(hit_pos)
				core.sound_play("x_mobs_spider_web", {pos = hit_pos, gain = 0.9, max_hear_distance = 20}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Splash web snare in 2.0m radius
				local objs = core.get_objects_inside_radius(hit_pos, 2.0)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = {fleshy = 3},
						}, dir)
						x_mobs.cast_web_envelop(source, obj, 0.6)
					end
				end
			end,
		})
	end,
})

core.register_entity("x_mobs:chasm_weaver_jewel_spore", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collide_with_objects = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		selectionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		visual = "sprite",
		textures = {"x_mob_core_sparkle.png^[colorize:#23deba:220"},
		visual_size = {x = 1.0, y = 1.0},
		glow = 14,
	},

	on_activate = function(self)
		self.object:set_armor_groups({immortal = 1})
	end,

	on_step = function(self, dtime)
		x_mob_core.step_projectile(self, dtime, {
			gravity = 2.5,
			drag = 0.03,
			radius = 0.85,
			hit_nodes = true,
			hit_objects = true,
			lifetime = 4.0,
			on_step = function(proj, dt, pos)
				self.trail_timer = (self.trail_timer or 0) + dt
				if self.trail_timer >= 0.05 then
					self.trail_timer = 0
					local vel = proj.object:get_velocity()
					x_mobs.spawn_chasm_jewel_spore_trail(pos, vel)
				end
			end,
			on_hit_object = function(proj, hit_obj, _hit_pos, dir)
				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				hit_obj:punch(source, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 9, acidic = 4},
				}, dir)
				proj._punched_direct = hit_obj

				-- Apply dual synergy: Web Slowdown AND Neurotoxic Venom DoT
				x_mobs.cast_web_envelop(source, hit_obj, 1.0)
				x_mobs.cast_venom_envelop(source, hit_obj, 1.0)
			end,
			on_hit = function(proj, hit_obj, hit_pos)
				x_mobs.spawn_chasm_jewel_spore_impact(hit_pos)
				core.sound_play("x_mobs_chasm_weaver_spell", {pos = hit_pos, gain = 1.0, max_hear_distance = 26}, true)

				local source = (proj._shooter and proj._shooter:is_valid()) and proj._shooter or proj.object
				local direct_punched = proj._punched_direct or hit_obj

				-- Catastrophic area acid-silk cloud in 3.5m radius
				local objs = core.get_objects_inside_radius(hit_pos, 3.5)
				for i = 1, #objs do
					local obj = objs[i]
					if obj and obj:is_valid() and obj ~= direct_punched
							and x_mob_core.is_valid_projectile_target(proj, obj) then
						local opos = obj:get_pos()
						local dir = opos and vector.direction(hit_pos, opos) or {x = 0, y = 1, z = 0}
						obj:punch(source, 1.0, {
							full_punch_interval = 1.0,
							damage_groups = {fleshy = 6, acidic = 3},
						}, dir)
						x_mobs.cast_web_envelop(source, obj, 0.8)
						x_mobs.cast_venom_envelop(source, obj, 0.8)
					end
				end
			end,
		})
	end,
})

-- ============================================================================
-- 2. CHASM WEAVER MOB REGISTRATION
-- ============================================================================

x_mob_core.register_mob("x_mobs:chasm_weaver", {
	initial_properties = {
		hp_max = 50,
		mesh = "x_mobs_chasm_weaver.glb",
		-- Multiple tarantula phenotypes for random selection by x_mob_core:
		textures = {
			{ "x_mobs_chasm_weaver_jewel.png" },
			{ "x_mobs_chasm_weaver_ornamental.png" },
			{ "x_mobs_chasm_weaver_pinktoe.png" },
			{ "x_mobs_chasm_weaver.png" },
		},
		-- Luanti glTF scaling: 10 units = 1 node. Model is ~3.55 units wide; 3.2 gives 1.14-node span
		visual_size = {x = 3.2, y = 3.2},
		collisionbox = {-0.45, 0.0, -0.45, 0.45, 0.45, 0.45},
		selectionbox = {-0.60, 0.0, -0.60, 0.60, 0.55, 0.60},
		stepheight = 1.2,
		glow = 5,
	},

	factions = { "insectoid", "spider", "subterranean" },
	armor_groups = { fleshy = 75 },
	aggro_radius = 20.0,
	attack_range = MELEE_RANGE,
	walk_speed = 3.8,
	pursuit_speed = 5.6,
	wander_speed = 2.2,
	wander_radius = 12.0,
	scan_interval = 0.35,
	knockback_mult = 1.8,
	can_crawl = true,
	can_swim = false,
	death_duration = 1.44,
	eye_offset = 0.45,

	health_regen = {
		flee_threshold = 12,
		return_threshold = 30,
		rate = 1.0,
	},

	damage_effect = { type = "ichor" },

	drops = {
		{ name = "farming:string",               min = 2, max = 5, chance = 0.90 },
		{ name = "default:diamond",              min = 1, max = 1, chance = 0.20 },
		{ name = "default:mese_crystal_fragment", min = 1, max = 3, chance = 0.50 },
		{ name = "default:flint",                min = 1, max = 2, chance = 0.45 },
		{ name = "default:coal_lump",            min = 1, max = 3, chance = 0.55 },
		{ name = "default:clay_lump",            min = 2, max = 4, chance = 0.40 },
		{ name = "vessels:glass_bottle",         min = 1, max = 1, chance = 0.30 },
	},

	animations = {
		idle   = {track = "idle",   speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.25, loop = true},
		attack = {track = "attack", speed = 1.2, loop = false},
		shoot  = {track = "shoot",  speed = 1.1, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	bones = {
		Thorax       = { pivot = { x = 0, y = 0.75, z = -0.2 } },
		Head         = { pivot = { x = 0, y = 0.75, z = 0.2 } },
		Abdomen      = { pivot = { x = 0, y = 0.8, z = -0.8 } },
		Leg_Upper_R1 = { pivot = { x = 0.38, y = 0.75, z = -0.15 } },
		Leg_Upper_L1 = { pivot = { x = -0.38, y = 0.75, z = -0.15 } },
		Leg_Upper_R2 = { pivot = { x = 0.38, y = 0.75, z = -0.45 } },
		Leg_Upper_L2 = { pivot = { x = -0.38, y = 0.75, z = -0.45 } },
		Leg_Upper_R3 = { pivot = { x = 0.38, y = 0.75, z = -0.78 } },
		Leg_Upper_L3 = { pivot = { x = -0.38, y = 0.75, z = -0.78 } },
	},

	vfx = {
		hurt = { type = "venom", count = 8 },
		death = {
			{ type = "spider_death", scale = 1.1 },
		},
		despawn = { type = "spider_dissolve", scale = 1.1 },
	},

	sounds = {
		distance = 22.0,
		random = { name = "x_mobs_spider_random", gain = 0.75, min_interval = 6.0, max_interval = 16.0 },
		attack = { name = "x_mobs_spider_attack", gain = 0.85 },
		shoot  = { name = "x_mobs_chasm_weaver_shoot", gain = 0.9 },
		hurt   = { name = "x_mobs_spider_hurt", gain = 0.9 },
		death  = { name = "x_mobs_spider_death", gain = 1.0 },
		pounce = { name = "x_mobs_spider_pounce", gain = 0.9 },
		spell  = { name = "x_mobs_chasm_weaver_spell", gain = 1.0 },
	},

	swarm_alert = { enabled = true, radius = 14.0, max_allies = 3 },

	cooldowns = {
		attack = 0,
		shoot = 2.5,
		pounce = 3.5,
		setae = 0,
		drop = 0,
	},

	on_activate = function(self)
		self.cooldowns = self.cooldowns or {}
		self.cooldowns.attack = 0
		self.cooldowns.shoot = 2.5
		self.cooldowns.pounce = 3.5
		self.cooldowns.setae = 0
		self.cooldowns.drop = 0
	end,

	can_flinch = function(self)
		return self.state ~= "pouncing" and self.state ~= "attacking" and self.state ~= "shooting"
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
				collisionbox = {-0.45, 0.0, -0.45, 0.45, 0.45, 0.45},
				selectionbox = {-0.60, 0.0, -0.60, 0.60, 0.55, 0.60},
			})
			if self.path_state then
				self.path_state.waypoints = nil
				self.path_state.index = 1
			end
		end

		-- Tarantula defensive trait: 20% chance to discharge irritating urticating setae cloud
		if dmg >= 4 and (self.cooldowns.setae or 0) <= 0 and math.random(1, 100) <= 20 then
			self.cooldowns.setae = 5.0
			local pos = self.object:get_pos()
			if pos then
				x_mobs.spawn_chasm_urticating_setae(pos)
				core.sound_play("x_mobs_chasm_weaver_setae", {pos = pos, gain = 0.85, max_hear_distance = 16}, true)

				-- Irritate and slow close attackers within 3.5m
				local attackers = core.get_objects_inside_radius(pos, 3.5)
				for i = 1, #attackers do
					local att = attackers[i]
					if att and att:is_valid() and att ~= self.object and att:is_player() then
						x_mob_core.apply_status_effect(att, {
							id = "urticating_itch",
							type = "slow",
							chance = 0.8,
							speed_factor = 0.70,
							duration = 2.5,
							hud_vignette = "x_mob_core_vignette.png^[colorize:#ffd04355",
						})
					end
				end
			end
		end
	end,

	on_action_end = function(self)
		if self.state == "pouncing" then
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
			end,
		},
		{
			from = "*",
			to = "pouncing",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or (self.cooldowns.pounce or 0) > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				local dy = tpos.y - pos.y
				local can_pounce_elev = (dy >= -8.0 and dy <= 2.5)
				if not can_pounce_elev or dist < POUNCE_MIN_DIST or dist > POUNCE_MAX_DIST then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.45), z = pos.z}
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
			end,
		},
		{
			from = "*",
			to = "shooting",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or (self.cooldowns.shoot or 0) > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				if dist < 4.0 or dist > BOLT_RANGE then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.45), z = pos.z}
				local target_eye = {x = tpos.x, y = tpos.y + 1.4, z = tpos.z}
				return x_mob_core.line_of_sight(eye_pos, target_eye)
			end,
			on_transition = function(self)
				self:perform_shoot(self.target:get_pos())
			end,
		},
		{
			from = "*",
			to = "attacking",
			condition = function(self)
				if (self.action_timer or 0) > 0 or not self.target or (self.cooldowns.attack or 0) > 0 then return false end
				local pos = self.object:get_pos()
				local tpos = self.target:get_pos()
				if not pos or not tpos then return false end

				local dist = vector.distance(pos, tpos)
				if dist > (self.attack_range or MELEE_RANGE) then return false end

				local eye_pos = {x = pos.x, y = pos.y + (self.eye_offset or 0.45), z = pos.z}
				local target_eye = {x = tpos.x, y = tpos.y + 1.2, z = tpos.z}
				return x_mob_core.line_of_sight(eye_pos, target_eye)
			end,
			on_transition = function(self)
				self:perform_attack(self.target)
			end,
		},
	},

	on_step = function(self, dtime)
		if self.state == "fleeing" then
			local return_thresh = self.return_hp_threshold or 30
			if (self.memory and not self.memory.flee_state) or (self.hp and self.hp >= return_thresh) then
				self.state = "idle"
				if self.memory then self.memory.flee_state = false end
			else
				x_mob_core.step_move_or_idle(self, dtime, "run", 1.25)
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

		-- Dynamic speed scaling & subterranean dark burst: predators run faster in darkness
		local light = core.get_node_light(pos) or 10
		local speed_mult = (light <= 6) and 1.2 or 1.0
		self.pursuit_speed = (dist > 8.0) and (5.8 * speed_mult) or (4.2 * speed_mult)
		local move_anim = (self.pursuit_speed > 4.6) and "run" or "walk"
		local anim_speed = (move_anim == "run") and 1.25 or 1.0
		x_mob_core.step_move_or_idle(self, dtime, move_anim, anim_speed)
	end,

	perform_shoot = function(self, target_pos)
		self.state = "shooting"
		self.action_timer = 0.96 -- 24 frames @ 25 fps
		self.cooldowns.shoot = 3.5

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		else
			x_mob_core.halt_horizontal_velocity(self)
		end

		local pos = self.object:get_pos()
		local shoot_dir = vector.direction(pos, target_pos)
		if not on_surface then
			local s_yaw = core.dir_to_yaw(shoot_dir)
			self._cur_rot = {x = 0, y = s_yaw, z = 0}
			self.object:set_rotation(self._cur_rot)
		end

		x_mob_core.play_animation(self.object, "shoot", {speed = 1.1, loop = false})

		-- 20% Chance: Iridescent Jewel Spore (Massive Area Acid-Silk Explosion) vs 80% Silk Bolt
		local is_jewel_spore = (math.random(1, 100) <= 20)

		if is_jewel_spore then
			x_mob_core.sound.play(self, "spell")
		else
			x_mob_core.sound.play(self, "shoot")
		end

		-- Projectile launch aligned with head rear-back and mouth thrust (~0.36s into animation)
		x_mob_core.schedule(self, 0.36, "scheduled_action", function()
			local cur_pos = self.object:get_pos()
			if not cur_pos then return end
			local cur_tpos = self.target and x_mob_core.is_player_alive(self.target) and self.target:get_pos() or target_pos
			if not cur_tpos then return end

			local mpos = {
				x = cur_pos.x + shoot_dir.x * 0.7,
				y = cur_pos.y + (self.eye_offset or 0.45) + shoot_dir.y * 0.4,
				z = cur_pos.z + shoot_dir.z * 0.7,
			}

			local entity_name = is_jewel_spore and "x_mobs:chasm_weaver_jewel_spore" or "x_mobs:chasm_weaver_bolt"
			local speed = is_jewel_spore and JEWEL_SPORE_SPEED or BOLT_SPEED

			local proj_obj = core.add_entity(mpos, entity_name)
			if proj_obj and proj_obj:is_valid() then
				local proj_ent = proj_obj:get_luaentity()
				if proj_ent then
					proj_ent._shooter = self.object
				end

				-- Lead target prediction for active player movement
				local target_vel = (self.target and self.target:is_valid() and self.target:get_velocity()) or {x = 0, y = 0, z = 0}
				local pdist = vector.distance(mpos, cur_tpos)
				local flight_time = pdist / speed
				local aim_target = {
					x = cur_tpos.x + target_vel.x * flight_time * 0.65,
					y = cur_tpos.y + target_vel.y * flight_time * 0.4 + 0.6,
					z = cur_tpos.z + target_vel.z * flight_time * 0.65,
				}
				local aim_dir = vector.direction(mpos, aim_target)

				proj_obj:set_velocity({
					x = aim_dir.x * speed,
					y = aim_dir.y * speed,
					z = aim_dir.z * speed,
				})
				proj_obj:set_yaw(core.dir_to_yaw(aim_dir))
			end
		end)
	end,

	perform_attack = function(self, target)
		self.state = "attacking"
		self.action_timer = 0.80 -- 24 frames @ 30 fps
		self.cooldowns.attack = 1.4

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.object:set_acceleration({x = 0, y = 0, z = 0})
			self.object:set_velocity({x = 0, y = 0, z = 0})
		else
			x_mob_core.halt_horizontal_velocity(self)
		end

		x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})
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

		-- Damage delivery at violent impaling pounce stroke (~0.35s)
		x_mob_core.schedule(self, 0.35, "scheduled_action", function()
			if not x_mob_core.is_player_alive(target) then return end
			local cur_pos = self.object:get_pos()
			local cur_tpos = target:get_pos()
			if not cur_pos or not cur_tpos then return end

			if vector.distance(cur_pos, cur_tpos) <= (self.attack_range or MELEE_RANGE) + 0.6 then
				target:punch(self.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = 7},
				}, vector.direction(cur_pos, cur_tpos))
				x_mobs.spawn_venom_particles(cur_tpos, 16)

				-- Melee bite synergy: 25% chance to inject Neurotoxic Chasm Venom
				if math.random(1, 100) <= 25 then
					x_mobs.cast_venom_envelop(self.object, target)
				end
			end
		end)
	end,

	perform_pounce = function(self, target_pos)
		self.state = "pouncing"
		self.action_timer = 0.85
		self.cooldowns.pounce = 4.5
		self.cooldowns.attack = 0.6

		local on_surface = self.on_wall_or_ceiling or
			(self._cur_rot and (math.abs(self._cur_rot.x) > 0.35 or math.abs(self._cur_rot.z) > 0.35))

		if on_surface then
			self.on_wall_or_ceiling = false
			self._has_wall_cbox = false
			self.object:set_properties({
				collisionbox = {-0.45, 0.0, -0.45, 0.45, 0.45, 0.45},
				selectionbox = {-0.60, 0.0, -0.60, 0.60, 0.55, 0.60},
			})
		end

		x_mob_core.play_animation(self.object, "attack", {speed = 1.3, loop = false})
		x_mob_core.sound.play(self, "pounce")

		local pos = self.object:get_pos()
		local pounce_dir = vector.direction(pos, target_pos)
		local pounce_dist = vector.distance(pos, target_pos)
		local leap_speed = math.min(math.max(pounce_dist / 0.8, 7.0), 13.0)

		local pounce_yaw = core.dir_to_yaw(pounce_dir)
		self._cur_rot = {x = 0, y = pounce_yaw, z = 0}
		self.object:set_rotation(self._cur_rot)

		local dy = target_pos.y - pos.y
		local initial_vy
		if dy < -2.0 then
			self.object:set_acceleration({x = 0, y = -14.0, z = 0})
			initial_vy = math.max(-8.0, dy * 0.7 + 1.5)
		else
			self.object:set_acceleration({x = 0, y = -16.0, z = 0})
			initial_vy = 3.5 + math.min(math.max(dy * 0.4, -0.8), 1.2)
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
				if tpos and vector.distance(land_pos, tpos) <= (self.attack_range or MELEE_RANGE) + 1.0 then
					self.target:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 8},
					}, vector.direction(land_pos, tpos))
					x_mobs.spawn_venom_particles(tpos, 14)
				end
			end
		end)
	end,

	perform_ceiling_drop = function(self, target_pos)
		self.state = "pouncing"
		self.action_timer = 0.85
		self.cooldowns.drop = 5.0
		self.cooldowns.pounce = 3.0
		self.cooldowns.attack = 0.5

		self._cur_rot = {x = -math.pi / 2, y = self.object:get_yaw() or 0, z = 0}
		self.object:set_rotation(self._cur_rot)
		self.object:set_acceleration({x = 0, y = -14.0, z = 0})

		local pos = self.object:get_pos()
		local dx = target_pos.x - pos.x
		local dz = target_pos.z - pos.z
		self.object:set_velocity({
			x = dx * 1.5,
			y = -3.5,
			z = dz * 1.5,
		})

		x_mob_core.play_animation(self.object, "attack", {speed = 1.2, loop = false})
		x_mob_core.sound.play(self, "pounce")
		x_mobs.spawn_spider_skitter(pos)

		x_mob_core.schedule(self, 0.48, "scheduled_action", function()
			local land_pos = self.object:get_pos()
			x_mobs.spawn_spider_skitter(land_pos)
			x_mobs.spawn_venom_particles(land_pos, 16)

			self._cur_rot = {x = 0, y = self.object:get_yaw() or 0, z = 0}
			self.object:set_rotation(self._cur_rot)
			self.object:set_acceleration({x = 0, y = -9.81, z = 0})

			if self.target and x_mob_core.is_player_alive(self.target) then
				local cur_tpos = self.target:get_pos()
				if cur_tpos and vector.distance(land_pos, cur_tpos) <= 3.0 then
					self.target:punch(self.object, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = {fleshy = 8},
					}, vector.direction(land_pos, cur_tpos))
				end
			end
		end)
	end,
})

-- Register natural spawns for Chasm Weaver in subterranean caverns, ruins, and dark stone strata
x_mob_core.register_spawn("x_mobs:chasm_weaver", {
	nodes = {
		"group:stone",
		"group:soil",
		"group:sand",
		"group:everness_sand",
		"default:stone",
		"default:desert_stone",
		"default:dirt",
		"everness:dirt_with_cursed_grass",
		"everness:cursed_dirt",
		"everness:cursed_stone",
		"everness:crystal_stone",
	},
	chance = 2200,
	active_object_count = 4,
	group_min = 1,
	group_max = 2,
	min_light = 0,
	max_light = 9,
	min_elevation = -31000,
	max_elevation = 100,
})
