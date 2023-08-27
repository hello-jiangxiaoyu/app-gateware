local require   = require
local conf      = require("conf.system")
local consul    = require("store/consul")
local file    = require("store/file")

local _M = {}


-- 获取store类型
function _M.GetStoreInterface()
    local tp = conf.GetStoreType()
    if tp == "consul" then
         return consul
    elseif tp == "file" then
       return file 
    end
        
    return nil
end


return _M
