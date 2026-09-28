# X Mobs (`x_mobs`)

High-performance mobs and boss framework for Luanti featuring original 3D models with glTF 2.0 multi-track skeletal animations, multi-phase combat mechanics, and dynamic entity visual controls.

## Features

- **glTF 2.0 Multi-Track Animations**: Custom-authored 3D models with 9 named animation tracks (`idle`, `walk`, `run`, `dash`, `slashone`, `slashtwo`, `heavyslash`, `hurt`, `death`) optimized for Luanti 5.17.0+ skeletal playback, following Unreal Engine Mannequin animation and movement principles (anticipation, weight shift, secondary wave lag, and momentum follow-through).
- **Intricate Boss Geometry**: 69 articulated voxel cuboid boxes oriented facing forward (+Y, toward the player) with an overhanging cowl, recessed dark facial void with glowing fangs, stepped horns, 3D cage ribs wrapping an inner emissive cyan soul core, dorsal spine vertebrae, tiered spiked pauldrons, skeletal claws, multi-layer tattered cloth streamers, and a pure voxel-box stepped scythe blade (without smooth curves) with directional non-repetitive UV unwrapping.
- **Blender 5 Project Included**: Includes the native Blender 5.2 LTS project file (`x_mobs_reaper.blend`) with full hierarchy, 14-bone armature rig, vertex weights, materials, and NLA animation tracks.
- **Professional Pixel-Art Texture Atlas**: 128x128 pixel-perfect texture atlas featuring dedicated non-overlapping regions for each anatomical component, hue-shifted 5-step shading ramps (deep indigo shadow, weathered ivory, cold steel, searing soul cyan, burnished gold), cloth fold cross-hatching, bone sutures, and polished scythe edge sheens.
- **Nether Wraith (Reaper Boss)**: A 3-block tall spectral apparition wielding the Soul Harvester scythe with 3 dynamic health-based combat phases, 3D aerial ascent and descent pathing, poise/super-armor mechanics, dead-player target dropping, and an uninterruptible 2-second death sequence animation.
- **Nether Arachnid (Spider Mob)**: A predatory multi-legged arachnid mob featuring 23-bone dual-jointed skeletal rigging (Femur Upper + Tibia Lower), articulated fangs and pedipalps, an alternating tetrapod gait walk and run cycle, pounce leaps, web snare projectiles, venom bite attacks, dead-player target dropping, and an iconic arachnid death curl animation where all 8 legs contract inward.
- **Multi-Phase Combat Mechanics**:
  - **Phase 1 (100% - 75% HP)**: Floating hover patrol, alternating between horizontal (`slashone`) and diagonal (`slashtwo`) scythe sweeps.
  - **Phase 2 (75% - 35% HP)**: Enhanced locomotion speed (+30%) and unlocked supersonic phantom `dash` gap-closer.
  - **Phase 3 (35% - 0% HP)**: Enraged spectral form unlocking the devastating `heavyslash` ground-slam shockwave attack.
- **Dynamic Particle Systems**: Advanced particle effects using modern Luanti particle APIs (texpools, drag, jitter, bounce, scale/alpha tweens, and glow) for spectral souls, ground shockwaves, venom droplets, web silk wisps, and skittering dust.

---

## 3D Asset Structure

All 3D assets are located in the mod directories:

| File | Type | Description |
| :--- | :--- | :--- |
| `assets/x_mobs_reaper.blend` | Blender 5.2 File | Native source file with 69 pure voxel boxes, 14-bone armature rig, materials, and 9 NLA action tracks |
| `models/x_mobs_reaper.glb` | glTF 2.0 Binary | glTF 2.0 binary mesh (external texture mode) with 9 named animation tracks starting at time 0 |
| `textures/x_mobs_reaper.png` | PNG Atlas | 128x128 pixel-art texture atlas with 14 mapped regions (obsidian robes, bone ribs, soul core, runes, steel scythe) |
| `assets/x_mobs_spider.blend` | Blender 5.2 File | Native source file with pure voxel boxes, 23-bone dual-jointed armature rig, materials, and 8 NLA action tracks |
| `models/x_mobs_spider.glb` | glTF 2.0 Binary | glTF 2.0 binary mesh with 8 named animation tracks starting at time 0 |
| `textures/x_mobs_spider.png` | PNG Atlas | 128x128 pixel-art texture atlas with 10 mapped regions (chitin, crimson eyes, venom, silk, and leg joints) |
| `textures/x_mobs_spider_particles.png` | PNG Sheet | 128x128 pixel-art 8x8 particle sprite sheet with chitin shards, fangs, acidic venom, silk webbing, eye sparks, and necrotic poison clouds |


