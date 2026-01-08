-- 🐉 Dragon Controller - زر متحرك للهاتف
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ابحث عن الـ Dragon
local dragon = game.Workspace.Characters.BLAACKASTA:FindFirstChild("Dragon-Dragon")

if not dragon then
    -- إذا مش موجود، دور في كل الـ Workspace
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "Dragon-Dragon" and obj:IsA("Tool") then
            dragon = obj
            break
        end
    end
end

-- شاشة التحكم
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DragController"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- الإطار الرئيسي (متحرك)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "ControlFrame"
mainFrame.Size = UDim2.new(0.25, 0, 0.15, 0) -- إطار صغير
mainFrame.Position = UDim2.new(0.375, 0, 0.425, 0) -- في نص الشاشة
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Active = true -- عشان نقدر نحركه
mainFrame.Draggable = true -- مهم! هذا اللي يخليه متحرك
mainFrame.Parent = screenGui

-- عنوان الإطار
local title = Instance.new("TextLabel")
title.Text = "🐉 Dragon"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- منطقة الأزرار
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0.7, 0)
buttonFrame.Position = UDim2.new(0, 0, 0.3, 0)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- صف الأزرار الأول
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(1, 0, 0.5, 0)
row1.BackgroundTransparency = 1
row1.Parent = buttonFrame

-- زر التشغيل/الإيقاف
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Text = "🔴"
toggleBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
toggleBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Parent = row1

-- زر زيادة الموارد
local resourceBtn = Instance.new("TextButton")
resourceBtn.Text = "📈"
resourceBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
resourceBtn.Position = UDim2.new(0.35, 0, 0.05, 0)
resourceBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
resourceBtn.TextColor3 = Color3.new(1, 1, 1)
resourceBtn.Font = Enum.Font.GothamBold
resourceBtn.TextSize = 18
resourceBtn.Parent = row1

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✗"
closeBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
closeBtn.Position = UDim2.new(0.65, 0, 0.05, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = row1

-- صف الأزرار الثاني (للتحريك)
local row2 = Instance.new("Frame")
row2.Size = UDim2.new(1, 0, 0.5, 0)
row2.Position = UDim2.new(0, 0, 0.5, 0)
row2.BackgroundTransparency = 1
row2.Parent = buttonFrame

-- أزرار التحريك
local upBtn = Instance.new("TextButton")
upBtn.Text = "⬆️"
upBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
upBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
upBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.Font = Enum.Font.GothamBold
upBtn.Parent = row2

local downBtn = Instance.new("TextButton")
downBtn.Text = "⬇️"
downBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
downBtn.Position = UDim2.new(0.35, 0, 0.05, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.Font = Enum.Font.GothamBold
downBtn.Parent = row2

local teleBtn = Instance.new("TextButton")
teleBtn.Text = "📍"
teleBtn.Size = UDim2.new(0.3, 0, 0.9, 0)
teleBtn.Position = UDim2.new(0.65, 0, 0.05, 0)
teleBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
teleBtn.TextColor3 = Color3.new(1, 1, 1)
teleBtn.Font = Enum.Font.GothamBold
teleBtn.Parent = row2

-- حالة التنشيط
local isActive = false
local dragonFound = dragon ~= nil

-- حدث زر التشغيل/الإيقاف
toggleBtn.MouseButton1Click:Connect(function()
    if not dragonFound then
        print("❌ Dragon مش موجود!")
        return
    end
    
    isActive = not isActive
    
    if isActive then
        toggleBtn.Text = "🟢"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        -- محاولة تنفيذ الأمر
        pcall(function()
            -- جرب تنفيذ الأمر INCREASE_RESOURCE
            if _G.INCREASE_RESOURCE then
                _G.INCREASE_RESOURCE('TOOLS', 112, 1)
                print("✅ تم تنفيذ INCREASE_RESOURCE")
            end
            
            -- أو أي تأثير آخر
            dragon.Position = dragon.Position + Vector3.new(0, 3, 0)
        end)
        
        print("🐉 Dragon مفعل!")
    else
        toggleBtn.Text = "🔴"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        print("🐉 Dragon معطل!")
    end
end)

-- حدث زر الموارد
resourceBtn.MouseButton1Click:Connect(function()
    if dragonFound then
        pcall(function()
            if _G.INCREASE_RESOURCE then
                _G.INCREASE_RESOURCE('TOOLS', 112, 1)
                resourceBtn.Text = "✅"
                
                task.wait(0.5)
                resourceBtn.Text = "📈"
            end
        end)
    end
end)

-- حدث أزرار التحريك
upBtn.MouseButton1Click:Connect(function()
    if dragonFound then
        dragon.Position = dragon.Position + Vector3.new(0, 2, 0)
        print("⬆️ Dragon راح فوق")
    end
end)

downBtn.MouseButton1Click:Connect(function()
    if dragonFound then
        dragon.Position = dragon.Position + Vector3.new(0, -2, 0)
        print("⬇️ Dragon راح تحت")
    end
end)

teleBtn.MouseButton1Click:Connect(function()
    if dragonFound and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            dragon.Position = hrp.Position + Vector3.new(0, 5, 0)
            print("📍 Dragon جاي عندك")
        end
    end
end)

-- حدث زر الإغلاق
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("✗ تم إغلاق المتحكم")
end)

-- رسالة للمستخدم
if dragonFound then
    print("✅ وجدت Dragon!")
    print("🎮 اسحب الإطار عشان تحركه!")
    print("🐉 استخدم الأزرار للتحكم")
else
    print("❌ Dragon مش موجود!")
    title.Text = "❌ No Dragon"
    toggleBtn.Text = "❌"
end
