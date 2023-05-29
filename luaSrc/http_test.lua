local _M = {}
local require   = require
local ngx       = require("ngx")
local http      = require("resty.http")

function _M.Handler()
    local ok, err = ngx.timer.at(0, _M.Handler2);
    if not ok then
		ngx.log(ngx.ERR, "failed to create timer: ", err)
		return
	end
    ngx.log(ngx.INFO, "### timer created")
end

function _M.Handler2()
    local httpc = http.new();
    httpc:set_timeouts(100, 100, 100) -- connect_timeout, send_timeout, read_timeout
    local resp, err = httpc:request_uri("http://192.168.119.143:3000/login", {
        method = "GET",
        headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "*/*",
        }
    })

    if (resp.status ~= 200 or err ~= nil) then
        ngx.log(ngx.ERR,"log server response===========", resp.status);
    end
    ngx.log(ngx.WARN, "@@@### log ok")
end

return _M
