-- Dragon (East)-Dragon (East) QUICK SCANNER
-- للهاتف عبر loadstring(game:HttpGet("")) - بحث فوري!

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

print("⚡ Dragon Quick Scanner Loading...")

-- دالة البحث الفوري SCAN_NOW!
local function SCAN_NOW_QUICK()
    print("\n🚀 SCAN_NOW STARTED - Fast Search!")
    
    local startTime = tick()
    local scanResults = {
        found = false,
        model = nil,
        path = "",
        timeTaken = 0,
        errors = {},
        quickStats = {}
    }
    
    -- البحث السريع في المسار المحدد فقط
    print("🔍 Quick scanning specific path...")
    
    local searchSteps = {
        "1. Checking ReplicatedStorage",
        "2. Looking for Assets folder", 
        "3. Searching Models",
        "4. Finding Chalices",
        "5. Locating Dragon model"
    }
    
    for i, step in ipairs(searchSteps) do
        print("   " .. step)
        wait(0.05) -- تأخير بسيط للواجهة
    end
    
    -- البحث المباشر
    local model = nil
    local success, err = pcall(function()
        model = game:GetService("ReplicatedStorage")
            :FindFirstChild("Assets")
            and game.ReplicatedStorage.Assets:FindFirstChild("Models")
            and game.ReplicatedStorage.Assets.Models:FindFirstChild("Chalices")
            and game.ReplicatedStorage.Assets.Models.Chalices:FindFirstChild("Dragon (East)-Dragon (East)")
    end)
    
    if success and model then
        scanResults.found = true
        scanResults.model = model
        scanResults.path = model:GetFullName()
        
        -- جمع إحصائيات سريعة
        local quickCount = 0
        local scriptCount = 0
        local meshCount = 0
        
        -- مسح سريع للأجزاء المهمة فقط
        for _, child in pairs(model:GetChildren()) do
            quickCount = quickCount + 1
            
            if child:IsA("BasePart") then
                scanResults.quickStats.Parts = (scanResults.quickStats.Parts or 0) + 1
            end
            
            if child:IsA("Script") or child:IsA("LocalScript") then
                scriptCount = scriptCount + 1
            end
            
            if child:IsA("MeshPart") then
                meshCount = meshCount + 1
            end
        end
        
        scanResults.quickStats.Children = quickCount
        scanResults.quickStats.Scripts = scriptCount
        scanResults.quickStats.Meshes = meshCount
        scanResults.quickStats.AssetId = model.AssetId or "N/A"
        
    else
        scanResults.found = false
        scanResults.errors = {err or "Model not found"}
    end
    
    scanResults.timeTaken = tick() - startTime
    
    print(string.format("\n✅ SCAN_NOW COMPLETE in %.2f seconds!", scanResults.timeTaken))
    
    if scanResults.found then
        print("🎯 MODEL FOUND!")
        print("📍 Path: " .. scanResults.path)
        print("📦 AssetId: " .. (scanResults.quickStats.AssetId or "N/A"))
        print("📊 Quick Stats:")
        print("   • Children: " .. (scanResults.quickStats.Children or 0))
        print("   • Scripts: " .. (scanResults.quickStats.Scripts or 0))
        print("   • Meshes: " .. (scanResults.quickStats.Meshes or 0))
    else
        print("❌ MODEL NOT FOUND!")
        print("💡 Error: " .. (scanResults.errors[1] or "Unknown"))
    end
    
    return scanResults
end

