# X Mobs (`x_mobs`)

High-performance mobs and boss framework for Luanti featuring original 3D models with glTF 2.0 multi-track skeletal animations, multi-phase combat mechanics, and dynamic entity visual controls.

## Features

- **glTF 2.0 Multi-Track Animations**: Custom-authored 3D models with named animation tracks optimized for Luanti 5.17.0+ skeletal playback, following Unreal Engine Mannequin animation and movement principles (anticipation, weight shift, secondary wave lag, and momentum follow-through).
- **Nether Arachnid (Spider Mob)**: A predatory multi-legged arachnid mob featuring 23-bone dual-jointed skeletal rigging (Femur Upper + Tibia Lower), articulated fangs and pedipalps, an alternating tetrapod gait walk and run cycle, pounce leaps, web snare projectiles, venom bite attacks, dead-player target dropping, and an iconic arachnid death curl animation where all 8 legs contract inward.
- **Fallen Shaman & Minions**: Undead necromancer summoning minions with channeling aura, resurrection bursts, and fireball attacks.
- **Skull Legion**: Undead army featuring the Skull King boss, Skull Lancers, and Skull Archers with directional bones, bone dust VFX, and necromantic magic.
- **Crystal Guardian**: Ancient towering crystalline golem with dense basalt and amethyst armor (`fleshy = 50, cracky = 70`), high health pool (140 HP), passive regenerative crystal core, stalwart persistence (never flees), bonded pair combat coordination, and a seismic Ground Smash AoE attack (20% chance) featuring plane-attracted shockwave particles, flying basalt debris, terrain debris mapping (ice chunks on ice, stone particles on stone), and directional player knockback across a 3-block radius. Pickaxes exploit its targeted crystalline weak point (`cracky = 70`), dealing heightened armor-piercing damage compared to deflected slashing blades (`fleshy = 50`).
- **Armored Bug**: Autonomous 3D flocking flyers utilizing the high-performance Swarm Intelligence subsystem with Boids repulsion, dynamic waypoint following, high-frequency wing oscillation, and coordinated hive mind attacks.
- **Flying Insect**: Fragile airborne swarm insect featuring unarmored carapace (`fleshy = 100`), lower health (24 HP) and attack damage, multi-track glTF animations (`idle`, `stand`, `walk`, `run`, `attack`, `death`), custom pixel-art particles for organic carapace, gossamer wings, and hemolymph, and native Luanti HSL texture modifiers (`^[hsl:`) creating rich brown phenotype color variations across swarms.
- **Skeleton Swordfish**: Undead pelagic predator mob utilizing `x_mob_core`'s fish schooling architecture with Leader-Follower Anchor Steering, 3D obstacle and boundary avoidance, multi-track glTF animations (`stand`, `idle`, `walk`, `run`, `attack`, `death`), zero-drift anatomical keyframe pivots, and democratic leader succession. Spawns naturally in oceanic waters while strictly excluding river systems.
- **Crazy Mushroom (Boss)**: A cunning fungal boss mob that commands a vanguard of 3 Fungus Minions. Features glTF 2.0 multi-track animations (`stand`, `walk`, `run`, `shoot`, `punch`, `death`), spore ball projectile attacks at mid-range, unarmored vulnerability (`fleshy = 90`), tactical kiting with slower retreat speed than players (`walk_speed = 3.0`, `retreat_speed = 2.8`), instant transition to a rapid cross-punch melee combo when players catch up within 3 blocks, and tactical retreat behind its minion vanguard to regenerate health when below 30% HP.
- **Fungus Minion**: Fast and aggressive fungal swarmers (`pursuit_speed = 5.2`) that serve as loyal shock-troops to the Crazy Mushroom boss. Features glTF 2.0 multi-track animations (`stand`, `walk`, `run`, `punch`, `death`), lunging punch attacks, and tight squad coordination rallying to protect the boss.
- **Dynamic Particle Systems**: Advanced particle effects using modern Luanti particle APIs (texpools, drag, jitter, bounce, scale/alpha tweens, plane attractors, line attractors, and glow) for venom droplets, web silk wisps, bone dust, crystal shards, and skittering dust.

