local ngx           = ngx
local type          = type
local math          = math
local ipairs        = ipairs
local string        = string
local require       = require
local conf          = require("conf.system")
local http          = require("resty.http")
local json_decode   = require("cjson.safe").decode
local json_encode   = require("cjson.safe").encode

local _M = {}
local ConstTime = 1000*1000*1000


function _M:exec()
    ngx.say(conf.GetStoreHost())
end


return _M
