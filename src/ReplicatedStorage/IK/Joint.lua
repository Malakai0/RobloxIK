local Joint = {}
Joint.__class = "Joint"
Joint.__index = Joint

function Joint.new(position, parent)
    local self = {
        _position = position;
        _parent = parent;
    }

    setmetatable(self, Joint)

    return Joint
end

function Joint:GetParent()
    return self._parent
end

function Joint:GetPosition()
    return self._position
end

function Joint:SetPosition(position: Vector3)
    self._position = position
end

return Joint