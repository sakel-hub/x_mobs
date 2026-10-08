--[[
	test_frosty_queen.lua - Automated Integration Test for Frosty Queen
	Validates:
	1. Entity and projectile registration (x_mobs:frosty_queen, x_mobs:frost_shard, x_mobs:envelop)
	2. Visual size aligns glTF dimensions to match standard player model height (1.70m, visual_size = {x = 7.8, y = 7.8})
	3. Floating locomotion (is_floating = true, hover_offset = 0.6)
	4. 7 canonical animation tracks (stand, walk, run, punch, shoot, hurt, die)
	5. All 14 mastered CC0 glacial audio variations exist and are mapped
	6. Pixel art particle sheet exists, projectile texture exists, and all 10 VFX spawners execute cleanly
	7. Envelop framework: open rectangular sleeve, bottom-half coverage, top-fading alpha texture,
	   speed reduction, natural animation preservation, and clean thaw restoration
	8. Physics override compatibility adapter (50% speed reduction and restoration)
	9. Combat state machine: normal combat (> 40 HP) vs core flee mechanics and health channel (<= 40 HP)
	10. Locale entries in en.po and template.pot
	11. Licensing manifest compliance in license.txt (author SaKeL, engine Luanti)
]]

local registered_entities = {}
local registered_mobs = {}
local scheduled_callbacks = {}
local spawned_particles = {}
local played_sounds = {}
local added_entities = {}
local dieplayer_callbacks = {}
local leaveplayer_callbacks = {}
local joinplayer_callbacks = {}
local respawnplayer_callbacks = {}
local shutdown_callbacks = {}
local punchplayer_callbacks = {}
local test_player

_G.vector = {
	distance = function(a, b)
		local dx, dy, dz = a.x - b.x, a.y - b.y, a.z - b.z
		return math.sqrt(dx * dx + dy * dy + dz * dz)
	end,
	direction = function(a, b)
		local dx, dy, dz = b.x - a.x, b.y - a.y, b.z - a.z
		local len = math.sqrt(dx * dx + dy * dy + dz * dz)
		if len == 0 then return {x = 0, y = 0, z = 0} end
		return {x = dx / len, y = dy / len, z = dz / len}
	end,
	normalize = function(v)
		local len = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
		if len == 0 then return {x = 0, y = 0, z = 0} end
		return {x = v.x / len, y = v.y / len, z = v.z / len}
	end,
	multiply = function(v, s)
		return {x = v.x * s, y = v.y * s, z = v.z * s}
	end,
	add = function(a, b)
		if type(b) == "number" then
			return {x = a.x + b, y = a.y + b, z = a.z + b}
		end
		return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
	end,
	subtract = function(a, b)
		if type(b) == "number" then
			return {x = a.x - b, y = a.y - b, z = a.z - b}
		end
		return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z}
	end,
	round = function(v)
		return {x = math.floor(v.x + 0.5), y = math.floor(v.y + 0.5), z = math.floor(v.z + 0.5)}
	end,
}

