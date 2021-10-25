local DrawParams = {}
DrawParams.__class = "DrawParams"
DrawParams.__index = DrawParams

function DrawParams.new()
    local self = {
        Part = nil;
    }

    setmetatable(self, DrawParams)

    return self
end

function DrawParams:Check()
    return self:CheckPart()
end

function DrawParams:CheckPart()
    assert(typeof(self.Part) == "Instance" and self.Part:IsA('BasePart'), "DrawParams.Part must be a BasePart!")
    return true
end

return DrawParams