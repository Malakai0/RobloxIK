return setmetatable({}, {__index = function(self, key)
    if (rawget(self, key)) then
        return rawget(self, key)
    end

    local module = script:FindFirstChild(key)
    if module then
        rawset(self, key, require(module))
        return self[key]
    end
end})