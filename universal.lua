local UniversalTab = Window:AddTab('Universal')

local UniversalMovement = Tabs.Universal:AddLeftGroupbox('Movement')
local UniversalUtilities = Tabs.Universal:AddLeftGroupbox('Utilities')

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

_UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJump.Value then
        _LocalHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end 
end)

_RunService.Stepped:Connect(function()
    if Toggles.Noclip.Value and _LocalCharacter then
        for _, v in pairs(_LocalCharacter:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end  
    end 
end)
_UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if _UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Toggles.ClickTP.Value and _LocalCharacter and _LocalRoot then
            _LocalRoot.CFrame = CFrame.new(_Mouse.Hit.Position)
        end
    end
end)

--[[ Linoria ]]--

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
    Text = 'ESP',
    Default = false,
})

UniversalUtilities:AddToggle('Chams', {
    Text = 'Chams',
    
})

UniversalUtilities:AddToggle('Tracers', {
    Text = 'Tracers'
})

UniversalUtilities:AddToggle('Nametags', {
    Text = 'Name tags'
})