local _M = {}
local iresty_test    = require("third.iresty_test")
local tb = iresty_test.new({unit_name="example"})


function _M.test()
    return "hello world"
end

-- 用例初始化
function tb:init()
    self:log("init complete")
end

function tb:test_00001()
    error("invalid input")
end

function tb:atest_00002()
    self:log("never be called")
end

function tb:test_00003()
   self:log("ok")
end


-- example_mock
function tb:test_00004()
    local function mock_test()
        return "mock test func error"
    end

    local mock_rules = {
        { _M, "test", mock_test}
    }

    local function mock_test_run()
        self:log(_M.test())
    end

    self:mock_run(mock_rules, mock_test_run)
end

-- 开始执行用例
function _M.exec()
    tb:run()
end

return _M
