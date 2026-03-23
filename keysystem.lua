--[[ Key System ]]--
local KeySystem = {}

--[[ Load Config ]]--
local config = loadstring(game:HttpGet('https://pastebin.com/raw/tbnSeXmv' .. '?t=' .. os.time()))()

local API_URL    = config.API_URL
local API_SECRET = config.API_SECRET
local FREE_KEY   = config.FREE_KEY

print('Config loaded - API_URL:', API_URL)

--[[ Storage ]]--
local function saveKey(key)
    pcall(function()
        if not isfolder('SMILE') then makefolder('SMILE') end
        writefile('SMILE/key.txt', key)
    end)
end

local function loadSavedKey()
    local ok, result = pcall(function()
        if isfile('SMILE/key.txt') then
            return readfile('SMILE/key.txt'):gsub('%s+', '')
        end
    end)
    return ok and result or nil
end

local function getHwid()
    local ok, hwid = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return ok and hwid or 'unknown'
end

--[[ Validation ]]--
local function validatePremium(key)
    local ok, response = pcall(function()
        local res = (request or http_request)({
            Url = API_URL .. '/validate?key=' .. key .. '&hwid=' .. getHwid(),
            Method = 'GET',
            Headers = {
                ['x-api-secret'] = API_SECRET
            }
        })
        return res.Body
    end)

    if not ok then
        warn('SMILE: Could not reach key server')
        return false, nil
    end

    local ok2, data = pcall(function()
        return _HttpService:JSONDecode(response)
    end)

    if ok2 and data and data.valid then
        return true, data.tier
    end

    return false, nil
end

function KeySystem:Validate(key)
    key = key:gsub('%s+', ''):upper()

    -- Check free key first (no API needed)
    if key == FREE_KEY:upper() then
        return true, 'free'
    end

    -- Otherwise validate premium via API
    return validatePremium(key)
end

--[[ UI Prompt ]]--
function KeySystem:Prompt()
    -- Try saved key first
    local savedKey = loadSavedKey()
    if savedKey then
        local valid, tier = self:Validate(savedKey)
        if valid then
            print('SMILE: Auto-logged in as [' .. tier .. ']')
            return true, tier
        else
            -- Saved key is no longer valid, delete it
            pcall(function() writefile('SMILE/key.txt', '') end)
        end
    end

    -- Show key prompt
    local KeyWindow = _Linoria.Library:CreateWindow({
        Title = 'SMILE - Key System',
        Center = true,
        AutoShow = true,
        Size = 400,
    })

    local KeyTab = KeyWindow:AddTab('Enter Key')
    local KeyBox = KeyTab:AddLeftGroupbox('Key')
    local StatusBox = KeyTab:AddRightGroupbox('Info')

    StatusBox:AddLabel('Free key available in')
    StatusBox:AddLabel('our Discord server!')
    StatusBox:AddButton('Copy Discord', function()
        setclipboard('discord.gg/yPeD8tx2Vq')
    end)

    KeyBox:AddLabel('Paste your key below:')

    KeyBox:AddInput('KeyInput', {
        Text = 'Key',
        Default = '',
        Placeholder = 'SMILE-XXXX-XXXX',
        Finished = false,
    })

    local statusLabel = KeyBox:AddLabel('Awaiting key...')

    local validated = false
    local userTier  = nil

    KeyBox:AddButton('Validate', function()
        local key = Options.KeyInput.Value
        if not key or key == '' then
            statusLabel:SetText('Please enter a key!')
            return
        end

        statusLabel:SetText('Validating...')

        local valid, tier = self:Validate(key)
        if valid then
            saveKey(key)
            validated = true
            userTier  = tier
            statusLabel:SetText('✅ Valid ' .. tier .. ' key!')
            task.wait(0.5)
            pcall(function() KeyWindow:Destroy() end)
        else
            statusLabel:SetText('❌ Invalid key! Try again.')
        end
    end)

    -- Wait for validation
    repeat task.wait(0.1) until validated

    return validated, userTier
end

return KeySystem