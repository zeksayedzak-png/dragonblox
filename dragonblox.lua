-- Dragon Fruit الحقيقية من المسار الجديد
local toolName = "Dragon (East)-Dragon (East)"
local toolPath = "ReplicatedStorage.Modules.Asset.ItemData.FruitAccessories." .. toolName

-- إنشاء واجهة صغيرة قابلة للسحب
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniFruitGUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.6, 0, 0.5, 0) -- واجهة صغيرة
frame.Position = UDim2.new(0.2, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(100, 100, 150)
frame.Parent = screenGui

-- خاصية السحب للنافذة
local isDragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(frame.Position.X.Scale, frame.Position.Y.Scale)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStart
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local deltaScale = Vector2.new(delta.X / viewportSize.X, delta.Y / viewportSize.Y)
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.4)
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.5)
        frame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- العنوان الصغير
local title = Instance.new("TextLabel")
title.Text = "🐉 Dragon Fruit"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
title.Parent = frame

-- زر الإغلاق الصغير
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0.15, 0, 0.15, 0)
closeBtn.Position = UDim2.new(0.85, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- البحث عن الفاكهة في المسار الجديد
local function findFruitInNewPath()
    local pathParts = {"ReplicatedStorage", "Modules", "Asset", "ItemData", "FruitAccessories"}
    
    local current = game
    for _, part in ipairs(pathParts) do
        current = current:FindFirstChild(part)
        if not current then
            return nil
        end
    end
    
    return current:FindFirstChild(toolName)
end

-- زر البحث السريع
local findBtn = Instance.new("TextButton")
findBtn.Text = "🔍 ابحث في المسار الجديد"
findBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
findBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
findBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
findBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
findBtn.Font = Enum.Font.SourceSansBold
findBtn.Parent = frame

-- زر الاستدعاء
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "✨ استدعي الفاكهة"
spawnBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
spawnBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 150)
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
findBtn.Font = Enum.Font.SourceSansBold
spawnBtn.Parent = frame

-- زر الإعطاء للحقيبة
local giveBtn = Instance.new("TextButton")
giveBtn.Text = "🎒 ضع في حقيبتي"
giveBtn.Size = UDim2.new(0.9, 0, 0.15, 0)
giveBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
giveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
giveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
giveBtn.Font = Enum.Font.SourceSansBold
giveBtn.Parent = frame

-- حالة البحث
local status = Instance.new("TextLabel")
status.Text = "⚡ جاهز للبحث"
status.Size = UDim2.new(1, 0, 0.15, 0)
status.Position = UDim2.new(0, 0, 0.8, 0)
status.TextColor3 = Color3.fromRGB(200, 200, 100)
status.Parent = frame

local foundFruit = nil

findBtn.MouseButton1Click:Connect(function()
    foundFruit = findFruitInNewPath()
    
    if foundFruit then
        status.Text = "✅ وجدت: " .. foundFruit.Name
        status.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("✅ المسار الصحيح: " .. foundFruit:GetFullName())
        
        -- فحص إذا كانت Tool
        if foundFruit:IsA("Tool") then
            status.Text = status.Text .. " (أداة)"
        end
    else
        status.Text = "❌ ما لقيت في المسار"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

spawnBtn.MouseButton1Click:Connect(function()
    if not foundFruit then
        status.Text = "⚠️ ابحث أولاً"
        status.TextColor3 = Color3.fromRGB(255, 150, 50)
        return
    end
    
    local clone = foundFruit:Clone()
    clone.Parent = workspace
    
    -- وضعها أمام اللاعب
    local player = game.Players.LocalPlayer
    if player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            clone:PivotTo(hrp.CFrame * CFrame.new(0, 0, -3))
        end
    end
    
    status.Text = "✨ استدعيت في الأرض"
    status.TextColor3 = Color3.fromRGB(255, 255, 100)
end)

giveBtn.MouseButton1Click:Connect(function()
    if not foundFruit then
        status.Text = "⚠️ ابحث أولاً"
        status.TextColor3 = Color3.fromRGB(255, 150, 50)
        return
    end
    
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        local clone = foundFruit:Clone()
        clone.Parent = backpack
        status.Text = "🎒 في حقيبتك!"
        status.TextColor3 = Color3.fromRGB(100, 255, 200)
    else
        status.Text = "❌ ما في حقيبة"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
