-- Arsenal Script com GUI Bonita, Botões Visuais ON/OFF, FOV, Aimbot, TriggerBot e WallCheck
if getgenv().ArsenalModGUI then return end
getgenv().ArsenalModGUI = true

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Configuração de variáveis
local Aimbot = false
local TriggerBot = false
local WallCheck = true
local ShowFOV = false
local FOV = 120
local FOVCircle

-- Função: Desenhar círculo FOV
local function drawFOV()
	if FOVCircle then FOVCircle:Remove() end
	FOVCircle = Drawing.new("Circle")
	FOVCircle.Color = Color3.fromRGB(0, 255, 0)
	FOVCircle.Thickness = 1
	FOVCircle.Radius = FOV
	FOVCircle.Transparency = 0.6
	FOVCircle.Filled = false
	FOVCircle.Visible = ShowFOV
end
drawFOV()

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ArsenalModGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "⚙ Arsenal Hack Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Função botão com cor dinâmica
local function criarBotao(nome, posY, callback)
	local botao = Instance.new("TextButton", frame)
	botao.Size = UDim2.new(0, 200, 0, 30)
	botao.Position = UDim2.new(0, 25, 0, posY)
	botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	botao.Font = Enum.Font.GothamBold
	botao.TextSize = 14
	botao.Text = nome .. ": OFF"
	Instance.new("UICorner", botao).CornerRadius = UDim.new(0, 6)

	local state = false
	botao.MouseButton1Click:Connect(function()
		state = not state
		botao.Text = nome .. ": " .. (state and "ON" or "OFF")
		botao.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
		callback(state)
	end)
end

-- Botões funcionais
criarBotao("Aimbot", 40, function(v) Aimbot = v end)
criarBotao("TriggerBot", 80, function(v) TriggerBot = v end)
criarBotao("WallCheck", 120, function(v) WallCheck = v end)
criarBotao("Mostrar FOV", 160, function(v)
	ShowFOV = v
	if FOVCircle then FOVCircle.Visible = v end
end)

-- Função: encontrar inimigo mais próximo
local function getClosestPlayer()
	local closest, dist = nil, math.huge
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
			local mousePos = UIS:GetMouseLocation()
			local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
			if onScreen and mag < FOV and mag < dist then
				if WallCheck then
					local ray = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, {LocalPlayer.Character})
					if ray and ray.Instance and ray.Instance:IsDescendantOf(plr.Character) then
						closest, dist = plr, mag
					end
				else
					closest, dist = plr, mag
				end
			end
		end
	end
	return closest
end

-- Aimbot e TriggerBot
RunService.RenderStepped:Connect(function()
	if FOVCircle then
		FOVCircle.Position = UIS:GetMouseLocation()
	end

	local target = getClosestPlayer()

	if Aimbot and target and target.Character:FindFirstChild("Head") then
		local head = target.Character.Head.Position
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head)
	end

	if TriggerBot and target then
		mouse1click()
	end
end)
