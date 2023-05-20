local _M        = {}
local require   = require
local http      = require("resty.http")
local http_new  = http.new


local function requestUri(url, method, header, body)
    local httpc = http_new()
    local resp = httpc:request_uri(url, {
        method  = method,
        body    = body,
        header  = header
    })

    return resp
end


function _M.GET(url, header, body)
    return requestUri(url, "GET", header, body)
end

function _M.POST(url, header, body)
    return requestUri(url, "POST", header, body)
end


return _M
