
local type              = type
local require           = require
local global_config     = global_config
local GetStringValue    = require("utils/tools").GetStringValue
local GetNumberValue    = require("utils/tools").GetNumberValue

local _M = {}


-- 获取store
local function getStore()
    if type(global_config) ~= "table" or type(global_config.store) ~= "table" then
        return {}
    end
    return global_config.store
end


-- 获取store类型
function _M.GetStoreType()
    return GetStringValue("type", getStore())
end


-- 获取store uri
function _M.GetStoreHost()
    return GetStringValue("host", getStore())
end


-- 获取store用户名
function _M.GetStoreUser()
    return GetStringValue("user", getStore())
end


-- 获取store密码
function _M.GetStorePassword()
    return GetStringValue("password", getStore())
end


return _M
