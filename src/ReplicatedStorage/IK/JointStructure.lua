local JointStructure = {}
JointStructure.__class = "JointStructure"
JointStructure.__index = JointStructure

local Joint = require(script.Parent.Joint);

function JointStructure.new(jointPositions, drawParams)
    assert(type(jointPositions) == "table", "jointPositions must be an array of Vector3s")
    assert(#jointPositions >= 2, "length of jointPositions must be at least 2")

    if (drawParams) then
        drawParams:Check()
    end

    local self = {
        _originalPositions = {};
        _joints = {};
        _attachments = {};
        _drawParams = drawParams;
    }

    for i = 1, #jointPositions do
        local position = jointPositions[i]
        local parent = self._joints[i - 1]
        self._joints[i] = Joint.new(position, parent)
    end

    if (self._drawParams) then
        for i = 1, #self._joints do
            local attachment = Instance.new("Attachment")
            attachment.Visible = true
            attachment.Parent = self._drawParams.Part
            self._attachments[i] = attachment
        end

        JointStructure.UpdateAttachments(self)
    end

    setmetatable(self, JointStructure)

    return self
end

function JointStructure:UpdateAttachments()
    local partCFrame = self._drawParams.Part.CFrame;
    for i = 1, #self._attachments do
        self._attachments[i].Position = partCFrame:PointToObjectSpace(partCFrame * self._joints[i]:GetPosition())
    end
end

function JointStructure:Draw()
    assert(self._drawParams, "Specify DrawParams when initializing to use JointStructure:Draw()")

    self:UpdateAttachments()
end

function JointStructure:GetFirstJoint()
    return self._joints[1]
end

function JointStructure:GetLastJoint()
    return self._joints[#self._joints]
end

function JointStructure:GetJoint(n)
    return self._joints[n]
end

function JointStructure:GetLength()
    return #self._joints;
end

return JointStructure