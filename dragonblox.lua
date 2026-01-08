-- 🐉 Dragon Tool Mini Spawner
local toolPath = "Workspace.Characters.BLAACKASTA.Dragon-Dragon"

-- إنشاء زر صغير جداً
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniDragonSpawner"
screenGui.Parent = game.CoreGui

-- الزر الأساسي (صغير جداً)
local spawnBtn = Instance.new("TextButton")
spawnBtn.Text = "🐉"  -- أيقونة صغيرة
spawnBtn.Size = UDim2.new(0.1, 0, 0.1, 0)  -- 10% من الشاشة
spawnBtn.Position = UDim2.new(0.45, 0, 0.45, 0)  -- في النصف تقريباً
spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
spawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnBtn.Font = Enum.Font.SourceSansBold
spawnBtn.TextSize = 20
spawnBtn.Parent = screenGui

-- زر الإغلاق (أصغر)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0.05, 0, 0.05, 0)
closeBtn.Position = UDim2.new(0.55, 0, 0.4, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 14
closeBtn.Visible = false  -- مخفي أولاً
closeBtn.Parent = screenGui

-- متغيرات لتحريك الزر
local isDragging = false
local dragStart = Vector2.new(0, 0)
local btnStart = Vector2.new(0, 0)

-- دالة للبحث عن الـ Tool
local function findTool()
    local parts = string.split(toolPath, ".")
    local current = game
    
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then
            return nil
        end
    end
    
    return current
end

-- عند الضغط على الزر لسحبه
spawnBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        btnStart = Vector2.new(spawnBtn.Position.X.Scale, spawnBtn.Position.Y.Scale)
        closeBtn.Visible = true  -- إظهار زر الإغلاق عند السحب
    end
end)

-- تحريك الزر مع الإصبع
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStart
        
        -- تحويل الحركة إلى مقياس الشاشة
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local deltaScale = Vector2.new(delta.X / viewportSize.X, delta.Y / viewportSize.Y)
        
        -- حساب الموقع الجديد مع الحدود
        local newX = math.clamp(btnStart.X + deltaScale.X, 0, 0.9)  -- 0.9 = 1 - 0.1 (عرض الزر)
        local newY = math.clamp(btnStart.Y + deltaScale.Y, 0, 0.9)  -- 0.9 = 1 - 0.1 (ارتفاع الزر)
        
        spawnBtn.Position = UDim2.new(newX, 0, newY, 0)
        
        -- تحريك زر الإغلاق مع الزر الرئيسي
        closeBtn.Position = UDim2.new(newX + 0.1, 0, newY - 0.05, 0)
    end
end)

-- عند ترك الزر
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if isDragging then
            isDragging = false
            -- إخفاء زر الإغلاق بعد ثانيتين
            task.wait(2)
            closeBtn.Visible = false
        end
    end
end)

-- عند النقر على الزر (ليس السحب)
spawnBtn.MouseButton1Click:Connect(function()
    -- التأكد أن هذا نقر مش سحب
    if not isDragging then
        local tool = findTool()
        
        if tool then
            -- نسخ الـ Tool
            local clone = tool:Clone()
            
            -- وضعه في حقيبة اللاعب
            local player = game.Players.LocalPlayer
            local backpack = player:FindFirstChild("Backpack")
            
            if backpack then
                clone.Parent = backpack
                
                -- تأثير مرئي مؤقت
                spawnBtn.Text = "✅"
                spawnBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                task.wait(0.5)
                spawnBtn.Text = "🐉"
                spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            else
                -- إذا ما في حقيبة، نضعه في الأرض
                clone.Parent = workspace
                
                -- وضعه أمام اللاعب
                if player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        clone:PivotTo(hrp.CFrame * CFrame.new(0, 0, -5))
                    end
                end
                
                spawnBtn.Text = "⬇️"
                task.wait(0.5)
                spawnBtn.Text = "🐉"
            end
        else
            -- إذا ما لقى الـ Tool
            spawnBtn.Text = "❌"
            spawnBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            task.wait(0.5)
            spawnBtn.Text = "🐉"
            spawnBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end)

-- زر الإغلاق
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- رسالة بدء
print("✅ زر Dragon Tool جاهز!")
print("🐉 اضغط للتكرار | اسحب لتحريك | ✕ للإغلاق")
