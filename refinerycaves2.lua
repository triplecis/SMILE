print("SMILE - " .. identifyexecutor() .. " - " .. os.date("%c").. " - []" .. game.PlaceId.. "] - " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) 

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