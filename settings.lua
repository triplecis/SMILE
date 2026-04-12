print('Settings module loaded')

--[[ Groupboxes ]]--
local SettingsMenu = _Tabs.Settings:AddLeftGroupbox('Menu')
local SettingsDiscord = _Tabs.Settings:AddLeftGroupbox('Discord')

--[[ Menu ]]--
SettingsMenu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI",
})

SettingsMenu:AddButton('Close UI', function()
    _Linoria.Library:Unload()
end)

--[[ Discord ]]--
SettingsDiscord:AddButton("Copy Discord", function()
    setclipboard("discord.gg/yPeD8tx2Vq")
end)

--[[ Themes and Configs ]]--
_Linoria.ThemeManager:SetLibrary(_Linoria.Library)
_Linoria.ThemeManager:SetFolder('SMILE/themes')
_Linoria.ThemeManager:ApplyToTab(_Tabs.Settings:AddRightGroupbox('Themes'))

_Linoria.SaveManager:SetLibrary(_Linoria.Library)
_Linoria.SaveManager:IgnoreThemeSettings()
_Linoria.SaveManager:SetFolder('SMILE/configs')
_Linoria.SaveManager:BuildConfigSection(_Tabs.Settings:AddLeftGroupbox('Configs'))

_Linoria.Library.ToggleKeybind = Options.MenuKeybind