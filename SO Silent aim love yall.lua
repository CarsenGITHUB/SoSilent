local Players, Client, Mouse, RS, Camera = 
game:GetService("Players"),
game:GetService("Players").LocalPlayer,
game:GetService("Players").LocalPlayer:GetMouse(),
game:GetService("RunService"),
game:GetService("Workspace").CurrentCamera

local TracerCircle = Drawing.new("Circle")

TracerCircle.Color     = Color3.new(0,0,0)
TracerCircle.Thickness = 1

local UpdateFOV = function ()
if ( not TracerCircle) then
    return TracerCircle
end
TracerCircle.Visible  = getgenv().SOSilent.TracerFOV.Visible
TracerCircle.Radius   = getgenv().SOSilent.TracerFOV.Radius * 3
TracerCircle.Position = Vector2.new(Mouse.X, Mouse.Y + (game:GetService("GuiService"):GetGuiInset().Y))
return TracerCircle
end

RS.Heartbeat:Connect(UpdateFOV)

local WallCheck = function(destination, ignore)
local Origin    = Camera.CFrame.p
local CheckRay  = Ray.new(Origin, destination - Origin)
local Hit       = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
return Hit      == nil
end

local WTS = function (Object)
local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local IsOnScreen = function (Object)
local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
return IsOnScreen
end

local FilterObjs = function (Object)
if string.find(Object.Name, "Gun") then
    return
end
if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
    return true
end
end

local ClosestPlrFromMouse2 = function()
local Target, Closest = nil, 1/0

for _ ,v in pairs(Players:GetPlayers()) do
    if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
        if getgenv().SOSilent.Tracer.WallCheck then
            local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
            if (Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                Closest = Distance
                Target = v
            end
            elseif getgenv().SOSilent.Tracer.UseCircleRadius then
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (TracerCircle.Radius > Distance and Distance < Closest and OnScreen) and WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}) then
                    Closest = Distance
                    Target = v
                end
            else
                local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
    
                if (Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
    end
return Target
end

local GetClosestBodyPart = function (character)
local ClosestDistance = 1/0
local BodyPart = nil

if (character and character:GetChildren()) then
    for _,  x in next, character:GetChildren() do
        if FilterObjs(x) and IsOnScreen(x) then
            local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Circle.Radius > Distance and Distance < ClosestDistance) then
                ClosestDistance = Distance
                BodyPart = x
            end
        end
    end
end
return BodyPart
end

local GetClosestBodyPartV2 = function (character)
local ClosestDistance = 1/0
local BodyPart = nil

if (character and character:GetChildren()) then
    for _,  x in next, character:GetChildren() do
        if FilterObjs(x) and IsOnScreen(x) then
            local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Distance < ClosestDistance) then
                ClosestDistance = Distance
                BodyPart = x
            end
        end
    end
end
return BodyPart
end

Mouse.KeyDown:Connect(function(Key)
local Keybind = getgenv().SOSilent.Tracer.Key:lower()
if (Key == Keybind) then
    if getgenv().SOSilent.Tracer.Enabled == true then
        IsTargetting = not IsTargetting
        if IsTargetting then
            Plr = ClosestPlrFromMouse2()
        else
            if Plr ~= nil then
                Plr = nil
                IsTargetting = false
            end
        end
    end
end
end)

