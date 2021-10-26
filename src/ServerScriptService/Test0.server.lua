local IK = require(game:GetService("ReplicatedStorage").IK);

local drawParams = IK.DrawParams;
local jointStructure = IK.JointStructure;
local fabric = IK.Fabric;
local snake = IK.Snake;

local target, part, pole = workspace.Target, workspace.Mechanism, workspace.Pole

local params = drawParams.new()
params.Part = part

local SnakeLength = 100
local Increment = 2.5

local offsets = {}
for i = -SnakeLength / 2, SnakeLength / 2, Increment do
    table.insert(offsets, Vector3.new(0, 0, i))
end

local positions = {}

for i = 1, #offsets do
    positions[i] = part.CFrame:PointToObjectSpace((CFrame.new(offsets[i]) * part.CFrame).Position)
end

local structure = jointStructure.new(positions, params)
local FABRIK = fabric.new(structure, target.Position, nil, 10, 0.001)

local snakey_wakey = snake.new(FABRIK, target)