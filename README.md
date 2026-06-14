# SellNPC

### Command Usage:
```
sellnpc <item_name>	-- add item_name to sales queue. quotes not needed, accepts auto-translate. 
sellnpc <profile_name> 	-- load a group of items from profiles.lua into the sales queue
```
Sales are now triggered by opening a shop window, you will need to queue items prior to this.

Items are removed from queue once selling has completed.

Will not try to sell items equipped, in bazaar or that can not be sold to NPC vendors.

## Auto-Sell

This version adds support for automatically selling items using a predefined profile when interacting with NPC vendors.

When enabled, the addon will:
- Automatically load a profile (default: `default`)
- Queue all items from that profile
- Sell matching items immediately when the shop window opens

This removes the need to run commands manually before opening a vendor window.

---

## Auto-Sell Commands

```
//sellnpc auto on   -- enables automatic selling

//sellnpc auto off  -- disables automatic selling

//sellnpc auto      -- displays current auto-sell status
```
---

## Settings

Auto-sell configuration is saved automatically and persists between sessions.

A settings file will be generated at:
```
addons/SellNPC/data/settings.xml
```
Example:
```
<settings>
    <auto_enabled>true</auto_enabled>
    <auto_profile>default</auto_profile>
</settings>

auto_enabled  -- controls whether auto-sell is enabled (default: true)

auto_profile  -- defines which profile is loaded automatically (default: 'default')
```
---

## Profiles

Profiles are defined in profiles.lua.

Example:
```
profiles['default'] = S{
    'acorn',
    'bat fang',
    'bone chip',
}

The `default` profile is used automatically by the auto-sell feature unless changed in settings.xml.
```
---

## Notes

- Item names must match Windower resource names.
- Items flagged as "No NPC Sale" will not be sold.
- Equipped items, bazaar items, and unsellable items are ignored.
- Items are removed from the queue after selling completes.

---

## Warning

There is no recovery for items sold to NPCs.

Use auto-sell carefully and verify your profile list before enabling.

---

## Changelog

Added:
- Automatic selling when interacting with NPC vendors
- Default profile support (`default`)
- Toggle command for auto-sell (`sellnpc auto on/off`)
- Persistent settings (auto-sell state saved between sessions)

Changed:
- Selling behavior now optionally triggers automatically on shop open
- Profile loading can occur without manual command input

Notes:
- Auto-sell defaults to enabled
- Settings stored in data/settings.xml

Enhancements done via: VC-MSCP (Vibe coding using Microsoft CoPilot)
