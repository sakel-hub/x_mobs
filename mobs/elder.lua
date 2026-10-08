--[[
	x_mobs - Elder
	Stealth ambush mob in x_mobs.
	Creeps quietly towards the player without footstep sounds.
	Upon closing into proximity (<= 3.2m), the Elder stops, ignites with a sputtering
	fuse sound and comical gas puff, swells up with an accelerating white flash texture
	overlay, and detonates after a 2.2-second fuse.
	Tactical defusal: If the player retreats > 6.0m before detonation, the Elder defuses,
	resets its visual state, and resumes pursuit.
	Detonation carves a spherical crater via VoxelManip, checks for falling nodes,
	ejects scattered item drops, damages/knocks back players and entities, and spawns
	custom pixel art debris and shockwave effects.

	Author: SaKeL
]]

local S = core.get_translator("x_mobs")

-- Combat and detonation tuning
local FUSE_DURATION = 2.2
local IGNITE_DISTANCE = 3.2
local DEFUSE_DISTANCE = 6.0
local REENGAGE_DISTANCE = 6.0
local FLEE_RESUME_DISTANCE = 8.5
local BLAST_RADIUS = 3
local DAMAGE_RADIUS = 6
local AGGRO_RADIUS = 18.0

-- ============================================================================
-- NATIVE VOXEL DETONATION SYSTEM
-- Adapted from Minetest Game TNT mod (PilzAdam, ShadowNinja, sofar, and contributors)
-- Released under the MIT License (see LICENSE / license.txt for full terms).
-- Reimplemented natively for x_mobs Elder without external TNT dependencies.
-- ============================================================================

--- Appends an item to the explosion drops table, respecting item loss settings
---@param drops table<string, ItemStack> Aggregated drops map
---@param item ItemStack|string Item to add
local function add_drop(drops, item)
	local stack = ItemStack(item)
	local def = stack:get_definition()
	local lost = def and def._tnt_loss or 0
	if lost > 0 and (lost == 1 or math.random(1, lost) == 1) then
		return
	end

	local name = stack:get_name()
	local drop = drops[name]
	if drop == nil then
		drops[name] = stack
	else
		drop:set_count(drop:get_count() + stack:get_count())
	end
end

--- Calculates directional velocity impulse for entities struck by explosion
---@param pos1 Vector Blast epicenter
---@param pos2 Vector Entity position
---@param old_vel Vector Entity initial velocity
---@param power number Kinetic impulse power
---@return Vector Resulting velocity
local function calc_velocity(pos1, pos2, old_vel, power)
	if vector.equals(pos1, pos2) then
		return old_vel
	end

	local vel = vector.direction(pos1, pos2)
	vel = vector.normalize(vel)
	vel = vector.multiply(vel, power)

	local dist = math.max(1, vector.distance(pos1, pos2))
	vel = vector.divide(vel, dist)
	vel = vector.add(vel, old_vel)

	vel = vector.add(vel, {
		x = math.random() - 0.5,
		y = math.random() - 0.5,
		z = math.random() - 0.5,
	})

	local len = vector.length(vel)
	if len > 250 then
		vel = vector.divide(vel, len / 250)
	end
	return vel
end

--- Selects an empty adjacent space for ejected item drops
---@param center Vector Explosion center
---@param pos Vector Target position buffer
---@param radius number Blast radius
local function rand_drop_pos(center, pos, radius)
	local reg_nodes = core.registered_nodes
	local i = 0
	local def
	repeat
		pos.x = center.x + math.random(-radius, radius)
		pos.y = center.y + math.random(-radius, radius)
		pos.z = center.z + math.random(-radius, radius)
		local nname = core.get_node(pos).name
		def = reg_nodes[nname]
		i = i + 1
	until (def and not def.walkable) or i > 12
end

--- Ejects collected node drops with kinetic physical dispersion
---@param drops table<string, ItemStack> Collected item drops
---@param pos Vector Explosion epicenter
---@param radius number Blast radius
local function eject_drops(drops, pos, radius)
	local drop_pos = vector.new(pos)
	for _, item in pairs(drops) do
		local count = math.min(item:get_count(), item:get_stack_max())
		while count > 0 do
			local take = math.max(1, math.min(radius * radius, count, item:get_stack_max()))
			rand_drop_pos(pos, drop_pos, radius)
			local dropitem = ItemStack(item)
			dropitem:set_count(take)
			local obj = core.add_item(drop_pos, dropitem)
			if obj then
				local ent = obj:get_luaentity()
				if ent then
					ent.collect = true
				end
				obj:set_acceleration({x = 0, y = -10, z = 0})
				obj:set_velocity({
					x = math.random(-3, 3),
					y = math.random(1, 8),
					z = math.random(-3, 3),
				})
			end
			count = count - take
		end
	end