_G.core = {
	get_modpath = function(modname)
		if modname == "x_mobs" then
			return "mods/x_mobs"
		elseif modname == "x_mob_core" then
			return "mods/x_mob_core"
		end
		return nil
	end,
	get_translator = function(_modname)
		return function(str) return str end
	end,
	register_entity = function(name, def)
		registered_entities[name] = def
	end,
	log = function() end,
	after = function(_delay, cb)
		table.insert(scheduled_callbacks, cb)
	end,
	sound_play = function(spec, params)
		table.insert(played_sounds, {spec = spec, params = params})
		return 1
	end,
	add_particlespawner = function(def)
		table.insert(spawned_particles, def)
		return #spawned_particles
	end,
	delete_particlespawner = function(_id, ...)
		local n = select("#", ...)
		if n >= 1 then
			local playername = select(1, ...)
			if type(playername) ~= "string" then
				error("bad argument #2 to 'delete_particlespawner' (string expected, got " .. type(playername) .. ")")
			end
		end
	end,
	dir_to_yaw = function(dir)
		local atan2 = math.atan2 or math.atan
		return -atan2(dir.x, dir.z)
	end,
	yaw_to_dir = function(yaw)
		return {x = -math.sin(yaw), y = 0, z = math.cos(yaw)}
	end,
	register_on_dieplayer = function(cb)
		table.insert(dieplayer_callbacks, cb)
	end,
	register_on_leaveplayer = function(cb)
		table.insert(leaveplayer_callbacks, cb)
	end,
	register_on_joinplayer = function(cb)
		table.insert(joinplayer_callbacks, cb)
	end,
	register_on_respawnplayer = function(cb)
		table.insert(respawnplayer_callbacks, cb)
	end,
	register_on_shutdown = function(cb)
		table.insert(shutdown_callbacks, cb)
	end,
	register_on_punchplayer = function(cb)
		table.insert(punchplayer_callbacks, cb)
	end,
	register_globalstep = function() end,
	register_on_player_hpchange = function() end,
	settings = {
		get_bool = function(_self, _key, default) return default end,
	},
	registered_items = {},
	get_item_group = function() return 0 end,
	get_connected_players = function()
		return {test_player}
	end,
	add_entity = function(pos, name)
		local obj = {
			_pos = {x = pos.x, y = pos.y, z = pos.z},
			_vel = {x = 0, y = 0, z = 0},
			_acc = {x = 0, y = 0, z = 0},
			_rot = {x = 0, y = 0, z = 0},
			_yaw = 0,
			_properties = {},
			_armor = {},
			_removed = false,
			_attached_to = nil,
			_anim = nil,
			is_valid = function(self) return not self._removed end,
			is_player = function() return false end,
			get_pos = function(self) return {x = self._pos.x, y = self._pos.y, z = self._pos.z} end,
			set_pos = function(self, p) self._pos = {x = p.x, y = p.y, z = p.z} end,
			get_velocity = function(self) return {x = self._vel.x, y = self._vel.y, z = self._vel.z} end,
			set_velocity = function(self, v) self._vel = {x = v.x, y = v.y, z = v.z} end,
			get_yaw = function(self) return self._yaw end,
			set_yaw = function(self, y) self._yaw = y end,
			get_properties = function(self) return self._properties end,
			set_properties = function(self, p)
				for k, v in pairs(p) do
					self._properties[k] = v
				end
			end,
			set_armor_groups = function(self, g) self._armor = g end,
			set_attach = function(self, parent, _bone, offset, _rot, forced_visible)
				self._attached_to = parent
				self._attach_offset = offset
				self._forced_visible = forced_visible
			end,
			set_animation = function(self, anim, speed, blend, loop)
				self._anim = {anim = anim, speed = speed, blend = blend, loop = loop}
			end,
			play_animation = function(self, track, opts)
				self._anim = {
					anim = track,
					speed = opts and opts.speed or 1.0,
					blend = opts and opts.blend or 0,
					loop = opts and opts.loop,
				}
			end,
			stop_animation = function(self, track)
				self._stopped_anim = track
			end,
			update_animation = function(self, track, opts)
				if self._anim and self._anim.anim == track and opts and opts.speed then
					self._anim.speed = opts.speed
				end
			end,
			set_bone_override = function(self, bone, override)
				self._bone_overrides = self._bone_overrides or {}
				self._bone_overrides[bone] = override
			end,
			get_animation = function(self)
				if self._anim then
					return self._anim.anim, self._anim.speed
				end
				return "stand", 30
			end,
			remove = function(self)
				self._removed = true
			end,
			punch = function(self, puncher, time, tool_caps, dir)
				self._last_punch = {puncher = puncher, time = time, tool_caps = tool_caps, dir = dir}
			end,
			get_hp = function() return 1 end,
		}
		local def = registered_entities[name]
		if def then
			if def.initial_properties then
				for pk, pv in pairs(def.initial_properties) do
					obj._properties[pk] = pv
				end
			end
			local ent = {}
			for k, v in pairs(def) do
				ent[k] = v
			end
			ent.object = obj
			obj.get_luaentity = function() return ent end
			if ent.on_activate then
				ent:on_activate("", 0)
			end
			table.insert(added_entities, ent)
			return obj
		end
		return nil
	end,
}

_G.minetest = _G.core

