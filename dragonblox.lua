-- Dragon Fruit Assembler (يجمع الأجزاء في Tool واحد)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DragonAssembler"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.8, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
frame.Parent = screenGui

-- سحب النافذة
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
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.2)
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
title.Text = "🔨 Dragon Fruit Assembler"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
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
    {name = "📦 القالب الأساسي", path = "ReplicatedStorage.Assets.Models.Chalices.Dragon (East)-Dragon (East)"},
    {name = "📊 بيانات الفاكهة", path = "ReplicatedStorage.Modules.Asset.ItemData.FruitAccessories.Dragon (East)-Dragon (East)"},
    {name = "🔄 نسخة التحول", path = "ReplicatedStorage.Modules.SkinUtil.SkinnedRigs.Transformations.Dragon (East)-Dragon(East)"},
    {name = "🍷 الكوب الأحمر", path = "ReplicatedStorage.Modules.SkinUtil.SkinnedRigs.Chalices.Dragon(East)-Dragon (East)"},
    {name = "🎨 مظهر الفاكهة", path = "ReplicatedStorage.Modules.SkinUtil.FruitSkins.Dragon(East)-Dragon (East)"},
    {name = "🎬 نسخة العرض", path = "Workspace.BaristaCutsceneDummy_Stored.Chalices.Dragon(East)-Dragon (East)"},
    {name = "📦 بيانات إضافية", path = "ReplicatedStorage.Modules.Asset.ItemData.FruitAccessories.Dragon (East)-Dragon (East)"}
}

-- منطقة العرض
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.95, 0, 0.6, 0)
scrollFrame.Position = UDim2.new(0.025, 0, 0.15, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
scrollFrame.Parent = frame

-- دالة للوصول للمسار
local function getObject(path)
    local parts = string.split(path, ".")
    local current = game
    
    for _, part in ipairs(parts) do
        part = part:gsub("^%s*(.-)%s*$", "%1") -- تنظيف المسافات
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    
    return current
end

-- زر فحص كل القطع
local checkBtn = Instance.new("TextButton")
checkBtn.Text = "🔍 فحص جميع القطع"
checkBtn.Size = UDim2.new(0.95, 0, 0.08, 0)
checkBtn.Position = UDim2.new(0.025, 0, 0.77, 0)
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.Font = Enum.Font.SourceSansBold
checkBtn.Parent = frame

-- زر تجميع الفاكهة
local assembleBtn = Instance.new("TextButton")
assembleBtn.Text = "✨ أنشئ فاكهة كاملة"
assembleBtn.Size = UDim2.new(0.95, 0, 0.08, 0)
assembleBtn.Position = UDim2.new(0.025, 0, 0.87, 0)
assembleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 150)
assembleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
assembleBtn.Font = Enum.Font.SourceSansBold
assembleBtn.Parent = frame

local foundObjects = {}

checkBtn.MouseButton1Click:Connect(function()
    scrollFrame:ClearAllChildren()
    foundObjects = {}
    
    local yOffset = 0
    local foundCount = 0
    
    for i, pathData in ipairs(paths) do
        local obj = getObject(pathData.path)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, yOffset)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = scrollFrame
        
        if obj then
            foundCount = foundCount + 1
            label.Text = "✅ " .. i .. ". " .. pathData.name
            label.TextColor3 = Color3.fromRGB(100, 255, 100)
            foundObjects[i] = obj
        else
            label.Text = "❌ " .. i .. ". " .. pathData.name
            label.TextColor3 = Color3.fromRGB(255, 100, 100)
            foundObjects[i] = nil
        end
        
        yOffset = yOffset + 35
    end
    
    local summary = Instance.new("TextLabel")
    summary.Text = "📊 " .. foundCount .. "/7 قطع موجودة"
    summary.Size = UDim2.new(1, 0, 0, 30)
    summary.Position = UDim2.new(0, 0, 0, yOffset)
    summary.TextColor3 = Color3.fromRGB(255, 200, 100)
    summary.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 40)
end)

assembleBtn.MouseButton1Click:Connect(function()
    -- التأكد من وجود القالب الأساسي (المسار 1)
    if not foundObjects[1] then
        local warn = Instance.new("TextLabel")
        warn.Text = "⚠️ القالب الأساسي مش موجود"
        warn.Size = UDim2.new(1, 0, 0, 30)
        warn.Position = UDim2.new(0, 0, 0, #paths*35 + 10)
        warn.TextColor3 = Color3.fromRGB(255, 150, 50)
        warn.Parent = scrollFrame
        return
    end
    
    -- نسخ القالب الأساسي
    local baseTool = foundObjects[1]:Clone()
    baseTool.Name = "Dragon_Fruit_Complete"
    
    -- إضافة الأجزاء الأخرى داخل الـ Tool
    for i = 2, #paths do
        if foundObjects[i] then
            local partClone = foundObjects[i]:Clone()
            partClone.Name = "Part_" .. i
            partClone.Parent = baseTool
            
            -- إذا كان Part أو Model، نحطه في مجلد
            if partClone:IsA("BasePart") or partClone:IsA("Model") then
                local modelFolder = baseTool:FindFirstChild("FruitParts") or Instance.new("Folder")
                modelFolder.Name = "FruitParts"
                modelFolder.Parent = baseTool
                partClone.Parent = modelFolder
            end
        end
    end
    
    -- إضافة خصائص التغذية
    local nutrition = Instance.new("NumberValue")
    nutrition.Name = "Nutrition"
    nutrition.Value = 100
    nutrition.Parent = baseTool
    
    local health = Instance.new("NumberValue")
    health.Name = "HealthBonus"
    health.Value = 50
    health.Parent = baseTool
    
    -- جعلها أداة قابلة للاستخدام
    if baseTool:IsA("Model") then
        -- تحويل Model إلى Tool
        local toolWrapper = Instance.new("Tool")
        toolWrapper.Name = baseTool.Name
        toolWrapper.ToolTip = "Dragon Fruit (Complete)"
        
        baseTool.Parent = toolWrapper
        baseTool = toolWrapper
    end
    
    -- وضعها في حقيبة اللاعب
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        baseTool.Parent = backpack
        
        local successMsg = Instance.new("TextLabel")
        successMsg.Text = "✅ فاكهة مكتملة في حقيبتك!"
        successMsg.Size = UDim2.new(1, 0, 0, 30)
        successMsg.Position = UDim2.new(0, 0, 0, #paths*35 + 10)
        successMsg.TextColor3 = Color3.fromRGB(100, 255, 200)
        successMsg.Parent = scrollFrame
        
        print("🎉 فاكهة Dragon Fruit مكتملة في حقيبتك!")
    else
        baseTool.Parent = workspace
        print("🎉 فاكهة Dragon Fruit مكتملة في الأرض!")
    end
end)
