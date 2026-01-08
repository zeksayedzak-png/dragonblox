-- 🛠️ Workspace Tool Hacker
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorkspaceHacker"
screenGui.Parent = game.CoreGui

-- الإطار الرئيسي (كبير شوية)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
mainFrame.Parent = screenGui

-- خاصية السحب للنافذة
local isDragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(mainFrame.Position.X.Scale, mainFrame.Position.Y.Scale)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStart
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local deltaScale = Vector2.new(delta.X / viewportSize.X, delta.Y / viewportSize.Y)
        local newX = math.clamp(frameStart.X + deltaScale.X, 0, 0.1)
        local newY = math.clamp(frameStart.Y + deltaScale.Y, 0, 0.15)
        mainFrame.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- شريط العنوان
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0.08, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Text = "🔓 Workspace Tool Hacker"
title.Size = UDim2.new(0.8, 0, 1, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = titleBar

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0.1, 0, 1, 0)
closeBtn.Position = UDim2.new(0.9, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- شريط البحث
local searchBar = Instance.new("Frame")
searchBar.Size = UDim2.new(1, 0, 0.1, 0)
searchBar.Position = UDim2.new(0, 0, 0.08, 0)
searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
searchBar.Parent = mainFrame

local scanBtn = Instance.new("TextButton")
scanBtn.Text = "🔍 SCAN_NOW (بحث قسري)"
scanBtn.Size = UDim2.new(0.95, 0, 0.7, 0)
scanBtn.Position = UDim2.new(0.025, 0, 0.15, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 18
scanBtn.Parent = searchBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "⏳ جاهز للمسح..."
statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0, 0, 0.7, 0)
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = searchBar

-- قائمة النتائج
local resultsFrame = Instance.new("ScrollingFrame")
resultsFrame.Size = UDim2.new(1, 0, 0.75, 0)
resultsFrame.Position = UDim2.new(0, 0, 0.18, 0)
resultsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
resultsFrame.Parent = mainFrame

-- دالة المسح القسري
local function deepScanWorkspace()
    local allTools = {}
    
    -- البحث في Workspace وأي مجلدات داخلها
    local function scanFolder(folder)
        for _, item in pairs(folder:GetChildren()) do
            -- إذا كان Tool
            if item:IsA("Tool") then
                table.insert(allTools, {
                    Object = item,
                    Path = item:GetFullName(),
                    Name = item.Name,
                    Parent = item.Parent.Name
                })
            end
            
            -- إذا كان فيه مجلدات داخلية، ابحث فيها أيضاً
            if #item:GetChildren() > 0 then
                scanFolder(item)
            end
        end
    end
    
    -- بدء المسح من Workspace
    scanFolder(workspace)
    
    return allTools
end

-- دالة إضافة Tool للاعب
local function addToolToPlayer(tool)
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        local clone = tool:Clone()
        clone.Parent = backpack
        return true
    else
        -- إذا ما في حقيبة، نحطه في workspace أمام اللاعب
        local clone = tool:Clone()
        clone.Parent = workspace
        
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                clone:PivotTo(hrp.CFrame * CFrame.new(0, 0, -5))
            end
        end
        return false
    end
end

scanBtn.MouseButton1Click:Connect(function()
    resultsFrame:ClearAllChildren()
    statusLabel.Text = "🔄 جاري المسح القسري..."
    
    -- مسح قسري لكل الـ Tools
    local tools = deepScanWorkspace()
    
    if #tools == 0 then
        statusLabel.Text = "❌ ما لقيت أي Tools في Workspace"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    statusLabel.Text = "✅ لقيت " .. #tools .. " أداة في Workspace"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- عرض النتائج
    local yOffset = 0
    
    for i, toolData in ipairs(tools) do
        -- صف لكل Tool
        local toolFrame = Instance.new("Frame")
        toolFrame.Size = UDim2.new(0.98, 0, 0, 60)
        toolFrame.Position = UDim2.new(0.01, 0, 0, yOffset)
        toolFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        toolFrame.Parent = resultsFrame
        
        -- اسم الـ Tool
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = "🛠️ " .. toolData.Name
        nameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
        nameLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = toolFrame
        
        -- المسار
        local pathLabel = Instance.new("TextLabel")
        pathLabel.Text = "📍 " .. toolData.Parent
        pathLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
        pathLabel.Position = UDim2.new(0.02, 0, 0.5, 0)
        pathLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        pathLabel.Font = Enum.Font.SourceSans
        pathLabel.TextXAlignment = Enum.TextXAlignment.Left
        pathLabel.TextSize = 12
        pathLabel.BackgroundTransparency = 1
        pathLabel.Parent = toolFrame
        
        -- زر الإضافة
        local addBtn = Instance.new("TextButton")
        addBtn.Text = "➕ ADD"
        addBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
        addBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
        addBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        addBtn.Font = Enum.Font.SourceSansBold
        addBtn.Parent = toolFrame
        
        -- زر النسخ
        local copyBtn = Instance.new("TextButton")
        copyBtn.Text = "📋"
        copyBtn.Size = UDim2.new(0.08, 0, 0.7, 0)
        copyBtn.Position = UDim2.new(0.58, 0, 0.15, 0)
        copyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.Parent = toolFrame
        
        -- حدث زر الإضافة
        addBtn.MouseButton1Click:Connect(function()
            local success = addToolToPlayer(toolData.Object)
            
            if success then
                addBtn.Text = "✅"
                addBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                statusLabel.Text = "🎁 أضفت: " .. toolData.Name .. " إلى حقيبتك"
            else
                addBtn.Text = "⬇️"
                addBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
                statusLabel.Text = "⬇️ أضفت: " .. toolData.Name .. " إلى الأرض"
            end
            
            task.wait(1)
            addBtn.Text = "➕ ADD"
            addBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        end)
        
        -- حدث زر النسخ
        copyBtn.MouseButton1Click:Connect(function()
            -- نسخ المسار إلى الحافظة
            pcall(function()
                setclipboard(toolData.Path)
                statusLabel.Text = "📋 نسخت مسار: " .. toolData.Path
                copyBtn.Text = "✅"
                task.wait(0.5)
                copyBtn.Text = "📋"
            end)
        end)
        
        yOffset = yOffset + 65
    end
    
    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end)

-- زر مسح جميع الأدوات (إضافي)
local massAddBtn = Instance.new("TextButton")
massAddBtn.Text = "🎁 إضافة جميع الأدوات"
massAddBtn.Size = UDim2.new(0.95, 0, 0.05, 0)
massAddBtn.Position = UDim2.new(0.025, 0, 0.94, 0)
massAddBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 180)
massAddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
massAddBtn.Font = Enum.Font.SourceSansBold
massAddBtn.Parent = mainFrame

massAddBtn.MouseButton1Click:Connect(function()
    local tools = deepScanWorkspace()
    local added = 0
    
    for _, toolData in pairs(tools) do
        if addToolToPlayer(toolData.Object) then
            added = added + 1
        end
    end
    
    statusLabel.Text = "🎉 أضفت " .. added .. " أداة إلى حقيبتك!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
end)

-- تحميل أولي
statusLabel.Text = "🔓 Workspace Hacker جاهز"
