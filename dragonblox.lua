-- Dragon Tool Explorer (يشوف محتويات الـ Tool)
local toolPath = "ReplicatedStorage.Assets.Models.Chalices.Dragon (East)-Dragon (East)"

-- إنشاء واجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToolExplorer"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.7, 0)
frame.Position = UDim2.new(0.1, 0, 0.15, 0)
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
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.3)
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
title.Text = "🔍 Dragon Tool Explorer"
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

-- البحث عن الـ Tool
local function findTool()
    local parts = string.split(toolPath, ".")
    local current = game
    
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    
    return current
end

-- منطقة العرض
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.95, 0, 0.7, 0)
scrollFrame.Position = UDim2.new(0.025, 0, 0.15, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
scrollFrame.Parent = frame

-- زر استكشاف
local exploreBtn = Instance.new("TextButton")
exploreBtn.Text = "🔍 استكشف محتويات الـ Tool"
exploreBtn.Size = UDim2.new(0.95, 0, 0.08, 0)
exploreBtn.Position = UDim2.new(0.025, 0, 0.87, 0)
exploreBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
exploreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exploreBtn.Font = Enum.Font.SourceSansBold
exploreBtn.Parent = frame

exploreBtn.MouseButton1Click:Connect(function()
    scrollFrame:ClearAllChildren()
    
    local tool = findTool()
    if not tool then
        local label = Instance.new("TextLabel")
        label.Text = "❌ ما لقيت الـ Tool"
        label.Size = UDim2.new(1, 0, 0, 40)
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
        label.Parent = scrollFrame
        return
    end
    
    -- عرض معلومات الـ Tool
    local toolInfo = Instance.new("TextLabel")
    toolInfo.Text = "📦 Tool: " .. tool.Name
    toolInfo.Size = UDim2.new(1, 0, 0, 30)
    toolInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
    toolInfo.Parent = scrollFrame
    
    local classInfo = Instance.new("TextLabel")
    classInfo.Text = "🏷️ النوع: " .. tool.ClassName
    classInfo.Size = UDim2.new(1, 0, 0, 30)
    classInfo.Position = UDim2.new(0, 0, 0, 35)
    classInfo.TextColor3 = Color3.fromRGB(200, 200, 100)
    classInfo.Parent = scrollFrame
    
    -- عرض محتويات الـ Tool (الـ Assets)
    local yOffset = 70
    local assetCount = 0
    
    for _, child in pairs(tool:GetChildren()) do
        assetCount = assetCount + 1
        
        local assetLabel = Instance.new("TextLabel")
        assetLabel.Text = "🔹 " .. assetCount .. ". " .. child.Name .. " (" .. child.ClassName .. ")"
        assetLabel.Size = UDim2.new(1, 0, 0, 30)
        assetLabel.Position = UDim2.new(0, 0, 0, yOffset)
        assetLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
        assetLabel.TextXAlignment = Enum.TextXAlignment.Left
        assetLabel.Parent = scrollFrame
        
        yOffset = yOffset + 35
        
        -- إذا كان الـ child جواه أطفال كمان
        if #child:GetChildren() > 0 then
            for _, subChild in pairs(child:GetChildren()) do
                local subLabel = Instance.new("TextLabel")
                subLabel.Text = "   └─ " .. subChild.Name .. " (" .. subChild.ClassName .. ")"
                subLabel.Size = UDim2.new(1, 0, 0, 25)
                subLabel.Position = UDim2.new(0, 0, 0, yOffset)
                subLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                subLabel.TextXAlignment = Enum.TextXAlignment.Left
                subLabel.Parent = scrollFrame
                
                yOffset = yOffset + 30
            end
        end
    end
    
    local totalLabel = Instance.new("TextLabel")
    totalLabel.Text = "📊 إجمالي المحتويات: " .. assetCount .. " عنصر"
    totalLabel.Size = UDim2.new(1, 0, 0, 30)
    totalLabel.Position = UDim2.new(0, 0, 0, yOffset)
    totalLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    totalLabel.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 40)
end)

-- تحميل أولي
local tool = findTool()
if tool then
    title.Text = title.Text .. " ✅"
else
    title.Text = title.Text .. " ❌"
end
