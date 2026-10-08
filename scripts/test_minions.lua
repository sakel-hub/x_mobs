--[[
	test_minions.lua - Automated Integration Test
	Validates Crystal Guardian Minion and Golem Minion mob configurations,
	ensuring player-scale dimensions, half damage, half health/armor resistance,
	and proper integration with x_mob_core framework.
]]

local registered_entities = {}
local registered_spawns = {}

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
	multiply = function(v, s)
		return {x = v.x * s, y = v.y * s, z = v.z * s}
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
	register_alias = function() end,
	log = function() end,
	registered_nodes = {
		["default:stone"] = { sounds = { dug = "default_dug_node" } },
	},
	registered_items = {},
	dir_to_yaw = function(_dir) return 0 end,
	yaw_to_dir = function(_yaw) return {x = 0, y = 0, z = 1} end,
	serialize = function(_t) return "" end,
	deserialize = function(_s) return {} end,
	sound_play = function() return 1 end,
	add_entity = function() return nil end,
	get_objects_inside_radius = function() return {} end,
	get_item_group = function() return 0 end,
	register_on_joinplayer = function() end,
	register_on_leaveplayer = function() end,
	register_on_dieplayer = function() end,
	register_on_respawnplayer = function() end,
	register_on_shutdown = function() end,
	get_node_light = function() return 13 end,
	after = function() end,
}
_G.minetest = _G.core

_G.x_mob_core = {
	register_mob = function(name, def)
		registered_entities[name] = def
	end,
	register_spawn = function(name, def)
		registered_spawns[name] = def
	end,
	step_wander_or_idle = function() end,
	step_move_or_idle = function() end,
	play_animation = function() end,
	play_sound = function() end,
	halt_horizontal_velocity = function() end,
	scan_for_player = function() return nil end,
	set_target = function() end,
	broadcast_threat = function() end,
	line_of_sight = function() return true end,
	schedule = function() end,
	step_projectile = function() end,
	predict_aim = function() return true, {x = 0, y = 0, z = 1} end,
	is_player_alive = function() return true end,
	are_allies = function() return false end,
	is_valid_projectile_target = function() return true end,
}

_G.x_mobs = {
	spawn_crystal_damage = function() end,
	spawn_crystal_death = function() end,
	spawn_crystal_regen = function() end,
	spawn_crystal_smash_charge = function() end,
	sample_ground_node = function() return { name = "default:stone", param2 = 0 } end,
	spawn_crystal_smash_wave = function() end,
	spawn_golem_rock_trail = function() end,
	spawn_golem_rock_shatter = function() end,
	spawn_golem_smash_wave = function() end,
	spawn_golem_punch = function() end,
	spawn_golem_node_raise = function() end,
	spawn_golem_hurt = function() end,
	spawn_golem_death = function() end,
	spawn_nature_roots_burst = function() end,
	spawn_nature_roots_shatter = function() end,
	spawn_nature_roots_trapped = function() end,
	spawn_nature_guardian_hurt = function() end,
	spawn_nature_guardian_death = function() end,
	spawn_nature_guardian_cast_charge = function() end,
	spawn_nature_guardian_attack = function() end,
}

print("1. Loading Bosses and Minions...")
dofile("mods/x_mobs/mobs/crystal_guardian.lua")
dofile("mods/x_mobs/mobs/crystal_guardian_minion.lua")
dofile("mods/x_mobs/mobs/golem.lua")
dofile("mods/x_mobs/mobs/golem_minion.lua")
dofile("mods/x_mobs/mobs/nature_guardian.lua")
dofile("mods/x_mobs/mobs/nature_guardian_minion.lua")

print("2. Validating Registrations...")
assert(registered_entities["x_mobs:crystal_guardian"], "crystal_guardian must be registered")
assert(registered_entities["x_mobs:crystal_guardian_minion"], "crystal_guardian_minion must be registered")

assert(registered_entities["x_mobs:golem"], "golem must be registered")
assert(registered_entities["x_mobs:golem_minion"], "golem_minion must be registered")
assert(registered_entities["x_mobs:golem_minion_boulder"], "golem_minion_boulder must be registered")

assert(registered_entities["x_mobs:nature_guardian"], "nature_guardian must be registered")
assert(registered_entities["x_mobs:nature_guardian_minion"], "nature_guardian_minion must be registered")

local cg_boss = registered_entities["x_mobs:crystal_guardian"]
local cg_minion = registered_entities["x_mobs:crystal_guardian_minion"]
local g_boss = registered_entities["x_mobs:golem"]
local g_minion = registered_entities["x_mobs:golem_minion"]
local g_boulder = registered_entities["x_mobs:golem_minion_boulder"]