end

--- Destroys a node in the voxel buffer, enqueuing drops or flame creation
---@param drops table<string, ItemStack> Drops map
---@param npos Vector Target node position
---@param cid number Content ID in voxel data
---@param c_air number Air content ID
---@param c_fire number Fire content ID
---@param on_blast_queue table Queued on_blast callbacks
---@param on_construct_queue table Queued on_construct callbacks
---@param cid_data table<number, table> Cached node definitions
---@param flame_on_construct? function Fire construct callback
---@return number New content ID
local function destroy_node(drops, npos, cid, c_air, c_fire,
		on_blast_queue, on_construct_queue, cid_data, flame_on_construct)
	if core.is_protected(npos, "") then
		return cid
	end

	local def = cid_data[cid]
	if not def then
		return c_air
	elseif def.on_blast then
		on_blast_queue[#on_blast_queue + 1] = {
			pos = vector.new(npos),
			on_blast = def.on_blast,
		}
		return cid
	elseif def.flammable and flame_on_construct and c_fire ~= c_air then
		on_construct_queue[#on_construct_queue + 1] = {
			fn = flame_on_construct,
			pos = vector.new(npos),
		}
		return c_fire
	else
		local node_drops = core.get_node_drops(def.name, "")
		for i = 1, #node_drops do
			add_drop(drops, node_drops[i])
		end
		return c_air
	end
end

--- Applies kinetic shockwave and damage to nearby players and entities
---@param pos Vector Explosion epicenter
---@param radius number Blast damage radius
---@param drops table<string, ItemStack> Drops map
local function entity_physics(pos, radius, drops)
	local objs = core.get_objects_inside_radius(pos, radius)
	for i = 1, #objs do
		local obj = objs[i]
		if obj and obj:is_valid() then
			local obj_pos = obj:get_pos()
			if obj_pos then
				local dist = math.max(1.0, vector.distance(pos, obj_pos))
				local damage = math.floor((4.0 / dist) * radius * 3.5)

				if obj:is_player() then
					local dir = vector.normalize(vector.subtract(obj_pos, pos))
					if dir.x == 0 and dir.y == 0 and dir.z == 0 then
						dir = { x = 0, y = 1, z = 0 }
					end
					local moveoff = vector.multiply(dir, math.max(3.0, (5.0 / dist) * radius))
					moveoff.y = math.max(2.5, moveoff.y)

					if obj.add_player_velocity then
						obj:add_player_velocity(moveoff)
					elseif obj.add_velocity then
						obj:add_velocity(moveoff)
					end

					obj:punch(obj, 1.0, {
						full_punch_interval = 1.0,
						damage_groups = { fleshy = damage },
					}, dir)

					-- Concussion: blast shellshock, disorientation vignette, smoke envelop, FOV dip, tinnitus ringing
					x_mob_core.apply_status_effect(obj, {
						id = "concussion",
						type = "custom",
						duration = 3.5,
						speed_factor = 0.45,
						jump_factor = 0.5,
						fov_factor = 0.85,
						fov_duration = 0.8,
						fov_transition = 0.2,
						envelop_texture = "x_mobs_smoke_envelop.png",
						hud_vignette = "x_mob_core_vignette.png^[colorize:#ffffff77",
						on_apply = function(target)
							if target:is_player() then
								core.sound_play("x_mobs_elder_fuse", {
									to_player = target:get_player_name(),
									gain = 0.7,
									pitch = 2.0,
								})
							end
						end,
					})
				else
					local is_attached = obj.get_attach and obj:get_attach() ~= nil
					local luaobj = not is_attached and obj:get_luaentity()
					if luaobj then
						local do_damage = true
						local do_knockback = true
						local entity_drops = {}
						local objdef = core.registered_entities[luaobj.name]

						if objdef and objdef.on_blast then
							do_damage, do_knockback, entity_drops = objdef.on_blast(luaobj, damage)
						end

						if do_knockback then
							local obj_vel = obj:get_velocity() or {x = 0, y = 0, z = 0}
							obj:set_velocity(calc_velocity(pos, obj_pos, obj_vel, radius * 8))
						end

						if do_damage then
							local armors = obj:get_armor_groups()
							if not armors or not armors.immortal then
								obj:punch(obj, 1.0, {
									full_punch_interval = 1.0,
									damage_groups = { fleshy = damage },
								}, nil)

								x_mob_core.apply_status_effect(obj, {
									id = "concussion",
									type = "custom",
									duration = 3.5,
									speed_factor = 0.45,
									jump_factor = 0.5,
									envelop_texture = "x_mobs_smoke_envelop.png",
								})
							end
						end

						for j = 1, #entity_drops do
							add_drop(drops, entity_drops[j])
						end
					end
				end
			end
		end
	end
