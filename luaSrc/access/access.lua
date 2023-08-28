
local ngx       = ngx
local require   = require
local rate      = require("access/ipLimit")

local _M = {}


-- access阶段处理函数
function _M:AccessHandler()
    rate.limit()
end


return _M
