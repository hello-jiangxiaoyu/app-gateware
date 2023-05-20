local _M        = {}
local type      = type
local require   = require
local ngx       = require("ngx")
local http      = require("resty.http")
local http_new  = http.new
local ngx_log   = ngx.log
local ngx_err   = ngx.ERR


local function request(method, path, query, headers, body, isReadBody)
    local httpc = http_new()
    local resp, err = httpc:request({
        method = method,
        path = path,
        query = query,
        body = body,
        headers = headers
    })

    if err ~= nil or type(resp) ~= "table" then
        ngx_log(ngx_err, "http request " ..method.. " " ..path.. " err: ", err)
        return ngx.HTTP_SERVICE_UNAVAILABLE, nil, nil
    end

    if type(isReadBody) == "boolean" and isReadBody then
        resp.body, err = resp:read_body()
        if not body then
            ngx_log(ngx_err, "http read_body " ..method.. " " ..path.. " err: ", err)
        end
    end

    return resp.status, resp.body, resp.header
end


function _M.GET(path, query, headers, body)
    return request("GET", path, query, headers, body, true)
end

function _M.POST(path, query, headers, body)
    return request("POST", path, query, headers, body, true)
end



return _M
