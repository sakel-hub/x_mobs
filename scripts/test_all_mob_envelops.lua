--[[
	test_all_mob_envelops.lua - Integration Test Suite for All Mob Envelops & Status Effects
	Validates that every mob debuff/effect properly attaches a 3D visual envelop sleeve
	to affected players alongside appropriate hud_vignette overlays.

	Author: SaKeL
	License: MIT
]]

local prefix = "mods/"
local f_probe = io.open("mods/x_mob_core/core/utils.lua", "r")
if f_probe then
	f_probe:close()
else
	prefix = "../"
end

local registered_entities = {}
local scheduled_afters = {}

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
	multiply = function(v, s) return {x = v.x * s, y = v.y * s, z = v.z * s} end,
	add = function(a, b)
		if type(b) == "number" then return {x = a.x + b, y = a.y + b, z = a.z + b} end
		return {x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
	end,
	subtract = function(a, b) return {x = a.x - b.x, y = a.y - b.y, z = a.z - b.z} end,
}

_G.core = {
	get_current_modname = function() return "x_mobs" end,
	get_modpath = function(m) return prefix .. m end,
	get_translator = function() return function(s) return s end end,
	register_entity = function(name, def) registered_entities[name] = def end,
	registered_nodes = {},
	register_globalstep = function() end,
	register_on_mods_loaded = function() end,
	register_on_joinplayer = function() end,
	register_on_dieplayer = function() end,
	register_on_respawnplayer = function() end,
	register_on_leaveplayer = function() end,
	register_on_shutdown = function() end,
	register_on_punchplayer = function() end,
	register_on_player_hpchange = function() end,
	register_chatcommand = function() end,
	setting_getbool = function() return false end,
	setting_get = function() return nil end,
	settings = { get_bool = function() return false end, get = function() return nil end },
	sound_play = function() return 1 end,
	add_particlespawner = function() return 1 end,
	delete_particlespawner = function() return true end,
	after = function(delay, cb)
		table.insert(scheduled_afters, {delay = delay, cb = cb})
	end,
	log = function() end,
	get_content_id = function() return 1 end,
	dir_to_yaw = function() return 0 end,
	yaw_to_dir = function() return {x = 0, y = 0, z = 1} end,
}
_G.minetest = _G.core

local created_envelops = {}
_G.core.add_entity = function(pos, name)
	if name == "x_mob_core:envelop" or name == "x_mobs:envelop" then
		local def = registered_entities[name]
		local ent_obj = {
			_pos = {x = pos.x, y = pos.y, z = pos.z},
			_valid = true,
			_props = {},
			_attached_to = nil,
			get_pos = function(s) return s._pos end,
			is_valid = function(s) return s._valid end,
			remove = function(s) s._valid = false end,
			set_properties = function(s, p)
				for k, v in pairs(p) do s._props[k] = v end
			end,
			get_properties = function(s) return s._props end,
			set_armor_groups = function() end,
			set_attach = function(s, parent, _bone, pos_att, rot, _vis)
				s._attached_to = parent
				s._attach_pos = pos_att
				s._attach_rot = rot
			end,
			get_attach = function(s) return s._attached_to end,
		}
		local ent_instance = {
			object = ent_obj,
			effects = {},
			get_composite_texture = def.get_composite_texture,
			on_step = def.on_step,
		}
		ent_obj.get_luaentity = function() return ent_instance end
		table.insert(created_envelops, ent_obj)
		if def.on_activate then def.on_activate(ent_instance, "", 0) end
		return ent_obj
	end
	return nil
end

local function create_mock_player(name)
	local p = {
		_name = name,
		_pos = {x = 0, y = 1, z = 0},
		_hp = 20,
		_speed = 1.0,
		_jump = 1.0,
		_valid = true,
		_hud = {},
		is_valid = function(s) return s._valid end,
		is_player = function() return true end,
		get_player_name = function(s) return s._name end,
		get_pos = function(s) return s._pos end,
		get_hp = function(s) return s._hp end,
		set_hp = function(s, hp) s._hp = hp end,
		get_physics_override = function(s) return {speed = s._speed, jump = s._jump} end,
		set_physics_override = function(s, o)
			if o.speed ~= nil then s._speed = o.speed end
			if o.jump ~= nil then s._jump = o.jump end
		end,
		get_properties = function()
			return {
				collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3},
				selectionbox = {-0.3, 0.0, -0.3, 0.3, 1.77, 0.3},
				visual_size = {x = 1.0, y = 1.0, z = 1.0},
			}
		end,
		hud_add = function(s, def)
			local id = #s._hud + 1
			s._hud[id] = def
			return id
		end,
		hud_change = function(s, id, stat, val)
			if s._hud[id] then s._hud[id][stat] = val end
		end,
		hud_remove = function(s, id)
			s._hud[id] = nil
		end,
		get_wielded_item = function() return { get_name = function() return "" end } end,
	}
	return p
