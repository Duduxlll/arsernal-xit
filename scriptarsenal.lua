-- COUNTER BLOX MOD V1 - GUI FUNCIONAL
-- Feito para uso com: loadstring(game:HttpGet("URL_DO_SCRIPT"))()

-- Tela principal
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CBX_Mod"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 330)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🎯 Counter Blox MOD"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Variáveis
getgenv().Aimbot = false
getgenv().TriggerBot = false
getgenv().WallCheck = false
getgenv().FOV = true

-- Função para criar botões
local function criarBotao(nome, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.Text = nome .. " [OFF]"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.BorderSizePixel = 0

	local ativo = false

	btn.MouseButton1Click:Connect(function()
		ativo = not ativo
		btn.Text = nome .. (ativo and " [ON]" or " [OFF]")
		btn.BackgroundColor3 = ativo and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
		callback(ativo)
	end)
end

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- FOV círculo
local fov = Drawing.new("Circle")
fov.Visible = true
fov.Thickness = 2
fov.Transparency = 1
fov.Color = Color3.fromRGB(0, 255, 0)
fov.Radius = 150
fov.Filled = false

-- Atualiza posição do FOV
RunService.RenderStepped:Connect(function()
	fov.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	fov.Visible = getgenv().FOV
end)

-- Função para achar inimigo mais perto da mira
function getClosest()
	local closest, dist = nil, math.huge
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
			local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
			if vis then
				local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
				if mag < dist and mag < fov.Radius then
					dist = mag
					closest = v
				end
			end
		end
	end
	return closest
end

-- AIMBOT
RunService.RenderStepped:Connect(function()
	if getgenv().Aimbot then
		local target = getClosest()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- TRIGGERBOT
RunService.RenderStepped:Connect(function()
	if getgenv().TriggerBot then
		local target = getClosest()
		if target then
			mouse1click()
			wait(0.15)
		end
	end
end)

-- Botões
criarBotao("Aimbot", 50, function(v) getgenv().Aimbot = v end)
criarBotao("TriggerBot", 95, function(v) getgenv().TriggerBot = v end)
criarBotao("FOV Visual", 140, function(v) getgenv().FOV = v end)
criarBotao("WallCheck", 185, function(v) getgenv().WallCheck = v end)

-- Info
local info = Instance.new("TextLabel", frame)
info.Text = "💡 Use com sabedoria"
info.Size = UDim2.new(1, -10, 0, 40)
info.Position = UDim2.new(0, 5, 1, -45)
info.TextColor3 = Color3.fromRGB(180, 180, 180)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextWrapped = true
