ZYStorage = class("ZYStorage")

function ZYStorage:ctor()

end

function ZYStorage:set(key, val, unique)
    unique = unique or false

    if val == nil then
        return
    end

    if unique then
        key = self:key(key)
    end

    cc.UserDefault:getInstance():setStringForKey(key, table.serialize(val))
    cc.UserDefault:getInstance():flush()
end

function ZYStorage:get(key, unique, default)
    unique = unique or false

    if unique then
        key = self:key(key)
    end

    local info = cc.UserDefault:getInstance():getStringForKey(key)
    if string.len(info) == 0 then
        return default
    end

    local result = table.unserialize(info)

    return result
end

function ZYStorage:del(key, unique)
    unique = unique or false

    if unique then
        key = self:key(key)
    end
    cc.UserDefault:getInstance():deleteValueForKey(key)
end

function ZYStorage:key(name)
    return "unique" .. name
end

function ZYStorage:getInstance()
    if not self._instance then
        self._instance = ZYStorage.new()
    end

    return self._instance
end

return ZYStorage
