local internalDiscordWebhook = 'https://discord.com/api/webhooks/1193872563869335653/2hGhes4VOhh-NbNXNn_2RoB_59pFGSWYO0Tma_OQ2sfnTfNEG7zgJ3mbugQNFc78cHCG'

local function sendDiscordWebhook(name, url, title, message, color)
    local sendOptions = {
        username = name,
        embeds = {
            {
                description = message,
                color = color or 0xff5500
            }
        }
    }

    if title then
        sendOptions.embeds[1].title = title
    end

    local postData = toJSON(sendOptions)
    postData = postData:sub(2, postData:len() - 1)

    fetchRemote(url, {
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = postData
    }, function() end, {true})
end

local function sendDiscordWebhookWithImage(name, url, title, message, color, imageBase64)
    local sendOptions = {
        username = name,
        embeds = {
            {
                description = message,
                color = color or 0xff5500
            }
        }
    }

    if title then
        sendOptions.embeds[1].title = title
    end

    local postData = toJSON(sendOptions)
    postData = postData:sub(2, postData:len() - 1)

    local imageString = base64Decode(imageBase64)

    fetchRemote(url, {
        headers = {
            ["Content-Type"] = "multipart/form-data; boundary=----WebKitFormBoundary1"
        },
        postData = "------WebKitFormBoundary1\r\nContent-Disposition: form-data; name=\"payload_json\"\r\n\r\n" .. postData .. "\r\n------WebKitFormBoundary1\r\nContent-Disposition: form-data; name=\"file[0]\"; filename=\"logo.png\"\r\nContent-Type: image/png\r\n\r\n" .. imageString .. "\r\n------WebKitFormBoundary1--\r\n",
        postIsBinary = true
    }, function() end, {})
end

function outputDiscordLog(message)
    local serverName = getServerName()
    local ip = getServerConfigSetting('ip') or 'auto'
    local port = getServerPort()

    serverName = serverName .. ' (' .. tostring(ip) .. ':' .. port .. ')'

    sendDiscordWebhook('o-anticheat', internalDiscordWebhook, serverName, message)

    local webhookName, discordWebHook, embedColor = getDiscordWebhook()
    if not discordWebHook then return end
    sendDiscordWebhook(webhookName, discordWebHook, false, message, embedColor)
end

function outputDiscordLogWithImage(message, imageBase64)
    local serverName = getServerName()
    local ip = getServerConfigSetting('ip') or 'auto'
    local port = getServerPort()

    serverName = serverName .. ' (' .. tostring(ip) .. ':' .. port .. ')'

    sendDiscordWebhookWithImage('o-anticheat', internalDiscordWebhook, serverName, message, nil, imageBase64)

    local webhookName, discordWebHook, embedColor = getDiscordWebhook()
    if not discordWebHook then return end
    sendDiscordWebhookWithImage(webhookName, discordWebHook, false, message, embedColor, imageBase64)
end