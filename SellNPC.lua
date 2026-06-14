_addon.command = 'SellNPC'
_addon.version = '2.0.0.5'
_addon.author = 'Ivaar + VC-MSCP (Vibe coding using Microsoft Copilot)'
_addon.name = 'SellNPC'

require('sets')
profiles = require('profiles')
config = require('config')
res_items = require('resources').items

local defaults = {
    auto_enabled = true,
    auto_profile = 'default',
}

settings = config.load(defaults)
sales_que = {}

function get_item_res(item)
    for k,v in pairs(res_items) do
        if (v.en:lower() == item or v.enl:lower() == item) and not v.flags['No NPC Sale'] then
            return v
        end
    end
    return nil
end

function check_item(name, silent)
    local name = windower.convert_auto_trans(name):lower()
    local item = get_item_res(name)
    if not item then
        windower.add_to_chat(207, '%s: "%s" not a valid item name.':format(_addon.name, name))
    else
        sales_que[item.id] = true
        if silent then return end
        windower.add_to_chat(207, '%s: "%s" added to sales queue.':format(_addon.name, item.en))
    end
end

local function load_profile(profile_name)
    if profiles and profiles[profile_name] then
        for name in pairs(profiles[profile_name]) do
            check_item(name, true)
        end
        return true
    end
    return false
end

function sell_all_items()
    local num = 0
    for index = 1, 80 do
        local item = windower.ffxi.get_items(0, index)
        if item and sales_que[item.id] and item.status == 0 then
            windower.packets.inject_outgoing(
                0x084,
                string.char(
                    0x084, 0x06, 0, 0,
                    item.count, 0, 0, 0,
                    item.id % 256,
                    math.floor(item.id / 256) % 256,
                    index, 0
                )
            )
            windower.packets.inject_outgoing(0x085, string.char(0x085, 0x04, 0, 0, 1, 0, 0, 0))
            num = num + item.count
        end
    end

    sales_que = {}

    if num > 0 then
        windower.add_to_chat(207, '%s: Selling %d items.':format(_addon.name, num))
    end
end

function initialize_shop(id, data)
    if id == 0x03C then
        if settings.auto_enabled then
            load_profile(settings.auto_profile)
        end
        sell_all_items()
    end
end

function sell_npc_command(...)
    local commands = {...}
    local cmd = commands[1] and commands[1]:lower()

    if cmd == 'auto' then
        local state = commands[2] and commands[2]:lower()

        if state == 'on' then
            settings.auto_enabled = true
            config.save(settings)
            windower.add_to_chat(207, ('%s: Auto-sell ENABLED'):format(_addon.name))
        elseif state == 'off' then
            settings.auto_enabled = false
            config.save(settings)
            windower.add_to_chat(207, ('%s: Auto-sell DISABLED'):format(_addon.name))
        else
            windower.add_to_chat(207, ('%s: Auto-sell is currently %s'):format(
                _addon.name,
                settings.auto_enabled and 'ENABLED' or 'DISABLED'
            ))
        end
        return
    end

    if not commands[1] then
        return
    elseif profiles[commands[1]] then
        for name in pairs(profiles[commands[1]]) do
            check_item(name, true)
        end
        windower.add_to_chat(207, ('%s: Loaded profile "%s"'):format(_addon.name, commands[1]))
    else
        check_item(table.concat(commands, ' '))
    end
end

windower.register_event('incoming chunk', initialize_shop)
windower.register_event('addon command', sell_npc_command)
