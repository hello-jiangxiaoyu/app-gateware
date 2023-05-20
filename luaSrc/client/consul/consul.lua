local _M            = {}
local ipairs        = ipairs
local type          = type
local require       = require
local ngx           = require("ngx")
local http_new      = require("resty.http").new
local json_decode   = require("cjson.safe").decode
local response      = require("controller.response")
local ngx_log       = ngx.log
local ngx_err       = ngx.ERR


-- 获取已在consul注册的服务列表
function _M.getConsulHosts(name)
    local httpc = http_new()
    local resp, err = httpc:request_uri("http://127.0.0.1:8500/v1/catalog/service/"..name, {method = "GET", body=nil})
    if err ~= nil or resp == nil then
        ngx_log(ngx_err, "request consul err: ", err)
        return nil
    end

    local hosts = {}
    for i, v in ipairs(json_decode(resp.body)) do
        if type(v) ~= "table" then
            return nil
        end

        hosts[i] = v.ServiceAddress .. ":" .. v.ServicePort
    end

    return hosts
end


function _M:exec()
    response.IsOkJson("consul服务列表", self.getConsulHosts("jiang"))
end


return _M
