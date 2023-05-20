
local _M = {}
local require = require
local ngx = require("ngx")
local limit_count = require "resty.limit.count"
local newLimit = limit_count.new

function _M.limit()
    local lim, err = newLimit("s_ip_limit", 3, 1)  -- 限流规则: 每秒3次
    if not lim then
        ngx.log(ngx.ERR, "new limit err: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    ngx.header["X-RateLimit-Limit"] = "3"
    local ip = ngx.var.binary_remote_addr  -- 客户端二进制形式ip
    local delay, err = lim:incoming(ip, true)
    if not delay then
        if err == "rejected" then
            ngx.header["X-RateLimit-Remaining"] = "0"
            ngx.say("too many request")
            return ngx.exit(ngx.HTTP_TOO_MANY_REQUESTS)
        end

        ngx.log(ngx.ERR, "limit err: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    ngx.header["X-RateLimit-Remaining"] = err
end

return _M
