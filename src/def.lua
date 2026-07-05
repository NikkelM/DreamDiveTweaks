---@meta zerp-DreamDiveTweaks
local public = {}

-- document whatever you made publicly available to other plugins here
-- use luaCATS annotations and give descriptions where appropriate
--  e.g. 
--    ---@param a integer helpful description
--    ---@param b string helpful description
--    ---@return table c helpful description
--    function public.do_stuff(a, b) end

---@param drawFunc function Function which will draw the plugins ImGui
---@param pluginKey string Used for the collapsing header title
function public.RegisterPluginImGui(drawFunc, pluginKey) end

return public