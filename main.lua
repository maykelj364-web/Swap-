local Players = game:GetService("Players")
local player = Players.LocalPlayer

local savedPosition
local marker

local gui = Instance.new("ScreenGui")
gui.Name = "RedAfterimage"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(190, 125)
frame.Position = UDim2.new(0.5, -95, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local function makeButton(name, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 42)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = name
    b.TextSize = 17
    b.Font = Enum.Font.GothamBold
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)

    b.MouseButton1Click:Connect(callback)
end

local function explosion(position)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Parent = workspace

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture =
        "rbxasset://textures/particles/sparkles_main.dds"
    emitter.Color = ColorSequence.new(
        Color3.fromRGB(255, 0, 0)
    )
    emitter.Lifetime = NumberRange.new(0.4, 0.8)
    emitter.Speed = NumberRange.new(8, 15)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Rate = 0
    emitter.Parent = part
    emitter:Emit(50)

    task.delay(2, function()
        part:Destroy()
    end)
end

makeButton("CLONE", 10, function()
    local char = player.Character
    if not char then return end

    savedPosition = char:GetPivot()

    if marker then
        marker:Destroy()
    end

    marker = Instance.new("Part")
    marker.Name = "RedClone"
    marker.Shape = Enum.PartType.Cylinder
    marker.Size = Vector3.new(0.15, 3, 3)
    marker.Material = Enum.Material.Neon
    marker.Color = Color3.fromRGB(255, 0, 0)
    marker.Transparency = 0.2
    marker.Anchored = true
    marker.CanCollide = false
    marker.CFrame =
        savedPosition * CFrame.Angles(0, 0, math.rad(90))
    marker.Parent = workspace

    explosion(savedPosition.Position)
end)

makeButton("SWAP", 62, function()
    local char = player.Character
    if not char or not savedPosition then return end

    local oldPosition = char:GetPivot()

    explosion(oldPosition.Position)
    explosion(savedPosition.Position)

    char:PivotTo(savedPosition)

    if marker then
        marker.CFrame =
            oldPosition * CFrame.Angles(0, 0, math.rad(90))
    end

    savedPosition = oldPosition

    explosion(oldPosition.Position)
end)
