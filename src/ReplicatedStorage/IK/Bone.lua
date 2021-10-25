local Bone = {}
Bone.__class = "Bone"
Bone.__index = Bone

function Bone.new(startPosition, magnitude, parent)
    local self = {
        startPosition = startPosition;
        magnitude = magnitude;
        parent = parent
    }

    setmetatable(self, Bone)

    return self;
end

return Bone