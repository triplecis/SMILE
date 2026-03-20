--!strict
local executor = identifyexecutor()

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local _Players = game:GetService("Players")
local _Player = _Players.LocalPlayer
local _LocalCharacter = _Player.Character
local _LocalRoot = _LocalCharacter.HumanoidRootPart
local _LocalHumanoid = _LocalCharacter.Humanoid
local _UserInputService = game:GetService("UserInputService")
local _RunService = game:GetService("RunService")
local _CurrentCamera = workspace.CurrentCamera
local _Mouse = _Player:GetMouse()

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

MainLeftGroupBox:AddToggle('MyToggle', {
    Text = 'Enable Feature',
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

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


_Players.PlayerAdded:Connect(function()
    PlayerDropdown:SetValues(getPlayerList())
end)

_Players.PlayerRemoving:Connect(function()
    PlayerDropdown:SetValues(getPlayerList())
end)