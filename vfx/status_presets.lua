--[[
	x_mobs - Status Effect Presets & Themed Visual Envelop Bindings
	Configures x_mobs-specific 16x16 pixel art envelop textures for status presets
	in x_mob_core while keeping core decoupled and agnostic.

	Author: SaKeL
	License: MIT
]]

local register = x_mob_core.status_effects.register_preset

-- ============================================================================
-- 1. POSITIVE BUFF PRESETS (ENVELOP OVERRIDES)
-- ============================================================================

register("frenzy", { envelop_texture = "x_mobs_frenzy_envelop.png" })
register("bloodlust", { envelop_texture = "x_mobs_frenzy_envelop.png" })
register("ironhide", { envelop_texture = "x_mobs_ironhide_envelop.png" })
register("carapace", { envelop_texture = "x_mobs_ironhide_envelop.png" })
register("haste", { envelop_texture = "x_mobs_haste_envelop.png" })
register("rejuvenation", { envelop_texture = "x_mobs_mending_envelop.png" })
register("solar_surge", { envelop_texture = "x_mobs_radiance_envelop.png" })
register("unstoppable", { envelop_texture = "x_mobs_frenzy_envelop.png" })
register("barrier", { envelop_texture = "x_mobs_barrier_envelop.png" })
register("shadow_march", { envelop_texture = "x_mobs_shadow_envelop.png" })

-- ============================================================================
-- 2. STANDARD DEBUFF PRESETS (X_MOBS THEMED ASSETS)
-- ============================================================================

register("fire", {
	type = "dot",
	category = "debuff",
	damage = 1,
	interval = 1.0,
	duration = 4.0,
	damage_type = "fire",
	envelop_texture = "x_mobs_fire_envelop.png",
})

register("ice", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.4,
	duration = 4.0,
	envelop_texture = "x_mobs_ice_envelop.png",
})

register("freeze", {
	type = "root",
	category = "debuff",
	duration = 2.5,
	envelop_texture = "x_mobs_ice_envelop.png",
})

register("venom", {
	type = "dot",
	category = "debuff",
	damage = 1,
	interval = 1.5,
	duration = 6.0,
	damage_type = "poison",
	envelop_texture = "x_mobs_venom_envelop.png",
})

register("web", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.3,
	jump_factor = 0.5,
	duration = 4.0,
	envelop_texture = "x_mobs_web_envelop.png",
})

register("roots", {
	type = "root",
	category = "debuff",
	duration = 3.0,
	envelop_texture = "x_mobs_roots_envelop.png",
})

register("mud", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.5,
	duration = 4.0,
	envelop_texture = "x_mobs_mud_envelop.png",
})

register("bone", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.4,
	duration = 4.0,
	envelop_texture = "x_mobs_bone_envelop.png",
})

register("void", {
	type = "dot",
	category = "debuff",
	damage = 2,
	interval = 1.5,
	duration = 5.0,
	envelop_texture = "x_mobs_void_envelop.png",
})

register("spore", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.6,
	duration = 5.0,
	envelop_texture = "x_mobs_spore_envelop.png",
})

register("swarm", {
	type = "dot",
	category = "debuff",
	damage = 1,
	interval = 1.0,
	duration = 3.0,
	envelop_texture = "x_mobs_swarm_envelop.png",
})

register("smoke", {
	type = "debuff",
	category = "debuff",
	duration = 4.0,
	envelop_texture = "x_mobs_smoke_envelop.png",
})

register("brine", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.5,
	duration = 4.0,
	envelop_texture = "x_mobs_brine_envelop.png",
})

register("crystal", {
	type = "root",
	category = "debuff",
	duration = 3.0,
	envelop_texture = "x_mobs_crystal_envelop.png",
})

register("necrotic_decay", {
	type = "poison",
	category = "debuff",
	damage = 2,
	interval = 1.0,
	duration = 4.0,
	speed_factor = 0.65,
	damage_type = "poison",
	envelop_texture = "x_mobs_venom_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#225505aa",
})

register("urticating_itch", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.70,
	duration = 2.5,
	envelop_texture = "x_mobs_swarm_envelop.png^[colorize:#ffd043:140",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#ffd04355",
})

register("crypt_laceration", {
	type = "dot",
	category = "debuff",
	damage = 1,
	interval = 1.0,
	duration = 2.5,
	damage_type = "bleed",
	envelop_texture = "x_mobs_frenzy_envelop.png^[colorize:#880410:140",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#88041044",
})

register("tremor_stagger", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.50,
	duration = 3.0,
	envelop_texture = "x_mobs_mud_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#40352b77",
})

register("magma_burn", {
	type = "dot",
	category = "debuff",
	damage = 1,
	interval = 1.0,
	duration = 3.0,
	damage_type = "fire",
	envelop_texture = "x_mobs_fire_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#ff440055",
})

register("void_distortion", {
	type = "slow",
	category = "debuff",
	speed_factor = 0.55,
	duration = 3.5,
	envelop_texture = "x_mobs_void_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#660099aa",
})

register("void_rend", {
	type = "dot",
	category = "debuff",
	damage = 2,
	interval = 1.0,
	duration = 3.0,
	damage_type = "bleed",
	envelop_texture = "x_mobs_void_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#8800ff88",
})

-- ============================================================================
-- 3. BOSS & ARMOR SET SIGNATURE DEBUFF PRESETS
-- ============================================================================

register("earth_anchor", {
	type = "custom",
	category = "debuff",
	duration = 4.0,
	gravity_factor = 2.4,
	jump_factor = 0.0,
	speed_factor = 0.55,
	envelop_texture = "x_mobs_mud_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#4a3219aa",
})

register("bone_shackles", {
	type = "root",
	category = "debuff",
	duration = 3.0,
	speed_factor = 0.0,
	jump_factor = 0.0,
	anti_heal = true,
	envelop_texture = "x_mobs_bone_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#ddddddbb",
})

register("crystallize", {
	type = "custom",
	category = "debuff",
	duration = 4.0,
	speed_factor = 0.15,
	jump_factor = 0.0,
	damage_multiplier = 1.35,
	envelop_texture = "x_mobs_crystal_envelop.png",
	hud_vignette = "x_mob_core_vignette.png^[colorize:#88ffff99",
})
