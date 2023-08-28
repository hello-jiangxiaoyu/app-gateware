local ngx           = ngx
local type          = type
local pairs         = pairs
local require       = require
local file          = require("utils/file")
local json_decode   = require("cjson.safe").decode
local json_encode   = require("cjson.safe").encode

local _M = {}


-- 获取证书
function _M.GetCertificate(domain)
    if type(domain) ~= "string" then
        return ""
    end
    local path = "/usr/local/openresty/nginx/conf/crt/" .. domain .. ".crt"
    return file.read_file(path)
end


-- 获取私钥
function _M.GetCertificateKey(domain)
    if type(domain) ~= "string" then
        return ""
    end
    local path = "/usr/local/openresty/nginx/conf/crt/" .. domain .. ".key"
    return file.read_file(path)
end


-- 获取域名级配置
local function getDomainConfiguration(domain)
    if type(domain) ~= "string" then
        return ""
    end
    local path = "/usr/local/openresty/nginx/conf/conf/" .. domain .. ".json"
    local confData = file.read_file(path)
    return json_decode(confData)    
end

-- 获取域名级配置
function _M.GetDomainConfiguration(domain)
    getDomainConfiguration(domain)
end


-- 获取host列表
function _M.GetHostList(domain, key)
    local domainConfig = getDomainConfiguration(domain)
    if type(domainConfig) ~= "table" or type(domainConfig.upstream) ~= "table" then
        ngx.log(ngx.WARN, "upstream list is empty.")
        return {}
    end

    for k, v in pairs(domainConfig.upstream) do
        if type(v) ~= "table" or type(v.rule) ~= "string" or type(v.hosts) ~= "table" then
            ngx.log(ngx.WARN, "invalidate domain upstream conf.")
            return {}
        end
        local m = ngx.re.match(key, v.rule, "jo")
        if m then
            return v.hosts  -- 匹配成功
        end
    end

    return {}
end


return _M
