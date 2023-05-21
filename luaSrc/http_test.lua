local _M = {}
local require   = require
local json      = require("cjson.safe")
local ngx       = require("ngx")
local http      = require("client.httpUri")

function _M.Handler()
    local args = ngx.req.get_uri_args() or ""
    ngx.say(json.encode(http.GET(args.peer, nil, nil)))
end


return _M