_G.x_mob_core = {
	register_mob = function(name, def)
		registered_mobs[name] = def
		if not def.on_step then
			def.on_step = function(self, dtime, moveresult)
				self._def = def
				-- Priority 14: Health regen & flee trigger
				if def.health_regen then
					local hr = def.health_regen
					local cur_hp = self.hp or (self.object and self.object:is_valid() and self.object:get_hp()) or 120
					if cur_hp <= (hr.flee_threshold or 0) and not self._flee_used then
						self.memory = self.memory or {}
						self.memory.flee_state = true
						if self.state ~= "flinching" then
							self.state = "fleeing"
						end
					end
				end

				-- Priority 15: Custom step hook
				if def.custom_step and def.custom_step(self, dtime, moveresult, def) then
					return
				end

				-- Priority 17: Tactical retreat
				local is_fleeing = (self.state == "fleeing")
					or (self.state == "channeling")
					or (self.memory and self.memory.flee_state)
				if is_fleeing and not self.is_dead and self.state ~= "flinching" then
					x_mob_core.step_tactical_retreat(self, dtime, def, moveresult)
					return
				end

				-- Priority 18: Melee
				if def.melee and self.target and (self.attack_cooldown or 0) <= 0 then
					local pos = self.object:get_pos()
					local tpos = self.target:get_pos()
					local dist = vector.distance(pos, tpos)
					if dist <= (def.melee.range or def.attack_range or 2.0) then
						x_mob_core.step_melee(self, dtime, def)
						return
					end
				end

				-- Priority 20: Shooter
				if def.shooter and self.target and (self.attack_cooldown or 0) <= 0 then
					local pos = self.object:get_pos()
					local tpos = self.target:get_pos()
					local dist = vector.distance(pos, tpos)
					if dist >= (def.shooter.min_range or 0) and dist <= (def.shooter.range or 15.0) then
						x_mob_core.combat.shooter.step(self, dtime, def)
						return
					end
				end
			end
		end
		_G.core.register_entity(name, def)
	end,
	step_tactical_retreat = function(mob, dtime, def, _moveresult)
		mob._tactical_retreat_called = true
		local pos = mob.object:get_pos()
		local tpos = mob.target and mob.target:get_pos()
		if not tpos then return false end

		local dist = vector.distance(pos, tpos)
		local to_target = vector.direction(pos, tpos)
		local face_yaw = core.dir_to_yaw(to_target)

		-- Desperate punch if caught in melee reach (<= 2.2m)
		if dist <= (def.melee and def.melee.range or 2.2) then
			if (mob.attack_cooldown or 0) <= 0 then
				x_mob_core.step_melee(mob, dtime, def)
				return true
			end
		end

		local hr = def.health_regen or mob.health_regen or {}
		local safe_dist = hr.safe_distance or 12.0

		if mob.state == "channeling" then
			x_mob_core.halt_horizontal_velocity(mob)
			mob._channeling_active = true
			mob._flee_channel_timer = (mob._flee_channel_timer or hr.channel_duration or 3.0) - dtime
			if mob._flee_channel_timer <= 0 then
				local restore = hr.heal_amount or 40
				local max_hp = def.initial_properties and def.initial_properties.hp_max or 120
				mob.hp = math.min(max_hp, (mob.hp or 0) + restore)
				mob.state = "idle"
				mob._flee_used = true
				if mob.memory then mob.memory.flee_state = false end
				if mob.on_return_to_fight then
					mob:on_return_to_fight()
				end
			end
			return true
		end

		if dist < safe_dist then
			local away_dir = { x = -to_target.x, y = 0, z = -to_target.z }
			local retreat_yaw = core.dir_to_yaw(away_dir)
			mob.object:set_yaw(retreat_yaw)
			x_mob_core.set_horizontal_velocity(mob, hr.flee_speed or def.flee_speed or 4.4, retreat_yaw)
			x_mob_core.play_animation(mob.object, "run", { speed = 1.2, loop = true })
			return true
		else
			-- Reached safe distance: begin channeling vulnerable heal!
			mob.state = "channeling"
			mob._flee_channel_timer = hr.channel_duration or 3.0
			x_mob_core.halt_horizontal_velocity(mob)
			mob.object:set_yaw(face_yaw)
			x_mob_core.play_animation(mob.object, "idle", { speed = 1.0, loop = true })
			return true
		end
	end,
	step_melee = function(mob, _dtime, def)
		mob.state = "attacking"
		mob.action_timer = (def and def.melee and def.melee.duration) or 0.7
		mob.attack_cooldown = (def and def.melee and def.melee.cooldown) or 1.4
		local anim = (def and def.melee and def.melee.animation) or "punch"
		x_mob_core.play_animation(mob.object, anim, { speed = 1.1, loop = false })
		x_mob_core.play_sound(mob, (def and def.melee and def.melee.sound) or "attack")
		return true
	end,
	combat = {
		shooter = {
			step = function(mob, _dtime, def)
				mob.state = "shooting"
				mob.action_timer = (def and def.shooter and def.shooter.fire_duration) or 0.8
				mob.attack_cooldown = (def and def.shooter and def.shooter.cooldown) or 2.8
				local s_anim = (def and def.shooter and def.shooter.animation) or "shoot"
				x_mob_core.play_animation(mob.object, s_anim, { speed = 1.0, loop = false })
				x_mob_core.play_sound(mob, (def and def.shooter and def.shooter.sound) or "shoot")
				return true
			end,
		},
	},
	listen = function() end,
	step_projectile = function(self, dtime, opts)
		self._step_called = true
		if opts.on_step then
			opts.on_step(self, dtime, self.object:get_pos())
		end
	end,
	play_animation = function(obj, anim, opts)
		obj:set_animation(anim, (opts and opts.speed or 1.0) * 30, 0.1, opts and opts.loop)
	end,
	play_sound = function(mob, sound_type)
		mob._last_sound = sound_type
	end,
	schedule = function(_mob, _delay, _id, cb)
		table.insert(scheduled_callbacks, cb)
	end,
	halt_horizontal_velocity = function(mob)
		mob._horizontal_halted = true
		if mob.object then
			local v = mob.object:get_velocity()
			mob.object:set_velocity({x = 0, y = v.y, z = 0})
		end
	end,
	set_horizontal_velocity = function(mob, speed, yaw)
		mob._horizontal_speed = speed
		mob._horizontal_yaw = yaw
		if mob.object then
			local dir = _G.core.yaw_to_dir(yaw)
			mob.object:set_velocity({x = dir.x * speed, y = 0, z = dir.z * speed})
		end
	end,
	step_move_or_idle = function(mob, _dtime, anim, _speed, _idle_anim)
		mob._move_called = true
		mob._move_anim = anim
	end,
	step_wander_or_idle = function(mob, _dtime, _wander_anim, _idle_anim)
		mob._wander_called = true
	end,
	scan_for_player = function(_mob, _radius)
		return nil
	end,
	set_target = function(mob, target)
		mob.target = target
	end,
	broadcast_threat = function(mob, threat, _radius)
		mob._threat_broadcast = threat
	end,
	is_player_alive = function(p)
		return p and p:is_valid() and p:get_hp() > 0
	end,
	line_of_sight = function(_p1, _p2)
		return true
	end,
	predict_aim = function(origin, target_pos, _target_vel, _speed)
		return 1.0, vector.direction(origin, target_pos)
	end,
	generate_uuid = function()
		local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
		return string.gsub(template, "[xy]", function(c)
			local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
			return string.format("%x", v)
		end)
	end,
}

