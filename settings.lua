print('Settings module loaded')

--[[ Groupboxes ]]--
local SettingsMenu    = _Tabs.Settings:AddLeftGroupbox('Menu')
local SettingsDiscord = _Tabs.Settings:AddLeftGroupbox('Discord')

--[[ Menu ]]--
SettingsMenu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI",
})

_Linoria.Library.ToggleKeybind = Options.MenuKeybind

SettingsMenu:AddButton('Close UI', function()
    _Linoria.Library:Unload()
end)

--[[ Discord ]]--
SettingsDiscord:AddButton("Copy Discord", function()
    setclipboard("discord.gg/yPeD8tx2Vq")
end)

--[[ Setup Managers ]]--
_Linoria.ThemeManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:IgnoreThemeSettings()
_Linoria.ThemeManager:SetFolder('SMILE/themes')
_Linoria.SaveManager:SetFolder('SMILE/configs')

--[[ Themes and Configs ]]--
_Linoria.ThemeManager:BuildThemeSection(_Tabs.Settings:AddRightGroupbox('Themes'))
_Linoria.SaveManager:BuildConfigSection(_Tabs.Settings:AddRightGroupbox('Configs'))