# kartik-ghostscare

Halloween script for Qbox, QBCore and ESX. Players who are alone outside at night get haunted by ghosts that only they can see.

Need help? Join the [Discord](https://discord.gg/T6AXd2eWdH).

## How it works

Every player has a haunting level. It slowly goes up while you're alone outside at night and drops when you're with others or it's daytime. The higher it gets, the worse it gets: first small things, then ghosts, then ghosts that come after you.

Some spots (graveyard, Mount Gordo, forests) are more haunted than others, check `Config.Hotspots`.

## Scares

Tier 1, small stuff:
- **Glimpse** - someone standing at the edge of your vision, gone when you look
- **Footsteps** - footsteps walking up behind you, nobody there
- **Blackout** - every light around you dies for a few seconds
- **Phone** - your phone rings, unknown number

Tier 2, ghosts:
- **Behind** - a ghost appears right behind you, turn around and it's staring at you
- **Road** - a ghost stands in the middle of the road, drive into it and your engine dies
- **Jumpout** - a ghost pops up right in front of your vehicle
- **Passenger** - a ghost fades into your passenger seat (or the back of your bike)
- **Screamer** - the lights die, then a ghost screams right in your face

Tier 3, it's after you:
- **Follow** - a ghost follows you and gets closer every time you look away
- **Angel** - it can't move while you watch it, but you have to blink sometime
- **Possessed** - the locals around you all stop and stare at you. One of them gets closer every time you look away, and when you finally turn around it screams in your face. Then they all walk off like nothing happened
- **Stalker** - something invisible follows you around. You might hear it or catch a shimmer of it, until it's suddenly right in your face

## EMF Reader

Usable item that beeps faster the closer a ghost is. It also picks up how haunted you are, so it starts ticking before anything shows up. Keeping it on makes ghosts show up more often.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- Qbox / QBCore / ESX (only needed for the EMF item)

## Installation

1. Drop `kartik-ghostscare` in your resources folder
2. Add `ensure kartik-ghostscare` to your server.cfg (after ox_lib and your framework)
3. Add the item to your inventory

ox_inventory (`ox_inventory/data/items.lua`):
```lua
['emf_reader'] = {
    label = 'EMF Reader',
    weight = 300,
    stack = false,
    close = true,
    description = 'Picks up things that should not be there.',
},
```
Don't add `consume` or `client.export` to it, ox_inventory then won't pass the use on to your framework.

qb-core (`qb-core/shared/items.lua`):
```lua
emf_reader = { name = 'emf_reader', label = 'EMF Reader', weight = 300, type = 'item', image = 'emf_reader.png', unique = true, useable = true, shouldClose = true, description = 'Picks up things that should not be there.' },
```

ESX: add `emf_reader` to your `items` table.

## Commands

- `/haunt [id] [scare]` - haunt a player right now, skips the haunting level (admin)
- `/emf` - toggle the EMF reader without the item (admin)

## Config

By default it only runs in October, set `Config.Months = {}` to run it all year. Everything else (chance, cooldown, night hours, models, hotspots) is in `config.lua`.

## Links

- Discord (support & updates): https://discord.gg/T6AXd2eWdH
- Docs: https://kartik-scripts.gitbook.io/
- More scripts: https://kartikscripts.store/
