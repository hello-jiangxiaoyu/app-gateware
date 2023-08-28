local ngx           = ngx
local require       = require
local file          = require("utils/file")
local json_decode   = require("cjson.safe").decode

local _M = {}


-- 初始化全局配置
function _M.InitGlobalConfig()
    local data = file.read_file("/usr/local/openresty/nginx/conf/conf/gateway.json")
    global_config = json_decode(data)  -- todo: 线程安全，支持定时刷新
end


return _M
