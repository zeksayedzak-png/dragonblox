-- 🔍 بحث عن Dragon Fruit الحقيقية
local function findRealDragonFruit()
    local realFruits = {}
    
    -- البحث في أماكن المطورين
    local searchLocations = {
        game:GetService("ServerStorage"),
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("StarterPack"),
        game:GetService("StarterGui")
    }
    
    -- أنواع الفواكه المحتملة
    local fruitNames = {
        "Dragon Fruit",
        "DragonFruit", 
        "Dragon (East)",
        "Dragon_East",
        "DragonEast",
        "DragonChalice",
        "Chalice_Fruit"
    }
    
    -- بدأ البحث
    for _, location in pairs(searchLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            for _, fruitName in pairs(fruitNames) do
                if string.find(obj.Name:lower(), fruitName:lower()) then
                    -- فحص إذا كان أداة (Tool) يمكن استخدامها
                    if obj:IsA("Tool") then
                        -- فحص إذا كانت فيها خاصية Nutrition (قيمة غذائية)
                        if obj:FindFirstChild("Nutrition") or 
                           obj:FindFirstChild("Health") or
                           obj:FindFirstChild("Energy") or
                           obj:FindFirstChild("Eat") then
                            table.insert(realFruits, obj)
                            print("✅ وجدت فاكهة حقيقية: " .. obj:GetFullName())
                        end
                    end
                end
            end
        end
    end
    
    return realFruits
end

-- إنشاء نافذة البحث
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.7, 0)
frame.Position = UDim2.new(0.05, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.1)
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.3)
        frame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- زر البحث عن الفاكهة الحقيقية
local searchBtn = Instance.new("TextButton")
searchBtn.Text = "🔍 ابحث عن Dragon Fruit الحقيقية"
searchBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
searchBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
searchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
searchBtn.Parent = frame

-- زر نسخ الفاكهة
local copyBtn = Instance.new("TextButton")
copyBtn.Text = "✨ استدعي الفاكهة"
copyBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
copyBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
copyBtn.Parent = frame

-- قائمة النتائج
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
resultsFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
resultsFrame.Parent = frame

local selectedFruit = nil

searchBtn.MouseButton1Click:Connect(function()
    resultsFrame:ClearAllChildren()
    local fruits = findRealDragonFruit()
    
    if #fruits == 0 then
        local msg = Instance.new("TextLabel")
        msg.Text = "❌ ما لقيت فاكهة حقيقية"
        msg.Size = UDim2.new(1, 0, 0, 30)
        msg.TextColor3 = Color3.fromRGB(255, 100, 100)
        msg.Parent = resultsFrame
    else
        for i, fruit in ipairs(fruits) do
            local btn = Instance.new("TextButton")
            btn.Text = "🍎 " .. fruit.Name .. " (Tool)"
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*45)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Parent = resultsFrame
            
            btn.MouseButton1Click:Connect(function()
                selectedFruit = fruit
                btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                print("✅ اخترت: " .. fruit:GetFullName())
            end)
        end
    end
end)

copyBtn.MouseButton1Click:Connect(function()
    if not selectedFruit then
        print("⚠️ اختر فاكهة أولاً")
        return
    end
    
    -- نسخ الفاكهة
    local clone = selectedFruit:Clone()
    
    -- وضعها في الحقيبة
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        clone.Parent = backpack
        print("✅ الفاكهة في حقيبتك!")
    else
        clone.Parent = workspace
        print("✅ الفاكهة في الأرض!")
    end
end)

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0.1, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.85, 0, 0.02, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
