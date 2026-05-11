---@meta _
-- grabbing our dependencies,
-- these funky (---@) comments are just there
--     to help VS Code find the definitions of things

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'LuaENVY-ENVY-auto'
mods['LuaENVY-ENVY'].auto()
-- ^ this gives us `public` and `import`, among others
--    and makes all globals we define private to this plugin.
---@diagnostic disable: lowercase-global

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = _PLUGIN

-- get definitions for the game's globals
---@module 'game'
game = rom.game
---@module 'game-import'
import_as_fallback(game)

---@module 'SGG_Modding-SJSON'
sjson = mods['SGG_Modding-SJSON']
---@module 'SGG_Modding-ModUtil'
modutil = mods['SGG_Modding-ModUtil']

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]
---@module 'SGG_Modding-ReLoad'
reload = mods['SGG_Modding-ReLoad']

---@module 'config'
config = chalk.auto 'config.lua'
-- ^ this updates our `.cfg` file in the config folder!
public.config = config -- so other mods can access our config

function dump(o, depth)
    depth = depth or 0
    if type(o) == 'table' then
        local s = "\n" .. string.rep("\t", depth) .. '{\n'
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. string.rep("\t",(depth+1)) .. '['..k..'] = ' .. dump(v, depth + 1) .. ',\n'
        end
        return s .. string.rep("\t", depth) .. '}'
    elseif type(o) == "string" then
        return "\"" .. o .. "\""
    else
        return tostring(o)
    end
end

local function on_ready()
    -- what to do when we are ready, but not re-do on reload.
    if config.enabled == false then return end
    mod = modutil.mod.Mod.Register(_PLUGIN.guid)
    mod.config = config

    function MergeUptoDepth(base, incoming, depth, currentDepth)
        depth = depth or 0
        currentDepth = currentDepth or 0
        local returnTable = base
        for k, v in pairs( incoming ) do
            if type(v) == "table" and currentDepth<depth then
                if next(v) == nil then
                    returnTable[k] = {}
                else
                    returnTable[k] = MergeUptoDepth( returnTable[k], v, depth, currentDepth + 1 )
                end
            elseif v == "nil" then
                returnTable[k] = nil
            else
                returnTable[k] = v
            end
        end
        return returnTable
    end

    mod.IsZag = rom.mods["NikkelM-Zagreus_Journey"] and
                rom.mods["NikkelM-Zagreus_Journey"].config and
                rom.mods["NikkelM-Zagreus_Journey"].config.enabled

    mod.MaxAllowedBiomeCount = (mod.IsZag and 8) or 8

    import 'visage.lua'
    import 'harvest.lua'
    import 'early_unlock.lua'
    import 'runlength.lua'
    import 'runlength_late.lua'
    import 'music_fix.lua'
    import 'metareward.lua'
end

local function on_reload()
    -- what to do when we are ready, but also again on every reload.
    -- only do things that are safe to run over and over.
    if config.enabled == false then return end
    import 'imgui.lua'
end

local function on_ready_late()
    if config.enabled == false then return end
    import 'visage_late.lua'
end

local function on_reload_late()
    if config.enabled == false then return end
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_multiple()

-- this runs only when modutil and the game's lua is ready
modutil.once_loaded.game(function()
    loader.load("early", on_ready, on_reload)
end)

mods.on_all_mods_loaded(function()
	modutil.once_loaded.game(function()
		loader.load("late", on_ready_late, on_reload_late)
	end)
end)