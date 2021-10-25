--// TODO: Write up a test for the Inverse Kinematics.

local IK = require(game:GetService("ReplicatedStorage").IK);

local drawParams = IK.DrawParams;

local params = drawParams.new()
params.Part = Instance.new("Part")
params.Part.Size = Vector3.new(5, 1, 1)
params.Part.CFrame = CFrame.new(Vector3.new(0, 10, 0), Vector3.new(10, 10, 0))
params.Part.Anchored = true
params.Part.Parent = workspace