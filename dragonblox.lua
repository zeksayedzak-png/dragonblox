-- 🎒 Dragon Tool Backpack Controller للهاتف
local player = game.Players.LocalPlayer
local backpack = player:FindFirstChild("Backpack")

-- زر بسيط للهاتف
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

-- زر إضافة Tool للـ Backpack
local addBtn = Instance.new("TextButton")
addBtn.Text = "🎒 Add Dragon"
addBtn.Size = UDim2.new(0.25, 0, 0.1, 0)
addBtn.Position = UDim2.new(0.375, 0, 0.4, 0)
addBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
addBtn.TextColor3 = Color3.new(1, 1, 1)
addBtn.Font = Enum.Font.GothamBold
addBtn.Parent = gui

-- زر زيادة الموارد
local resourceBtn = Instance.new("TextButton")
resourceBtn.Text = "📈 +Resource"
resourceBtn.Size = UDim2.new(0.25, 0, 0.1, 0)
resourceBtn.Position = UDim2.new(0.375, 0, 0.52, 0)
resourceBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
resourceBtn.TextColor3 = Color3.new(1, 1, 1)
resourceBtn.Font = Enum.Font.GothamBold
resourceBtn.Parent = gui

-- حدث إضافة الـ Tool
addBtn.MouseButton1Click:Connect(function()
    -- ابحث عن الـ Tool
    local dragonTool = game.Workspace.Characters.BLAACKASTA:FindFirstChild("Dragon-Dragon")
    
    if dragonTool and backpack then
        -- انسخ الـ Tool للـ Backpack
        local clone = dragonTool:Clone()
        clone.Parent = backpack
        
        addBtn.Text = "✅ Added!"
        print("🎒 تم إضافة Dragon للـ Backpack")
        
        task.wait(1)
        addBtn.Text = "🎒 Add Dragon"
    else
        addBtn.Text = "❌ Not Found"
        task.wait(1)
        addBtn.Text = "🎒 Add Dragon"
    end
end)

-- حدث زيادة الموارد
resourceBtn.MouseButton1Click:Connect(function()
    -- حاول تنفيذ الأمر
    local success, result = pcall(function()
        -- جرب تنفيذ INCREASE_RESOURCE
        if _G.INCREASE_RESOURCE then
            _G.INCREASE_RESOURCE('TOOLS', 112, 1)
            return true
        end
        
        -- أو جرب هذا إذا كان فيه RemoteEvent
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("INCREASE_RESOURCE")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer('TOOLS', 112, 1)
            return true
        end
        
        return false
    end)
    
    if success and result then
        resourceBtn.Text = "✅ Done!"
        print("📈 تم زيادة الموارد")
    else
        resourceBtn.Text = "❌ Failed"
        print("❌ فشل تنفيذ الأمر")
    end
    
    task.wait(1)
    resourceBtn.Text = "📈 +Resource"
end)

print("✅ Dragon Backpack Controller loaded!")
print("🎒 اضغط 'Add Dragon' لإضافة الـ Tool")
print("📈 اضغط '+Resource' لزيادة الموارد")
