local type = type

local _M = {}

-- 获取table里的string值
function _M.GetStringValue(key, tb, default)
    if type(tb) ~= "table" or type(tb[key]) ~= "string" then
        return default or ""
    end
    return tb[key]
end


-- 获取table里的数字值
function _M.GetNumberValue(key, tb, default)
    if type(tb) ~= "table" or type(tb[key]) ~= "number" then
        return default or -1
    end
    return tb[key]
end


return _M