---

## Multi-Track Animations

All animations are authored at 24 FPS and follow Unreal Engine Mannequin animation and timing principles:

| Track Name | Length | Loop | Description |
| :--- | :--- | :--- | :--- |
| `idle` | 60 frames (2.5s) | Yes | Floating vertical bobbing with rhythmic breathing, scythe cradle, and trailing cloth wave delay |
| `walk` | 30 frames (1.25s) | Yes | Forward hovering locomotion with cloth drag and balanced scythe sway |
| `run` | 20 frames (0.83s) | Yes | Aggressive forward rush with forward torso lean (-18°), arms swept back, and trailing robe streamers |
| `dash` | 15 frames (0.625s) | No | Supersonic phantom surge with explosive anticipation, forward thrust, and deceleration recovery |
| `slashone` | 18 frames (0.75s) | No | Wide horizontal scythe cleave with deep wind-up anticipation, weapon weight shift, and follow-through recoil |
| `slashtwo` | 20 frames (0.83s) | No | Overhead diagonal executioner cleave rotating the spine and pitching the blade down |
| `heavyslash` | 32 frames (1.33s) | No | Boss ultimate ground slam: high vertical leap, weapon raise, downward plunge, and ground shockwave recoil |
| `hurt` | 12 frames (0.5s) | No | Visceral damage reaction: backward torso recoil, spine arch, arm flinch, and robe forward lag |
| `death` | 45 frames (1.875s) | No | Soul collapse: torso convulsion, armature spine slump, scythe drop, and ethereal dissolution |

### Nether Arachnid (Spider) Tracks

| Track Name | Length | Loop | Description |
| :--- | :--- | :--- | :--- |
| `idle` | 48 frames (2.0s) | Yes | Cephalothorax rhythmic breathing, abdomen subtle heave, fangs twitching, and leg stance micro-adjustments |
| `walk` | 24 frames (1.0s) | Yes | Alternating tetrapod gait (Set A vs Set B 180° phase offset) with vertical cephalothorax bobbing and abdomen sway |
| `run` | 16 frames (0.67s) | Yes | Rapid predatory scamper with deep crouched posture, fast leg frequency, and flared chelicerae fangs |
| `bite` | 15 frames (0.625s) | No | Cephalothorax rears up, front legs lift, fangs flare wide outward, then snap shut downward with venom injection |
| `pounce` | 20 frames (0.833s) | No | Deep squat compression across all 8 legs, explosive forward leap, airborne leg spread, and slam landing |
| `web` | 18 frames (0.75s) | No | Body pitches forward, abdomen raises vertically, spinnerets pulse, and silk strands spray forward |
| `hurt` | 10 frames (0.417s) | No | Rapid defensive flinch pulling all 8 legs inward towards the body with backward cephalothorax snap |
| `death` | 36 frames (1.5s) | No | Arachnid death curl: sudden convulsion, hydraulic pressure collapse curling all legs under body, tipping onto side |

---

## Developer API

### `x_mobs.play_animation(obj, track_name, params)`
Dispatches skeletal animation to an object using modern glTF track playback with fallback support.

```lua
x_mobs.play_animation(entity_obj, "bite", {
    speed = 1.0,
    loop = false,
    blend = 0.15,
})
```

### `x_mobs.register_mob(name, def)`
Registers a mob definition with standard physical and animation properties.

```lua
x_mobs.register_mob("x_mobs:spider", {
    -- Entity definition
})
```

### `x_mobs.spawn_web_particles(pos, dir)`
Shoots an expanding directional cone of sticky silk web strands from the spinneret with drag, collision, and alpha fading.

### `x_mobs.spawn_venom_particles(pos, count)`
Spawns high-energy toxic amber venom droplets and crimson flare sparks at bite impact points with ground bounce physics.

