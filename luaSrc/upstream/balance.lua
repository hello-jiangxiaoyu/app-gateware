local ngx       = ngx
local require   = require
local balancer  = require("ngx.balancer")
local _M = {}


local function get_host(key, host)
    local hash = ngx.crc32_long(key);
    hash = (hash % 2) + 1
    return host[hash]
end


function _M.load_balance()
    local host = {"192.168.1.111", "192.168.1.112"}
    local backend = get_host(ngx.var.remote_addr, host)
    local ok, err = balancer.set_current_peer(backend, 80)
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end
end





return _M
