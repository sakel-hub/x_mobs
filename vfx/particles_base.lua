--[[
	x_mobs - Core Particle Systems Base & Declarative VFX Dispatcher
	Shared helpers, node texture sampling, target resolution, and lifecycle listeners
--]]

local node_tile_cache = {}

--- Retrieves the primary tile texture name for a given node for particle fallback
---@param node_name string Name of the node
---@return string texture Name of the texture or fallback
local function get_node_tile_texture(node_name)
	if not node_name or node_name == "" or node_name == "air" or node_name == "ignore" then
		return "default_stone.png"
	end
	local cached = node_tile_cache[node_name]
	if cached then
		return cached
	end

	local tex = ""
	local ndef = core.registered_nodes[node_name]
	if ndef and ndef.tiles then
		local t = ndef.tiles[1]
		if type(t) == "string" then
			tex = t
		elseif type(t) == "table" and t.name then
			tex = t.name
		end
	end
	if tex == "" then
		tex = "default_stone.png"
	end
	node_tile_cache[node_name] = tex
	return tex
end

x_mobs.get_node_tile_texture = get_node_tile_texture

--- Samples the solid surface node directly under an impact position
---@param pos Vector Impact coordinate
---@return table node Node table with name and param2
function x_mobs.sample_ground_node(pos)
	if not pos then return { name = "default:stone", param2 = 0 } end
	local p = vector.round(pos)
	for dy = 0, -2, -1 do
		local check_p = { x = p.x, y = p.y + dy, z = p.z }
		local node = core.get_node_or_nil(check_p)
		if node and node.name ~= "air" and node.name ~= "ignore" then
			local ndef = core.registered_nodes[node.name]
			if ndef and ndef.walkable ~= false and ndef.drawtype ~= "airlike" then
				return node
			end
		end
	end
	local below = core.get_node_or_nil({ x = p.x, y = p.y - 1, z = p.z })
	if below and below.name ~= "air" and below.name ~= "ignore" then
		return below
	end
	return { name = "default:stone", param2 = 0 }
end



--- Resolves an ObjectRef target or Vector position into {pos = Vector, obj = ObjectRef|nil}
---@param target_or_pos ObjectRef|Vector Target entity or 3D coordinate vector
---@return table|nil result Table with {pos = Vector, obj = ObjectRef|nil} or nil if invalid
function x_mobs.resolve_target_or_pos(target_or_pos)
	if not target_or_pos then return nil end
	if type(target_or_pos) == "table" and target_or_pos.x and target_or_pos.y and target_or_pos.z then
		return { pos = target_or_pos, obj = nil }
	end
	if type(target_or_pos) == "userdata" or (type(target_or_pos) == "table" and target_or_pos.get_pos) then
		if target_or_pos.is_valid and not target_or_pos:is_valid() then
			return nil
		end
		local p = target_or_pos:get_pos()
		if p then
			return { pos = p, obj = target_or_pos }
		end
	end
	return nil
end

