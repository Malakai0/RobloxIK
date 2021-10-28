local Fabrik = require(script.Parent.Fabric)
local JointStructure = require(script.Parent.JointStructure)

local Rig = {}
Rig.__class = "Rig"
Rig.__index = Rig

function Rig.new(CompleteStructure)

end

return Rig

--[[
{
    Root = {
        Neck = {
            Vector3.new(0, 1, 0)
        },
        LeftArm = {
            Vector3.new(-1, .75, 0),
            Vector3.new(-2, .75, 0),
            Vector2.new(-3, .75, 0)
        },
        RightArm = {
            Vector3.new(1, .75, 0),
            Vector3.new(2, .75, 0),
            Vector2.new(3, .75, 0)
        }
    }
}
]]