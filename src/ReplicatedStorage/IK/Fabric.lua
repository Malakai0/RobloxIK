local PolicyService = game:GetService("PolicyService")
local Fabric = {}
Fabric.__class = "Fabric"
Fabric.__index = Fabric

local Signal = require(script.Parent.Signal)

local function Round(num, dp)
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end

function RoundVector(vec, dp)
    return Vector3.new(Round(vec.X, dp), Round(vec.Y, dp), Round(vec.Z, dp))
end

local function Angle(from, to)
    local denominator = (from - to).Magnitude
    if (denominator < 1e-05) then
        return 0
    end

    local dot = math.clamp(from:Dot(to) / denominator, -1, 1)
    return math.deg(math.acos(dot))
end

local function SignedAngle(from, to, axis)
    local cross = from:Cross(to)
    return Angle(from, to) * math.sign(axis.X * cross.X + axis.Y * cross.Y + axis.Z * cross.Z)
end

local function ClosestPointOnPlane(normal, distance, point)
    local pointToPlaneDistance = Round(normal:Dot(point) + distance, 2)
    return point - (normal * pointToPlaneDistance)
end

function Fabric.new(JointStructure, Target, Pole, Iterations, Delta)
    local self = {
        --// Main parameters
        ChainLength = JointStructure:GetLength();
        Target = Target;
        Pole = Pole;
        
        --// Solver parameters
        Iterations = Iterations;
        Delta = Delta;
        
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

        if (i ~= self.ChainLength) then
            self._bonesLength[i] = (self._bones[i + 1]:GetPosition() - Current:GetPosition()).Magnitude
            self._completeLength += self._bonesLength[i]
        end

        Current = Current:GetParent()
    end

    self.OnInit:Fire()
end

function Fabric:ResolveIK()
    if (not self.Target) then
        return
    end

    if (#self._bonesLength ~= self.ChainLength - 1) then
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
            if ((self._positions[#self._positions] - self.Target).Magnitude <= self.Delta) then
                break
            end

            for i = #self._positions, 2, -1 do
                if (i == #self._positions) then
                    self._positions[i] = self.Target;
                else
                    self._positions[i] = self._positions[i + 1] + ((self._positions[i] - self._positions[i + 1]).Unit * self._bonesLength[i])
                end
            end

            for i = 2, #self._positions do
                self._positions[i] = self._positions[i - 1] + ((self._positions[i] - self._positions[i - 1]).Unit * self._bonesLength[i - 1])
            end

            if ((self._positions[#self._positions] - self.Target).Magnitude <= self.Delta) then
                break
            end
        end
    end

    if (self.Pole) then
        --TODO: Fix weird spinny bug.
        --[[
        for i = 2, #self._positions - 1 do
            local normal = (self._positions[i + 1] - self._positions[i - 1]).Unit
            local distance = -normal:Dot(self._positions[i - 1])
            
            local projectedPole = RoundVector(ClosestPointOnPlane(normal, distance, self.Pole), 2)
            local projectedBone = RoundVector(ClosestPointOnPlane(normal, distance, self._positions[i]), 2)

            local angle = Angle(projectedBone - self._positions[i - 1], projectedPole - self._positions[i - 1])
            
            self._positions[i] = CFrame.fromAxisAngle(normal, math.rad(angle)) * (self._positions[i] - self._positions[i - 1]) + self._positions[i - 1]
        end]]
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