end

--- Executes complete spherical voxel crater carving, item ejection, and physics blast
---@param pos Vector Explosion epicenter
---@param blast_radius number Node destruction radius
---@param damage_radius number Entity damage radius
local function execute_elder_explosion(pos, blast_radius, damage_radius)
	pos = vector.round(pos)
	local radius = blast_radius or BLAST_RADIUS
	local dmg_radius = damage_radius or DAMAGE_RADIUS

	-- Spatial audio playback
	core.sound_play("x_mobs_elder_explode", {
		pos = pos,
		gain = 2.0,
		max_hear_distance = 64.0,
	}, true)

	local vm = VoxelManip()
	local pr = PseudoRandom(os.time())
	local p1 = vector.subtract(pos, radius)
	local p2 = vector.add(pos, radius)
	local minp, maxp = vm:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	local drops = {}
	local on_blast_queue = {}
	local on_construct_queue = {}

	local flame_def = core.registered_nodes["fire:basic_flame"]
	local flame_on_construct = flame_def and flame_def.on_construct
	local c_fire = flame_def and core.get_content_id("fire:basic_flame") or core.CONTENT_AIR
	local c_air = core.CONTENT_AIR
	local c_ignore = core.CONTENT_IGNORE

	-- Cache node definitions by content ID for efficient lookups
	local cid_data = {}
	for name, def in pairs(core.registered_nodes) do
		local id = core.get_content_id(name)
		cid_data[id] = def
	end

	-- Map metadata locations
	local has_meta = {}
	local meta_nodes = core.find_nodes_with_meta(p1, p2)
	for i = 1, #meta_nodes do
		has_meta[a:indexp(meta_nodes[i])] = true
	end

	-- Spherical crater carving with natural roughness
	local rad_sq = radius * radius
	for z = -radius, radius do
		for y = -radius, radius do
			local vi = a:index(pos.x - radius, pos.y + y, pos.z + z)
			for x = -radius, radius do
				local r_sq = x * x + y * y + z * z
				if r_sq == 0 or (rad_sq / r_sq) >= (pr:next(80, 125) / 100) then
					local cid = data[vi]
					if cid ~= c_air and cid ~= c_ignore then
						local p = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
						local new_cid = destroy_node(drops, p, cid, c_air, c_fire,
							on_blast_queue, on_construct_queue, cid_data, flame_on_construct)

						if new_cid ~= data[vi] then
							data[vi] = new_cid
							if has_meta[vi] then
								core.get_meta(p):from_table(nil)
							end
						end
					end
				end
				vi = vi + 1
			end
		end
	end

	vm:set_data(data)
	vm:write_to_map()
	vm:update_liquids()
	if vm.close ~= nil then
		vm:close()
	end

	-- Check single for falling sand/gravel within 1.4x blast radius
	local r_fall = math.ceil(radius * 1.4)
	for y = -r_fall, r_fall do
		for z = -r_fall, r_fall do
			for x = -r_fall, r_fall do
				local r_dist = math.sqrt(x * x + y * y + z * z)
				if (r_dist / radius) < 1.4 then
					core.check_single_for_falling({x = pos.x + x, y = pos.y + y, z = pos.z + z})
				end
			end
		end
	end

	-- Trigger custom on_blast node callbacks
	for i = 1, #on_blast_queue do
		local queued = on_blast_queue[i]
		local dist = math.max(1, vector.distance(queued.pos, pos))
		local intensity = rad_sq / (dist * dist)
		local node_drops = queued.on_blast(queued.pos, intensity)
		if node_drops then
			for j = 1, #node_drops do
				add_drop(drops, node_drops[j])
			end
		end
	end

	-- Trigger queued fire placement callbacks
	for i = 1, #on_construct_queue do
		on_construct_queue[i].fn(on_construct_queue[i].pos)
	end

	-- Damage and knockback
	entity_physics(pos, dmg_radius, drops)

	-- Eject harvested blocks
	eject_drops(drops, pos, radius)

	-- Visual debris, smoke, and shockwave effects
	x_mobs.spawn_elder_explode(pos, radius)
end

-- ============================================================================
-- MOB REGISTRATION: ELDER
-- ============================================================================