--- Dispatches a single particle effect specification
---@param pos Vector Base world position
---@param rot number Yaw rotation in radians
---@param spec string|table Particle effect descriptor
local function play_single_vfx(pos, rot, spec)
	if not spec or not pos then return end
	local vtype = (type(spec) == "string" and spec) or spec.type
	if not vtype then return end

	if vtype == "flame" then
		x_mobs.spawn_death_flame(pos, (type(spec) == "table" and spec.scale) or 1.0, rot)
	elseif vtype == "venom" then
		x_mobs.spawn_venom_particles(pos, (type(spec) == "table" and spec.count) or 8)
	elseif vtype == "web" then
		x_mobs.spawn_web_particles(pos, (type(spec) == "table" and spec.dir) or {x = 0, y = 1, z = 0})
	elseif vtype == "spider_skitter" then
		x_mobs.spawn_spider_skitter(pos)
	elseif vtype == "spider_death" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_death(pos, scale, rot)
	elseif vtype == "spider_chitin" then
		local count = (type(spec) == "table" and spec.count) or 16
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_chitin(pos, count, scale)
	elseif vtype == "spider_venom_splatter" then
		local count = (type(spec) == "table" and spec.count) or 24
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_venom_splatter(pos, count, scale)
	elseif vtype == "spider_silk_rupture" then
		local count = (type(spec) == "table" and spec.count) or 18
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_silk_rupture(pos, count, scale)
	elseif vtype == "spider_eye_shatter" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_eye_shatter(pos, scale)
	elseif vtype == "spider_poison_mist" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_poison_mist(pos, scale)
	elseif vtype == "spider_dissolve" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_spider_dissolve(pos, scale)
	elseif vtype == "chitin_shatter" or vtype == "chitin_shards" then
		local count = (type(spec) == "table" and spec.count) or 16
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_chitin_shards(pos, count, scale)
	elseif vtype == "ichor_burst" or vtype == "ichor" then
		local count = (type(spec) == "table" and spec.count) or 28
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_ichor_burst(pos, count, scale)
	elseif vtype == "wing_shreds" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_wing_shreds(pos, count, scale)
	elseif vtype == "ichor_dissolve" then
		x_mobs.spawn_ichor_dissolve(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "armored_bug_death" then
		x_mobs.spawn_armored_bug_death(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "armored_bug_hurt" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 0.6
		x_mobs.spawn_ichor_burst(pos, count, scale)
	elseif vtype == "armored_bug_despawn" then
		x_mobs.spawn_ichor_dissolve(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "bug_carapace" or vtype == "bug_shards"
			or vtype == "flying_insect_carapace" or vtype == "flying_insect_shards" then
		local count = (type(spec) == "table" and spec.count) or 12
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_bug_carapace_shards(pos, count, scale)
	elseif vtype == "bug_ichor_burst" or vtype == "bug_ichor"
			or vtype == "flying_insect_ichor_burst" or vtype == "flying_insect_ichor"
			or vtype == "flying_insect_hurt" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 0.6
		x_mobs.spawn_bug_ichor_burst(pos, count, scale)
	elseif vtype == "bug_wing_shreds" or vtype == "bug_wings"
			or vtype == "flying_insect_wing_shreds" or vtype == "flying_insect_wings" then
		local count = (type(spec) == "table" and spec.count) or 8
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_bug_wing_shreds(pos, count, scale)
	elseif vtype == "bug_dissolve" or vtype == "flying_insect_despawn"
			or vtype == "flying_insect_dissolve" then
		x_mobs.spawn_bug_dissolve(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "flying_insect_death" then
		x_mobs.spawn_flying_insect_death(pos, (type(spec) == "table" and spec.scale) or 1.0)
	elseif vtype == "shaman_resurrect" then
		x_mobs.spawn_shaman_resurrect_particles(pos)
	elseif vtype == "shaman_resurrect_burst" then
		x_mobs.spawn_shaman_resurrect_burst(pos)
	elseif vtype == "shaman_interrupted" then
		x_mobs.spawn_shaman_interrupted_burst(pos)
	elseif vtype == "fireball_trail" then
		x_mobs.spawn_fireball_trail(pos)
	elseif vtype == "fireball_impact" then
		x_mobs.spawn_fireball_impact(pos)
	elseif vtype == "bone_dust" then
		x_mobs.spawn_bone_dust(pos)
	elseif vtype == "magic_summon" then
		x_mobs.spawn_magic_summon(pos)
	elseif vtype == "mushroom_dissolve" or vtype == "fungus_dissolve" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_dissolve(pos, scale)
	elseif vtype == "mushroom_hurt" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_hurt(pos, scale)
	elseif vtype == "mushroom_death" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_mushroom_death(pos, scale)
	elseif vtype == "fungus_hurt" then
		x_mobs.spawn_fungus_hurt(pos)
	elseif vtype == "fungus_death" then
		x_mobs.spawn_fungus_death(pos)
	elseif vtype == "elder_hurt" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_elder_hurt(pos, scale)
	elseif vtype == "elder_fuse" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_elder_fuse(pos, scale)
	elseif vtype == "elder_explode" then
		local radius = (type(spec) == "table" and spec.radius) or 3.0
		x_mobs.spawn_elder_explode(pos, radius)
	elseif vtype == "elder_death" then
		local scale = (type(spec) == "table" and spec.scale) or 1.0
		x_mobs.spawn_elder_death(pos, scale)
	end
end

--- Dispatches visual effects defined in a mob's declarative vfx table
---@param mob table Mob entity instance
---@param stage "hurt"|"death"|"despawn" Visual effect stage
function x_mobs.play_vfx(mob, stage)
	if not mob or not mob.vfx then return end
	local spec = mob.vfx[stage]
	if not spec or not mob.object then return end

	local pos = mob.object:get_pos()
	if not pos then return end
	local rot = (mob._cur_rot and mob._cur_rot.y) or (mob.object:is_valid() and mob.object:get_yaw()) or 0

	if type(spec) == "table" and spec[1] then
		for i = 1, #spec do
			play_single_vfx(pos, rot, spec[i])
		end
	else
		play_single_vfx(pos, rot, spec)
	end
end


x_mobs.play_single_vfx = play_single_vfx

-- Automatic lifecycle listeners for declarative mob VFX
x_mob_core.listen("on_mob_hurt", function(mob, _puncher, _dmg)
	x_mobs.play_vfx(mob, "hurt")
end)

x_mob_core.listen("on_mob_death", function(mob, _puncher)
	x_mobs.play_vfx(mob, "death")
end)

x_mob_core.listen("on_mob_despawn", function(mob)
	x_mobs.play_vfx(mob, "despawn")
end)

