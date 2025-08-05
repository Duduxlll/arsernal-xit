-- Counter Blox Script com GUI Bonita e Funcional
-- Feito para uso via executor (Delta, Hydrogen, etc.)
-- Recomendado executar com: loadstring(game:HttpGet("https://raw.githubusercontent.com/SEU-USUARIO/counterblox-mod/main/script.lua"))()

-- // GUI SETUP
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CounterBloxMod"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 370)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚙️ Counter Blox Mod"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- // Função de botão com ativação/desativação
local function criarBotao(nome, posY, callback)
	local botao = Instance.new("TextButton", frame)
	botao.Size = UDim2.new(0.9, 0, 0, 35)
	botao.Position = UDim2.new(0.05, 0, 0, posY)
	botao.Text = nome .. " [OFF]"
	botao.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	botao.TextColor3 = Color3.new(1, 1, 1)
	botao.Font = Enum.Font.Gotham
	botao.TextSize = 16
	botao.BorderSizePixel = 0
	
	local ligado = false
	
	botao.MouseButton1Click:Connect(function()
		ligado = not ligado
		botao.Text = nome .. (ligado and " [ON]" or " [OFF]")
		botao.BackgroundColor3 = ligado and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 60)
		callback(ligado)
	end)
end

-- // Variáveis globais
getgenv().Aimbot = false
getgenv().TriggerBot = false
getgenv().WallCheck = false
getgenv().FOV = true

-- // AIMBOT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

function getClosestPlayer()
	local closestPlayer, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if dist < closestDistance and dist < 150 then
					closestDistance = dist
					closestPlayer = player
				end
			end
		end
	end
	return closestPlayer
end

-- Loop do Aimbot
RunService.RenderStepped:Connect(function()
	if getgenv().Aimbot then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

-- // TRIGGERBOT
RunService.RenderStepped:Connect(function()
	if getgenv().TriggerBot then
		local target = getClosestPlayer()
		if target then
			mouse1click()
			wait(0.1)
		end
	end
end)

-- // FOV CÍRCULO
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = 150
fovCircle.Thickness = 2
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Visible = true

RunService.RenderStepped:Connect(function()
	fovCircle.Visible = getgenv().FOV
end)

-- // BOTÕES DA GUI
criarBotao("Aimbot", 50, function(v) getgenv().Aimbot = v end)
criarBotao("TriggerBot", 95, function(v) getgenv().TriggerBot = v end)
criarBotao("FOV Visual", 140, function(v) getgenv().FOV = v end)

-- // Futuro: WallCheck (implementação depende do Raycast do mapa)
criarBotao("WallCheck", 185, function(v) getgenv().WallCheck = v end)

-- Info
local info = Instance.new("TextLabel", frame)
info.Text = "💡 Use com responsabilidade"
info.Size = UDim2.new(1, -10, 0, 40)
info.Position = UDim2.new(0, 5, 1, -45)
info.TextColor3 = Color3.fromRGB(180, 180, 180)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextWrapped = true

