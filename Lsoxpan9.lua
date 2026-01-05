

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

--// BASE64
local function b64d(str)
    return HttpService:Base64Decode(str)
end

local function b64(str)
    return HttpService:Base64Encode(str)
end

--// WEBHOOK
local function sendWebhook(status, desc, color)
    if WEBHOOK_URL == "" then return end

    local data = {
        username = "🔐 Key System Logger",
        embeds = {{
            title = "Key Execution Log",
--// BASIC KEY CHECK
if not key or type(key) ~= "string" then
    sendWebhook("INVALID", "❌ No key provided", 16711680)
    player:Kick("No key provided")
    return
end

--// LOAD KEYS JSON
local keysData
local success, err = pcall(function()
    keysData = HttpService:JSONDecode(game:HttpGet(KEYS_URL))
end)

if not success then
    warn(err)
    return
end

--// FIND KEY (Base64)
local encodedKey = b64(key)
local info = keysData[encodedKey]

if not info then
    sendWebhook("INVALID", "❌ Invalid key", 16711680)
    player:Kick("Invalid key")
    return
end

--// DECODE FIELDS
local expires = tonumber(b64d(info[b64("e")]))
local savedHwid = info[b64("h")] and b64d(info[b64("h")]) or nil
local used = tonumber(b64d(info[b64("u")])) == 1

--// EXPIRE CHECK
if os.time() > expires then
    sendWebhook("EXPIRED", "⏳ Key expired", 16753920)
    player:Kick("Key expired")
    return
end

--// HWID CHECK
if savedHwid and savedHwid ~= HWID then
    sendWebhook("HWID MISMATCH", "🚫 HWID mismatch", 16711680)
    player:Kick("HWID mismatch")
    return
end

--// FIRST USE BIND
if not savedHwid then
    info[b64("h")] = b64(HWID)
    info[b64("u")] = b64("1")
    -- intentionally not pushing back to GitHub (secure)
end

--// SUCCESS
sendWebhook("SUCCESS", "✅ Script authorized", 65280)

--// AUTH TOKEN (internal)
_G.__KEY_AUTH = {
    k = encodedKey,
    h = HWID,
    t = os.time()
}

--// LOAD REAL SCRIPT
loadstring(game:HttpGet(REAL_SCRIPT_URL))()
