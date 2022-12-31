local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")

local Config = require(ReplicatedStorage.Shared.Modules.UI)
local Player = Players.LocalPlayer
local ScreenGui = Player.PlayerGui:WaitForChild("UI")

local Colors = {}
local Sizes = {}

for _, TextButton: TextButton in ScreenGui:GetDescendants() do
    if (not TextButton:IsA("TextButton")) then
        continue
    end

    local H, S, V = TextButton.BackgroundColor3:ToHSV()

    Colors[TextButton] = TextButton.BackgroundColor3
    Sizes[TextButton] = TextButton.Size

    TextButton.MouseEnter:Connect(function()
       Tween:Create(TextButton, TweenInfo.new(Config.Short + 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromHSV(H, S, V - (Config.Hue / 255))}):Play()
    end)

    TextButton.MouseLeave:Connect(function()
        Tween:Create(TextButton, TweenInfo.new(Config.Short + 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = Colors[TextButton]}):Play()
    end)

    TextButton.Activated:Connect(function(inputObject, clickCount)
        Tween:Create(TextButton, TweenInfo.new(Config.Short, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.fromScale(Sizes[TextButton].X.Scale - Config.Click_Size, Sizes[TextButton].Y.Scale - Config.Click_Size)}):Play()
    
        delay(Config.Short + 0.05, function()
            Tween:Create(TextButton, TweenInfo.new(Config.Short, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = Sizes[TextButton]}):Play()
        end)
    end)
end
