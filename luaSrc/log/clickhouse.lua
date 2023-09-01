local _M = {}
local pairs     = pairs
local string    = string
local require   = require
local tonumber  = tonumber
local ngx       = require("ngx")
local http      = require("resty.http")

local function getInsertSql(tbName, logTable)
    local columns, values = "", ""
    for k, v in pairs(logTable) do
        columns = columns .. k .. ","
        if not tonumber(v) then
            values = values .."'".. v .."',"
            goto CONTINUE
        end

        values = values .. v .. ","
        ::CONTINUE::
    end

    return "INSERT INTO " ..tbName.. "(" ..string.sub(columns, 0, #columns - 1)..
            ")VALUES(" .. string.sub(values, 0, #values - 1) .. ");"
end


function _M.LogSendTimer(_, istSql)
    local host = "172.27.102.84:8123"
    local urlDecode = {
        host = host,
        url = "http://" .. host
    }
    local conf = {
        user = "default",
        passwd = "default",
        database = "log",
        logTable = "test_log"
    }

	local httpc = http.new()
	httpc:set_timeouts(100, 100, 100) -- connect_timeout, send_timeout, read_timeout
	local resp, err = httpc:request_uri(urlDecode.url, {
		method = "POST",
		headers = {
			["Host"] = urlDecode.host,
            ["X-ClickHouse-User"] = conf.user,
            ["X-ClickHouse-Key"] = conf.passwd,
            ["X-ClickHouse-Database"] = conf.database
		},
        body = istSql
	})

    if err ~= nil or resp == nil then
        ngx.log(ngx.ERR, "===log request err: ", err)
        return
    end

	if resp.status ~= 200 then
		ngx.log(ngx.ERR, "===log server response", resp.status, resp.body);
	end
end


function _M.Handler(logTable)
    local istSql = getInsertSql("test_log", logTable)
    ngx.log(ngx.INFO, "===insert sql: ", istSql)
    local ok, err = ngx.timer.at(0, _M.LogSendTimer, istSql);
    if not ok then
		ngx.log(ngx.ERR, "failed to create timer: ", err)
		return
	end
end


return _M
