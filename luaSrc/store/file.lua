local ngx           = ngx
local type          = type
local require       = require
local file          = require("utils/file")
local json_decode   = require("cjson.safe").decode

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
    if type(domainConfig) ~= "table" or type(domainConfig.upstream) ~= "table" or type(domainConfig.upstream[key]) ~= "table" then
        ngx.log(ngx.WARN, "upstream list is empty.")
        return {}
    end
    return domainConfig.upstream[key]
end


return _M
