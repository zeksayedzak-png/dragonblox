-- Dragon Fruit Assembler (يجمع قطع الفاكهة)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.7, 0, 0.8, 0)
frame.Position = UDim2.new(0.15, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
frame.Parent = screenGui

-- خاصية السحب
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
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.3)
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.2)
        frame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- العنوان
local title = Instance.new("TextLabel")
title.Text = "🐉 Dragon Fruit Assembler"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
title.Parent = frame

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0.1, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- قائمة المسارات
local paths = {
    {name = "🎮 بيانات الفاكهة", path = "ReplicatedStorage.Modules.Asset.ItemData.FruitAccessories.Dragon (East)-Dragon (East)"},
    {name = "🔄 نسخة التحول", path = "ReplicatedStorage.Modules.SkinUtil.SkinnedRigs.Transformations.Dragon (East)-Dragon(East)"},
    {name = "🍷 الكوب الأحمر", path = "ReplicatedStorage.Modules.SkinUtil.SkinnedRigs.Chalices.Dragon(East)-Dragon (East)"},
    {name = "🎨 مظهر الفاكهة", path = "ReplicatedStorage.Modules.SkinUtil.FruitSkins.Dragon(East)-Dragon (East)"},
    {name = "🎬 نسخة العرض", path = "Workspace.BaristaCutsceneDummy_Stored.Chalices.Dragon(East)-Dragon (East)"},
    {name = "📦 الموديل الأساسي", path = "ReplicatedStorage.Assets.Models.Chalices.Dragon (East)-Dragon (East)"}
}

local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(0.95, 0, 0.6, 0)
resultsFrame.Position = UDim2.new(0.025, 0, 0.15, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
resultsFrame.Parent = frame

local function checkPath(fullPath)
    local parts = string.split(fullPath, ".")
    local current = game
    
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then
            return false, nil
        end
    end
    
    return true, current
end

-- زر فحص كل المسارات
local scanBtn = Instance.new("TextButton")
scanBtn.Text = "🔍 افحص جميع المسارات"
scanBtn.Size = UDim2.new(0.95, 0, 0.08, 0)
scanBtn.Position = UDim2.new(0.025, 0, 0.77, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.Parent = frame

-- زر إنشاء فاكهة
local createBtn = Instance.new("TextButton")
createBtn.Text = "✨ أنشئ فاكهة كاملة"
createBtn.Size = UDim2.new(0.95, 0, 0.08, 0)
createBtn.Position = UDim2.new(0.025, 0, 0.87, 0)
createBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 150)
createBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createBtn.Font = Enum.Font.SourceSansBold
createBtn.Parent = frame

scanBtn.MouseButton1Click:Connect(function()
    resultsFrame:ClearAllChildren()
    
    local foundCount = 0
    local foundObjects = {}
    
    for i, pathData in ipairs(paths) do
        local exists, obj = checkPath(pathData.path)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, (i-1)*35)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = resultsFrame
        
        if exists then
            foundCount = foundCount + 1
            label.Text = "✅ " .. pathData.name
            label.TextColor3 = Color3.fromRGB(100, 255, 100)
            table.insert(foundObjects, obj)
        else
            label.Text = "❌ " .. pathData.name
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, #paths * 35)
end)

createBtn.MouseButton1Click:Connect(function()
    -- محاولة إنشاء فاكهة من البيانات
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if not backpack then
        print("❌ ما في حقيبة")
        return
    end
    
    -- محاولة الحصول على الموديل الأساسي
    local modelPath = "ReplicatedStorage.Assets.Models.Chalices.Dragon (East)-Dragon (East)"
    local parts = string.split(modelPath, ".")
    local current = game
    
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then break end
    end
    
    if current and current:IsA("Model") then
        -- إنشاء Tool جديد
        local newTool = Instance.new("Tool")
        newTool.Name = "Dragon_Fruit_Final"
        newTool.ToolTip = "Dragon Fruit (East)"
        
        -- نسخ الموديل داخل الـ Tool
        local modelClone = current:Clone()
        modelClone.Parent = newTool
        
        -- إضافة خصائص التغذية
        local nutrition = Instance.new("NumberValue")
        nutrition.Name = "Nutrition"
        nutrition.Value = 100
        nutrition.Parent = newTool
        
        local health = Instance.new("NumberValue")
        health.Name = "HealthBonus"
        health.Value = 50
        health.Parent = newTool
        
        -- إضافة Script للأكل
        local eatScript = Instance.new("Script")
        eatScript.Name = "EatScript"
        eatScript.Source = [[
            tool = script.Parent
            
            tool.Activated:Connect(function()
                local humanoid = game.Players.LocalPlayer.Character.Humanoid
                humanoid.Health = humanoid.Health + tool.HealthBonus.Value
                tool:Destroy()
            end)
        ]]
        eatScript.Parent = newTool
        
        newTool.Parent = backpack
        print("✅ فاكهة من صنعي في حقيبتك!")
    else
        print("❌ ما أقدرش أنشئ الفاكهة")
    end
end)
