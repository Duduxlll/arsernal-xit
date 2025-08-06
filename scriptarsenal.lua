-- COUNTER BLOX MOD SCRIPT: Aimbot, TriggerBot, WallCheck, FOV + GUI
if getgenv().CBloxMod then return end
getgenv().CBloxMod = true

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variáveis
local AimbotOn = false
local TriggerBotOn = false
local WallCheckOn = true
local ShowFOV = false
local FOV = 120

local FOVCircle = nil
local CurrentTarget = nil

-- GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "CounterBloxGUI"

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 240, 0, 220)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Botão utilitário
local function criarBotao(txt, y, callback)
	local botao = Instance.new("TextButton", Frame)
	botao.Size = UDim2.new(0, 200, 0, 30)
	botao.Position = UDim2.new(0, 20, 0, y)
	botao.Text = txt
	botao.Font = Enum.Font.GothamBold
	botao.TextSize = 14
	botao.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	botao.TextColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", botao).CornerRadius = UDim.new(0, 6)
	botao.MouseButton1Click:Connect(callback)
	return botao
end

-- Botões
criarBotao("Aimbot: ON/OFF", 20, function()
	AimbotOn = not AimbotOn
end)

criarBotao("TriggerBot: ON/OFF", 60, function()
	TriggerBotOn = not TriggerBotOn
end)

criarBotao("WallCheck: ON/OFF", 100, function()
	WallCheckOn = not WallCheckOn
end)

criarBotao("Mostrar FOV: ON/OFF", 140, function()
	ShowFOV = not ShowFOV
	if ShowFOV and not FOVCircle then
		FOVCircle = Drawing.new("Circle")
		FOVCircle.Radius = FOV
		FOVCircle.Color = Color3.fromRGB(255, 255, 255)
		FOVCircle.Thickness = 1
		FOVCircle.Transparency = 0.7
		FOVCircle.Filled = false
		FOVCircle.Visible = true
	elseif FOVCircle then
		FOVCircle:Remove()
		FOVCircle = nil
	end
end)

-- Função: inimigo mais próximo do mouse
local function getClosestEnemy()
	local closest, dist = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local pos, visible = Camera:WorldToViewportPoint(head.Position)
			if visible then
				local mousePos = UIS:GetMouseLocation()
				local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if mag < FOV and mag < dist then
					if WallCheckOn then
						local ray = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 500, {LocalPlayer.Character})
						if ray and ray.Instance and ray.Instance:IsDescendantOf(player.Character) then
							closest, dist = player, mag
						end
					else
						closest, dist = player, mag
					end
				end
			end
		end
	end
	return closest
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
	if AimbotOn then
		local target = getClosestEnemy()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
			CurrentTarget = target
		else
			CurrentTarget = nil
		end
	end

	-- FOV desenhado
	if FOVCircle then
		FOVCircle.Position = UIS:GetMouseLocation()
	end
end)

-- TriggerBot loop
RunService.RenderStepped:Connect(function()
	if TriggerBotOn and CurrentTarget and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
		mouse1click()
	end
end)