-- دالة البحث العميق (لكن أسرع)
local function DEEP_SCAN_NOW()
    print("\n🔍 DEEP SCAN STARTED - Comprehensive Search")
    
    local model = nil
    local found = false
    
    -- البحث مع رسائل تقدم
    local progress = {
        "Searching ReplicatedStorage...",
        "Looking for Assets folder...",
        "Checking Models directory...",
        "Scanning Chalices...",
        "Locating Dragon (East)-Dragon (East)..."
    }
    
    for i, msg in ipairs(progress) do
        print("   " .. msg)
        
        -- محاولة البحث في كل خطوة
        if i == 1 then
            if not game:GetService("ReplicatedStorage") then
                print("❌ ReplicatedStorage not found!")
                return nil
            end
        elseif i == 2 then
            if not game.ReplicatedStorage:FindFirstChild("Assets") then
                print("❌ Assets folder not found!")
                return nil
            end
        elseif i == 3 then
            if not game.ReplicatedStorage.Assets:FindFirstChild("Models") then
                print("❌ Models folder not found!")
                return nil
            end
        elseif i == 4 then
            if not game.ReplicatedStorage.Assets.Models:FindFirstChild("Chalices") then
                print("❌ Chalices folder not found!")
                return nil
            end
        elseif i == 5 then
            model = game.ReplicatedStorage.Assets.Models.Chalices:FindFirstChild("Dragon (East)-Dragon (East)")
            if model then
                found = true
                print("✅ MODEL FOUND!")
            else
                print("❌ Dragon model not found!")
            end
        end
        
        wait(0.1) -- تأخير مرئي
    end
    
    if found and model then
        -- تحليل سريع
        print("\n📊 QUICK ANALYSIS:")
        
        local stats = {
            Children = #model:GetChildren(),
            Descendants = #model:GetDescendants(),
            Scripts = 0,
            Meshes = 0,
            Sounds = 0,
            Textures = 0
        }
        
        -- مسح سريع للأجزاء
        for _, obj in pairs(model:GetChildren()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                stats.Scripts = stats.Scripts + 1
            elseif obj:IsA("MeshPart") then
                stats.Meshes = stats.Meshes + 1
            elseif obj:IsA("Sound") then
                stats.Sounds = stats.Sounds + 1
            elseif obj:IsA("Decal") then
                stats.Textures = stats.Textures + 1
            end
        end
        
        print("   • Children: " .. stats.Children)
        print("   • Scripts: " .. stats.Scripts)
        print("   • Meshes: " .. stats.Meshes)
        print("   • Sounds: " .. stats.Sounds)
        print("   • Textures: " .. stats.Textures)
        print("   • Asset ID: " .. (model.AssetId or "N/A"))
        
        return {model = model, stats = stats, found = true}
    end
    
    return {found = false, error = "Model not found"}
end

-- واجهة الهاتف مع SCAN_NOW السريع
local function CREATE_QUICK_SCANNER_UI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QuickScannerUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    -- الإطار الرئيسي
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.075, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = screenGui
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "⚡ QUICK SCAN_NOW"
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- أزرار المسح
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
    buttonFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = mainFrame
    
    -- زر SCAN_NOW السريع
    local quickScanBtn = Instance.new("TextButton")
    quickScanBtn.Name = "QuickScanBtn"
    quickScanBtn.Text = "🚀 SCAN_NOW (FAST)"
    quickScanBtn.Size = UDim2.new(0.48, 0, 0.9, 0)
    quickScanBtn.Position = UDim2.new(0, 0, 0, 0)
    quickScanBtn.BackgroundColor3 = Color3.fromRGB(215, 80, 0)
    quickScanBtn.TextColor3 = Color3.new(1, 1, 1)
    quickScanBtn.Font = Enum.Font.GothamBold
    quickScanBtn.TextScaled = true
    quickScanBtn.Parent = buttonFrame
    
    -- زر البحث العميق
    local deepScanBtn = Instance.new("TextButton")
    deepScanBtn.Name = "DeepScanBtn"
    deepScanBtn.Text = "🔍 DEEP SCAN"
    deepScanBtn.Size = UDim2.new(0.48, 0, 0.9, 0)
    deepScanBtn.Position = UDim2.new(0.52, 0, 0, 0)
    deepScanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    deepScanBtn.TextColor3 = Color3.new(1, 1, 1)
    deepScanBtn.Font = Enum.Font.GothamBold
    deepScanBtn.TextScaled = true
    deepScanBtn.Parent = buttonFrame
    
    -- منطقة النتائج
    local resultFrame = Instance.new("ScrollingFrame")
    resultFrame.Name = "ResultFrame"
    resultFrame.Size = UDim2.new(0.94, 0, 0.65, 0)
    resultFrame.Position = UDim2.new(0.03, 0, 0.27, 0)
    resultFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    resultFrame.BackgroundTransparency = 0.2
    resultFrame.ScrollBarThickness = 8
    resultFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    resultFrame.Parent = mainFrame
    
    -- شريط الحالة
    local statusBar = Instance.new("TextLabel")
    statusBar.Name = "StatusBar"
    statusBar.Text = "Ready to scan Dragon (East)-Dragon (East)..."
    statusBar.Size = UDim2.new(0.94, 0, 0.05, 0)
    statusBar.Position = UDim2.new(0.03, 0, 0.93, 0)
    statusBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    statusBar.TextColor3 = Color3.new(1, 1, 1)
    statusBar.Font = Enum.Font.Gotham
    statusBar.TextWrapped = true
    statusBar.Parent = mainFrame
    
    -- زر النسخ
    local copyBtn = Instance.new("TextButton")
    copyBtn.Text = "📋 COPY RESULTS"
    copyBtn.Size = UDim2.new(0.4, 0, 0.06, 0)
    copyBtn.Position = UDim2.new(0.3, 0, 0.86, 0)
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextScaled = true
    copyBtn.Visible = false
    copyBtn.Parent = mainFrame
    
    -- متغيرات
    local lastScanResults = nil
    local scanInProgress = false
    
    -- دالة تحديث النتائج
    local function UPDATE_RESULTS(scanData, scanType)
        resultFrame:ClearAllChildren()
        
        if not scanData then
            return
        end
        
        local yOffset = 10
        
        -- عنوان النتائج
        local resultTitle = Instance.new("TextLabel")
        resultTitle.Text = "📊 SCAN RESULTS - " .. scanType
        resultTitle.Size = UDim2.new(0.96, 0, 0, 30)
        resultTitle.Position = UDim2.new(0.02, 0, 0, yOffset)
        resultTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        resultTitle.TextColor3 = Color3.new(1, 1, 1)
        resultTitle.Font = Enum.Font.GothamBold
        resultTitle.Parent = resultFrame
        
        yOffset = yOffset + 40
        
        -- نتيجة البحث
        local resultBox = Instance.new("Frame")
        resultBox.Size = UDim2.new(0.96, 0, 0, scanData.found and 120 or 80)
        resultBox.Position = UDim2.new(0.02, 0, 0, yOffset)
        resultBox.BackgroundColor3 = scanData.found and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(80, 40, 40)
        resultBox.Parent = resultFrame
        
        local statusIcon = Instance.new("TextLabel")
        statusIcon.Text = scanData.found and "✅ FOUND!" or "❌ NOT FOUND"
        statusIcon.Size = UDim2.new(0.3, 0, 0.3, 0)
        statusIcon.Position = UDim2.new(0.02, 0, 0.1, 0)
        statusIcon.BackgroundTransparency = 1
        statusIcon.TextColor3 = Color3.new(1, 1, 1)
        statusIcon.Font = Enum.Font.GothamBlack
        statusIcon.TextScaled = true
        statusIcon.Parent = resultBox
        
        local pathText = Instance.new("TextLabel")
        pathText.Text = scanData.found and "📍 " .. scanData.path or "💡 Model not found at path"
        pathText.Size = UDim2.new(0.94, 0, 0.4, 0)
        pathText.Position = UDim2.new(0.03, 0, 0.4, 0)
        pathText.BackgroundTransparency = 1
        pathText.TextColor3 = Color3.fromRGB(220, 220, 220)
        pathText.Font = Enum.Font.Gotham
        pathText.TextWrapped = true
        pathText.TextXAlignment = Enum.TextXAlignment.Left
        pathText.Parent = resultBox
        
        if scanData.found then
            local timeText = Instance.new("TextLabel")
            timeText.Text = string.format("⏱️ Scan time: %.2f seconds", scanData.timeTaken or 0)
            timeText.Size = UDim2.new(0.94, 0, 0.2, 0)
            timeText.Position = UDim2.new(0.03, 0, 0.7, 0)
            timeText.BackgroundTransparency = 1
            timeText.TextColor3 = Color3.fromRGB(200, 200, 100)
            timeText.Font = Enum.Font.Gotham
            timeText.TextXAlignment = Enum.TextXAlignment.Left
            timeText.Parent = resultBox
        end
        
        yOffset = yOffset + (scanData.found and 130 or 90)
        
        -- عرض الإحصائيات إذا وجدت
        if scanData.found and scanData.quickStats then
            local statsFrame = Instance.new("Frame")
            statsFrame.Size = UDim2.new(0.96, 0, 0, 100)
            statsFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
            statsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
            statsFrame.Parent = resultFrame
            
            local statsTitle = Instance.new("TextLabel")
            statsTitle.Text = "📊 QUICK STATISTICS"
            statsTitle.Size = UDim2.new(1, 0, 0.2, 0)
            statsTitle.Position = UDim2.new(0, 0, 0, 0)
            statsTitle.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
            statsTitle.TextColor3 = Color3.new(1, 1, 1)
            statsTitle.Font = Enum.Font.GothamBold
            statsTitle.Parent = statsFrame
            
            local statsText = Instance.new("TextLabel")
            statsText.Text = string.format(
                "Children: %d\nScripts: %d\nMeshes: %d\nAsset ID: %s",
                scanData.quickStats.Children or 0,
                scanData.quickStats.Scripts or 0,
                scanData.quickStats.Meshes or 0,
                scanData.quickStats.AssetId or "N/A"
            )
            statsText.Size = UDim2.new(0.98, 0, 0.7, 0)
            statsText.Position = UDim2.new(0.01, 0, 0.25, 0)
            statsText.BackgroundTransparency = 1
            statsText.TextColor3 = Color3.fromRGB(200, 220, 255)
            statsText.Font = Enum.Font.Gotham
            statsText.TextWrapped = true
            statsText.TextXAlignment = Enum.TextXAlignment.Left
            statsText.Parent = statsFrame
            
            yOffset = yOffset + 110
            
            -- زر فحص السكربتات
            if scanData.quickStats.Scripts and scanData.quickStats.Scripts > 0 then
                local scriptsBtn = Instance.new("TextButton")
                scriptsBtn.Text = "💻 CHECK SCRIPTS (" .. scanData.quickStats.Scripts .. ")"
                scriptsBtn.Size = UDim2.new(0.96, 0, 0, 40)
                scriptsBtn.Position = UDim2.new(0.02, 0, 0, yOffset)
                scriptsBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
                scriptsBtn.TextColor3 = Color3.new(1, 1, 1)
                scriptsBtn.Font = Enum.Font.GothamBold
                scriptsBtn.Parent = resultFrame
                
                scriptsBtn.MouseButton1Click:Connect(function()
                    if scanData.model then
                        -- فحص سريع للسكربتات
                        local scripts = {}
                        for _, obj in pairs(scanData.model:GetDescendants()) do
                            if obj:IsA("Script") or obj:IsA("LocalScript") then
                                table.insert(scripts, {
                                    name = obj.Name,
                                    type = obj.ClassName,
                                    disabled = obj.Disabled
                                })
                            end
                        end
                        
                        -- عرض السكربتات
                        local scriptsFrame = Instance.new("Frame")
                        scriptsFrame.Size = UDim2.new(0.96, 0, 0, 50 + (#scripts * 30))
                        scriptsFrame.Position = UDim2.new(0.02, 0, 0, yOffset + 50)
                        scriptsFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
                        scriptsFrame.Parent = resultFrame
                        
                        local scriptsTitle = Instance.new("TextLabel")
                        scriptsTitle.Text = "💻 SCRIPTS FOUND"
                        scriptsTitle.Size = UDim2.new(1, 0, 0.2, 0)
                        scriptsTitle.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
                        scriptsTitle.TextColor3 = Color3.new(1, 1, 1)
                        scriptsTitle.Font = Enum.Font.GothamBold
                        scriptsTitle.Parent = scriptsFrame
                        
                        local sy = 25
                        for i, script in ipairs(scripts) do
                            local scriptLabel = Instance.new("TextLabel")
                            scriptLabel.Text = string.format("%d. %s [%s] %s", 
                                i, script.name, script.type, 
                                script.disabled and "(Disabled)" : "(Active)")
                            scriptLabel.Size = UDim2.new(0.98, 0, 0, 20)
                            scriptLabel.Position = UDim2.new(0.01, 0, 0, sy)
                            scriptLabel.BackgroundTransparency = 1
                            scriptLabel.TextColor3 = Color3.fromRGB(220, 200, 200)
                            scriptLabel.Font = Enum.Font.Gotham
                            scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
                            scriptLabel.Parent = scriptsFrame
                            
                            sy = sy + 25
                        end
                        
                        yOffset = yOffset + 60 + (#scripts * 30)
                    end
                end)
                
                yOffset = yOffset + 50
            end
        end
        
        resultFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
        
        -- حفظ النتائج للنسخ
        if scanData.found then
            lastScanResults = string.format(
                "🐉 Dragon (East)-Dragon (East) Scan Results\n%s\n\n📍 Path: %s\n⏱️ Time: %.2fs\n\n📊 Statistics:\n• Children: %d\n• Scripts: %d\n• Meshes: %d\n• Asset ID: %s",
                os.date("%Y-%m-%d %H:%M:%S"),
                scanData.path,
                scanData.timeTaken or 0,
                scanData.quickStats.Children or 0,
                scanData.quickStats.Scripts or 0,
                scanData.quickStats.Meshes or 0,
                scanData.quickStats.AssetId or "N/A"
            )
            
            copyBtn.Visible = true
        end
    end
    
    -- أحداث الأزرار
    
    -- SCAN_NOW السريع
    quickScanBtn.MouseButton1Click:Connect(function()
        if scanInProgress then return end
        
        scanInProgress = true
        quickScanBtn.Text = "⚡ SCANNING..."
        quickScanBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        deepScanBtn.Visible = false
        statusBar.Text = "Quick scan in progress..."
        
        task.spawn(function()
            local results = SCAN_NOW_QUICK()
            
            UPDATE_RESULTS(results, "QUICK SCAN")
            
            quickScanBtn.Text = "🚀 SCAN_NOW (FAST)"
            quickScanBtn.BackgroundColor3 = Color3.fromRGB(215, 80, 0)
            deepScanBtn.Visible = true
            
            if results.found then
                statusBar.Text = string.format(
                    "✅ Found in %.2fs! Children: %d, Scripts: %d",
                    results.timeTaken,
                    results.quickStats.Children or 0,
                    results.quickStats.Scripts or 0
                )
            else
                statusBar.Text = "❌ Model not found at specified path!"
            end
            
            scanInProgress = false
        end)
    end)
    
    -- البحث العميق
    deepScanBtn.MouseButton1Click:Connect(function()
        if scanInProgress then return end
        
        scanInProgress = true
        deepScanBtn.Text = "🔍 ANALYZING..."
        deepScanBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        quickScanBtn.Visible = false
        statusBar.Text = "Deep scan in progress..."
        
        task.spawn(function()
            local results = DEEP_SCAN_NOW()
            
            UPDATE_RESULTS(results, "DEEP SCAN")
            
            deepScanBtn.Text = "🔍 DEEP SCAN"
            deepScanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            quickScanBtn.Visible = true
            
            if results.found then
                statusBar.Text = string.format(
                    "✅ Deep scan complete! Found %d scripts, %d meshes",
                    results.stats.Scripts or 0,
                    results.stats.Meshes or 0
                )
            else
                statusBar.Text = "❌ Model not found!"
            end
            
            scanInProgress = false
        end)
    end)
    
    -- نسخ النتائج
    copyBtn.MouseButton1Click:Connect(function()
        if lastScanResults then
            setclipboard(lastScanResults)
            copyBtn.Text = "✅ COPIED!"
            statusBar.Text = "Results copied to clipboard!"
            
            wait(2)
            copyBtn.Text = "📋 COPY RESULTS"
        end
    end)
    
    return screenGui
end

-- ============================================
-- 🚀 START EXECUTION
-- ============================================

CREATE_QUICK_SCANNER_UI()

print("\n" .. string.rep("=", 60))
print("⚡ Dragon (East)-Dragon (East) QUICK SCANNER")
print("🎯 SCAN_NOW - Fast Search for Mobile")
print("📱 Optimized for Delta Roblox")
print(string.rep("=", 60))
print("\n✅ Quick Scanner loaded!")
print("🚀 Press 'SCAN_NOW (FAST)' for instant search")
print("🔍 Press 'DEEP SCAN' for detailed analysis")
