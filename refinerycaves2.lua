print('Refinery Caves 2 module loaded')

--[[ Linoria ]]--
local Example = _Tabs.Game:AddLeftGroupbox('Refinery Caves 2')
local LivePlayers = _Tabs.Game:AddRightGroupbox('Live Players')

--[[ Linoria UI]]
Example:AddLabel('No game specific features yet, check back later!')

LivePlayers:AddLabel('This is a list of all players currently in the refinery caves, as long as they are within the distance of the local player.')
LivePlayers:AddDropdown('PlayerList', {}, function() end)
LivePlayers:AddButton('Refresh List', function()
    local playerNames = {}
    for _, player in pairs(workspace.Live:GetChildren()) do
        if player:IsA('Model') and player:FindFirstChild('Humanoid') then
            table.insert(playerNames, player.Name)
        end
    end
    Options.PlayerList:SetOptions(playerNames)
end)

-- Nothing Yet

--[[ Notes

workspace.Live
Stores all players including local, as long as they are within a certain distance.

workspace.Grab
Holds ores and trees under MaterialPart and WoodPart respectively, includes items in the shop stored under Attributes._StoreTag(#STORENAME) -- I believe this also works the same as the Live folder.

workspace.Vehicles
Stores all vehicles including boats.

Vehicle Note:
Each vehicle has a Configuration folder.
In that folder, there can be a variety of numbervalues all with different purposes, and it also stores a folder named "Data".

VEHICLES,
BUGGY CONFIGURATIONS:
DAMPING -- edits out of vehicle, i believe this doesn't work though
FLIPHEIGHT -- doesn't work, i think.
GASTANK
LOWERLIMIT
MAXSPEED
SPEED
STREERANGLE -- edits out of vehicle
STIFFNESS -- edits out of vehicle, i believe this doesn't work though
UPPERLIMIT


BOAT, 
DROPLET CONFIGURATIONS:
ACCELERATION
ANGULARDECCELERATION
DECELERATION
GASTANK
SPEED
STEERSPEED

QUICKWAVE CONFIGURATIONS:
ACCELERATION
ANGULARDECCELERATION
DECELERATION
GASTANK
SPEED
STEERSPEED


workspace.WorldSpawn
Holds all spawned Ores and Trees
Gotta have it refresh overtime, will also add how long till it goes away using it's TimeLeft attribute

workspace.Plots
Each plot has a folder with "Barriers", "Objects" and Wiring.
Following this subject, there's also a script for logic baking
An Object Value for the Owner
A Model named Upgrades filled with parts, all titled from 1 to 24
A Part named Plot and one named ProjectionZone, The plot part is the center of the player's plot. I do not know the purpose of the projectionzone
Lastly there's a Configuration folder with a "Settings" folder

Compass XYZ is exact if teleport to certain spot/coords then at least teleport Y+4(Average R6 Player Height)

Modules are stored in game.ReplicatedStorage for all Trees and Ores with the code.

Places

- Blue Corridor - x1142, y-448, z2636
- 

]]--