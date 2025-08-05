-- Script Arsenal: Aimbot, TriggerBot, FOV, WallCheck + GUI Bonita

-- Proteção de ambiente
if getgenv().ArsenalMod then return end
getgenv().ArsenalMod = true

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Variáveis
local AimbotEnabled = false
local TriggerBotEnabled = false
local WallCheckEnabled = true
local FOVRadius = 100
local FOVCircle
local Target

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ArsenalModGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 220)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Função para criar botões
local function criarBotao(texto, posY, callback)
	local Botao = Instance.new("TextButton", Frame)
	Botao.Size = UDim2.new(0, 200, 0, 30)
	Botao.Position = UDim2.new(0, 20, 0, posY)
	Botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	Botao.Text = texto
	Botao.Font = Enum.Font.GothamBold
	Botao.TextSize = 14
	Botao.MouseButton1Click:Connect(callback)

	local corner = Instance.new("UICorner", Botao)
	corner.CornerRadius = UDim.new(0, 6)

	return Botao
end

-- Botões
criarBotao("Aimbot: ON/OFF", 20, function()
	AimbotEnabled = not AimbotEnabled
end)

criarBotao("TriggerBot: ON/OFF", 60, function()
	TriggerBotEnabled = not TriggerBotEnabled
end)

criarBotao("WallCheck: ON/OFF", 100, function()
	WallCheckEnabled = not WallCheckEnabled
end)

criarBotao("Mostrar FOV: ON/OFF", 140, function()
	if FOVCircle then
		FOVCircle:Remove()
		FOVCircle = nil
	else
		FOVCircle = Drawing.new("Circle")
		FOVCircle.Position = UIS:GetMouseLocation()
		FOVCircle.Color = Color3.fromRGB(255, 255, 255)
		FOVCircle.Radius = FOVRadius
		FOVCircle.Visible = true
		FOVCircle.Thickness = 1
		FOVCircle.Transparency = 0.7
	end
end)

-- Função para encontrar o inimigo mais próximo
local function getClosestPlayer()
	local closestPlayer, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
			if onScreen then
				local mousePos = UIS:GetMouseLocation()
				local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if dist < FOVRadius and dist < closestDistance then
					if WallCheckEnabled then
						local ray = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 500, {LocalPlayer.Character})
						if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
							closestPlayer = player
							closestDistance = dist
						end
					else
						closestPlayer = player
						closestDistance = dist
					end
				end
			end
		end
	end
	return closestPlayer
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		Target = getClosestPlayer()
		if Target and Target.Character and Target.Character:FindFirstChild("Head") then
			local headPos = Target.Character.Head.Position
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, headPos)
		end
	end

	if FOVCircle then
		FOVCircle.Position = UIS:GetMouseLocation()
	end
end)

-- TriggerBot Loop
RunService.RenderStepped:Connect(function()
	if TriggerBotEnabled and Target and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
		mouse1click()
	end
end)
-- Script Arsenal: Aimbot, TriggerBot, FOV, WallCheck + GUI Bonita

-- Proteção de ambiente
if getgenv().ArsenalMod then return end
getgenv().ArsenalMod = true

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Variáveis
local AimbotEnabled = false
local TriggerBotEnabled = false
local WallCheckEnabled = true
local FOVRadius = 100
local FOVCircle
local Target

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ArsenalModGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 220)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Função para criar botões
local function criarBotao(texto, posY, callback)
	local Botao = Instance.new("TextButton", Frame)
	Botao.Size = UDim2.new(0, 200, 0, 30)
	Botao.Position = UDim2.new(0, 20, 0, posY)
	Botao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	Botao.Text = texto
	Botao.Font = Enum.Font.GothamBold
	Botao.TextSize = 14
	Botao.MouseButton1Click:Connect(callback)

	local corner = Instance.new("UICorner", Botao)
	corner.CornerRadius = UDim.new(0, 6)

	return Botao
end

-- Botões
criarBotao("Aimbot: ON/OFF", 20, function()
	AimbotEnabled = not AimbotEnabled
end)

criarBotao("TriggerBot: ON/OFF", 60, function()
	TriggerBotEnabled = not TriggerBotEnabled
end)

criarBotao("WallCheck: ON/OFF", 100, function()
	WallCheckEnabled = not WallCheckEnabled
end)

criarBotao("Mostrar FOV: ON/OFF", 140, function()
	if FOVCircle then
		FOVCircle:Remove()
		FOVCircle = nil
	else
		FOVCircle = Drawing.new("Circle")
		FOVCircle.Position = UIS:GetMouseLocation()
		FOVCircle.Color = Color3.fromRGB(255, 255, 255)
		FOVCircle.Radius = FOVRadius
		FOVCircle.Visible = true
		FOVCircle.Thickness = 1
		FOVCircle.Transparency = 0.7
	end
end)

-- Função para encontrar o inimigo mais próximo
local function getClosestPlayer()
	local closestPlayer, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
			if onScreen then
				local mousePos = UIS:GetMouseLocation()
				local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if dist < FOVRadius and dist < closestDistance then
					if WallCheckEnabled then
						local ray = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 500, {LocalPlayer.Character})
						if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
							closestPlayer = player
							closestDistance = dist
						end
					else
						closestPlayer = player
						closestDistance = dist
					end
				end
			end
		end
	end
	return closestPlayer
end

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		Target = getClosestPlayer()
		if Target and Target.Character and Target.Character:FindFirstChild("Head") then
			local headPos = Target.Character.Head.Position
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, headPos)
		end
	end

	if FOVCircle then
		FOVCircle.Position = UIS:GetMouseLocation()
	end
end)

-- TriggerBot Loop
RunService.RenderStepped:Connect(function()
	if TriggerBotEnabled and Target and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
		mouse1click()
	end
end)