---

## Mob Mechanics & How to Play

X Mobs introduces a variety of dynamic creatures and challenging bosses to your world. Each mob is designed with unique behaviors, combat phases, and visual effects to provide an immersive gameplay experience.

- **Spider**: A predatory arachnid that stalks players. Watch out for its web snare projectiles that can root you in place, and its venomous bite that applies damage over time.
- **Fallen Shaman**: A necromancer that resurrects fallen minions. Defeating the Shaman quickly is crucial, as it will continuously summon reinforcements.
- **Skull Legion**: Undead skeletal warriors ranging from basic lancers to archers. They often spawn in groups and coordinate their attacks.
- **Crystal Guardian**: A towering basalt and amethyst golem with immense health. Its thick armor makes it resistant to swords, but vulnerable to pickaxes. Watch out for its devastating ground smash attack that sends shockwaves and debris flying!
- **Armored Bug & Flying Insect**: Autonomous swarming insects that fly in coordinated flocks. They will swarm and attack players who disturb their hives.
- **Skeleton Swordfish**: Undead pelagic predators that swim in highly coordinated shoals. They spawn in deep oceans (avoiding rivers) and perform explosive lunge attacks when provoked.
- **Crazy Mushroom & Fungus Minions**: A boss encounter featuring the Crazy Mushroom and its 3 loyal Fungus Minions. The boss stays at range firing corrosive spore balls while its fast minions charge players down. Because the mushroom boss moves slower than players, closing the distance will force it into a close-quarters punch battle. If brought below 30% health, the boss retreats behind surviving minions to regenerate spores and vitality!

### Spawning Mobs

Mobs naturally spawn in their respective biomes and environments based on their configured logic. For example, Spiders lurk in dark caverns, Crystal Guardians protect deep crystal geodes, and Skeleton Swordfish school in oceanic depths (`group:water`).

## Modding & Custom Mobs

You can easily register your own mobs or modify existing ones using the `x_mob_core` API.

### Minimal Mob Definition Example

Here is a quick example of how to register a basic custom mob:

```lua
x_mob_core.register_mob("mymod:custom_mob", {
	initial_properties = {
		hp_max = 20,
		mesh = "mymod_mob.glb",
		textures = {
			"mymod_mob.png",
		},
		visual_size = {x = 1.0, y = 1.0},
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		stepheight = 0.6,
	},

	factions = { "monster" },
	armor_groups = { fleshy = 100 },
	damage = 3,
	attack_range = 2.0,
	walk_speed = 1.6,
	pursuit_speed = 3.2,
	wander_speed = 1.2,

	animations = {
		stand  = {track = "stand",  speed = 1.0, loop = true},
		walk   = {track = "walk",   speed = 1.0, loop = true},
		run    = {track = "run",    speed = 1.2, loop = true},
		attack = {track = "attack", speed = 1.0, loop = false},
		death  = {track = "death",  speed = 1.0, loop = false},
	},

	drops = {
		{ name = "default:bone", min = 1, max = 2, chance = 0.8 },
	},
})
```

### Spawning Your Mob

To spawn your custom mob in the world naturally, use the spawn registry:

```lua
x_mob_core.register_spawn("mymod:custom_mob", {
	nodes = {"group:stone", "group:soil"},
	min_light = 0,
	max_light = 7,
	chance = 3500,
	active_object_count = 2,
	min_elevation = -50,
	max_elevation = 100,
})
```

## Detailed Developer API

For extensive technical details on advanced mechanics, skeletal animations, particle systems, shoaling/flocking architecture, and multi-phase combat logic, please refer to the detailed **[API.md](API.md)**.

---

## License

- Code: MIT (see `LICENSE.txt`)
- Models & Textures: CC-BY-4.0 (see `LICENSE.txt`)
- Audio: CC0 1.0 Universal & CC-BY-4.0 (see `LICENSE.txt`)

