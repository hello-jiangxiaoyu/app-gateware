local _M        = {}
local ngx       = ngx
local require   = require
local json      = require("cjson.safe")
local http      = require("resty.http")
local http_new  = http.new


local function requestUri(url, method, header, body)
    local httpc = http_new()
    local resp = httpc:request_uri(url, {
        method  = method,
        body    = body,
        header  = header
    })

    ngx.log(ngx.INFO, "### ", json.encode(resp), url, " ###")
    return resp
end


function _M.GET(url, header, body)
    return requestUri(url, "GET", header, body)
end

function _M.POST(url, header, body)
    return requestUri(url, "POST", header, body)
end


return _M
