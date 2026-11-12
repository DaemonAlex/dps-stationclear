# dps-stationclear

Hides map props that are in the way, and keeps stray game peds off chosen spots.

## What it is for

Some props in the game map stand where you do not want them. A farm fence runs through train
station platforms. Light poles stand on a race track. Trees grow across rails. These props
belong to the map, so deleting them does not last. This script hides them for every player who
comes near. It also stops the game from spawning its own background peds on a spot where one of
your own NPCs stands.

## What it does

- Hides the farm fence family (`prop_fnc_farm_01a` to `01f`) at eight train stations.
- Hides the light poles on the Mirror Park Raceway.
- Clears cedar, sequoia and birch trees along the Roxwood Junction rail and road corridor, and
  two lone sequoias west of Roxwood.
- Blocks game scenario peds at the LSIA terminal desk.
- `/clearfence` hides the farm fence within 40 metres of where you stand.

It works by area. Each hide is set up when a player comes within range, using ox_lib points.
There is no loop that runs all the time.

## On its own, and with other scripts

**On its own.** With only ox_lib it hides the station fences and the listed props. Every place
is a fixed coordinate in `client.lua`. If a listed map is not installed, that entry has nothing
to hide and does no harm.

**With [dps-trains](https://github.com/DaemonAlex/dps-trains).** The eight station spots are the
platforms the trains stop at. Players can walk the platform and board without a fence in the
way. This script does not call dps-trains. It only shares the same places.

**With a paid Roxwood map.** The corridor entries hide the map's own trees (`onx_sequoia_...`)
where they stand on the rails and the road. The map files are not touched, so a map update does
not undo the hides.

**With [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs).** The ped block at LSIA stops a
game pilot from spawning next to Captain Marcus. Your own NPCs are script peds and are left
alone. The block is lifted when the player walks away.

## Requirements

- `ox_lib`

## Install

1. Put the folder in your resources and add `ensure dps-stationclear` after `ox_lib`.
2. Edit the lists in `client.lua` to suit your map.
3. Restart `dps-stationclear`.

## Configuration

All settings are tables at the top of each part of `client.lua`.

| Setting | Meaning |
|---|---|
| `TARGETS` | The fence models to hide at stations. |
| `STATIONS` | Station positions. The fence is hidden within 50 metres of each. |
| `AREAS` | Other hides. Each has a label, a position, a radius and a list of models. |
| `PED_BLOCKS` | Spots where game scenario peds must not spawn. Each has a position and a radius. |
| `/clearfence` | Command. Hides the farm fence within 40 metres of you. |

## Recent changes

- **12 November 2026.** README added.
- **2 November 2026.** The four "LS Live" hides are retired. They were built for a map that is
  no longer installed, and they were hiding the stock ground on Alta Street.
- **25 October 2026.** First commit, as it runs on DelPerroSands.
- **27 September 2026.** Ped blocks added, first at the LSIA terminal desk.
- **26 September 2026.** LS Live construction site hides added (retired on 2 November).
- **23 September 2026.** Two lone sequoias west of Roxwood hidden.
- **21 September 2026.** Roxwood Junction corridor cleared of trees.

## Author

Made by [DaemonAlex](https://github.com/DaemonAlex) for DelPerroSands.

## Other DPS scripts

All of these are made for DelPerroSands and run together on one Qbox server. Each one works on
its own. The ones marked "pairs with" do more when both are running.

| Script | What it does |
|---|---|
| [dps-inventory](https://github.com/DaemonAlex/dps-inventory) | The inventory: ox_inventory with equipment slots, backpacks, armour plates and a self status panel, in the DelPerroSands colours. |
| [dps-medical](https://github.com/DaemonAlex/dps-medical) | Patient records, illness and diagnostic tests. A companion to wasabi_ambulance. Pairs with dps-inventory: symptoms and diagnoses show on the status panel. |
| [dps-insurance](https://github.com/DaemonAlex/dps-insurance) | Ties m-Insurance into the MDT, impound, hospital and medical chart. Pairs with dps-medical. |
| [dps-studio](https://github.com/DaemonAlex/dps-studio) | Build rooms, doors and portals in game from one panel (`/studio`), with owners and managers so staff do not have to support them. |
| [dps-shops](https://github.com/DaemonAlex/dps-shops) | Shop clerks who greet and react to a robbery, then player-owned shops. |
| [dps-fleet](https://github.com/DaemonAlex/dps-fleet) | Vehicle browser and workshop on one panel: extras, liveries and mods for emergency vehicles. |
| [dps-parking](https://github.com/DaemonAlex/dps-parking) | Parking with valet, impound, violations and reserved spots. |
| [dps-vehiclepersistence](https://github.com/DaemonAlex/dps-vehiclepersistence) | Vehicles stay where they were parked. Pairs with dps-parking. |
| [dps-towjob](https://github.com/DaemonAlex/dps-towjob) | Queue-based tow job with jg-mechanic integration. |
| [dps-services](https://github.com/DaemonAlex/dps-services) | Request a tow and follow it live on the lb-phone and lb-tablet. Pairs with dps-towjob. |
| [dps-autoshops](https://github.com/DaemonAlex/dps-autoshops) | Self-service repair shops when no mechanic is on duty. |
| [dps-cityworker](https://github.com/DaemonAlex/dps-cityworker) | City infrastructure job and career. |
| [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs) | NPCs you can talk to, with trust, quests and intel. |
| [dps-badpeds](https://github.com/DaemonAlex/dps-badpeds) | Police interaction with NPCs: stops, arrests, intel and jail records. |
| [dps-gangwars](https://github.com/DaemonAlex/dps-gangwars) | Ambient gang NPCs, territory population and war reinforcements. |
| [dps-rotations](https://github.com/DaemonAlex/dps-rotations) | Moves dealers, harvests and other spots on a fixed schedule. |
| [dps-trains](https://github.com/DaemonAlex/dps-trains) | The train system. Pairs with dps-trains-stock, dps-traintools and dps-transitapp. |
| [dps-transitapp](https://github.com/DaemonAlex/dps-transitapp) | Live train arrival boards on the lb-phone. |
| [dps-faceplant](https://github.com/DaemonAlex/dps-faceplant) | City help, reports and staff tools on the lb-phone and lb-tablet. |
| [dps-chat](https://github.com/DaemonAlex/dps-chat) | A command box for voice-only servers. No chat feed. |
| [dps-filmmode](https://github.com/DaemonAlex/dps-filmmode) | One key hides every HUD layer and gives a smooth free camera for recording. |
