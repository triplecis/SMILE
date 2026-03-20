print('Refinery Caves 2 module loaded')

--[[ Linoria ]]--
local GameGroupBox = _Tabs.Game:AddLeftGroupbox('Refinery Caves 2')

--[[ Linoria UI]]
GameGroupBox:AddLabel('No game specific features yet, check back later!')

-- Nothing Yet

--[[ Notes

workspace.Live
Stores all players, as long as they're in the distance of the local player

workspace.Grab
Has all the grabbable items in the game, includes items in the shop stored under Attributes._StoreTag(#STORENAME) -- I believe this also works the same as the Live folder.

workspace.Vehicles
Stores all vehicles in the game.

workspace.WorldSpawn
Holds all spawned Ores and Trees

Modules are stored in game.ReplicatedStorage for all Trees and Ores with the code.

]]--