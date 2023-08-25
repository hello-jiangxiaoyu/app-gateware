local _M = {}
local require = require
local ngx = require("ngx")
local ssl = ngx.ssl
local file = require("utils/file")

function _M:Exec()
    local ok, err = ssl.clear_certs()
    if not ok then
        ngx.log(ngx.ERR, "failed to clear existing (fallback) certificates")
        return ngx.exit(500)
    end

    local cert_data, err = self.get_my_pem_cert_data()
    if not cert_data then
        ngx.log(ngx.ERR, "failed to get PEM cert: ", err)
        return ngx.exit(500)
    end

    -- 解析出 cdata 类型的证书值，你可以用 lua-resty-lrucache 缓存解析结果
    local cert, err = ssl.parse_pem_cert(cert_data)
    if not cert then
        ngx.log(ngx.ERR, "failed to parse PEM cert: ", err)
        return ngx.exit(500)
    end

    ok, err = ssl.set_cert(cert)
    if not ok then
        ngx.log(ngx.ERR, "failed to set cert: ", err)
        return ngx.exit(500)
    end

    local pkey_data, err = self.get_my_pem_priv_key_data()
    if not pkey_data then
        ngx.log(ngx.ERR, "failed to get DER private key: ", err)
        return ngx.exit(500)
    end

    local pkey, err = ssl.parse_pem_priv_key(pkey_data)
    if not pkey then
        ngx.log(ngx.ERR, "failed to parse pem key: ", err)
        return ngx.exit(500)
    end

    local ok, err = ssl.set_priv_key(pkey)
    if not ok then
        ngx.log(ngx.ERR, "failed to set private key: ", err)
        return ngx.exit(500)
    end
end


-- 读取证书
function _M.get_my_pem_cert_data()
    return file.read_file("/usr/local/openresty/nginx/conf/crt/real.crt")
end


-- 读取私钥
function _M.get_my_pem_priv_key_data()
    return file.read_file("/usr/local/openresty/nginx/conf/crt/real.key")
end


return _M