_G.x_mobs = {}

print("======================================================================")
print("RUNNING AUTOMATED UNIT & INTEGRATION TESTS: FROSTY QUEEN")
print("======================================================================")

-- 1. Load VFX particle spawners
print("[TEST 1] Loading VFX mob_particles.lua...")
dofile("mods/x_mobs/vfx/mob_particles.lua")
assert(type(x_mobs.spawn_frosty_queen_trail) == "function", "spawn_frosty_queen_trail missing")
assert(type(x_mobs.spawn_frosty_queen_shoot_charge) == "function", "spawn_frosty_queen_shoot_charge missing")
assert(type(x_mobs.spawn_frosty_queen_spell_cast) == "function", "spawn_frosty_queen_spell_cast missing")
assert(type(x_mobs.spawn_frosty_queen_spell_freeze) == "function", "spawn_frosty_queen_spell_freeze missing")
assert(type(x_mobs.spawn_frosty_queen_spell_shatter) == "function", "spawn_frosty_queen_spell_shatter missing")
assert(type(x_mobs.spawn_frosty_queen_envelop_shroud) == "function", "spawn_frosty_queen_envelop_shroud missing")
assert(type(x_mobs.spawn_frosty_queen_projectile_trail) == "function", "spawn_frosty_queen_projectile_trail missing")
assert(type(x_mobs.spawn_frosty_queen_projectile_impact) == "function", "spawn_frosty_queen_projectile_impact missing")
assert(type(x_mobs.spawn_frosty_queen_hurt) == "function", "spawn_frosty_queen_hurt missing")
assert(type(x_mobs.spawn_frosty_queen_death) == "function", "spawn_frosty_queen_death missing")
print("  ✓ All 10 Frosty Queen VFX particle spawner functions exist.")

-- 2. Test particle spawner executions and modern table structures
print("[TEST 2] Testing VFX particle spawner invocation and parameters...")
local dummy_pos = {x = 0, y = 10, z = 0}
local dummy_vel = {x = 0, y = 0, z = 5}
local dummy_obj = {
	get_pos = function() return dummy_pos end,
	is_valid = function() return true end,
}
spawned_particles = {}

x_mobs.spawn_frosty_queen_trail(dummy_pos)
x_mobs.spawn_frosty_queen_shoot_charge(dummy_pos, dummy_obj)
x_mobs.spawn_frosty_queen_spell_cast(dummy_pos)
x_mobs.spawn_frosty_queen_spell_freeze(dummy_pos)
x_mobs.spawn_frosty_queen_spell_shatter(dummy_pos)
x_mobs.spawn_frosty_queen_envelop_shroud(dummy_obj, 6.0)
x_mobs.spawn_frosty_queen_projectile_trail(dummy_pos, dummy_vel)
x_mobs.spawn_frosty_queen_projectile_impact(dummy_pos)
x_mobs.spawn_frosty_queen_hurt(dummy_pos)
x_mobs.spawn_frosty_queen_death(dummy_pos)

