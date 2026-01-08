-- Dragon Tool Cloner
local toolName = "Dragon (East)-Dragon (East)"
local toolPath = "ReplicatedStorage.Assets.Models.Chalices." .. toolName

-- البحث عن الأداة الأصلية
local originalTool = nil
local function findTool()
    -- جرب المسار المباشر أول
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
    
    -- إذا ما لقيش، ابحث في كل اللعبة
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

local title = Instance.new("TextLabel")
title.Text = "🐉 Dragon Tool Generator"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 0)
title.Parent = frame

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
    
    -- نسخ الأداة
    local clone = originalTool:Clone()
    clone.Parent = workspace
    
    -- وضعه أمام اللاعب
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
        updateStatus("🎁 الأداة في حقيبتك الآن!", Color3.fromRGB(0, 255, 150))
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
