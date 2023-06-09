local skynet = require "skynet"
local mysql = require "skynet.db.mysql"

local M = {}

function M.excute(sql)
    if M.m_HandleID then
        skynet.error("[Mysql EXCUTE] : " .. sql)
        local res, err = M.m_HandleID:query(sql)
        if not res then
            skynet.error("[Mysql Error] : mysql query error: " .. err)
            return nil
        end
        return res
    end
    skynet.error("[Mysql Error] : mysql not connected")
    return nil
end

function M.disconnect()
    if M.m_HandleID then
        M.m_HandleID:disconnect()
        M.m_HandleID = nil
    end
end

skynet.start(function ()
    local function onConnect()
        skynet.error("[Mysql] : connect mysql success!")
    end
    M.m_HandleID = mysql.connect(
        {
            host = skynet.getenv("mysql_host"),
            port = skynet.getenv("mysql_port"),
            database = skynet.getenv("mysql_database"),
            user = skynet.getenv("mysql_user"),
            password = skynet.getenv("mysql_password"),
            max_packet_size = skynet.getenv("mysql_max_packet_size"),
            on_connect = onConnect
        }
    )

    if M.m_HandleID == nil then
        skynet.error("[Mysql Error] : connect mysql failed!")
        return false
    end

    skynet.dispatch("lua", function (session, address, cmd, ...)
        local func = assert(M[cmd], string.format("[Mysql Error] : Unknown command %s", tostring(cmd)))
        skynet.ret(skynet.pack(func(...)))
    end)
end)