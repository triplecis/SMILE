local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'SMILE',
    Center = true,
    AutoShow = true
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Settings = Window:AddTab('Settings')
}

local MainLeftGroupBox = Tabs.Main:AddLeftGroupbox('Example')
local SettingsMenu = Tabs.Settings:AddLeftGroupbox('Menu')
local SettingsThemes = Tabs.Settings:AddRightGroupbox('Themes')
local SettingsConfigs = Tabs.Settings:AddRightGroupbox('Configs')
local SettingsDiscord = Tabs.Settings:AddRightGroupbox('Discord')

--[[ Services ]]--

local _Players = game:GetService("Players")
local _Player = _Players.LocalPlayer
local _LocalCharacter = _Player.Character
local _LocalRoot = _LocalCharacter.HumanoidRootPart
local _LocalHumanoid = _LocalCharacter.Humanoid
local _UserInputService = game:GetService("UserInputService")
local _RunService = game:GetService("RunService")
local _CurrentCamera = workspace.CurrentCamera
local _Mouse = _Player:GetMouse()

local executor = identifyexecutor()

local placeID = game.PlaceId
local jobID = game.JobId
local universeID = game.GameId

--[[local GameModules = {
    [12196278347] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/refinerycaves2.lua', -- Refinery Caves 2
    [192800] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/workatapizzaplace.lua', -- Work at a Pizza Place
    [5523851880] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/8ballpoolclassic.lua', -- 8 Ball Pool Classic
    [2653064683] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/wordbomb.lua' -- Word Bomb
    [142823291] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/murdermystery2.lua' -- Murder Mystery 2
    [277751860] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/epicminigames.lua' -- Epic Minigames
    [6722921118] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/colorbook.lua' -- Color Book
}

local function loadModule(url)
    loadstring(game:HttpGet(url))()
end

loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/universal.lua')

if GameModules[PlaceId] then
    loadModule(GameModules[PlaceId])
else
    print('No specific module for this game, universal only.')
end

]]--
--[[ Linoria ]]--

SettingsMenu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI",
    Callback = function()
        Library.ToggleKeybind = Options.MenuKeybind.Value
    end
})

SettingsMenu:AddButton('Close UI', function()
    Library:Unload()   
end)

SettingsThemes:AddLabel('Placeholder')

SettingsConfigs:AddLabel('Placeholder')

SettingsDiscord:AddButton("Copy Discord", function()
    setclipboard("discord.gg/yPeD8tx2Vq")
end)