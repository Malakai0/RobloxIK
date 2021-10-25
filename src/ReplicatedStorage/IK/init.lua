local _cache = {}

return setmetatable({}, {__index = function(self, key)
    if (_cache[key]) then
        return _cache[key]
    end

    local module = script:FindFirstChild(key)
    if module then
        _cache[key] = require(module)
    end
end})