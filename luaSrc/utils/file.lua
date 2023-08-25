local io = io
local type = type
local _M = {}


-- 读取整个文件内容
function _M.read_file(path)
    if type(path) ~= "string" or path == "" then
        return ""
    end

    local file = io.input(path, "r")
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