x_mob_core.register_mob("x_mobs:elder", {
	initial_properties = {
		hp_max = 24,
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		selectionbox = {-0.35, 0.0, -0.35, 0.35, 1.75, 0.35},
		visual = "mesh",
		mesh = "x_mobs_elder.glb",
		textures = {
			"x_mobs_elder.png",
		},
		visual_size = {x = 1.0, y = 1.0},
		makes_footstep_sound = false,
		infotext = S("Elder"),
		backface_culling = false,
	},

	armor_groups = { fleshy = 100 },
	knockback_mult = 1.0,
	factions = { "monster", "hostile", "elder" },
	mob_height = 1.7,
	eye_offset = 1.47,
	makes_footstep_sound = false,
	walk_speed = 2.4,
	wander_speed = 1.6,
	pursuit_speed = 3.2,
	aggro_radius = AGGRO_RADIUS,
	attack_range = IGNITE_DISTANCE,

	drops = {
		{ name = "default:stick",     min = 1, max = 2, chance = 0.60 },
		{ name = "default:coal_lump", min = 1, max = 2, chance = 0.40 },
		{ name = "default:paper",     min = 1, max = 2, chance = 0.50 },
		{ name = "default:flint",     min = 1, max = 1, chance = 0.30 },
	},

	sounds = {
		base = "x_mobs_elder",
		distance = 24.0,
		gain = 1.0,
		pitch_jitter = 0.05,
		hurt = "x_mobs_elder_hurt",
		death = "x_mobs_elder_hurt",
		random = "x_mobs_elder_idle",
	},

	animations = {
		idle    = { track = "idle",    speed = 1.0, loop = true },
		walk    = { track = "walk",    speed = 1.0, loop = true },
		run     = { track = "walk",    speed = 1.25, loop = true },
		hurt    = { track = "hurt",    speed = 1.0, loop = false },
		death   = { track = "death",   speed = 1.0, loop = false },
		explode = { track = "explode", speed = 1.0, loop = false },
	},

	--- Damage reaction callback
	---@param puncher? ObjectRef Attacker reference
	---@param _dmg number Damage dealt
	on_hurt = function(self, puncher, _dmg)
		if puncher and puncher:is_valid() then
			self.target = puncher
			x_mob_core.broadcast_threat(self, puncher, 24.0)
		end
		if self.state == "flinching" and self.state ~= "igniting" then
			x_mob_core.halt_horizontal_velocity(self)
		end
		local pos = self.object:get_pos()
		if pos then
			x_mobs.spawn_elder_hurt(pos)
		end
	end,

	--- Death callback when slain before detonating
	---@param _killer? ObjectRef Slaying entity or player
	on_death = function(self, _killer)
		-- Restore default texture overlay upon death
		if self.object and self.object:is_valid() then
			self.object:set_properties({
				textures = {"x_mobs_elder.png"}
			})
			local pos = self.object:get_pos()
			if pos then
				x_mobs.spawn_elder_death(pos)
			end
		end
	end,

	--- Stepped behavior update: quiet stalking, ignition countdown, accelerating white flash, and detonation
	---@param dtime number Delta time in seconds
	on_step = function(self, dtime)
		local pos = self.object:get_pos()
		if not pos then return end

		-- Defensive flinch stun: let hurt animation play if not in ignition
		if self.state == "flinching" and self.state ~= "igniting" then
			return
		end

		-- ====================================================================
		-- 1. IGNITION & DETONATION COUNTDOWN STATE
		-- ====================================================================
		if self.state == "igniting" then
			self.fuse_timer = (self.fuse_timer or 0) + dtime
			self.fuse_particle_timer = (self.fuse_particle_timer or 0) + dtime

			-- Check if target player escaped beyond defusal threshold
			local defused = false
			if not self.target or not x_mob_core.is_player_alive(self.target) then
				defused = true
			else
				local tpos = self.target:get_pos()
				if not tpos or vector.distance(pos, tpos) > DEFUSE_DISTANCE then
					defused = true
				end
			end

			if defused then
				-- Tactical defusal: reset visual overlay and resume stalk
				self.state = "walk"
				self.fuse_timer = 0
				self.fuse_particle_timer = 0
				self.is_ignited = false
				self.object:set_properties({
					textures = {"x_mobs_elder.png"}
				})
				x_mob_core.play_animation(self.object, "walk", { speed = 1.0, loop = true })
				return
			end

			-- Face target while hissing and expanding
			if self.target and self.target:is_valid() then
				local tpos = self.target:get_pos()
				if tpos then
					local to_target = vector.direction(pos, tpos)
					to_target.y = 0
					local tlen = math.sqrt(to_target.x * to_target.x + to_target.z * to_target.z)
					if tlen > 0.01 then
						to_target = { x = to_target.x / tlen, y = 0, z = to_target.z / tlen }
						local face_yaw = core.dir_to_yaw(to_target)
						self.object:set_yaw(face_yaw)
						self._cur_rot = { x = 0, y = face_yaw, z = 0 }
					end
				end
			end

			-- Accelerating white flash texture overlay
			local progress = math.min(1.0, self.fuse_timer / FUSE_DURATION)
			local freq = 3.0 + progress * 10.0
			local flash_phase = math.sin(self.fuse_timer * freq * math.pi * 2)
			if flash_phase > 0.0 then
				local alpha = math.floor(flash_phase * 220)
				self.object:set_properties({
					textures = {"x_mobs_elder.png^[colorize:#ffffff:" .. alpha}
				})
			else
				self.object:set_properties({
					textures = {"x_mobs_elder.png"}
				})
			end

			-- Sputtering fuse sparks and sulfur smoke wisps
			if self.fuse_particle_timer >= 0.08 then
				self.fuse_particle_timer = 0
				x_mobs.spawn_elder_fuse(pos, 1.0)
			end

			-- Detonation execution at fuse expiration
			if self.fuse_timer >= FUSE_DURATION then
				execute_elder_explosion(pos, BLAST_RADIUS, DAMAGE_RADIUS)
				self.object:remove()
				return
			end

			-- Halt movement while igniting
			x_mob_core.halt_horizontal_velocity(self)
			return
		end

		-- ====================================================================
		-- 2. TARGET ACQUISITION & STEALTH STALKING
		-- ====================================================================
		if not self.target or not x_mob_core.is_player_alive(self.target) then
			self.target = nil
			local player = x_mob_core.scan_for_player(self, self.aggro_radius or AGGRO_RADIUS)
			if player then
				x_mob_core.set_target(self, player)
				x_mob_core.broadcast_threat(self, player, 24.0)
			else
				x_mob_core.step_wander_or_idle(self, dtime, "walk", "idle")
				return
			end
		end

		local tpos = self.target:get_pos()
		if not tpos then
			self.target = nil
			return
		end

		local dist = vector.distance(pos, tpos)

		-- Tactical low-HP retreat and re-engagement:
		-- 1. When critically low on HP, allow the elder to retreat and gain distance first.
		-- 2. Once distance is established (>= 8.5m), if the player pursues and closes in again (<= 6.0m),
		--    the elder turns around to stalk and detonate.
		-- 3. If trapped/cornered for > 2.0s without being able to escape, turn and detonate defensively.
		local is_fleeing_mode = (self.state == "fleeing" or self.state == "flee") or
			(self.memory and self.memory.flee_state)

		if is_fleeing_mode then
			if dist >= FLEE_RESUME_DISTANCE then
				self._has_escaped = true
			end
			self._flee_duration = (self._flee_duration or 0) + dtime

			local is_cornered = (self._flee_duration >= 2.0 and dist <= REENGAGE_DISTANCE) or
				(self._flee_stagnant_timer and self._flee_stagnant_timer > 0.5)
			local player_caught_up = self._has_escaped and dist <= REENGAGE_DISTANCE

			if (player_caught_up or is_cornered) and (self.state == "fleeing" or self.state == "flee") then
				self.state = "walk"
			elseif dist > FLEE_RESUME_DISTANCE and self.state == "walk" then
				-- Resume tactical retreat if player retreats and elder is still low on HP
				self.state = "fleeing"
			end
		else
			self._has_escaped = nil
			self._flee_duration = nil
		end

		-- Proximity trigger: ignite when closing within 3.2 meters
		if dist <= IGNITE_DISTANCE then
			self.state = "igniting"
			self.fuse_timer = 0
			self.fuse_particle_timer = 0
			self.is_ignited = true

			x_mob_core.halt_horizontal_velocity(self)
			x_mob_core.play_animation(self.object, "explode", { speed = 1.0, loop = false, force = true })

			core.sound_play("x_mobs_elder_ignite", {
				pos = pos,
				gain = 1.2,
				max_hear_distance = 32.0,
			}, true)
			return
		end

		-- Silent stealth stalk: advance toward player without footsteps
		x_mob_core.step_move_or_idle(self, dtime, "walk", 1.0, "idle")
	end,
})

-- ============================================================================
-- NATURAL SPAWNING REGISTRATION (Solitary Cavern & Dark Wilderness Stalker)
-- ============================================================================

x_mob_core.register_spawn("x_mobs:elder", {
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
	chance = 8000,
	active_object_count = 2,
	group_min = 1,
	group_max = 1,
	min_light = 0,
	max_light = 9,
	min_elevation = -31000,
	max_elevation = 31000,
})
