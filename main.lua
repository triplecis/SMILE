print('Executed SMILE at ' .. os.date('%X'))

--[[ Services ]]--
local _Players = game:GetService("Players")
local _RunService = game:GetService("RunService")
local _UserInputService = game:GetService("UserInputService")
local _TweenService = game:GetService("TweenService")
local _HttpService = game:GetService("HttpService")
local _ReplicatedStorage = game:GetService("ReplicatedStorage")
local _SoundService = game:GetService("SoundService")
local _PathfindingService = game:GetService("PathfindingService")
local _VirtualInputManager = game:GetService("VirtualInputManager")
local _ContextActionService = game:GetService("ContextActionService")

local _CurrentCamera = workspace.CurrentCamera
local _Player = _Players.LocalPlayer
local _LocalCharacter = _Player.Character or _Player.CharacterAdded:Wait()
local _LocalHumanoid = _LocalCharacter:WaitForChild("Humanoid")
local _LocalRoot = _LocalCharacter:WaitForChild("HumanoidRootPart")
local _Mouse = _Player:GetMouse()

--[[ Executor / Game Info ]]--
local Executor = identifyexecutor and identifyexecutor() or "Unknown"
local PlaceId = game.PlaceId
local JobId = game.JobId
local GameId = game.GameId

--[[ Linoria ]]--
_Linoria = {
    Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))(),
    ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua'))(),
    SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua'))(),
}

_Window = _Linoria.Library:CreateWindow({
    Title = 'SMILE',
    Center = true,
    AutoShow = true,
})

local MarketplaceService = game:GetService("MarketplaceService")
local success, info = pcall(function() return MarketplaceService:GetProductInfo(PlaceId) end)
local gameName = success and info.Name:sub(1, 12) or "Game"

_Tabs = {
    Main = _Window:AddTab('Main'),
    Game = _Window:AddTab(gameName),
    Universal = _Window:AddTab('Universal'),
    Settings = _Window:AddTab('Settings'),
}

--[[ Linoria UI ]]--
local MainLeftGroupBox = _Tabs.Main:AddLeftGroupbox('Example')


--[[ Game Modules ]]--
local GameModules = {
    [12196278347] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/refinerycaves2.lua', -- Refinery Caves 2
    [192800] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/workatapizzaplace.lua', -- Work at a Pizza Place
    [5523851880] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/8ballpoolclassic.lua', -- 8 Ball Pool Classic
    [2653064683] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/wordbomb.lua', -- Word Bomb
    [142823291] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/murdermystery2.lua', -- Murder Mystery 2
    [277751860] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/epicminigames.lua', -- Epic Minigames
    [6722921118] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/colorbook.lua', -- Color Book
}

--[[ Functions ]]--
local function loadModule(url)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn('Failed to load: ' .. url .. '\n' .. err)
    end
end

loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/universal.lua')
loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/settings.lua')

if GameModules[PlaceId] then
    loadModule(GameModules[PlaceId])
else
    _Tabs.Game:SetVisible(false)
    print('No specific module for this game, universal only.')
end