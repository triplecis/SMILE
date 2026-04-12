local PlayersTab = _Tabs.PlayersList:AddLeftGroupbox('Players')
local SelectedPlayerTab = _Tabs.PlayersList:AddLeftGroupbox('Selected Player')

--[[ Player List ]]--
local function getPlayerList()
    local list = {}
    for _, v in pairs(_Players:GetPlayers()) do
        if v ~= _Player then
            table.insert(list, v.Name)
        end
    end
    return list
end

local PlayersPlayerDropdown = PlayersTab:AddDropdown('PlayersPlayerlist', {
    Text = 'Player List',
    Default = nil,
    AllowNull = true,
    Values = {},
    Multi = false,
})

SelectedPlayerTab:AddButton('Teleport to Player', function()
    local targetName = Options.Playerlist.Value
    if not targetName or targetName == "" then return end

    local targetPlayer = _Players:FindFirstChild(targetName)
    if not targetPlayer then return end

    local hrp = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        _LocalRoot.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
    end
end)

SelectedPlayerTab:AddButton('Spectate Player', function()
    local targetName = Options.Playerlist.Value
    if not targetName or targetName == "" then return end

    local targetPlayer = _Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character then return end

    _CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChild("Humanoid")
end)

SelectedPlayerTab:AddButton('Stop Spectating', function()
    _CurrentCamera.CameraSubject = _LocalHumanoid
end)

_Players.PlayerAdded:Connect(function()
    task.wait(1)
    PlayersPlayerDropdown:SetValues(getPlayerList())
end)

_Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    PlayersDropdown:SetValues(getPlayerList())
end)

task.delay(1, function()
    PlayersPlayerDropdown:SetValues(getPlayerList())
end)