-- 🐉 Dragon Tool Controller للهاتف
-- زر صغير في الشاشة يتحكم في Dragon

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ابحث عن الـ Dragon Tool في المسار
local dragonPath = game.Workspace.Characters.BLAACKASTA
local dragonTool = dragonPath:FindFirstChild("Dragon-Dragon")

if dragonTool then
    print("✅ وجدت Dragon Tool!")
    
    -- إنشاء زر صغير في الشاشة
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DragonController"
    screenGui.Parent = player.PlayerGui
    
    -- زر التحكم الرئيسي
    local controlButton = Instance.new("TextButton")
    controlButton.Name = "DragonBtn"
    controlButton.Text = "🐉"
    controlButton.TextSize = 24
    controlButton.Font = Enum.Font.GothamBold
    controlButton.TextColor3 = Color3.new(1, 1, 1)
    controlButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    -- حجم وموقع صغير للهاتف
    controlButton.Size = UDim2.new(0.12, 0, 0.08, 0) -- زر صغير
    controlButton.Position = UDim2.new(0.44, 0, 0.8, 0) -- أسفل الشاشة
    
    controlButton.Parent = screenGui
    
    -- متغيرات التحكم
    local isActivated = false
    local originalPosition = dragonTool.Position
    
    -- دالة تفعيل/إلغاء التفعيل
    local function toggleDragon()
        if isActivated then
            -- إلغاء التفعيل
            isActivated = false
            controlButton.Text = "🐉"
            controlButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            
            -- إرجاع للأصل (إذا أردت)
            -- dragonTool.Position = originalPosition
            
            print("🔴 Dragon معطل")
        else
            -- تفعيل
            isActivated = true
            controlButton.Text = "🔥"
            controlButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            
            -- حرك الـ Dragon
            dragonTool.Position = dragonTool.Position + Vector3.new(0, 5, 0)
            
            print("🟢 Dragon مفعل")
            
            -- محاولة تنفيذ الأمر
            pcall(function()
                -- جرب تنفيذ الأمر
                _G.INCREASE_RESOURCE('TOOLS', 112, 1)
                print("✅ تم تنفيذ الأمر")
            end)
        end
    end
    
    -- حدث الضغط على الزر
    controlButton.MouseButton1Click:Connect(toggleDragon)
    
    -- زر إضافي للتحريك
    local moveButton = Instance.new("TextButton")
    moveButton.Name = "MoveBtn"
    moveButton.Text = "↕️"
    moveButton.TextSize = 18
    moveButton.Font = Enum.Font.GothamBold
    moveButton.TextColor3 = Color3.new(1, 1, 1)
    moveButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    moveButton.Size = UDim2.new(0.1, 0, 0.06, 0)
    moveButton.Position = UDim2.new(0.57, 0, 0.81, 0)
    moveButton.Parent = screenGui
    
    -- دالة تحريك الـ Dragon
    moveButton.MouseButton1Click:Connect(function()
        dragonTool.Position = dragonTool.Position + Vector3.new(0, 2, 0)
        print("⬆️ رفع Dragon")
    end)
    
    -- زر إنزال
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownBtn"
    downButton.Text = "↧"
    downButton.TextSize = 18
    downButton.Font = Enum.Font.GothamBold
    downButton.TextColor3 = Color3.new(1, 1, 1)
    downButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    downButton.Size = UDim2.new(0.1, 0, 0.06, 0)
    downButton.Position = UDim2.new(0.33, 0, 0.81, 0)
    downButton.Parent = screenGui
    
    downButton.MouseButton1Click:Connect(function()
        dragonTool.Position = dragonTool.Position + Vector3.new(0, -2, 0)
        print("⬇️ إنزال Dragon")
    end)
    
    -- معلومات صغيرة
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Text = "Dragon Controller"
    infoLabel.TextSize = 12
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(0.2, 0, 0.04, 0)
    infoLabel.Position = UDim2.new(0.4, 0, 0.88, 0)
    infoLabel.Parent = screenGui
    
    print("🎮 أزرار التحكم جاهزة!")
    print("🐉 اضغط على الزر للتحكم في Dragon")
    
else
    print("❌ Dragon Tool مش موجود في المسار!")
    print("💡 المسار: Workspace.Characters.BLAACKASTA.Dragon-Dragon")
    
    -- اعرض رسالة للمستخدم
    local gui = Instance.new("ScreenGui")
    gui.Parent = player.PlayerGui
    
    local msg = Instance.new("TextLabel")
    msg.Text = "❌ Dragon Tool مش موجود!\n\nالمسار:\nWorkspace.Characters.BLAACKASTA.Dragon-Dragon"
    msg.Size = UDim2.new(0.7, 0, 0.3, 0)
    msg.Position = UDim2.new(0.15, 0, 0.35, 0)
    msg.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    msg.TextColor3 = Color3.new(1, 1, 1)
    msg.TextWrapped = true
    msg.Parent = gui
end
