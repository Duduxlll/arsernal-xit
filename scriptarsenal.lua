-- COUNTER BLOX XIT - GUI COMPLETA COM AIMBOT, TRIGGERBOT, FOV, ETC
if getgenv().CounterBloxModLoaded then return end
getgenv().CounterBloxModLoaded = true

-- Serviços Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis principais
local Aimbot = false
local TriggerBot = false
local WallCheck = true
local ShowFOV = true
local FOVRadius = 130

-- Criar FOV visual
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 0)
FOVCircle.Thickness = 2
FOVCircle.Radius = FOVRadius
FOVCircle.Visible = ShowFOV
FOVCircle.Transparency = 0.6
FOVCircle.Filled = false

-- Criar GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CounterBloxModGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 330)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔥 Counter Blox Hack Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Função para criar botão com feedback visual
local function criarBotao(nome, posY, callback)
	local botao = Instance.new("TextButton", frame)
	botao.Size = UDim2.new(0, 230, 0, 40)
	botao.Position = UDim2.new(0, 25, 0, posY)
	botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	botao.Font = Enum.Font.GothamBold
	botao.TextSize = 16
	botao.Text = nome .. ": OFF"
	Instance.new("UICorner", botao).CornerRadius = UDim.new(0, 6)

	local ativo = false
	botao.MouseButton1Click:Connect(function()
		ativo = not ativo
		botao.Text = nome .. ": " .. (ativo and "ON" or "OFF")
		botao.BackgroundColor3 = ativo and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
		callback(ativo)
	end)
end

-- Criar botões
criarBotao("Aimbot", 60, function(v) Aimbot = v end)
criarBotao("TriggerBot", 110, function(v) TriggerBot = v end)
criarBotao("WallCheck", 160, function(v) WallCheck = v end)
criarBotao("Mostrar FOV", 210, function(v)
	ShowFOV = v
	FOVCircle.Visible = v
end)

-- Função: encontrar inimigo mais próximo no FOV
local function getClosestEnemy()
	local closest, dist = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, visible = Camera:WorldToScreenPoint(head.Position)
			local mouse = UIS:GetMouseLocation()
			local diff = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
			if visible and diff < FOVRadius and diff < dist then
				if WallCheck then
					local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, {LocalPlayer.Character})
					if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
						closest, dist = player, diff
					end
				else
					closest, dist = player, diff
				end
			end
		end
	end
	return closest
end

-- Loop principal
RunService.RenderStepped:Connect(function()
	if FOVCircle then
		FOVCircle.Position = UIS:GetMouseLocation()
	end

	local target = getClosestEnemy()

	if Aimbot and target and target.Character and target.Character:FindFirstChild("Head") then
		local head = target.Character.Head.Position
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head)
	end

	if TriggerBot and target then
		mouse1click()
	end
end)

