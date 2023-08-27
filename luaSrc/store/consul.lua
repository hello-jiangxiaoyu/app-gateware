local ngx           = ngx
local type          = type
local ipairs        = ipairs
local require       = require
local http_new      = require("resty.http").new
local json_decode   = require("cjson.safe").decode

local _M = {}


-- 获取已在consul注册的服务列表
function _M.GetHostList(name, key)
    local httpc = http_new()
    local resp, err = httpc:request_uri("http://127.0.0.1:8500/v1/catalog/service/"..name, {method = "GET", body=nil})
    if err ~= nil or resp == nil then
        ngx.log(ngx.ERR, "request consul err: ", err)
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


-- 获取https证书
function _M.GetCertificate(domain)

end


-- 获取私钥
function _M.GetCertificateKey(domain)

end


return _M
