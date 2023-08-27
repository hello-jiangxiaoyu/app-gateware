local ngx       = ngx
local type      = type
local math      = math
local next      = next
local require   = require
local ngx_var   = ngx.var
local store     = require("store.common")
local balancer  = require("ngx.balancer")
local json_encode = require("cjson.safe").encode
local _M = {}


-- 获取后端ip列表
local function getHostList(host, key)
    local itf = store.GetStoreInterface(); if not itf then
        return {}
    end
    return itf.GetHostList(host, key)
end


-- 从host列表中随机挑一个
local function pickHost(key, hosts)
    if type(hosts) ~= "table" or next(hosts) == nil then
        return ""
    end

    local hash = math.random(1, #hosts)
    return hosts[hash]
end


-- 设置反向代理ip
function _M.LoadBalance()
    local host = getHostList(ngx.var.http_host, "quick_auth")
    local backend = pickHost(ngx.var.remote_addr, host)
    ngx.log(ngx.INFO, "backend: ", backend)
    local ok, err = balancer.set_current_peer(backend, 80)
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end
end


return _M