print("3. Validating Crystal Guardian Minion...")
-- Size and stepheight validation: player height is ~1.8 blocks, stepheight >= 1.1 for 1-tall blocks
local cg_cbox = cg_minion.initial_properties.collisionbox
local cg_height = cg_cbox[5] - cg_cbox[2]
print(string.format("  Crystal Minion height: %.2f (boss: %.2f)", cg_height, cg_boss.mob_height))
assert(math.abs(cg_height - 1.81) < 0.05, "Crystal Guardian Minion height must be ~1.8 blocks")
assert(cg_minion.initial_properties.visual_size.x == 9.5, "Crystal minion visual_size must be 9.5")
assert(cg_minion.initial_properties.stepheight >= 1.1, "Crystal minion stepheight must be >= 1.1 to step 1-tall blocks")

-- Health validation: half of boss
local cg_b_hp = cg_boss.initial_properties.hp_max
local cg_m_hp = cg_minion.initial_properties.hp_max
print(string.format("  Crystal Minion HP: %d (boss: %d)", cg_m_hp, cg_b_hp))
assert(cg_m_hp == cg_b_hp / 2, "Crystal minion HP must be half of boss HP (70 vs 140)")

-- Armor validation: half resistance
print(string.format("  Crystal Minion Armor: fleshy=%d, cracky=%d (boss: fleshy=%d, cracky=%d)",
	cg_minion.armor_groups.fleshy, cg_minion.armor_groups.cracky,
	cg_boss.armor_groups.fleshy, cg_boss.armor_groups.cracky))
assert(cg_minion.armor_groups.fleshy == 75, "Crystal minion fleshy armor must be 75")
assert(cg_minion.armor_groups.cracky == 85, "Crystal minion cracky armor must be 85")

-- Damage validation: half of boss
print(string.format("  Crystal Minion Damage: %d (boss: %d)", cg_minion.damage, cg_boss.damage))
assert(cg_minion.damage == cg_boss.damage / 2, "Crystal minion damage must be half of boss damage")

-- Pack validation
assert(cg_boss.pack and cg_boss.pack.role == "leader",
	"Crystal Guardian must be pack leader")
assert(cg_minion.pack and cg_minion.pack.leader_type == "x_mobs:crystal_guardian",
	"Crystal minion pack leader must be x_mobs:crystal_guardian")

