local Class = require "common.class"
local errcode = require "common.errcode"

local skynet = require "skynet"
local cjson = require "cjson"

local system = Class:new()

function system:initDB(mysql_db, redis_db)
    self.m_MysqlDB = mysql_db
    self.m_RedisDB = redis_db
end

function system:getUid(token)
    local online_users = skynet.call(self.m_RedisDB, "lua", "get", "OnlineUses")
    online_users = cjson.decode(online_users)
    if online_users then
        return online_users[token]
    end
    return nil
end

function system:getToken(uid)
    local online_users = skynet.call(self.m_RedisDB, "lua", "get", "OnlineUses")
    online_users = cjson.decode(online_users)
    if online_users then
        for token, v in pairs(online_users) do
            if tonumber(v) == tonumber(uid) then
                return token
            end
        end
    end
    return nil
end

function system:setToOnline(uid, token)
    local online_users = skynet.call(self.m_RedisDB, "lua", "get", "OnlineUses") or {}
    if online_users and online_users[token] == nil then
        online_users[token] = uid
        skynet.call(self.m_RedisDB, "lua", "set", "OnlineUses", cjson.encode(online_users))
        skynet.call(self.m_RedisDB, "lua", "set", token, uid)
        return errcode.SUCCEESS
    else
        skynet.error(string.format("[Logic Error] : user uid = %s alredy exists, token is %s", uid, token))
        return errcode.UNKNOWN, self:getToken(uid)
    end
end

function system:checkToken(data)
    local uid = skynet.call(self.m_RedisDB, "lua", "get", data.token)
    if uid then
        skynet.call(self.m_RedisDB, "lua", "expire", data.token, skynet.getenv("redis_token_expire"))
        return uid, errcode.SUCCEESS
    end

    -- 更新在线玩家
    local online_users = skynet.call(self.m_RedisDB, "lua", "get", "OnlineUses")
    online_users = cjson.decode(online_users)
    if online_users then
        online_users[data.token] = nil
        skynet.call(self.m_RedisDB, "lua", "set", "OnlineUses", cjson.encode(online_users))
    end

    return uid, errcode.INVALID_TOKEND
end

return system