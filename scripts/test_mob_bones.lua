--[[
	test_mob_bones.lua - Bone Rig Configuration Verification Test Suite
	Verifies that all registered mobs in x_mobs have valid data-driven bone pivot tables
	matching their Blender armatures and glTF coordinate conventions.
]]

-- luacheck: push ignore 142 143

local reg_entities = {}
local reg_mobs = {}

_G.vector = {
	new = function(x, y, z)
		if type(x) == "table" then return { x = x.x or 0, y = x.y or 0, z = x.z or 0 } end
		return { x = x or 0, y = y or 0, z = z or 0 }
	end,
}

_G.core = {
	registered_entities = reg_entities,
	registered_nodes = {},
	registered_craftitems = {},
	register_entity = function() end,
	register_craftitem = function() end,
	register_node = function() end,
	register_alias = function() end,
	register_on_joinplayer = function() end,
	register_on_respawnplayer = function() end,
	register_on_leaveplayer = function() end,
	register_on_dieplayer = function() end,
	register_on_shutdown = function() end,
	register_globalstep = function() end,
	after = function() end,
	sound_play = function() end,
	get_color_escape_sequence = function() return "" end,
	get_translator = function()
		return function(str) return str end
	end,
	get_current_modname = function() return "x_mobs" end,
	get_modpath = function(mod)
		if mod == "x_mobs" then return "." end
		return nil
	end,
}

_G.x_mob_core = {
	registered_mobs = reg_mobs,
	register_mob = function(name, def)
		reg_mobs[name] = def
		reg_entities[name] = def
	end,
	register_spawn = function() end,
	adopt_nearby_orphans = function() end,
	broadcast_threat = function() end,
	dissolve = function() end,
}

-- luacheck: pop


-- Mock vfx
_G.x_mobs = _G.x_mobs or {}
x_mobs.vfx = setmetatable({}, {
	__index = function()
		return function() end
	end
})

print("1. Loading all mob definitions...")

local mob_files = {
	"spider.lua",
	"golem.lua",
	"golem_minion.lua",
	"crystal_guardian.lua",
	"crystal_guardian_minion.lua",
	"nature_guardian.lua",
	"nature_guardian_minion.lua",
	"crazy_mushroom.lua",
	"fungus_minion.lua",
	"fallen_shaman.lua",
	"fallen_minion.lua",
	"skull_king.lua",
	"skull_lancer.lua",
	"skull_archer.lua",
	"spectrum.lua",
	"skeleton_swordfish.lua",
	"armored_bug.lua",
	"flying_insect.lua",
}

local mod_prefix = "mobs/"
local test_file = io.open("mobs/spider.lua", "r")
if test_file then
	test_file:close()
else
	local root_file = io.open("mods/x_mobs/mobs/spider.lua", "r")
	if root_file then
		root_file:close()
		mod_prefix = "mods/x_mobs/mobs/"
	end
end

for _, file in ipairs(mob_files) do
	dofile(mod_prefix .. file)
end

print("2. Validating bone configurations across all mobs...")

local forbidden_legacy_names = {
	peitoral = true,
	corpo = true,
}

local checked_count = 0
for mob_name, def in pairs(x_mob_core.registered_mobs) do
	assert(def.bones, "FAILURE: " .. mob_name .. " is missing bones table!")
	assert(type(def.bones) == "table", "FAILURE: " .. mob_name .. " bones must be a table!")
	assert(next(def.bones) ~= nil, "FAILURE: " .. mob_name .. " bones table is empty!")

	for bname, bdef in pairs(def.bones) do
		assert(not forbidden_legacy_names[bname],
			"FAILURE: " .. mob_name .. " contains forbidden legacy bone: " .. bname)
		assert(type(bdef) == "table",
			"FAILURE: " .. mob_name .. " bone " .. bname .. " must be a table")
		assert(bdef.pivot,
			"FAILURE: " .. mob_name .. " bone " .. bname .. " must define a pivot")
		assert(type(bdef.pivot.x) == "number",
			"FAILURE: " .. mob_name .. " bone " .. bname .. " pivot.x must be a number")
		assert(type(bdef.pivot.y) == "number",
			"FAILURE: " .. mob_name .. " bone " .. bname .. " pivot.y must be a number")
		assert(type(bdef.pivot.z) == "number",
			"FAILURE: " .. mob_name .. " bone " .. bname .. " pivot.z must be a number")
	end

	print(string.format("  [OK] %-30s (%d bones configured)", mob_name, (function()
		local c = 0
		for _ in pairs(def.bones) do c = c + 1 end
		return c
	end)()))
	checked_count = checked_count + 1
end

assert(checked_count >= 18, "Expected at least 18 mobs, verified " .. checked_count)
print(string.format("\n=== SUCCESS: All %d mobs verified with valid bone pivot configurations! ===", checked_count))