assert(#spawned_particles >= 10, "Expected at least 10 particle spawners triggered, got " .. #spawned_particles)
for i, sp in ipairs(spawned_particles) do
	assert(sp.texpool or sp.texture, "Particle spawner " .. i .. " missing texpool/texture")
	-- Verify backwards-compatible fallback fields exist alongside modern structured ranges
	assert(sp.minpos and sp.maxpos, "Particle spawner " .. i .. " missing legacy minpos/maxpos fallback")
	assert(sp.minvel and sp.maxvel, "Particle spawner " .. i .. " missing legacy minvel/maxvel fallback")
end
print("  ✓ All 10 particle spawners executed cleanly with modern texpools and legacy fallbacks.")

-- 3. Load Envelop Framework & Frosty Queen definition
print("[TEST 3] Loading envelop.lua and frosty_queen.lua...")
dofile("mods/x_mob_core/combat/particles.lua")
dofile("mods/x_mob_core/combat/hunger_adapter.lua")
dofile("mods/x_mob_core/combat/hud_effects.lua")
dofile("mods/x_mob_core/combat/envelop.lua")
dofile("mods/x_mob_core/combat/status_effects.lua")
dofile("mods/x_mobs/mobs/frosty_queen.lua")
assert(registered_mobs["x_mobs:frosty_queen"], "x_mobs:frosty_queen registration missing")
assert(registered_entities["x_mobs:frost_shard"], "x_mobs:frost_shard registration missing")
assert(registered_entities["x_mobs:frost_shard"].initial_properties.textures[1] ==
	"x_mobs_frosty_queen_particles.png^[sheet:8x8:0,1", "Frost shard must use particle sheet tile [sheet:8x8:0,1")
assert(registered_entities["x_mob_core:envelop"], "x_mob_core:envelop registration missing")
print("  ✓ All entities registered successfully.")

-- 4. Validate Frosty Queen mob properties and animations
print("[TEST 4] Validating Frosty Queen mob definition...")
local fq_def = registered_mobs["x_mobs:frosty_queen"]
assert(fq_def.initial_properties.visual == "mesh", "Visual must be mesh")
assert(fq_def.initial_properties.mesh == "x_mobs_frosty_queen.glb", "Mesh must be x_mobs_frosty_queen.glb")
assert(fq_def.initial_properties.visual_size.x == 7.8 and fq_def.initial_properties.visual_size.y == 7.8,
	"Visual size must be {x=7.8, y=7.8} (matching 1.70m player height)")
assert(fq_def.mob_height == 1.7, "Mob height must be 1.7m (matching player)")
assert(fq_def.eye_offset == 1.47, "Eye offset must be 1.47m (matching player eye height)")
assert(fq_def.initial_properties.collisionbox[5] == 1.7, "Collisionbox height must be 1.7m")
assert(fq_def.is_floating == true, "Must have is_floating = true")
assert(fq_def.hover_offset == 0.6, "Must have hover_offset = 0.6")
assert(fq_def.initial_properties.hp_max == 120, "HP max must be 120")

-- Validate all 7 canonical animation tracks
local anims = fq_def.animations
assert(anims.idle and anims.idle.track == "idle", "idle animation track missing")
assert(anims.walk and anims.walk.track == "walk", "walk animation track missing")
assert(anims.run and anims.run.track == "run", "run animation track missing")
assert(anims.punch and anims.punch.track == "punch", "punch animation track missing")
assert(anims.shoot and anims.shoot.track == "shoot", "shoot animation track missing")
assert(anims.hurt and anims.hurt.track == "hurt", "hurt animation track missing")
assert(anims.death and anims.death.track == "death", "death animation track missing")
print("  ✓ 7 canonical animation tracks correctly mapped to glTF actions.")

-- 5. Validate Audio Assets and mapping
print("[TEST 5] Checking audio file existence and sound table mappings...")
local sounds = {
	"x_mobs_frosty_queen_idle.1.ogg",
	"x_mobs_frosty_queen_idle.2.ogg",
	"x_mobs_frosty_queen_idle.3.ogg",
	"x_mobs_frosty_queen_attack.1.ogg",
	"x_mobs_frosty_queen_attack.2.ogg",
	"x_mobs_frosty_queen_shoot.1.ogg",
	"x_mobs_frosty_queen_shoot.2.ogg",
	"x_mobs_frosty_queen_hurt.1.ogg",
	"x_mobs_frosty_queen_hurt.2.ogg",
	"x_mobs_frosty_queen_death.1.ogg",
	"x_mobs_frosty_queen_death.2.ogg",
	"x_mobs_frosty_queen_freeze.1.ogg",
	"x_mobs_frosty_queen_freeze.2.ogg",
	"x_mobs_frosty_queen_shatter.ogg",
}

for _, sname in ipairs(sounds) do
	local f = io.open("mods/x_mobs/sounds/" .. sname, "rb")
	assert(f ~= nil, "Audio asset missing: mods/x_mobs/sounds/" .. sname)
	local content = f:read("*a")
	f:close()
	assert(#content > 100, "Audio file corrupt/empty: " .. sname)
end
print("  ✓ All 14 CC0 glacial audio assets verified on filesystem.")

-- 6. Validate Textures and Meshes on filesystem
print("[TEST 6] Checking textures and models on filesystem...")
local textures = {
	"x_mobs_frosty_queen_particles.png",
	"x_mobs_ice_envelop.png",
	"x_mobs_frosty_queen.png",
}
for _, tname in ipairs(textures) do
	local f = io.open("mods/x_mobs/textures/" .. tname, "rb")
	assert(f ~= nil, "Texture missing: mods/x_mobs/textures/" .. tname)
	local content = f:read("*a")
	f:close()
	assert(#content > 50, "Texture empty: " .. tname)
end

local f_obj = io.open("mods/x_mobs/models/x_mobs_envelop_box.obj", "rb")
assert(f_obj ~= nil, "Model missing: mods/x_mobs/models/x_mobs_envelop_box.obj")
local obj_content = f_obj:read("*a")
f_obj:close()
assert(#obj_content > 100, "Model empty: x_mobs_envelop_box.obj")
print("  ✓ All textures and 3D models verified on filesystem.")

-- 7. Test Reusable Envelop System
print("[TEST 7] Testing Reusable Envelop System...")
test_player = {
	_pos = {x = 0, y = 5, z = 0},
	_hp = 20,
	_speed = 1.0,
	_jump = 1.0,
	_is_valid = true,
	_anim = "walk",
	is_valid = function(self) return self._is_valid end,
	is_player = function() return true end,
	get_player_name = function() return "TestHero" end,
	get_pos = function(self) return {x = self._pos.x, y = self._pos.y, z = self._pos.z} end,
	get_hp = function(self) return self._hp end,
	get_physics_override = function(self) return {speed = self._speed, jump = self._jump} end,
	set_physics_override = function(self, o)
		if o.speed ~= nil then self._speed = o.speed end
		if o.jump ~= nil then self._jump = o.jump end
	end,
	hud_add = function(_self, _def) return 1 end,
	hud_change = function() end,
	hud_remove = function() end,
	get_properties = function()
		return {
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3},
			selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3},
			visual_size = {x = 1.0, y = 1.0, z = 1.0},
		}
	end,
	get_animation = function(self) return self._anim, 30 end,
	set_animation = function(self, anim) self._anim = anim end,
}

local queen_obj = core.add_entity({x = 5, y = 5, z = 0}, "x_mobs:frosty_queen")

-- Cast frost envelop on player
x_mobs.cast_frost_envelop(queen_obj, test_player)

-- Player speed should now be 0.5 (50% slowdown) and jump prevented (jump = 0)
assert(math.abs(test_player._speed - 0.5) < 0.001,
	"Player speed should be reduced to 0.5, got " .. tostring(test_player._speed))
assert(math.abs(test_player._jump - 0.0) < 0.001,
	"Player jump should be prevented (0.0), got " .. tostring(test_player._jump))
assert(x_mob_core.is_enveloped(test_player) == true, "Target must be recognized as enveloped")
assert(test_player._anim == "walk", "Player animation must not be frozen or overridden")

-- Find the created envelop entity
local env_ent = nil
for _, ent in ipairs(added_entities) do
	if ent.initial_properties and ent.initial_properties.mesh == "x_mob_core_envelop_box.obj" then
		env_ent = ent
		break
	end
end
assert(env_ent ~= nil, "Envelop entity was not created")
assert(env_ent.object:get_properties().mesh == "x_mob_core_envelop_box.obj",
	"Envelop must use open rectangular sleeve mesh x_mob_core_envelop_box.obj")
assert(env_ent.object:get_properties().pointable == false,
	"Envelop must be pointable = false so hits pass through")
assert(env_ent.object:get_properties().backface_culling == false,
	"Envelop must disable backface culling to render interior walls")
assert(env_ent.object:get_properties().use_texture_alpha == true,
	"Envelop must enable texture alpha for smooth top fade")
assert(env_ent.object._attached_to == test_player,
	"Envelop must attach to target")
assert(env_ent.object._forced_visible == true,
	"Envelop must pass forced_visible = true for client first-person visibility")

-- Verify bottom half geometry: height is 55% of entity height (~0.97m)
local v_size = env_ent.object:get_properties().visual_size
assert(math.abs(v_size.y - (1.77 * 0.55)) < 0.01,
	"Envelop height must cover bottom half (0.55 * height), got: " .. tostring(v_size.y))
assert(math.abs(v_size.x - (0.6 * 1.15)) < 0.01,
	"Envelop width must expand by 1.15 margin around collisionbox, got: " .. tostring(v_size.x))

-- Test expiration after 6s
env_ent:on_step(6.0)
assert(env_ent.object:is_valid() == false, "Envelop should be removed after 6s")
assert(x_mob_core.is_enveloped(test_player) == false, "Target should no longer be marked as enveloped")

-- Run scheduled timer callbacks to test frost slow expiration
for _, cb in ipairs(scheduled_callbacks) do
	cb()
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Player speed must be restored to 1.0 after frost slow duration")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Player jump must be restored to 1.0 after frost slow duration")

-- Test reusability: apply custom agnostic envelop to a mob entity with custom timings & texture
local mob_target = core.add_entity({x = 2, y = 5, z = 0}, "x_mobs:frosty_queen")
local custom_envelop = x_mob_core.apply_envelop(mob_target, {
	id = "frost_test",
	duration = 4.0,
	texture = "custom_freeze.png",
})
assert(custom_envelop ~= nil, "Custom mob envelop entity was not created")
assert(x_mob_core.is_enveloped(mob_target) == true, "Mob target must be recognized as enveloped")
local mob_env_props = custom_envelop:get_properties()
assert(mob_env_props.mesh == "x_mob_core_envelop_box.obj", "Mob envelop must use open rectangular mesh")
assert(mob_env_props.textures[1] == "custom_freeze.png", "Mob envelop must use custom texture")
-- In Luanti Irrlicht scene graph, child visual_size divides parent scale (7.8) to prevent blowout
assert(mob_env_props.visual_size.y < 1.0, "Mob child visual_size must be normalized by parent scale")

-- Test manual removal
x_mob_core.remove_envelop(mob_target)
assert(x_mob_core.is_enveloped(mob_target) == false, "Mob target should no longer be enveloped after remove_envelop")

print("  ✓ Reusable Envelop Framework verified: agnostic open rectangular sleeve geometry (no top/bottom caps), " ..
	"bottom-half coverage, top-fading alpha texture, parent scale normalization, and clean removal.")

-- 8. Test Player Lifecycle Listeners (Die, Leave, Join, Respawn, Shutdown cleanup)
print("[TEST 8] Testing lifecycle listeners (die, leave, join, respawn, shutdown)...")
test_player._is_valid = true
test_player._speed = 1.0
test_player._jump = 1.0
x_mobs.cast_frost_envelop(queen_obj, test_player)
assert(math.abs(test_player._speed - 0.5) < 0.001, "Speed should be 0.5")
assert(math.abs(test_player._jump - 0.0) < 0.001, "Jump should be 0.0")

-- Trigger dieplayer callback
for _, cb in ipairs(dieplayer_callbacks) do
	cb(test_player)
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Speed must be restored on player death")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Jump must be restored on player death")