end


-- Load subsystems
local utils = dofile(prefix .. "x_mob_core/core/utils.lua")
_G.x_mob_core = {
	listen = function() end,
	emit = function() end,
	generate_uuid = utils.generate_uuid,
	utils = utils,
}
_G.x_mobs = {}
dofile(prefix .. "x_mob_core/animation/animator.lua")
dofile(prefix .. "x_mob_core/combat/particles.lua")
dofile(prefix .. "x_mob_core/combat/hunger_adapter.lua")
dofile(prefix .. "x_mob_core/combat/hud_effects.lua")
dofile(prefix .. "x_mob_core/combat/envelop.lua")
dofile(prefix .. "x_mob_core/combat/status_effects.lua")
dofile(prefix .. "x_mobs/api.lua")
dofile(prefix .. "x_mobs/vfx/status_presets.lua")

print("==================================================")
print("RUNNING AUTOMATED MOB ENVELOP & STATUS EFFECT TESTS")
print("==================================================")

local test_cases = {
	{
		mob = "suture_golem",
		effect_id = "necrotic_decay",
		effect_def = {
			id = "necrotic_decay",
			type = "poison",
			damage = 2,
			interval = 1.0,
			duration = 4.0,
			speed_factor = 0.65,
			envelop_texture = "x_mobs_venom_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#225505aa",
		},
		expected_envelop = "x_mobs_venom_envelop.png",
	},
	{
		mob = "void_strider (distortion)",
		effect_id = "void_distortion",
		effect_def = {
			id = "void_distortion",
			type = "slow",
			speed_factor = 0.55,
			duration = 3.5,
			envelop_texture = "x_mobs_void_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#660099aa",
		},
		expected_envelop = "x_mobs_void_envelop.png",
	},
	{
		mob = "void_strider (rend)",
		effect_id = "void_rend",
		effect_def = {
			id = "void_rend",
			type = "bleed",
			damage = 2,
			interval = 1.0,
			duration = 3.0,
			envelop_texture = "x_mobs_void_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#8800ff88",
		},
		expected_envelop = "x_mobs_void_envelop.png",
	},
	{
		mob = "chasm_weaver (setae)",
		effect_id = "urticating_itch",
		effect_def = {
			id = "urticating_itch",
			type = "slow",
			chance = 0.8,
			speed_factor = 0.70,
			duration = 2.5,
			envelop_texture = "x_mobs_swarm_envelop.png^[colorize:#ffd043:140",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#ffd04355",
		},
		expected_envelop = "x_mobs_swarm_envelop.png^[colorize:#ffd043:140",
	},
	{
		mob = "crypt_stalker (laceration)",
		effect_id = "crypt_laceration",
		effect_def = {
			id = "crypt_laceration",
			type = "dot",
			damage = 1,
			tick_rate = 1.0,
			duration = 2.5,
			envelop_texture = "x_mobs_frenzy_envelop.png^[colorize:#880410:140",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#88041044",
		},
		expected_envelop = "x_mobs_frenzy_envelop.png^[colorize:#880410:140",
	},
	{
		mob = "dungeon_brute (stagger)",
		effect_id = "tremor_stagger",
		effect_def = {
			id = "tremor_stagger",
			type = "slow",
			speed_factor = 0.50,
			duration = 3.0,
			envelop_texture = "x_mobs_mud_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#40352b77",
		},
		expected_envelop = "x_mobs_mud_envelop.png",
	},
	{
		mob = "heated_sword (magma burn)",
		effect_id = "magma_burn",
		effect_def = {
			id = "magma_burn",
			type = "dot",
			damage = 1,
			tick_rate = 1.0,
			duration = 3.0,
			envelop_texture = "x_mobs_fire_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#ff440055",
		},
		expected_envelop = "x_mobs_fire_envelop.png",
	},
	{
		mob = "frosty_queen (frost)",
		effect_id = "frost",
		effect_def = {
			id = "frost",
			type = "slow",
			speed_factor = 0.50,
			duration = 3.0,
			envelop_texture = "x_mobs_ice_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#55ccff88",
		},
		expected_envelop = "x_mobs_ice_envelop.png",
	},
	{
		mob = "spider (venom)",
		effect_id = "venom",
		effect_def = {
			id = "venom",
			type = "dot",
			damage = 1,
			interval = 1.0,
			duration = 3.0,
			envelop_texture = "x_mobs_venom_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#00aa2288",
		},
		expected_envelop = "x_mobs_venom_envelop.png",
	},
	{
		mob = "nature_guardian (roots)",
		effect_id = "nature_roots",
		effect_def = {
			id = "nature_roots",
			type = "root",
			duration = 3.0,
			envelop_texture = "x_mobs_roots_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#3a5f0b88",
		},
		expected_envelop = "x_mobs_roots_envelop.png",
	},
	{
		mob = "golem (earth anchor)",
		effect_id = "earth_anchor",
		effect_def = {
			id = "earth_anchor",
			type = "custom",
			duration = 3.0,
			envelop_texture = "x_mobs_mud_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#3b2d1f88",
		},
		expected_envelop = "x_mobs_mud_envelop.png",
	},
	{
		mob = "spectrum (void miasma)",
		effect_id = "void_miasma",
		effect_def = {
			id = "void_miasma",
			type = "custom",
			duration = 3.0,
			envelop_texture = "x_mobs_void_envelop.png",
			hud_vignette = "x_mob_core_vignette.png^[colorize:#440066aa",
		},
		expected_envelop = "x_mobs_void_envelop.png",
	},
}

