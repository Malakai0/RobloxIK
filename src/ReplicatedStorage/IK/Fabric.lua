local Fabric = {}
Fabric.__class = "Fabric"
Fabric.__index = Fabric

local Bone = require(script.Parent.Bone)
local Signal = require(script.Parent.Signal)

function Fabric.new(JointStructure, Target, Pole, Iterations, Delta, SnapStrength)
    local self = {
        --// Main parameters
        ChainLength = JointStructure:GetLength();
        Target = Target;
        Pole = Pole;
        
        --// Solver parameters
        Iterations = Iterations;
        Delta = Delta;
        SnapBackStrength = SnapStrength;

        --// Protected parameters
        _bonesLength = {};
        _completeLength = 0;
        _bones = {};
        _positions = {};
        _structure = JointStructure;

        --// Signals
        OnDraw = Signal.new();
        OnEarlyUpdate = Signal.new();
        OnLateUpdate = Signal.new();
        OnInit = Signal.new();
        OnResolve = Signal.new();
    }

    setmetatable(self, Fabric)
    self:Init()

    return self
end

function Fabric:Init()
    self._completeLength = 0;

    local Current = self._structure:GetLastJoint()
    for i = self.ChainLength, 1, -1 do
        self._bones[i] = Current

        if (i == self.ChainLength) then
            
        else
            self._bonesLength[i] = (self._bones[i + 1]:GetPosition() - Current:GetPosition()).Magnitude
            self._completeLength += self._bonesLength[i]
        end

        Current = Current.Parent
    end

    self.OnInit:Fire()
end

function Fabric:ResolveIK()
    if (not self.Target) then
        return
    end

    if (not #self._bonesLength ~= self.ChainLength) then
        self:Init()
    end

    for i = 1, #self._bones do
        self._positions[i] = self._bones[i]:GetPosition()
    end

    if ((self.Target - self._bones[1]:GetPosition()).Magnitude >= self._completeLength) then
        local direction = (self.Target - self._positions[1]).Unit
        for i = 2, #self._positions do
            self._positions[i] = self._positions[i - 1] + direction * self._bonesLength[i - 1]
        end
    else
        for i = 1, self.Iterations do
            for i = #self._positions, 2 do
                if (i == #self._positions) then
                    self._positions[i] = self.Target;
                else
                    self._positions[i] = self._positions[i + 1] + ((self._positions[i] - self._positions[i + 1]).Unit * self._bonesLength[i])
                end
            end

            for i = 2, #self._positions + 1 do
                self._positions[i] = self._positions[i + 1] + ((self._positions - self._positions[i - 1]).Unit * self._bonesLength[i - 1])
            end

            if ((self._positions[i] - self.Target).Magnitude <= self.Delta) then
                break
            end
        end
    end

    for i = 1, #self._positions do
        self._bones[i]:SetPosition(self._positions[i])
    end

    self.OnResolve:Fire()
end

function Fabric:Update()
    self.OnEarlyUpdate:Fire()
    self:ResolveIK()
    self.OnLateUpdate:Fire()
end

function Fabric:Draw()
    self._structure:Draw()
    self.OnDraw:Fire()
end

return Fabric