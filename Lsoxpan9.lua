

--// CONFIG
local KEYS_URL = "https://raw.githubusercontent.com/sonfor50/76qKBTHWgc/main/uKhEwlemiVO7ByU7cPs722Muod9t3JdQ.json"
local REAL_SCRIPT_URL = "https://raw.githubusercontent.com/sonfor50/SDAL7hdSU7/main/6c799sCG7LB9A8GfQhazbZY9fN4eU51398DwFCKf12SbF74L74q4p3YB6s4cbs8i.Lua"

local WEBHOOK_URL = "https://discord.com/api/webhooks/1457792277966618900/YyxUT4vBHL-Rxq98QafcH6wF_WYBSIM0wcDvW2sMqibConh1YJmrsQhBzl2KWlokk_mI"

--// SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local player = Players.LocalPlayer

--// HWID
local HWID = RbxAnalytics:GetClientId()

--// WEBHOOK FUNCTION
local function sendWebhook(status, desc, color)
    local data = {
        username = "🔐 Key System Logger",
        embeds = {{
            title = "Key Execution Log",
            description = desc,
            color = color,
            fields = {
                {
                    name = "👤 Player",
                    value = player.Name .. " (" .. player.UserId .. ")",
                    inline = true
                },
                {
                    name = "💻 HWID",
                    value = HWID,
                    inline = false
                },
                {
                    name = "🔑 Key",
                    value = tostring(key),
                    inline = false
                },
                {
                    name = "📌 Status",
                    value = status,
                    inline = true
                }
            },
            footer = {
                text = "Test Key System • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }

    pcall(function()
        HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

--// BASIC KEY CHECK
if not key then
    sendWebhook("INVALID", "❌ No key provided", 16711680)
    player:Kick("No key provided")
    return
end

--// LOAD KEYS
local keys
local ok, err = pcall(function()
    keys = HttpService:JSONDecode(game:HttpGet(KEYS_URL))
end)

if not ok then
    warn(err)
    sendWebhook("ERROR", "❌ Failed to load keys JSON", 16711680)
    player:Kick("Failed to load keys")
    return
end

local info = keys[key]
if not info then
    sendWebhook("INVALID", "❌ Invalid key used", 16711680)
    player:Kick("Invalid key")
    return
end

--// EXPIRE CHECK
if os.time() > info.expires then
    sendWebhook("EXPIRED", "⏳ Key expired", 16753920)
    player:Kick("Key expired")
    return
end

--// HWID CHECK
if info.hwid and info.hwid ~= HWID then
    sendWebhook("HWID MISMATCH", "🚫 HWID does not match", 16711680)
    player:Kick("HWID mismatch")
    return
end

--// FIRST USE BIND
if not info.hwid then
    info.hwid = HWID
    info.used = true
end

--// SUCCESS
sendWebhook("SUCCESS", "✅ Script authorized successfully", 65280)

--// AUTH TOKEN
_G.__KEY_AUTH = {
    h = HWID,
    k = key,
    t = os.time()
}

--// LOAD REAL SCRIPT
loadstring(game:HttpGet("https://raw.githubusercontent.com/sonfor50/SDAL7hdSU7/main/6c799sCG7LB9A8GfQhazbZY9fN4eU51398DwFCKf12SbF74L74q4p3YB6s4cbs8i.Lua"))()