RS.Heartbeat:Connect(function()
if getgenv().SOSilent.Silentaim.Enabled then
if Silentaim and Silentaim.Character and Silentaim.Character:WaitForChild(getgenv().SOSilent.Silentaim.Part) then
if getgenv().SOSilent.SilentaimAndTracer.DesyncResolver == true and Silentaim.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().SOSilent.Boths.DesyncDetection then            
    pcall(function()
        local TargetVel = Silentaim.Character[getgenv().SOSilent.Silentaim.Part]
        TargetVel.Velocity = Vector3.new(0, 0, 0)
        TargetVel.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    end)
end
    if getgenv().SOSilent.SilentaimAndTracer.AntiGroundShots == true and Prey.Character:FindFirstChild("Humanoid") == Enum.HumanoidStateType.Freefall then
        pcall(function()
            local TargetVelv5 = Prey.Character[getgenv().SOSilent.Silentaim.Part]
            TargetVelv5.Velocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
            TargetVelv5.AssemblyLinearVelocity = Vector3.new(TargetVelv5.Velocity.X, (TargetVelv5.Velocity.Y * 0.5), TargetVelv5.Velocity.Z)
        end)
    end
    if getgenv().SOSilent.SilentaimAndTracer.UnderGroundResolver == true then            
        pcall(function()
            local TargetVelv2 = Prey.Character[getgenv().SOSilent.Silentaim.Part]
            TargetVelv2.Velocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
            TargetVelv2.AssemblyLinearVelocity = Vector3.new(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
        end)
    end
end
end
if getgenv().SOSilent.Tracer.Enabled == true then
if getgenv().SOSilent.SilentaimAndTracer.DesyncResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().SOSilent.Tracer.Part) and Plr.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > getgenv().SOSilent.SilentaimAndTracer.DesyncDetection then
    pcall(function()
        local TargetVelv3 = Plr.Character[getgenv().SOSilent.Tracer.Part]
        TargetVelv3.Velocity = Vector3.new(0, 0, 0)
        TargetVelv3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
end
    if getgenv().SOSilent.SilentaimAndTracer.UnderGroundResolver == true and Plr and Plr.Character and Plr.Character:WaitForChild(getgenv().SOSilent.Tracer.Part)then
    pcall(function()
        local TargetVelv4 = Plr.Character[getgenv().SOSilent.Tracer.Part]
        TargetVelv4.Velocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
        TargetVelv4.AssemblyLinearVelocity = Vector3.new(TargetVelv4.Velocity.X, 0, TargetVelv4.Velocity.Z)
    end)
end
end
end)
RS.RenderStepped:Connect(function()
if getgenv().SOSilent.Tracer.Enabled == true then
    if getgenv().SOSilent.Tracer.CheckIfKo == true and Plr and Plr.Character then 
        local KOd = Plr.Character:WaitForChild("BodyEffects")["K.O"].Value
        local Grabbed = Plr.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
        if KOd or Grabbed then
            Plr = nil
            IsTargetting = false
        end
    end
    if getgenv().SOSilent.Tracer.UnlockOnEnemyDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
        if Plr.Character.Humanoid.health < 4 then
            Plr = nil
            IsTargetting = false
        end
    end
    if getgenv().SOSilent.Tracer.UnlockOnPlayerDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
        if Client.Character.Humanoid.health < 4 then
            Plr = nil
            IsTargetting = false
        end
    end
    if getgenv().SOSilent.Tracer.DisableOutSideCircle == true and Plr and Plr.Character and Plr.Character:WaitForChild("HumanoidRootPart") then
        if
        TracerCircle.Radius <
            (Vector2.new(
                Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).X,
                Camera:WorldToScreenPoint(Plr.Character.HumanoidRootPart.Position).Y
            ) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
         then
            Plr = nil
            IsTargetting = false
        end
    end
    if getgenv().SOSilent.Tracer.Predicting and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().SOSilent.Tracer.Part) then
        if getgenv().SOSilent.Tracer.UseShake then
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().SOSilent.Tracer.Part].Position + Plr.Character[getgenv().SOSilent.Tracer.Part].Velocity * getgenv().SOSilent.Tracer.Prediction +
            Vector3.new(
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower),
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower),
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower)
            ) * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SOSilent.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        else
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().SOSilent.Tracer.Part].Position + Plr.Character[getgenv().SOSilent.Tracer.Part].Velocity * getgenv().SOSilent.Tracer.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SOSilent.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    elseif getgenv().SOSilent.Tracer.Predicting == false and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().SOSilent.Tracer.Part) then
        if getgenv().SOSilent.Tracer.UseShake then
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().SOSilent.Tracer.Part].Position +
            Vector3.new(
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower),
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower),
                math.random(-getgenv().SOSilent.Tracer.ShakePower, getgenv().SOSilent.Tracer.ShakePower)
            ) * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SOSilent.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        else
            local Main = CFrame.new(Camera.CFrame.p,Plr.Character[getgenv().SOSilent.Tracer.Part].Position)
            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SOSilent.Tracer.Smoothness, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        end
    end
end
end)

