-- Dragon Tool Cloner مع تحريك النافذة بالإصبع
local toolName = "Dragon (East)-Dragon (East)"

-- البحث عن الأداة الأصلية
local originalTool = nil
local function findTool()
    originalTool = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
    if originalTool then
        originalTool = originalTool:FindFirstChild("Models")
        if originalTool then
            originalTool = originalTool:FindFirstChild("Chalices")
            if originalTool then
                originalTool = originalTool:FindFirstChild(toolName)
            end
        end
    end
    
    if not originalTool then
        for _, obj in pairs(game:GetDescendants()) do
            if obj.Name == toolName and obj:IsA("Tool") then
                originalTool = obj
                break
            end
        end
    end
end

-- إنشاء واجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.4, 0)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
frame.Parent = screenGui

-- ========== هنا التحكم بسحب النافذة ==========
local isDragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

-- جعل إطار النافذة قابل للسحب
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
        
        -- تحويل الحركة من بيكسلات إلى مقياس الشاشة (0-1)
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local deltaScale = Vector2.new(
            delta.X / viewportSize.X,
            delta.Y / viewportSize.Y
        )
        
        -- تحديث موقع النافذة
        local newX = frameStart.X + deltaScale.X
        local newY = frameStart.Y + deltaScale.Y
        
        -- التأكد من بقاء النافذة داخل الشاشة
        newX = math.clamp(newX, 0, 0.2) -- 0.2 = 1 - 0.8 (عرض النافذة)
        newY = math.clamp(newY, 0, 0.6) -- 0.6 = 1 - 0.4 (ارتفاع النافذة)
        
        frame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)
-- ========== نهاية كود سحب النافذة ==========

-- عنوان النافذة مع زر إغلاق
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.15, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "🐉 Dragon Tool Generator"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Position = UDim2.new(0.1, 0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.BackgroundTransparency = 1
title.Parent = titleBar

-- زر إغلاق النافذة
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local status = Instance.new("TextLabel")
status.Text = "جاري البحث عن الأداة..."
status.Size = UDim2.new(1, 0, 0.15, 0)
status.Position = UDim2.new(0, 0, 0.15, 0)
status.TextColor3 = Color3.fromRGB(200, 200, 255)
status.Parent = frame

local function updateStatus(msg, color)
    status.Text = msg
    status.TextColor3 = color or Color3.fromRGB(200, 200, 255)
end

-- زر البحث
local findBtn = Instance.new("TextButton")
findBtn.Text = "🔍 ابحث عن الأداة"
findBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
findBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
findBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
findBtn.Parent = frame

-- زر الاستدعاء
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "✨ استدعي الأداة"
spawnBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
spawnBtn.Position = UDim2.new(0.55, 0, 0.35, 0)
spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
spawnBtn.Parent = frame

-- زر الإعطاء لنفسك
local giveBtn = Instance.new("TextButton")
giveBtn.Text = "🎁 أعطني الأداة"
giveBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
giveBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
giveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
giveBtn.Parent = frame

-- زر وضع في الأرض
local dropBtn = Instance.new("TextButton")
dropBtn.Text = "⬇️ ضع في الأرض"
dropBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
dropBtn.Position = UDim2.new(0.55, 0, 0.55, 0)
dropBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
dropBtn.Parent = frame

-- معلومات
local info = Instance.new("TextLabel")
info.Text = "الأداة: غير موجودة"
info.Size = UDim2.new(1, 0, 0.15, 0)
info.Position = UDim2.new(0, 0, 0.75, 0)
info.TextColor3 = Color3.fromRGB(150, 255, 150)
info.Parent = frame

-- البحث عن الأداة أول مرة
findTool()

findBtn.MouseButton1Click:Connect(function()
    findTool()
    if originalTool then
        updateStatus("✅ وجدت الأداة!", Color3.fromRGB(0, 255, 0))
        info.Text = "الأداة: " .. originalTool:GetFullName()
    else
        updateStatus("❌ ما لقيتش الأداة", Color3.fromRGB(255, 0, 0))
        info.Text = "الأداة: غير موجودة"
    end
end)

spawnBtn.MouseButton1Click:Connect(function()
    if not originalTool then
        updateStatus("⚠️ ابحث عن الأداة أولاً", Color3.fromRGB(255, 150, 0))
        return
    end
    
    local clone = originalTool:Clone()
    clone.Parent = workspace
    
    local player = game.Players.LocalPlayer
    if player.Character then
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            clone:PivotTo(hrp.CFrame * CFrame.new(0, 0, -5))
        end
    end
    
    updateStatus("✨ الأداة استدعيت في الأرض", Color3.fromRGB(255, 255, 0))
end)

giveBtn.MouseButton1Click:Connect(function()
    if not originalTool then
        updateStatus("⚠️ ابحث عن الأداة أولاً", Color3.fromRGB(255, 150, 0))
        return
    end
    
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        local clone = originalTool:Clone()
        clone.Parent = backpack
        updateStatus("🎁 الأداة في حقيبتك!", Color3.fromRGB(0, 255, 150))
    else
        updateStatus("❌ ما في حقيبة", Color3.fromRGB(255, 100, 100))
    end
end)

dropBtn.MouseButton1Click:Connect(function()
    if not originalTool then
        updateStatus("⚠️ ابحث عن الأداة أولاً", Color3.fromRGB(255, 150, 0))
        return
    end
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local clone = originalTool:Clone()
            clone.Parent = workspace
            clone:PivotTo(hrp.CFrame * CFrame.new(0, 0, -3))
            updateStatus("⬇️ الأداة وضعت تحتك", Color3.fromRGB(150, 200, 255))
        end
    end
end)

-- تحديث الحالة
if originalTool then
    updateStatus("✅ الأداة موجودة وجاهزة", Color3.fromRGB(0, 255, 0))
    info.Text = "الأداة: " .. originalTool:GetFullName()
else
    updateStatus("❌ اضغط 'ابحث عن الأداة'", Color3.fromRGB(255, 100, 100))
end
