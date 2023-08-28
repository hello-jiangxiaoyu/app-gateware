local _M            = {}
local type          = type
local require       = require
local io_open       = io.open
local env           = require("common/env")
local json          = require "cjson.safe"
local ngx           = require("ngx")
local shared_config = ngx.shared.config
local json_decode   = json.decode
local json_encode   = json.encode


-- todo 通过consul实现动态负载均衡, 定时向consul拉取配置

-- 获取配置
local function getConfByName(key)
    local conf = json.decode(shared_config:get(key))
    if conf then
        return conf  -- 命中缓存
    end

    local file = io_open(env.service.configurationPath .. key, "r")
    if not file then
        ngx.log(ngx.ERR, "Example.json file open faild")
        return nil
    end

    local content = file:read("*all")
    file:close()
    conf = json_decode(content)
    if type(conf) ~= "table" then
        return nil
    end

    shared_config:safe_set(key, content)  -- 存入共享内存
    return conf
end


-- 获取服务级配置
function _M.GetSrvConf()
    return getConfByName(env.service.serviceKey)
end


-- 获取用户级配置
function _M.GetUserConf(key)
    return getConfByName(key)
end


-- 更新配置
function _M.UpdateConf(key, conf)
    if type(key) ~= "string" or type(conf) ~= "table" then
        return "req para err"
    end

    local file = io_open(key, "a"); if not file then
        return "can't open file " .. key
    end

    local content = json_encode(conf)
    file:write(content)
    shared_config:safe_set(key, content)
    file:close()

    return nil
end

return _M
