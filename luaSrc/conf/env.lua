local _M = {}
local os = os
local type = type

function getEnv(name, default)
    local res = os.getenv(name)
    if type(res) ~= "string" or res == "" then
        res = default
    end
    return res 
end


function _M.GetConsulAddr()
    return getEnv("CONSUL_ADDR", "127.0.0.1")
end


return _M
