local io    = io
local ngx   = ngx
local type  = type
local pcall = pcall
local _M    = {}


-- 读取整个文件内容
function _M.read_file(path)
    if type(path) ~= "string" or path == "" then
        return ""
    end

    local ok, file = pcall(io.input, path, "r")
    if not ok then
        ngx.log(ngx.ERR, "failed to read " .. path .. "; ", file)
        return ""
    end

    local data = ""
    repeat
        local line = io.read()
        if nil == line then
            break
        end
        data = data .. "\n" .. line            -- 逐行读取内容，文件结束时返回nil
    until (false)
    io.close(file)
    return data
end


return _M
