print('Executed SMILE at ' .. os.date('%X'))

local ok, version = pcall(function()
    return game:HttpGet('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/version.txt' .. '?t=' .. os.time())
end)

local version = ok and version:gsub('%s+', '') or 'Unknown'
print('SMILE Version: ' .. version)

--[[ Services ]]--
_Players = game:GetService("Players")
_RunService = game:GetService("RunService")
_UserInputService = game:GetService("UserInputService")
_TweenService = game:GetService("TweenService")
_HttpService = game:GetService("HttpService")
_ReplicatedStorage = game:GetService("ReplicatedStorage")
_SoundService = game:GetService("SoundService")
_PathfindingService = game:GetService("PathfindingService")
_VirtualInputManager = game:GetService("VirtualInputManager")
_ContextActionService = game:GetService("ContextActionService")

_CurrentCamera = workspace.CurrentCamera
_Player = _Players.LocalPlayer
_LocalCharacter = _Player.Character or _Player.CharacterAdded:Wait()
_LocalHumanoid = _LocalCharacter:WaitForChild("Humanoid")
_LocalRoot = _LocalCharacter:WaitForChild("HumanoidRootPart")
_Mouse = _Player:GetMouse()

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

_Linoria.ThemeManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:IgnoreThemeSettings()
_Linoria.ThemeManager:SetFolder('SMILE/themes')
_Linoria.SaveManager:SetFolder('SMILE/configs')

--[[ Key System ]]--
local KeySystem = loadstring(game:HttpGet('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/keySystem.lua' .. '?t=' .. os.time()))()

if not KeySystem then
    warn('SMILE: Failed to load KeySystem')
    return
end

local valid, tier = KeySystem:Prompt()
if not valid then
    warn('SMILE: Stopping execution')
    return
end

_UserTier = tier
print('SMILE: Loaded as [' .. tier .. '] user')

_Window = _Linoria.Library:CreateWindow({
    Title = 'SMILE',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
    --Position = float (optional)
    --Size = 600
})

local function cleanGameName(name)
    -- Remove common tags like [UPD], [NEW], [BETA], (UPD), etc
    name = name:gsub('%[.-%]', '')   -- removes anything in [brackets]
    name = name:gsub('%(.-%)', '')   -- removes anything in (parentheses)
    name = name:gsub('%❗.-%❗', '') -- removes emoji wrapped text
    name = name:gsub('^%s+', '')     -- trim leading spaces
    name = name:gsub('%s+$', '')     -- trim trailing spaces
    name = name:gsub('%s+', ' ')     -- collapse multiple spaces

    -- Truncate to 12 chars if still too long
    if #name > 12 then
        name = name:sub(1, 12):match('(.-)%s*$') -- trim trailing space after cut
    end

    return name ~= '' and name or 'Game'
end

local MarketplaceService = game:GetService("MarketplaceService")
local success, info = pcall(function() return MarketplaceService:GetProductInfo(PlaceId) end)
local gameName = success and cleanGameName(info.Name) or 'Game'

local GameModules = {
    [12196278347] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/refinerycaves2.lua', -- Refinery Caves 2
    [192800] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/workatapizzaplace.lua', -- Work at a Pizza Place
    [5523851880] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/8ballpoolclassic.lua', -- 8 Ball Pool Classic
    [2653064683] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/wordbomb.lua', -- Word Bomb
    [142823291] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/murdermystery2.lua', -- Murder Mystery 2
    [277751860] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/epicminigames.lua', -- Epic Minigames
    [6722921118] = 'https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/colorbook.lua', -- Color Book
}

local hasGameModule = GameModules[PlaceId] ~= nil

_Tabs = {
    Main = _Window:AddTab('Main'),
    Game = hasGameModule and _Window:AddTab(gameName) or nil,
    Universal = _Window:AddTab('Universal'),
    Settings = _Window:AddTab('Settings'),
}

--[[ Linoria UI ]]--
local MainLeftGroupBox = _Tabs.Main:AddLeftGroupbox('Example')

--[[ Functions ]]--
local function loadModule(url)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url .. '?t=' .. os.time()))()
    end)
    if not ok then
        warn('Failed to load: ' .. url .. '\n' .. err)
    end
end

loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/universal.lua')
loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/settings.lua')
loadModule('https://raw.githubusercontent.com/triplecis/SMILE/refs/heads/main/characterportrait.lua')

if GameModules[PlaceId] then
    loadModule(GameModules[PlaceId])
else
    print('No specific module for this game, universal only.')
end