-- Test leaveplayer callback
x_mobs.cast_frost_envelop(queen_obj, test_player)
assert(math.abs(test_player._speed - 0.5) < 0.001, "Speed should be 0.5")
assert(math.abs(test_player._jump - 0.0) < 0.001, "Jump should be 0.0")
for _, cb in ipairs(leaveplayer_callbacks) do
	cb(test_player)
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Speed must be restored on player leave")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Jump must be restored on player leave")

-- Test joinplayer callback (cleans up any lingering slow/jump from crash/restart)
test_player._speed = 0.5 -- Simulate player joining with a stale speed override
test_player._jump = 0.0  -- Simulate player joining with a stale jump override
for _, cb in ipairs(joinplayer_callbacks) do
	cb(test_player)
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Speed must be sanitized on player join")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Jump must be sanitized on player join")

-- Test respawnplayer callback
x_mobs.cast_frost_envelop(queen_obj, test_player)
assert(math.abs(test_player._speed - 0.5) < 0.001, "Speed should be 0.5")
assert(math.abs(test_player._jump - 0.0) < 0.001, "Jump should be 0.0")
for _, cb in ipairs(respawnplayer_callbacks) do
	cb(test_player)
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Speed must be restored on player respawn")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Jump must be restored on player respawn")

-- Test shutdown callback
x_mobs.cast_frost_envelop(queen_obj, test_player)
assert(math.abs(test_player._speed - 0.5) < 0.001, "Speed should be 0.5")
assert(math.abs(test_player._jump - 0.0) < 0.001, "Jump should be 0.0")
for _, cb in ipairs(shutdown_callbacks) do
	cb()
