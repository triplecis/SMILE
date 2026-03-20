print('Universal module loaded')

--[[ Linoria ]]--
local UniversalMovement = _Tabs.Universal:AddLeftGroupbox('Movement')
local UniversalUtilities = _Tabs.Universal:AddLeftGroupbox('Utilities')
local UniversalCamera = _Tabs.Universal:AddLeftGroupbox('Camera')
local UniversalWorld = _Tabs.Universal:AddRightGroupbox('World')
local UniversalRender = _Tabs.Universal:AddRightGroupbox('Render')

--[[ Services ]]--
local _RunService = game:GetService("RunService")
local _UserInputService = game:GetService("UserInputService")
local _Players = game:GetService("Players")
local _Player = _Players.LocalPlayer
local _LocalCharacter = _Player.Character
local _LocalRoot = _LocalCharacter and _LocalCharacter:FindFirstChild("HumanoidRootPart")
local _LocalHumanoid = _LocalCharacter and _LocalCharacter:FindFirstChild("Humanoid")
local _CurrentCamera = workspace.CurrentCamera
local _Mouse = _Player:GetMouse()

--[[ Functions / Code ]]--
local flying = false
local speed = 60
local velocity = Vector3.zero
local bodyVel
local bodyGyro

local ESPObjects = {}
local ChamsObjects = {}
local TracerObjects = {}
local NametagObjects = {}
local HealthbarObjects = {}

--[[ Noclip Fly ]]--
local function getChar()
	_LocalCharacter = _Player.Character or _Player.CharacterAdded:Wait()
	_LocalHumanoid = _LocalCharacter:WaitForChild("Humanoid")
	_LocalRoot = _LocalCharacter:WaitForChild("HumanoidRootPart")
end

getChar()

_Player.CharacterAdded:Connect(function()
	task.wait(1)
	getChar()
end)

local function setNoclip(state)
	if not _LocalCharacter then return end
	for _,v in pairs(_LocalCharacter:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = not state
		end
	end
end

local function startFly()
	if flying then return end
	flying = true
	bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce, bodyVel.Velocity, bodyVel.Parent = Vector3.new(1e6,1e6,1e6), Vector3.zero, _LocalRoot
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque, bodyGyro.CFrame, bodyGyro.Parent = Vector3.new(1e6,1e6,1e6), _LocalRoot.CFrame, _LocalRoot
	_LocalHumanoid.PlatformStand = true
end

local function stopFly()
	flying = false
	if bodyVel then bodyVel:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	setNoclip(false)
	_LocalHumanoid.PlatformStand = false
end

_RunService.RenderStepped:Connect(function()
	if not flying or not _LocalRoot then return end
	setNoclip(true)
	local cam = _CurrentCamera
	local UIS = _UserInputService
	local isDown = function(k) return UIS:IsKeyDown(Enum.KeyCode[k]) end

	local moveDir =
		(isDown("W") and cam.CFrame.LookVector or Vector3.zero) +
		(isDown("S") and -cam.CFrame.LookVector or Vector3.zero) +
		(isDown("A") and -cam.CFrame.RightVector or Vector3.zero) +
		(isDown("D") and cam.CFrame.RightVector or Vector3.zero) +
		(isDown("Space") and Vector3.yAxis or Vector3.zero) +
		(isDown("LeftShift") and -Vector3.yAxis or Vector3.zero)

	velocity = velocity:Lerp(moveDir.Magnitude > 0 and moveDir.Unit * speed or Vector3.zero, 0.2)
	bodyVel.Velocity = velocity
	bodyGyro.CFrame = cam.CFrame
end)

--[[ Infinite Jump ]]--
_UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump.Value then
        _LocalHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end 
end)

--[[ Noclip ]]--
_RunService.Stepped:Connect(function()
    if Toggles.Noclip.Value and _LocalCharacter then
        for _, v in pairs(_LocalCharacter:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end  
    end 
end)

--[[ Click Teleport ]]--
_UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if _UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggles.ClickTP.Value and _LocalCharacter and _LocalRoot then
            _LocalRoot.CFrame = CFrame.new(_Mouse.Hit.Position)
        end
    end
end)

