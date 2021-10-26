local Snake = {}
Snake.__class = "Snake"
Snake.__index = Snake

function Snake.new(fabric, target)
    local self = {
        _fabric = fabric;
        _target = target;
        _parts = {};
    }

    local body = Instance.new('Model')
    for i = 1, fabric.ChainLength - 1 do
        local part = Instance.new('Part')
        part.Parent = body
        self._parts[i] = part
    end
    self.body = body

    setmetatable(self, Snake)

    self._fabric.OnDraw:Connect(function()
        self:_update()
    end)

    self:_init()
    return self;
end

function Snake:_init()
    game:GetService("RunService").Heartbeat:Connect(function()
        self._fabric.Target = self._target.Position - self._fabric._structure._drawParams.Part.Position
        self._fabric:Update()
        self._fabric:Draw()
    end)
end

function Snake:_update()
    for i = 1, #self._parts do
        local length = self._fabric._bonesLength[i]
        local nextPos = self._fabric._positions[i + 1]

        local direction = (nextPos - self._fabric._positions[i]).Unit

        local part = self._parts[i]
        if (part.Parent == nil) then
            print('oh no!')
            part:Destroy()
            self._parts[i] = Instance.new('Part')
            self._parts[i].Parent = self.body
            part = self._parts[i]
        end

        local origin = CFrame.new(self._fabric._structure._attachments[1].WorldPosition) * CFrame.new(self._fabric._completeLength / 2, 0, 0)

        part.Size = Vector3.new(1, 1, length)
        part.CFrame = origin * (CFrame.new(self._fabric._positions[i], self._fabric._positions[i] + direction) * CFrame.new(0, 0, -length / 2))
    end
    self.body.Parent = workspace
end

return Snake