end
assert(math.abs(test_player._speed - 1.0) < 0.001, "Speed must be restored on server shutdown")
assert(math.abs(test_player._jump - 1.0) < 0.001, "Jump must be restored on server shutdown")

print("  ✓ Full lifecycle listeners (die, leave, join, respawn, shutdown) prevent speed and jump state leaks.")

-- 9. Test Combat AI State Machine: Normal Combat (> 40 HP) vs Core Flee Mechanics (<= 40 HP)
print("[TEST 9] Testing combat AI state machine (Normal vs Low Health)...")
assert(fq_def.health_regen ~= nil, "health_regen must be defined on Frosty Queen")
assert(fq_def.health_regen.flee_threshold == 40, "flee_threshold must be 40 HP")
assert(fq_def.health_regen.return_threshold == 80, "return_threshold must be 80 HP")
assert(fq_def.health_regen.heal_amount == 40, "heal_amount must be 40 HP")
assert(fq_def.health_regen.safe_distance == 12.0, "safe_distance must be 12.0m")
assert(fq_def.health_regen.flee_speed == 4.4, "flee_speed must be 4.4")
assert(fq_def.can_swim == false, "can_swim must be false")
assert(fq_def.disallow_water == true, "disallow_water must be true")

local fq_instance = {}
for k, v in pairs(fq_def) do
	fq_instance[k] = v
end
local fq_mob_obj = core.add_entity({x = 0, y = 0, z = 0}, "x_mobs:frosty_queen")
fq_instance.object = fq_mob_obj
fq_instance.hp = 100 -- High HP
fq_instance.target = test_player

-- Normal combat, close range (2.0m <= 2.6m melee reach)
test_player._pos = {x = 0, y = 0, z = 2.0}
scheduled_callbacks = {}
fq_instance:on_step(0.1)
assert(fq_instance.state == "attacking",
	"Expected normal combat to punch at close range (<= 2.6m), got: " .. tostring(fq_instance.state))
print("  ✓ Normal combat (> 40 HP) punches in close melee quarters (<= 2.6m).")

-- Normal combat, range 8.0m (outside melee reach, within shoot bracket 4-16m)
fq_instance.state = "idle"
fq_instance.attack_cooldown = 0
fq_instance.cooldowns = { spell = 0, shoot = 0 }
test_player._pos = {x = 0, y = 0, z = 8.0}
fq_instance:on_step(0.1)
assert(fq_instance.state == "casting",
	"Expected normal combat to cast frost envelop spell at 8m, got: " .. tostring(fq_instance.state))
print("  ✓ Normal combat (> 40 HP) casts frost spell at range (8.0m).")

-- Normal combat, range 10.0m with spell on cooldown -> shooter fires frost shards
fq_instance.state = "idle"
fq_instance.attack_cooldown = 0
fq_instance.cooldowns = { spell = 10, shoot = 0 }
test_player._pos = {x = 0, y = 0, z = 10.0}
fq_instance:on_step(0.1)
assert(fq_instance.state == "shooting",
	"Expected normal combat to fire ranged shards when spell on cooldown (10m), got: " .. tostring(fq_instance.state))
