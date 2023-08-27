
local _M        = {}
local string    = string
local require   = require
local ngx       = require("ngx")
local clickhouse = require("log.clickhouse")
local ngx_var   = ngx.var


-- 接口访问日志
local function getAccessLogTable()
    local accessLog = {}
    accessLog["time_iso8601"]               = string.sub(ngx_var.time_iso8601, 0, 19)
    accessLog["status"]                     = ngx_var.status
    accessLog["request_method"]             = ngx_var.request_method
    accessLog["uri"]                        = ngx_var.uri
    accessLog["remote_addr"]                = ngx_var.remote_addr
    accessLog["remote_port"]                = ngx_var.remote_port
    accessLog["server_addr"]                = ngx_var.server_addr
    accessLog["server_port"]                = ngx_var.server_port
    accessLog["http_host"]                  = ngx_var.http_host
    accessLog["http_name"]                  = ngx_var.http_name
    accessLog["args"]                       = ngx_var.args
    accessLog["request_length"]             = ngx_var.request_length
    accessLog["body_bytes_sent"]            = ngx_var.body_bytes_sent
    accessLog["bytes_sent"]                 = ngx_var.bytes_sent
    accessLog["request_time"]               = ngx_var.request_time
    accessLog["connection_requests"]        = ngx_var.connection_requests
    accessLog["connection"]                 = ngx_var.connection
    accessLog["upstream"]                   = ngx_var.upstream
    accessLog["upstream_status"]            = ngx_var.upstream_status
    accessLog["upstream_response_time"]     = ngx_var.upstream_response_time
    accessLog["upstream_response_length"]   = ngx_var.upstream_response_length
    accessLog["http_referer"]               = ngx_var.http_referer
    accessLog["http_user_agent"]            = ngx_var.http_user_agent
    accessLog["pid"]                        = ngx_var.pid
    accessLog["ssl_protocol"]               = ngx_var.ssl_protocol
    accessLog["scheme"]                     = ngx_var.scheme
    accessLog["server_protocol"]            = ngx_var.server_protocol
    return accessLog
end


function _M.log()
    clickhouse.Handler(getAccessLogTable())
end


return _M