--[[ ESP ]]--
local function removeESP()
    for _, objects in pairs(ESPObjects) do
        for _, obj in pairs(objects) do
            obj:Remove()
        end
    end
    ESPObjects = {}
end

local function createBox(player)
    if player == _Player then return end
    ESPObjects[player] = {}

    local function applyBox(character)
        if ESPObjects[player] then
            for _, obj in pairs(ESPObjects[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
            ESPObjects[player] = {}
        end

        local hrp = character:WaitForChild("HumanoidRootPart")

        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Size = Vector3.new(3.5, 5, 2)
        box.Offset = CFrame.new(0, 0.5, 0)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0
        box.Parent = game.CoreGui

        table.insert(ESPObjects[player], box)

        player.CharacterRemoving:Connect(function()
            if box and box.Parent then box:Destroy() end
        end)
    end

    if player.Character then
        applyBox(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if Toggles.ESPBox.Value then
            applyBox(char)
        end
    end)
end

local function createESP(player)
    if player == _Player then return end
    ESPObjects[player] = {}

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5

    table.insert(ESPObjects[player], highlight)

    player.CharacterAdded:Connect(function(char)
        if Toggles.ESP.Value then
            highlight.Parent = char
        end
    end)

    if player.Character then
        highlight.Parent = player.Character
    end
end

--[[ Chams ]]--
local function removeChams()
    for _, objects in pairs(ChamsObjects) do
        for _, obj in pairs(objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
    end
    ChamsObjects = {}
end

local function createChams(player)
    if player == _Player then return end
    ChamsObjects[player] = {}

    local function applyChams(character)
        if ChamsObjects[player] then
            for _, obj in pairs(ChamsObjects[player]) do
                if obj and obj.Parent then obj:Destroy() end
            end
            ChamsObjects[player] = {}
        end

        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        highlight.Parent = game.CoreGui

        table.insert(ChamsObjects[player], highlight)

        player.CharacterRemoving:Connect(function()
            if highlight and highlight.Parent then highlight:Destroy() end
        end)
    end

    if player.Character then
        applyChams(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if Toggles.Chams.Value then
            applyChams(char)
        end
    end)
end

--[[ Tracers ]]--
local function removeTracers()
    for _, obj in pairs(TracerObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    TracerObjects = {}
end

local function createTracer(player)
    if player == _Player then return end

    local function applyTracer(character)
        if TracerObjects[player] then
            if TracerObjects[player] and TracerObjects[player].Parent then
                TracerObjects[player]:Destroy()
            end
        end

        local hrp = character:WaitForChild("HumanoidRootPart")

        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Transparency = 1
        line.Visible = true

        TracerObjects[player] = line

        local connection
        connection = _RunService.RenderStepped:Connect(function()
            if not Toggles.Tracers.Value or not hrp or not hrp.Parent then
                line:Remove()
                connection:Disconnect()
                return
            end

            local screenPos, onScreen = _CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                line.Visible = true
                line.From = Vector2.new(_CurrentCamera.ViewportSize.X / 2, _CurrentCamera.ViewportSize.Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            else
                line.Visible = false
            end
        end)

        player.CharacterRemoving:Connect(function()
            line:Remove()
            connection:Disconnect()
        end)
    end

    if player.Character then
        applyTracer(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if Toggles.Tracers.Value then
            applyTracer(char)
        end
    end)
end

--[[ Nametags ]]--
local function removeNametags()
    for _, objects in pairs(NametaggerObjects) do
        for _, obj in pairs(objects) do
            if obj then obj:Remove() end
        end
    end
    NametaggerObjects = {}
end

local function createNametag(player)
    if player == _Player then return end
    NametaggerObjects[player] = {}

    local function applyNametag(character)
        if NametaggerObjects[player] then
            for _, obj in pairs(NametaggerObjects[player]) do
                if obj then obj:Remove() end
            end
            NametaggerObjects[player] = {}
        end

        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        local name = Drawing.new("Text")
        name.Text = player.Name
        name.Size = 14
        name.Center = true
        name.Outline = true
        name.OutlineColor = Color3.fromRGB(0, 0, 0)
        name.Color = Color3.fromRGB(255, 255, 255)
        name.Visible = true

        local health = Drawing.new("Text")
        health.Size = 12
        health.Center = true
        health.Outline = true
        health.OutlineColor = Color3.fromRGB(0, 0, 0)
        health.Color = Color3.fromRGB(0, 255, 0)
        health.Visible = true

        table.insert(NametaggerObjects[player], name)
        table.insert(NametaggerObjects[player], health)

        local connection
        connection = _RunService.RenderStepped:Connect(function()
            if not Toggles.Nametags.Value or not hrp or not hrp.Parent then
                name:Remove()
                health:Remove()
                connection:Disconnect()
                return
            end

            local screenPos, onScreen = _CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))

            if onScreen then
                name.Visible = true
                health.Visible = true
                name.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                health.Text = string.format("[%d/%d]", humanoid.Health, humanoid.MaxHealth)
                health.Color = Color3.fromRGB(
                    255 - (humanoid.Health / humanoid.MaxHealth * 255),
                    humanoid.Health / humanoid.MaxHealth * 255,
                    0
                )
                health.Position = Vector2.new(screenPos.X, screenPos.Y - 8)
            else
                name.Visible = false
                health.Visible = false
            end
        end)

        player.CharacterRemoving:Connect(function()
            name:Remove()
            health:Remove()
            connection:Disconnect()
        end)
    end

    if player.Character then
        applyNametag(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if Toggles.Nametags.Value then
            applyNametag(char)
        end
    end)
end

--[[ Healthbars ]]--
local function removeHealthbars()
    for _, objects in pairs(HealthbarObjects) do
        for _, obj in pairs(objects) do
            if obj then obj:Remove() end
        end
    end
    HealthbarObjects = {}
end

local function createHealthbar(player)
    if player == _Player then return end
    HealthbarObjects[player] = {}

    local function applyHealthbar(character)
        if HealthbarObjects[player] then
            for _, obj in pairs(HealthbarObjects[player]) do
                if obj then obj:Remove() end
            end
            HealthbarObjects[player] = {}
        end

        local hrp = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        -- Background bar
        local background = Drawing.new("Square")
        background.Filled = true
        background.Color = Color3.fromRGB(0, 0, 0)
        background.Transparency = 1
        background.Visible = true

        -- Health fill bar
        local bar = Drawing.new("Square")
        bar.Filled = true
        bar.Transparency = 1
        bar.Visible = true

        -- Border outline
        local border = Drawing.new("Square")
        border.Filled = false
        border.Color = Color3.fromRGB(0, 0, 0)
        border.Thickness = 1
        border.Transparency = 1
        border.Visible = true

        table.insert(HealthbarObjects[player], background)
        table.insert(HealthbarObjects[player], bar)
        table.insert(HealthbarObjects[player], border)

        local barWidth = 4
        local barHeight = 50

        local connection
        connection = _RunService.RenderStepped:Connect(function()
            if not Toggles.Healthbars.Value or not hrp or not hrp.Parent then
                background:Remove()
                bar:Remove()
                border:Remove()
                connection:Disconnect()
                return
            end

            local topPos, topOnScreen = _CurrentCamera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
            local botPos, botOnScreen = _CurrentCamera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

            if topOnScreen and botOnScreen then
                background.Visible = true
                bar.Visible = true
                border.Visible = true

                local healthPercent = humanoid.Health / humanoid.MaxHealth
                local currentHeight = barHeight * healthPercent

                local xPos = topPos.X - 30
                local yTop = topPos.Y
                local yBot = botPos.Y
                local dynHeight = yBot - yTop

                -- Background
                background.Size = Vector2.new(barWidth, dynHeight)
                background.Position = Vector2.new(xPos, yTop)

                -- Health fill (grows from bottom)
                bar.Size = Vector2.new(barWidth, dynHeight * healthPercent)
                bar.Position = Vector2.new(xPos, yTop + dynHeight * (1 - healthPercent))
                bar.Color = Color3.fromRGB(
                    255 - (healthPercent * 255),
                    healthPercent * 255,
                    0
                )

                -- Border
                border.Size = Vector2.new(barWidth, dynHeight)
                border.Position = Vector2.new(xPos, yTop)
            else
                background.Visible = false
                bar.Visible = false
                border.Visible = false
            end
        end)

        player.CharacterRemoving:Connect(function()
            background:Remove()
            bar:Remove()
            border:Remove()
            connection:Disconnect()
        end)
    end

    if player.Character then
        applyHealthbar(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        if Toggles.Healthbars.Value then
            applyHealthbar(char)
        end
    end)
end

--[[ Linoria UI ]]--

UniversalMovement:AddToggle('FlyToggle', {
    Text = 'Flight',
    Tooltip = 'Toggle Flight',
    Callback = function(Value)
        if Value then
            startFly()
        else
            stopFly()
        end
    end
})

UniversalMovement:AddSlider('FlySpeed', {
    Text = 'Flight Speed',
    Default = 60,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
        speed = Value  
    end
})

UniversalMovement:AddLabel("Fly Keybind"):AddKeyPicker("FlyKey", {
	Default = "",
	Mode = "Toggle",
	Text = "Fly Key",

	Callback = function()
		Toggles.FlyToggle:SetValue(not Toggles.FlyToggle.Value)
	end
})

UniversalMovement:AddSlider('Walkspeed', {
    Text = 'Walkspeed',
    Default = 16,
    Min = 0,
    Max = 250,
    Rounding = 0
})
if _LocalHumanoid.UseJumpPower == false then
    UniversalMovement:AddSlider('JumpHeight', {
        Text = 'JumpHeight',
        Tooltip = 'Default: 7.2',
        Default = 7.2,
        Min = 0,
        Max = 250,
        Rounding = 0,
        Callback = function(Value)
            _LocalHumanoid.JumpHeight = Value
        end
    })
else 
    UniversalMovement:AddSlider('Jumppower', {
        Text = 'JumpPower',
        Tooltip = 'Default: 50',
        Default = 50,
        Min = 0,
        Max = 250,
        Rounding = 0,
        Callback = function(Value)
            _LocalHumanoid.JumpPower = Value
        end
    })
end

UniversalMovement:AddToggle('InfiniteJump', {
    Text = "Infinite Jump",
    Default = false
})

UniversalMovement:AddToggle('Noclip', {
    Text = "Noclip",
    Default = false
})

UniversalMovement:AddToggle('ClickTP', {
    Text = 'ClickTP',
    Tooltip = 'Left Control + Left Click',
    Default = false,
})

UniversalUtilities:AddToggle('ESP', {
    Text = 'Player ESP',
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createESP(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.ESP.Value then
                    createESP(player)
                end
            end)
        else
            removeESP()
        end
    end
})

UniversalUtilities:AddToggle('Boxes', {
    Text = 'ESP Boxes',
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createBox(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.ESPBox.Value then
                    createBox(player)
                end
            end)
        else
            removeESP()
        end
    end
})

UniversalUtilities:AddToggle('Chams', {
    Text = 'Chams',
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createChams(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.Chams.Value then
                    createChams(player)
                end
            end)
        else
            removeChams()
        end
    end
})

UniversalUtilities:AddToggle('Tracers', {
    Text = 'Tracers'
    Default = false,
     Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createTracer(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.Tracers.Value then
                    createTracer(player)
                end
            end)
        else
            removeTracers()
        end
    end
})

UniversalUtilities:AddToggle('Nametags', {
    Text = 'Name tags'
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createNametag(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.Nametags.Value then
                    createNametag(player)
                end
            end)
        else
            removeNametags()
        end
    end
})

UniversalUtilities:AddToggle('Healthbar', {
    Text = 'Healthbar',
    Default = false,
    Callback = function(value)
        if value then
            for _, player in pairs(_Players:GetPlayers()) do
                createHealthbar(player)
            end
            _Players.PlayerAdded:Connect(function(player)
                if Toggles.Healthbars.Value then
                    createHealthbar(player)
                end
            end)
        else
            removeHealthbars()
        end
    end
})



_Players.PlayerAdded:Connect(function()
    PlayerDropdown:SetValues(getPlayerList())
end)

_Players.PlayerRemoving:Connect(function()
    PlayerDropdown:SetValues(getPlayerList())
end)