for i, tc in ipairs(test_cases) do
	local player = create_mock_player("tester_" .. i)
	x_mob_core.apply_status_effect(player, tc.effect_def)

	assert(x_mob_core.has_status_effect(player, tc.effect_id),
		string.format("[%s] Status effect %s not active", tc.mob, tc.effect_id))
	assert(x_mob_core.is_enveloped(player, tc.effect_id),
		string.format("[%s] Target not recognized as enveloped with %s", tc.mob, tc.effect_id))

	local env_data = x_mob_core.get_envelop_data(player)
	assert(env_data ~= nil and env_data.envelop ~= nil,
		string.format("[%s] Envelop entity missing for %s", tc.mob, tc.effect_id))

	local props = env_data.envelop:get_properties()
	local applied_tex = props.textures and props.textures[1]
	assert(applied_tex == tc.expected_envelop,
		string.format("[%s] Expected envelop texture %s, got: %s", tc.mob, tc.expected_envelop, tostring(applied_tex)))

	-- Check clean removal
	x_mob_core.remove_status_effect(player, tc.effect_id)
	assert(not x_mob_core.has_status_effect(player, tc.effect_id),
		string.format("[%s] Status effect failed to remove", tc.mob))
	assert(not x_mob_core.is_enveloped(player),
		string.format("[%s] Envelop failed to remove", tc.mob))

	print(string.format("[PASS] %-30s -> Envelop sleeve %s successfully bound & cleaned", tc.mob, tc.expected_envelop))
end

-- Test Preset Inheritance (applying by ID without explicit envelop_texture inherits from status_presets)
print("\n--- Testing Preset Fallback Inheritance ---")
local preset_player = create_mock_player("preset_tester")
x_mob_core.apply_status_effect(preset_player, {
	id = "necrotic_decay",
	duration = 3.0,
})
assert(x_mob_core.is_enveloped(preset_player, "necrotic_decay"),
	"Preset inheritance must automatically bind x_mobs_venom_envelop.png for necrotic_decay")
local p_data = x_mob_core.get_envelop_data(preset_player)
local p_tex = p_data.envelop:get_properties().textures[1]
assert(p_tex == "x_mobs_venom_envelop.png",
	"Expected preset texture x_mobs_venom_envelop.png, got: " .. tostring(p_tex))
print("[PASS] Preset inheritance verified: necrotic_decay automatically receives x_mobs_venom_envelop.png")

print("\n==================================================")
print("ALL MOB ENVELOP INTEGRATION TESTS PASSED (100%)!")
print("==================================================")