task.spawn(function ()
while task.wait() do
    if Plr then
        if getgenv().SOSilent.Tracer.Enabled and (Plr.Character) and getgenv().SOSilent.Tracer.ClosestBodyPart then
            getgenv().SOSilent.Tracer.Part = tostring(GetClosestBodyPartV2(Plr.Character))
        end
    end
end
end)

RS.Heartbeat:Connect(function()
if getgenv().SOSilent.Tracer.AirshotFunc == true then
if Plr.Character.Humanoid.Jump == true and Plr.Character.Humanoid.FloorMaterial == Enum.Material.Air then
    getgenv().SOSilent.Tracer.Part = getgenv().SOSilent.Tracer.AirshotPart
    else
    getgenv().SOSilent.Tracer.Part = getgenv().SOSilent.Tracer.Part
    end
end
end)
-- SilentaimAim //

local Players, Client, Mouse, RS, Camera, r =
game:GetService("Players"),
game:GetService("Players").LocalPlayer,
game:GetService("Players").LocalPlayer:GetMouse(),
game:GetService("RunService"),
game.Workspace.CurrentCamera,
math.random

local Circle = Drawing.new("Circle")
Circle.Color = Color3.new(0, 0, 0)
Circle.Transparency = 0.5
Circle.Thickness = 1

local Prey
local On

local Vec2 = function(property)
return Vector2.new(property.X, property.Y + (game:GetService("GuiService"):GetGuiInset().Y))
end

local UpdateSilentaimFOV = function()
if not Circle then
return Circle
end
Circle.Visible = getgenv().SOSilent.FOV["Visible"]
Circle.Radius = getgenv().SOSilent.FOV["Radius"] * 3.05
Circle.Position = Vec2(Mouse)
local chance = CalcChance(SOSilent.Silentaim.HitChance)
if not chance then
return nil
end

return Circle
end

game.RunService.RenderStepped:Connect(
function()
UpdateSilentaimFOV()
end
)

local WallCheck = function(destination, ignore)
if getgenv().SOSilent.Silentaim.WallCheck then
local Origin = Camera.CFrame.p
local CheckRay = Ray.new(Origin, destination - Origin)
local Hit = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
return Hit == nil
else
return true
end
end


GetClosestToMouse = function()
local Target, Closest = nil, 1 / 0

for _, v in pairs(Players:GetPlayers()) do
if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

    if
        (Circle.Radius > Distance and Distance < Closest and OnScreen and
            WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}))
     then
        Closest = Distance
        Target = v
    end
end
end
return Target
end

function TargetChecks(Target)
if getgenv().SOSilent.Silentaim.UnlockOnDeath == true and Target.Character then
return Target.Character.BodyEffects["K.O"].Value and true or false
end
return false
end

function PredictionictTargets(Target, Value)
return Target.Character[getgenv().SOSilent.Silentaim.AimPart].CFrame +
(Target.Character[getgenv().SOSilent.Silentaim.AimPart].Velocity * Value)
end

local WTS = function(Object)
local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local IsOnScreen = function(Object)
local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
return IsOnScreen
end

local FilterObjs = function(Object)
if string.find(Object.Name, "Gun") then
return
end
if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
return true
end
end

local GetClosestBodyPart = function (character)
local ClosestDistance = 1/0
local BodyPart = nil

if (character and character:GetChildren()) then
    for _,  x in next, character:GetChildren() do
        if FilterObjs(x) and IsOnScreen(x) then
            local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if (Circle.Radius > Distance and Distance < ClosestDistance) then
                ClosestDistance = Distance
                BodyPart = x
            end
        end
    end
end
return BodyPart
end

RS.RenderStepped:Connect(
function()
if Prey then
    if Prey ~= nil and getgenv().SOSilent.Silentaim.Enabled and getgenv().SOSilent.Silentaim.ClosestBodyPart == true then
        getgenv().SOSilent.Silentaim["AimPart"] = tostring(GetClosestBodyPart(Prey.Character))
    end
end
end
)

local grmt = getrawmetatable(game)
local index = grmt.__index
local properties = {
"Hit"
}
setreadonly(grmt, false)

grmt.__index =
newcclosure(
function(self, v)
if Mouse and (table.find(properties, v)) then
    Prey = GetClosestToMouse()
    if Prey ~= nil and getgenv().SOSilent.Silentaim.Enabled and not TargetChecks(Prey) then
        local endpoint = PredictionictTargets(Prey, getgenv().SOSilent.Silentaim.Prediction)

        return (table.find(properties, tostring(v)) and endpoint)
    end
end
return index(self, v)
end
)

