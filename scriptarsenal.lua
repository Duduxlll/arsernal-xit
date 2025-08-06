-- COUNTER BLOX ULTIMATE MOD by ChatGPT for Vitor
-- Aimbot com FOV ajustável, TriggerBot, WallCheck, AORHACK (ESP), Pain Assist e GUI completa

if getgenv().CBloxMod then return end
getgenv().CBloxMod = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local TriggerBotEnabled = false
local WallCheckEnabled = true
local ESPEnabled = false
local FOVRadius = 120
local AimbotStrength = 5 -- 1 (forte) a 10 (fraco)

local ESP_Boxes = {}
local FOVCircle = nil
local Target = nil

-- GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "CBloxUltimateGUI"

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 260, 0, 320)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0, 8)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Top

-- Util: criar botão
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 30)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- Util: slider
local function createSlider(title, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 230, 0, 40)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = title .. ": " .. default
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12

    local slider = Instance.new("TextButton", container)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.Size = UDim2.new(1, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    slider.Text = ""
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

    slider.MouseButton1Down:Connect(function()
        local moving = true
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not moving then conn:Disconnect() return end
            local mouse = UIS:GetMouseLocation().X
            local pos = mouse - slider.AbsolutePosition.X
            local pct = math.clamp(pos / slider.AbsoluteSize.X, 0, 1)
            local val = math.floor((min + (max - min) * pct) + 0.5)
            label.Text = title .. ": " .. val
            callback(val)
        end)
        UIS.InputEnded:Wait()
        moving = false
    end)

    return container
end

-- Adicionar botões e sliders
Frame:AddChild(createButton("Aimbot: ON/OFF", function() AimbotEnabled = not AimbotEnabled end))
Frame:AddChild(createButton("TriggerBot: ON/OFF", function() TriggerBotEnabled = not TriggerBotEnabled end))
Frame:AddChild(createButton("WallCheck: ON/OFF", function() WallCheckEnabled = not WallCheckEnabled end))
Frame:AddChild(createButton("AORHACK (ESP): ON/OFF", function() ESPEnabled = not ESPEnabled end))
Frame:AddChild(createButton("Mostrar FOV: ON/OFF", function()
    if FOVCircle then FOVCircle:Remove() FOVCircle = nil else
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Color = Color3.new(1, 1, 1)
        FOVCircle.Thickness = 1
        FOVCircle.Transparency = 0.6
        FOVCircle.Filled = false
        FOVCircle.Visible = true
        FOVCircle.Radius = FOVRadius
    end
end))
Frame:AddChild(createSlider("FOV", 50, 300, FOVRadius, function(v) FOVRadius = v if FOVCircle then FOVCircle.Radius = v end end))
Frame:AddChild(createSlider("Aimbot Força", 1, 10, AimbotStrength, function(v) AimbotStrength = v end))

-- Util: inimigo mais próximo
local function getClosest()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, vis = Camera:WorldToViewportPoint(head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < FOVRadius and mag < dist then
                    if WallCheckEnabled then
                        local ray = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500, {LocalPlayer.Character})
                        if ray and ray.Instance and ray.Instance:IsDescendantOf(p.Character) then
                            closest, dist = p, mag
                        end
                    else
                        closest, dist = p, mag
                    end
                end
            end
        end
    end
    return closest
end

-- ESP loop
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, b in pairs(ESP_Boxes) do b:Remove() end
        ESP_Boxes = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
                if onscreen then
                    local box = Drawing.new("Square")
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 45)
                    box.Size = Vector2.new(50, 90)
                    box.Color = Color3.new(1, 0, 0)
                    box.Thickness = 1
                    box.Transparency = 0.8
                    box.Filled = false
                    box.Visible = true
                    table.insert(ESP_Boxes, box)
                end
            end
        end
    else
        for _, b in pairs(ESP_Boxes) do b:Remove() end
        ESP_Boxes = {}
    end
end)

-- Aimbot + Trigger loop
RunService.RenderStepped:Connect(function()
    if FOVCircle then FOVCircle.Position = UIS:GetMouseLocation() end
    if AimbotEnabled then
        Target = getClosest()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local pos = Target.Character.Head.Position
            local dir = (pos - Camera.CFrame.Position).Unit
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), 0.1 * (11 - AimbotStrength))
        end
    else
        Target = nil
    end
    if TriggerBotEnabled and Target then
        mouse1click()
    end
end)

