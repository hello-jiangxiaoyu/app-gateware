
function get_service_ip(name)
    -- 根据service name获取k8s部署的service ip
    retulocal http = require("socket.http")
    local json = require("json")

    -- Construct the API URL for the service
    local url = "https://k3s.default.svc/api/v1/namespaces/default/services/" .. name

    -- Make an HTTP GET request to the API
    local response_body = {}
    local res, code, response_headers = http.request{
        url = url,
        method = "GET",
        headers = {
            ["Authorization"] = "Bearer " .. os.getenv("TOKEN"),
            ["Content-Type"] = "application/json"
        },
        sink = ltn12.sink.table(response_body)
    }

    -- Parse the JSON response and extract the service IP
    local service = json.decode(table.concat(response_body))
    local ip = service.spec.clusterIP

    return ip
end