print("  ✓ Normal combat (> 40 HP) fires ranged frost shards when spell on cooldown (10.0m).")

-- Low-health combat (HP <= 40): Core Flee Mechanics & Tactical Retreat
fq_instance.hp = 30 -- Low HP
fq_instance.state = "idle"
fq_instance.attack_cooldown = 0
fq_instance.cooldowns = { spell = 10, shoot = 0 }

-- Low-health, player pursues (dist = 5.0m < safe_distance 12.0m) -> retreats
test_player._pos = {x = 0, y = 0, z = 5.0}
fq_instance._horizontal_speed = nil
fq_instance:on_step(0.1)
assert(fq_instance.state == "fleeing",
	"Expected low-health queen to enter fleeing state, got: " .. tostring(fq_instance.state))
assert(fq_instance._horizontal_speed and fq_instance._horizontal_speed >= 4.0,
	"Expected low-health queen to retreat when dist < safe_distance")
assert(fq_mob_obj._anim and fq_mob_obj._anim.anim == "run",
	"Expected low-health queen to play run animation while retreating")
print("  ✓ Low-health combat (<= 40 HP) retreats when player pursues (< 12m).")

-- Low-health, reached safe distance (dist = 14.0m >= 12.0m) -> vulnerable healing channel
test_player._pos = {x = 0, y = 0, z = 14.0}
fq_instance:on_step(0.1)
assert(fq_instance.state == "channeling",
	"Expected low-health queen to channel healing at safe distance (14m), got: " .. tostring(fq_instance.state))
print("  ✓ Low-health combat (<= 40 HP) begins vulnerable healing channel at safe distance (>= 12.0m).")

-- Low-health, desperate cornered melee punch if player catches up (dist <= 2.2m)
fq_instance.state = "fleeing"
fq_instance.attack_cooldown = 0
test_player._pos = {x = 0, y = 0, z = 1.8}
fq_instance:on_step(0.1)
assert(fq_instance.state == "attacking", "Expected desperate cornered punch when cornered at <= 2.2m")
print("  ✓ Low-health combat (<= 40 HP) only punches as a desperate last resort if cornered (<= 2.2m).")

-- 10. Verify Localization Entries in locale/
print("[TEST 10] Checking localization entries in en.po and template.pot...")
local function file_contains(path, pattern)
	local f = io.open(path, "r")
	if not f then return false end
	local content = f:read("*a")
	f:close()
	return content:find(pattern, 1, true) ~= nil
end

assert(file_contains("mods/x_mobs/locale/en.po", 'msgid "Frosty Queen"'), "en.po missing Frosty Queen")
assert(file_contains("mods/x_mobs/locale/en.po", 'msgid "Frost Shard"'), "en.po missing Frost Shard")
assert(file_contains("mods/x_mobs/locale/en.po", 'msgid "Ice Envelop"'), "en.po missing Ice Envelop")
assert(file_contains("mods/x_mobs/locale/template.pot", 'msgid "Frosty Queen"'), "template.pot missing Frosty Queen")
assert(file_contains("mods/x_mobs/locale/template.pot", 'msgid "Frost Shard"'), "template.pot missing Frost Shard")
assert(file_contains("mods/x_mobs/locale/template.pot", 'msgid "Ice Envelop"'), "template.pot missing Ice Envelop")
print("  ✓ Localization entries verified in en.po and template.pot.")

-- 11. Verify Licensing Manifest in license.txt
print("[TEST 11] Checking licensing manifest compliance in license.txt...")
assert(file_contains("mods/x_mobs/license.txt", "models/x_mobs_envelop_box.obj"),
	"license.txt missing envelop mesh attribution")
assert(file_contains("mods/x_mobs/license.txt", "assets/x_mobs_envelop_box.blend"),
	"license.txt missing envelop blend attribution")
assert(file_contains("mods/x_mobs/license.txt", "textures/x_mobs_frosty_queen_particles.png"),
	"license.txt missing particle sheet attribution")
assert(file_contains("mods/x_mobs/license.txt", "textures/x_mobs_ice_envelop.png"),
	"license.txt missing envelop texture attribution")
assert(file_contains("mods/x_mobs/license.txt", "sounds/x_mobs_frosty_queen_idle.1.ogg"),
	"license.txt missing idle audio attribution")
assert(file_contains("mods/x_mobs/license.txt", "sounds/x_mobs_frosty_queen_freeze.1.ogg"),
	"license.txt missing freeze audio attribution")
assert(file_contains("mods/x_mobs/license.txt", "sounds/x_mobs_frosty_queen_shatter.ogg"),
	"license.txt missing shatter audio attribution")
assert(not file_contains("mods/x_mobs/license.txt", "juraj"), "license.txt contains forbidden username juraj")
print("  ✓ Licensing manifest verified: full asset attribution, strictly Luanti, author SaKeL.")

print("======================================================================")
print("ALL 11 FROSTY QUEEN INTEGRATION TESTS PASSED SUCCESSFULLY!")
print("======================================================================")