-- Declarative combat validation
assert(cg_boss.melee, "Crystal Guardian must configure declarative melee table")
assert(cg_boss.melee.range == 3.0, "Crystal Guardian melee range must be 3.0")
assert(#cg_boss.melee.attacks == 2, "Crystal Guardian must have 2 weighted attacks")
assert(cg_boss.melee.attacks[1].animation == "punch" and cg_boss.melee.attacks[1].weight == 80,
	"Crystal Guardian attack 1 must be 80% punch")
assert(cg_boss.melee.attacks[2].animation == "smash" and cg_boss.melee.attacks[2].weight == 20,
	"Crystal Guardian attack 2 must be 20% seismic smash")
assert(cg_boss.melee.attacks[2].aoe == true, "Crystal Guardian smash attack must be AoE")

assert(cg_minion.melee, "Crystal minion must configure declarative melee table")
assert(cg_minion.melee.range == 2.2, "Crystal minion melee range must be 2.2")
assert(#cg_minion.melee.attacks == 2, "Crystal minion must have 2 weighted attacks")
assert(cg_minion.melee.attacks[1].animation == "punch" and cg_minion.melee.attacks[1].weight == 80,
	"Crystal minion attack 1 must be 80% punch")
assert(cg_minion.melee.attacks[2].animation == "smash" and cg_minion.melee.attacks[2].weight == 20,
	"Crystal minion attack 2 must be 20% seismic smash")
assert(cg_minion.melee.attacks[2].aoe == true, "Crystal minion smash attack must be AoE")

print("4. Validating Golem Minion...")
-- Size and stepheight validation: player height is ~1.8 blocks, stepheight >= 1.1 for 1-tall blocks
local g_cbox = g_minion.initial_properties.collisionbox
local g_height = g_cbox[5] - g_cbox[2]
print(string.format("  Golem Minion height: %.2f (boss: %.2f)", g_height, g_boss.mob_height))
assert(math.abs(g_height - 1.80) < 0.05, "Golem Minion height must be 1.8 blocks")
assert(math.abs(g_minion.initial_properties.visual_size.x - 4.8) < 0.01,
	"Golem minion visual_size must be 4.8 (2/3 of 7.2)")
assert(g_minion.initial_properties.stepheight >= 1.1, "Golem minion stepheight must be >= 1.1 to step 1-tall blocks")

-- Health validation: half of boss
local g_b_hp = g_boss.initial_properties.hp_max
local g_m_hp = g_minion.initial_properties.hp_max
print(string.format("  Golem Minion HP: %d (boss: %d)", g_m_hp, g_b_hp))
assert(g_m_hp == g_b_hp / 2, "Golem minion HP must be half of boss HP (80 vs 160)")

-- Armor validation: half resistance
print(string.format("  Golem Minion Armor: fleshy=%d, cracky=%d (boss: fleshy=%d, cracky=%d)",
	g_minion.armor_groups.fleshy, g_minion.armor_groups.cracky,
	g_boss.armor_groups.fleshy, g_boss.armor_groups.cracky))
assert(g_minion.armor_groups.fleshy == 70, "Golem minion fleshy armor must be 70")
assert(g_minion.armor_groups.cracky == 95, "Golem minion cracky armor must be 95")

-- Damage validation: half of boss
print(string.format("  Golem Minion Damage: %d (boss: %d)", g_minion.damage, g_boss.damage))
assert(g_minion.damage == 3, "Golem minion damage must be 3 (half of 7)")

-- Boulder projectile validation
assert(g_boulder.initial_properties.visual == "node", "Boulder must use visual = 'node'")
assert(math.abs(g_boulder.initial_properties.visual_size.x - 0.45) < 0.01,
	"Boulder visual size must be 0.45 (scaled from 0.7)")
local dummy_b = {
	object = {
		set_armor_groups = function() end,
		set_properties = function() end,
		set_velocity = function(self, v) self._vel = v end,
		get_velocity = function(self) return self._vel end,
	}
}
g_boulder.on_activate(dummy_b, "")
assert(dummy_b.object._vel.y >= 2.5, "Boulder rise velocity must be >= 2.5 for elevated launch")

-- Flee and Regen thresholds validation: half of boss
assert(g_minion.health_regen.flee_threshold == 20, "Golem minion flee threshold must be 20")
assert(g_minion.health_regen.return_threshold == 35, "Golem minion return threshold must be 35")

-- Declarative combat validation
assert(g_minion.melee, "Golem minion must configure declarative melee table")
assert(g_minion.melee.range == 2.1, "Golem minion melee range must be 2.1")
assert(#g_minion.melee.attacks == 2, "Golem minion must have 2 weighted attacks")
assert(g_minion.melee.attacks[1].animation == "punch2" and g_minion.melee.attacks[1].weight == 80,
	"Golem minion attack 1 must be 80% punch2")
assert(g_minion.melee.attacks[2].animation == "punch" and g_minion.melee.attacks[2].weight == 20,
	"Golem minion attack 2 must be 20% seismic smash")
assert(g_minion.shooter, "Golem minion must configure declarative shooter table")
assert(g_minion.shooter.range == 14.0 and g_minion.shooter.min_range == 5.0,
	"Golem minion shooter range must be 5.0 to 14.0")
assert(g_minion.shooter.kiting == false, "Golem minion shooter kiting must be false")
assert(g_minion.shooter.shoot_while_retreating == true,
	"Golem minion shooter shoot_while_retreating must be true")

-- Pack validation
assert(g_minion.pack and g_minion.pack.leader_type == "x_mobs:golem",
	"Golem minion pack leader must be x_mobs:golem")

print("5. Validating Nature Guardian Minion...")
local ng_boss = registered_entities["x_mobs:nature_guardian"]
local ng_minion = registered_entities["x_mobs:nature_guardian_minion"]

-- Size and stepheight validation: player height is ~1.8 blocks, stepheight >= 1.1 for 1-tall blocks
local ng_cbox = ng_minion.initial_properties.collisionbox
local ng_height = ng_cbox[5] - ng_cbox[2]
print(string.format("  Nature Minion height: %.2f (boss: %.2f)", ng_height, ng_boss.mob_height))
assert(math.abs(ng_height - 1.80) < 0.05, "Nature Guardian Minion height must be 1.8 blocks")
assert(math.abs(ng_minion.initial_properties.visual_size.x - 5.625) < 0.05,
	"Nature minion visual_size must be ~5.6 (scaled down from 10)")
assert(ng_minion.initial_properties.stepheight >= 1.1, "Nature minion stepheight must be >= 1.1 to step 1-tall blocks")

-- Health validation: half of boss
local ng_b_hp = ng_boss.initial_properties.hp_max
local ng_m_hp = ng_minion.initial_properties.hp_max
print(string.format("  Nature Minion HP: %d (boss: %d)", ng_m_hp, ng_b_hp))
assert(ng_m_hp == ng_b_hp / 2, "Nature minion HP must be half of boss HP (60 vs 120)")

-- Armor validation: half resistance (takes 85 fleshy vs 65 for boss, 135 choppy vs 120 for boss)
print(string.format("  Nature Minion Armor: fleshy=%d, choppy=%d (boss: fleshy=%d, choppy=%d)",
	ng_minion.armor_groups.fleshy, ng_minion.armor_groups.choppy,
	ng_boss.armor_groups.fleshy, ng_boss.armor_groups.choppy))
assert(ng_minion.armor_groups.fleshy == 85, "Nature minion fleshy armor must be 85")
assert(ng_minion.armor_groups.choppy == 135, "Nature minion choppy armor must be 135")

-- Damage validation: half of boss
print(string.format("  Nature Minion Damage: %.1f (boss: %.1f)", ng_minion.damage, ng_boss.damage))
assert(ng_minion.damage == 1.5, "Nature minion damage must be 1.5 (half of 2.5/3.0 scale)")

-- Pack validation
assert(ng_minion.pack and ng_minion.pack.leader_type == "x_mobs:nature_guardian",
	"Nature minion pack leader must be x_mobs:nature_guardian")

-- Hurt animation validation
assert(ng_minion.animations.hurt and ng_minion.animations.hurt.track == "hurt",
	"Nature minion must register hurt animation track")

-- Declarative combat & distance spell validation
assert(ng_boss.melee, "Nature Guardian must configure declarative melee table")
assert(ng_boss.melee.range == 3.2, "Nature Guardian melee range must be 3.2")
assert(ng_boss.melee.damage == 7, "Nature Guardian melee damage must be 7")
assert(ng_boss.melee.animation == "attack", "Nature Guardian melee animation must be attack")
assert(ng_boss.cooldowns and ng_boss.cooldowns.root_spell == 12.0, "Nature Guardian root spell cooldown must be 12.0")
assert(type(ng_boss.custom_step) == "function", "Nature Guardian must define custom_step hook for distance spell")

assert(ng_minion.melee, "Nature minion must configure declarative melee table")
assert(ng_minion.melee.range == 2.1, "Nature minion melee range must be 2.1")
assert(ng_minion.melee.damage == 1.5, "Nature minion melee damage must be 1.5")
assert(ng_minion.melee.animation == "attack", "Nature minion melee animation must be attack")
assert(ng_minion.cooldowns and ng_minion.cooldowns.root_spell == 14.0, "Nature minion root spell cooldown must be 14.0")
assert(type(ng_minion.custom_step) == "function", "Nature minion must define custom_step hook for distance spell")

-- Test minion distance spell execution
local minion_test_target = {
	is_valid = function() return true end,
	is_player = function() return true end,
	get_pos = function() return { x = 0, y = 0, z = 8 } end,
	get_velocity = function() return { x = 0, y = 0, z = 0 } end,
	get_attach = function() return nil end,
	get_player_name = function() return "MinionSpellVictim" end,
	get_luaentity = function() return nil end,
}
local minion_mob = {
	state = "idle",
	object = {
		is_valid = function() return true end,
		get_pos = function() return { x = 0, y = 0, z = 0 } end,
		set_yaw = function() end,
		get_yaw = function() return 0 end,
	},
	target = minion_test_target,
	cooldowns = { root_spell = 0 },
}
assert(ng_minion.custom_step(minion_mob, 0.1) == true, "Minion must cast root spell at distance (8.0m)")
assert(minion_mob.state == "casting", "Minion state must transition to casting")
assert(minion_mob.cooldowns.root_spell == 14.0, "Minion root spell cooldown must be 14.0s")
assert(minion_mob.action_timer == 2.0, "Minion action timer must be 2.0s")

-- Test minion yields to melee when target is close (< 5.0m)
minion_mob.state = "idle"
minion_mob.action_timer = 0
minion_mob.cooldowns.root_spell = 0
minion_test_target.get_pos = function() return { x = 0, y = 0, z = 2 } end
assert(ng_minion.custom_step(minion_mob, 0.1) == false,
	"Minion custom_step must yield to melee when target is close (2.0m)")

-- Test minion yields to pursuit when target is beyond max spell range (> 12.0m)
minion_test_target.get_pos = function() return { x = 0, y = 0, z = 15 } end
assert(ng_minion.custom_step(minion_mob, 0.1) == false,
	"Minion custom_step must yield to pursuit when target is far (15.0m)")

print("6. Validating Natural Spawns...")
assert(registered_spawns["x_mobs:crystal_guardian_minion"], "Crystal minion spawn must be registered")
assert(registered_spawns["x_mobs:golem_minion"], "Golem minion spawn must be registered")
assert(registered_spawns["x_mobs:nature_guardian_minion"], "Nature minion spawn must be registered")

print("=== ALL MINION TESTS PASSED SUCCESSFULLY! ===")
