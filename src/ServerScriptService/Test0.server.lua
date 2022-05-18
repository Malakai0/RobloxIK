local IK = require(game:GetService("ReplicatedStorage").IK);

local drawParams = IK.DrawParams;
local jointStructure = IK.JointStructure;
local fabric = IK.Fabric;
local snake = IK.Snake;

local target, part = workspace.Target, workspace.Mechanism

local params = drawParams.new()
params.Part = part

local SnakeLength = 100
local Increment = 10

local offsets = {}
for i = 0, -SnakeLength, -Increment do
    table.insert(offsets, part.CFrame:PointToObjectSpace( (part.CFrame * CFrame.new(0, 0, i)).Position ))
end

local structure = jointStructure.new(offsets, params)
local FABRIK = fabric.new(structure, part.CFrame:PointToObjectSpace(target.Position), nil, 10, 0.001)

local snakey_wakey = snake.new(FABRIK, target)