Mouse.KeyDown:Connect(
function(Key)
if (Key == getgenv().SOSilent.Silentaim.Toggle:lower()) then
    if getgenv().SOSilent.Silentaim.Enabled == true then
        getgenv().SOSilent.Silentaim.Enabled = false
    else
        getgenv().SOSilent.Silentaim.Enabled = true
    end
end
end
)

RS.Heartbeat:Connect(function()
if getgenv().SOSilent.Silentaim.UseAirShotPart == true and Prey.Character:FindFirstChild("Humanoid") then
if Prey.Character.Humanoid.FloorMaterial == Enum.Material.Air and Prey.Character.Humanoid.Jump == true then
getgenv().SOSilent.Silentaim.AimPart = getgenv().SOSilent.Silentaim.AirshotPart
else
getgenv().SOSilent.Silentaim.AimPart = getgenv().SOSilent.Silentaim.AimPart
   end
end
end)

while getgenv().SOSilent.Silentaim.AutoPrediction == true do
local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
local pingValue = string.split(ping, " ")[5]
local pingNumber = tonumber(pingValue)
if pingNumber < 30 then
getgenv().SOSilent.Silentaim.Prediction = 0.12588
elseif pingNumber < 40 then
getgenv().SOSilent.Silentaim.Prediction = 0.11911
elseif pingNumber < 50 then
getgenv().SOSilent.Silentaim.Prediction = 0.12471
elseif pingNumber < 60 then
getgenv().SOSilent.Silentaim.Prediction = 0.12766
elseif pingNumber < 70 then
getgenv().SOSilent.Silentaim.Prediction = 0.12731
elseif pingNumber < 80 then
getgenv().SOSilent.Silentaim.Prediction = 0.12951
elseif pingNumber < 90 then
getgenv().SOSilent.Silentaim.Prediction = 0.13181
elseif pingNumber < 100 then
getgenv().SOSilent.Silentaim.Prediction = 0.13573
elseif pingNumber < 110 then
getgenv().SOSilent.Silentaim.Prediction = 0.1455
elseif pingNumber < 120 then
getgenv().SOSilent.Silentaim.Prediction = 0.1437
elseif pingNumber < 130 then
getgenv().SOSilent.Silentaim.Prediction = 0.156692
elseif pingNumber < 140 then
getgenv().SOSilent.Silentaim.Prediction = 0.1223333
elseif pingNumber < 150 then
getgenv().SOSilent.Silentaim.Prediction = 0.15
elseif pingNumber < 160 then
getgenv().SOSilent.Silentaim.Prediction = 0.16
elseif pingNumber < 170 then
getgenv().SOSilent.Silentaim.Prediction = 0.1923111 
elseif pingNumber < 180 then
getgenv().SOSilent.Silentaim.Prediction = 0.19284
elseif pingNumber < 190 then
getgenv().SOSilent.Silentaim.Prediction = 0.166547
elseif pingNumber < 200 then
getgenv().SOSilent.Silentaim.Prediction = 0.165566
elseif pingNumber < 210 then
getgenv().SOSilent.Silentaim.Prediction = 0.16780
elseif pingNumber < 220 then
getgenv().SOSilent.Silentaim.Prediction = 0.165566
elseif pingNumber < 230 then
getgenv().SOSilent.Silentaim.Prediction = 0.15692
elseif pingNumber < 240 then
getgenv().SOSilent.Silentaim.Prediction = 0.16780
elseif pingNumber < 250 then
getgenv().SOSilent.Silentaim.Prediction = 0.1651
elseif pingNumber < 300 then
getgenv().SOSilent.Silentaim.Prediction = 0.195566
elseif pingNumber < 350 then
getgenv().SOSilent.Silentaim.Prediction = 0.16537

end
wait(0.25)
end

if getgenv().SOSilent.Silentaim.AntiAimViewer == true then
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and  v.Character:FindFirstChild("HumanoidRootPart")  then
    local c = game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
    local d = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(c.X, c.Y)).Magnitude

    if a > d then
        b = v
        a = d
    end
end
end

return b
end