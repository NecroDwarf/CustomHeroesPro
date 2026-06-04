require("custom_heroes_pro")
require("utils/timers")

if custom_heroes_pro == nil then
	custom_heroes_pro = class({})
end

function Precache( context )
end

-- Create the game mode when we activate
function Activate()
	custom_heroes_pro:InitGameMode()
end