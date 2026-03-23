local ReplicatedMaps = _ReplicatedStorage:WaitForChild('Maps')

--[[ Color Book 

Nothing yet

]]--

--[[ Linoria ]]--
local LeftGroup = _Tabs.Game:AddLeftGroupbox('Color Book')
local RightGroupAF = _Tabs.Game:AddRightGroupbox('Autofarm')

--[[ Linoria UI]]
LeftGroup:AddLabel('No real game specific features yet, check back later!')
LeftGroup:AddButton({
    Text = 'Paint All',
    Func = function()
        print('Paint All button clicked')
    end
    DoubleClick = false,
    Tooltip = 'Paints all unpainted tiles on the map',
})

RightGroupAF:AddLabel('No game specific features yet, check back later!') -- Goes through all maps in the game and paints all unpainted tiles.
RightGroupAF:AddToggle('AutofarmToggle', {
    Text = 'Autofarm',
    Default = false,
    Tooltip = 'Automatically paints all unpainted tiles in the game',
    Callback = function(state)
        print('Autofarm toggled: ' .. tostring(state))
    end
})