### `x_mobs.spawn_spider_skitter(pos)`
Spawns tiny skittering dust and silk flecks beneath multi-legged mobs during movement and pounce landings.

### `x_mobs.spawn_spectral_particles(pos, count)`
Spawns ethereal glowing soul wisps around a position with Brownian jitter, upward buoyancy, scale/alpha tweens, and additive bloom.

### `x_mobs.spawn_impact_shockwave(pos, radius)`
Spawns a dual-layered ground shockwave: an expanding radial blast ring with atmospheric drag and floor bounce, plus a vertical soul eruption geyser at the epicenter.

### `x_mobs.spawn_dash_trail(pos, dir)`
Spawns an ethereal void wake behind dashing entities with negative directional momentum and rapid dissipation.

### `x_mobs.spawn_scythe_cleave(pos, dir)`
Spawns a high-speed crescent soul arc cutting along the scythe swing trajectory.

### `x_mobs.spawn_shaman_resurrect_particles(pos)`
Spawns a rising fiery channeling aura around the Fallen Shaman during minion resurrection.

### `x_mobs.spawn_shaman_resurrect_burst(pos)`
Spawns an explosive fiery summoning eruption burst when a resurrected minion materializes.

### `x_mobs.spawn_shaman_interrupted_burst(pos)`
Spawns an erratic fiery disruption burst and backfire blast when the Shaman is struck during resurrection.

### `x_mobs.spawn_fireball_trail(pos)`
Spawns floating ember trail particles behind the Shaman's projectile fireball.

### `x_mobs.spawn_fireball_impact(pos)`
Spawns an explosive fiery detonation burst upon fireball collision with entities or terrain.

### `x_mobs.spawn_chitin_shards(pos, count, scale)`
Spawns sharp fractured chitin armor plate shards bursting radially outward with gravitational acceleration and physical terrain bouncing.

### `x_mobs.spawn_ichor_burst(pos, count, scale)`
Spawns pressurized bioluminescent yellow-green hemolymph/ichor droplets spraying radially outward with gravity and luminous bloom upon armor breach.

### `x_mobs.spawn_wing_shreds(pos, count, scale)`
Spawns delicate fluttering translucent wing membrane scraps drifting downwards with high atmospheric drag and horizontal air current sway.

### `x_mobs.spawn_ichor_dissolve(pos, scale)`
Spawns an expanding caustic acidic mist puff upon armored bug corpse despawn, preventing abrupt mesh disappearance.

### `x_mobs.spawn_armored_bug_death(pos, scale)`
Spawns the full composite death effect for the Armored Bug: chitin carapace shards, pressurized ichor spray, and fluttering wing scraps.

### `x_mobs.spawn_spider_chitin(pos, count, scale)`
Spawns sharp fractured chitin carapaces, ivory fangs, and spiny leg segments bursting outward with realistic terrain bounce.

### `x_mobs.spawn_spider_venom_splatter(pos, count, scale)`
Spawns a pressurized fountain of acidic venom and hemolymph droplets erupting from the ruptured venom sac.

### `x_mobs.spawn_spider_silk_rupture(pos, count, scale)`
Spawns torn gossamer silk webbing and tangled spinneret filament clusters floating slowly with high aerodynamic drag.

### `x_mobs.spawn_spider_eye_shatter(pos, scale)`
Spawns popping ruby-crimson eye embers and dying ocular sparks scattering into the air from the cephalothorax.

### `x_mobs.spawn_spider_poison_mist(pos, scale)`
Spawns an expanding billowing cloud of necrotic acid mist and venom vapor rising over the fallen corpse.

### `x_mobs.spawn_spider_death(pos, scale, rotation)`
Spawns the full composite visceral death sequence for the spider: chitin shards, venom fountain, ruptured silk, eye sparks, and toxic poison mist mapped to the spider's anatomy and facing direction.

### `x_mobs.spawn_spider_dissolve(pos, scale)`
Spawns a soft dissolving necrotic venom mist when the spider corpse despawns.

---

## License

- Code: MIT (see `LICENSE.txt`)
- Models & Textures: CC-BY-4.0 (see `LICENSE.txt`)
- Audio: CC0 1.0 Universal & CC-BY-4.0 (see `LICENSE.txt`)

