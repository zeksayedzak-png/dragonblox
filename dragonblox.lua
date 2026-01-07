-- Dragon Chalice Deep Scanner - Mobile Version
-- يعمل على الهاتف عبر loadstring(game:HttpGet(""))

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local localPlayer = Players.LocalPlayer

-- ============== متغيرات النظام ==============
local isScanning = false
local collectedData = nil
local currentTab = 1
local tabs = {"📊 المعلومات", "🔗 الروابط", "💻 السكربتات", "🔍 البحث العميق", "📋 النسخ"}
local scanLogs = {}

-- ============== دالة البحث عن النموذج ==============
local function findDragonChalice()
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Assets")
            :WaitForChild("Models")
            :WaitForChild("Chalices")
            :WaitForChild("Dragon (East)-Dragon (East)")
    end)
    
    if success then
        return result, "✅ النموذج موجود!"
    else
        return nil, "❌ النموذج غير موجود: " .. tostring(result)
    end
end

-- ============== دالة البحث العميق SCAN_NOW ==============
local function deepScanNow(model)
    if isScanning then return end
    isScanning = true
    
    scanLogs = {}
    table.insert(scanLogs, "🚀 بدء المسح العميق...")
    table.insert(scanLogs, "⏰ " .. os.date("%H:%M:%S"))
    
    local scanResults = {
        SecurityIssues = {},
        HiddenScripts = {},
        ExternalLinks = {},
        LargeAssets = {},
        SuspiciousContent = {}
    }
    
    -- 1. مسح كل الأصول
    for _, descendant in pairs(model:GetDescendants()) do
        -- اكتشاف السكربتات المخفية
        if (descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript")) then
            if descendant.Name:find("Secret") or descendant.Name:find("Hidden") or descendant.Name:find("Admin") then
                table.insert(scanResults.HiddenScripts, {
                    Object = descendant,
                    Path = descendant:GetFullName(),
                    Reason = "اسم مشبوه"
                })
            end
            
            -- تحليل محتوى السكربت
            local content = ""
            if pcall(function() content = descendant.Source end) then
                -- بحث عن كلمات مفتاحية خطيرة
                local dangerousPatterns = {
                    "loadstring", "HttpGet", "setclipboard", 
                    "Instance.new", "FireServer", "InvokeServer",
                    "game.Players", "LocalPlayer", "Backdoor"
                }
                
                for _, pattern in ipairs(dangerousPatterns) do
                    if content:find(pattern) then
                        table.insert(scanResults.SecurityIssues, {
                            Script = descendant.Name,
                            Pattern = pattern,
                            Line = content:match(".*" .. pattern .. ".*")
                        })
                    end
                end
            end
        end
        
        -- اكتشاف الروابط الخارجية
        if descendant:IsA("Decal") or descendant:IsA("Texture") then
            local assetId = descendant.Texture or ""
            if assetId:find("http://") or assetId:find("https://") then
                table.insert(scanResults.ExternalLinks, {
                    Type = descendant.ClassName,
                    Name = descendant.Name,
                    URL = assetId
                })
            end
        end
        
        -- اكتشاف الأصول الكبيرة
        if descendant:IsA("BasePart") then
            local size = descendant.Size
            local volume = size.X * size.Y * size.Z
            if volume > 1000 then
                table.insert(scanResults.LargeAssets, {
                    Part = descendant.Name,
                    Size = size,
                    Volume = math.floor(volume)
                })
            end
        end
        
        -- اكتشاف محتوى مشبوه في StringValues
        if descendant:IsA("StringValue") and #descendant.Value > 50 then
            local value = descendant.Value
            if value:find("eval") or value:find("execute") or value:find("compile") then
                table.insert(scanResults.SuspiciousContent, {
                    Name = descendant.Name,
                    Type = "StringValue",
                    Preview = value:sub(1, 100) .. "..."
                })
            end
        end
    end
    
    -- 2. فحص الروابط
    table.insert(scanLogs, "🔗 فحص الروابط الخارجية...")
    
    -- 3. تحليل المخاطر
    local riskLevel = "🟢 منخفض"
    local issueCount = #scanResults.SecurityIssues + #scanResults.HiddenScripts
    
    if issueCount > 5 then
        riskLevel = "🔴 عالي"
    elseif issueCount > 2 then
        riskLevel = "🟡 متوسط"
    end
    
    -- 4. إنشاء التقرير
    local report = {
        "=== تقرير المسح العميق ===",
        "📅 التاريخ: " .. os.date("%Y-%m-%d %H:%M:%S"),
        "🎯 النموذج: " .. model.Name,
        "⚠️ مستوى الخطورة: " .. riskLevel,
        "",
        "📊 النتائج:",
        "🔒 مشاكل أمنية: " .. #scanResults.SecurityIssues,
        "👁️ سكربتات مخفية: " .. #scanResults.HiddenScripts,
        "🌐 روابط خارجية: " .. #scanResults.ExternalLinks,
        "📦 أصول كبيرة: " .. #scanResults.LargeAssets,
        "❓ محتوى مشبوه: " .. #scanResults.SuspiciousContent
    }
    
    -- إضافة التفاصيل إذا وجدت مشاكل
    if #scanResults.SecurityIssues > 0 then
        table.insert(report, "\n🔒 مشاكل أمنية مفصل:")
        for _, issue in ipairs(scanResults.SecurityIssues) do
            table.insert(report, "  • " .. issue.Script .. " - " .. issue.Pattern)
        end
    end
    
    table.insert(scanLogs, "✅ اكتمل المسح العميق!")
    table.insert(scanLogs, "📊 النتائج جاهزة للعرض")
    
    isScanning = false
    return scanResults, report
end

-- ============== دالة جمع Asset IDs ==============
local function collectAllAssetIds(model)
    local assetData = {
        Model = {Name = model.Name, AssetId = model.AssetId},
        Meshes = {}, Textures = {}, Sounds = {},
        Animations = {}, Scripts = {}, OtherAssets = {}
    }
    
    for _, obj in pairs(model:GetDescendants()) do
        -- Meshes
        if obj:IsA("MeshPart") then
            table.insert(assetData.Meshes, {
                Name = obj.Name,
                AssetId = obj.MeshId,
                Type = "MeshPart"
            })
        elseif obj:IsA("SpecialMesh") or obj:IsA("FileMesh") then
            table.insert(assetData.Meshes, {
                Name = obj.Name,
                AssetId = obj.MeshId,
                Type = obj.ClassName
            })
        end
        
        -- Textures
        if obj:IsA("Decal") then
            table.insert(assetData.Textures, {
                Name = obj.Name,
                AssetId = obj.Texture,
                Type = "Decal"
            })
        end
        
        -- Sounds
        if obj:IsA("Sound") then
            table.insert(assetData.Sounds, {
                Name = obj.Name,
                AssetId = obj.SoundId,
                Type = "Sound"
            })
        end
        
        -- Animations
        if obj:IsA("Animation") then
            table.insert(assetData.Animations, {
                Name = obj.Name,
                AssetId = obj.AnimationId,
                Type = "Animation"
            })
        end
        
        -- Scripts
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local content = "غير قابل للقراءة"
            local lineCount = 0
            
            if pcall(function() 
                content = obj.Source
                lineCount = #(string.split(content, "\n"))
            end) then
                table.insert(assetData.Scripts, {
                    Name = obj.Name,
                    Type = obj.ClassName,
                    Content = content,
                    LineCount = lineCount,
                    Disabled = obj.Disabled
                })
            end
        end
        
        -- Other
        if obj:GetAttribute("AssetId") then
            table.insert(assetData.OtherAssets, {
                Name = obj.Name,
                AssetId = obj:GetAttribute("AssetId"),
                Type = obj.ClassName
            })
        end
    end
    
    return assetData
end

-- ============== واجهة المستخدم ==============
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeepScannerMobile"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    -- الإطار الرئيسي
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.075, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🔍 Dragon Chalice Deep Scanner"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0.07, 0)
    title.Position = UDim2.new(0, 0, 0.01, 0)
    title.Parent = mainFrame
    
    -- تبويبات التنقل
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0.08, 0)
    tabFrame.Position = UDim2.new(0, 0, 0.09, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame
    
    -- إنشاء التبويبات
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. i
        tabButton.Text = tabName
        tabButton.TextSize = 11
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1/#tabs, -2, 1, 0)
        tabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        tabButton.Parent = tabFrame
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = i
            updateContent(currentTab)
        end)
    end
    
    -- منطقة المحتوى
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(0.98, 0, 0.68, 0)
    contentFrame.Position = UDim2.new(0.01, 0, 0.18, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 8
    contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    contentFrame.Parent = mainFrame
    
    -- شريط التحكم السفلي
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(1, 0, 0.12, 0)
    controlFrame.Position = UDim2.new(0, 0, 0.87, 0)
    controlFrame.BackgroundTransparency = 1
    controlFrame.Parent = mainFrame
    
    -- زر المسح الأساسي
    local scanButton = Instance.new("TextButton")
    scanButton.Name = "ScanButton"
    scanButton.Text = "🔍 مسح Dragon Chalice"
    scanButton.TextSize = 14
    scanButton.Font = Enum.Font.GothamBold
    scanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    scanButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    scanButton.Size = UDim2.new(0.45, 0, 0.8, 0)
    scanButton.Position = UDim2.new(0.025, 0, 0.1, 0)
    scanButton.Parent = controlFrame
    
    -- زر البحث العميق
    local deepScanButton = Instance.new("TextButton")
    deepScanButton.Name = "DeepScanButton"
    deepScanButton.Text = "🚀 SCAN_NOW"
    deepScanButton.TextSize = 14
    deepScanButton.Font = Enum.Font.GothamBold
    deepScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    deepScanButton.BackgroundColor3 = Color3.fromRGB(215, 80, 0)
    deepScanButton.Size = UDim2.new(0.45, 0, 0.8, 0)
    deepScanButton.Position = UDim2.new(0.525, 0, 0.1, 0)
    deepScanButton.Parent = controlFrame
    
    -- دالة تحديث المحتوى
    function updateContent(tabIndex)
        contentFrame:ClearAllChildren()
        
        if not collectedData and tabIndex ~= 4 then
            local message = Instance.new("TextLabel")
            message.Text = "📭 لم يتم تحليل البيانات بعد.\nاضغط على '🔍 مسح Dragon Chalice' أولاً."
            message.TextColor3 = Color3.fromRGB(255, 200, 100)
            message.TextSize = 14
            message.BackgroundTransparency = 1
            message.Size = UDim2.new(1, 0, 0.3, 0)
            message.Position = UDim2.new(0, 0, 0.3, 0)
            message.TextWrapped = true
            message.Parent = contentFrame
            return
        end
        
        local yOffset = 10
        
        if tabIndex == 1 then -- المعلومات
            local infoText = Instance.new("TextLabel")
            infoText.Text = string.format(
                "📦 النموذج: %s\n📍 المسار: ReplicatedStorage.Assets.Models.Chalices\n🔢 إجمالي الأجزاء: %d\n\n📊 الإحصائيات:\n🔷 Meshes: %d\n🎨 Textures: %d\n🔊 Sounds: %d\n💃 Animations: %d\n💻 Scripts: %d",
                collectedData.Model.Name,
                #collectedData.Meshes + #collectedData.Textures + #collectedData.Sounds + #collectedData.Animations + #collectedData.Scripts,
                #collectedData.Meshes,
                #collectedData.Textures,
                #collectedData.Sounds,
                #collectedData.Animations,
                #collectedData.Scripts
            )
            infoText.TextColor3 = Color3.fromRGB(200, 220, 255)
            infoText.TextSize = 12
            infoText.BackgroundTransparency = 1
            infoText.Size = UDim2.new(0.96, 0, 0, 150)
            infoText.Position = UDim2.new(0.02, 0, 0, yOffset)
            infoText.TextWrapped = true
            infoText.TextXAlignment = Enum.TextXAlignment.Left
            infoText.Parent = contentFrame
            yOffset += 160
            
        elseif tabIndex == 2 then -- الروابط
            -- رابط النموذج
            if collectedData.Model.AssetId and collectedData.Model.AssetId ~= "" then
                local linkText = Instance.new("TextLabel")
                linkText.Text = "🔗 رابط النموذج:\nhttps://assetdelivery.roblox.com/v1/asset/?id=" .. collectedData.Model.AssetId
                linkText.TextColor3 = Color3.fromRGB(150, 200, 255)
                linkText.TextSize = 11
                linkText.BackgroundTransparency = 1
                linkText.Size = UDim2.new(0.96, 0, 0, 40)
                linkText.Position = UDim2.new(0.02, 0, 0, yOffset)
                linkText.TextWrapped = true
                linkText.TextXAlignment = Enum.TextXAlignment.Left
                linkText.Parent = contentFrame
                
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋 نسخ"
                copyBtn.TextSize = 10
                copyBtn.Size = UDim2.new(0.2, 0, 0.5, 0)
                copyBtn.Position = UDim2.new(0.75, 0, 0.25, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                copyBtn.Parent = linkText
                
                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard("https://assetdelivery.roblox.com/v1/asset/?id=" .. collectedData.Model.AssetId)
                    copyBtn.Text = "✅ تم!"
                    task.wait(1)
                    copyBtn.Text = "📋 نسخ"
                end)
                
                yOffset += 50
            end
            
        elseif tabIndex == 3 then -- السكربتات
            if #collectedData.Scripts == 0 then
                local noScripts = Instance.new("TextLabel")
                noScripts.Text = "📭 لا توجد سكربتات في هذا النموذج"
                noScripts.TextColor3 = Color3.fromRGB(255, 150, 150)
                noScripts.TextSize = 14
                noScripts.BackgroundTransparency = 1
                noScripts.Size = UDim2.new(1, 0, 0.1, 0)
                noScripts.Position = UDim2.new(0, 0, 0.3, 0)
                noScripts.Parent = contentFrame
                return
            end
            
            for i, script in ipairs(collectedData.Scripts) do
                local scriptFrame = Instance.new("Frame")
                scriptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                scriptFrame.Size = UDim2.new(0.96, 0, 0, 80)
                scriptFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
                scriptFrame.Parent = contentFrame
                
                local scriptInfo = Instance.new("TextLabel")
                scriptInfo.Text = string.format(
                    "💻 %s [%s]\n📊 %d سطر | ⚡ %s",
                    script.Name,
                    script.Type,
                    script.LineCount,
                    script.Disabled and "معطل" : "نشط"
                )
                scriptInfo.TextColor3 = Color3.fromRGB(150, 255, 150)
                scriptInfo.TextSize = 11
                scriptInfo.BackgroundTransparency = 1
                scriptInfo.Size = UDim2.new(0.7, 0, 0.6, 0)
                scriptInfo.Position = UDim2.new(0.02, 0, 0.05, 0)
                scriptInfo.TextWrapped = true
                scriptInfo.TextXAlignment = Enum.TextXAlignment.Left
                scriptInfo.Parent = scriptFrame
                
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋 نسخ الكود"
                copyBtn.TextSize = 10
                copyBtn.Size = UDim2.new(0.25, 0, 0.4, 0)
                copyBtn.Position = UDim2.new(0.73, 0, 0.3, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
                copyBtn.Parent = scriptFrame
                
                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard(script.Content)
                    copyBtn.Text = "✅ تم!"
                    task.wait(1)
                    copyBtn.Text = "📋 نسخ الكود"
                end)
                
                yOffset += 85
            end
            
        elseif tabIndex == 4 then -- البحث العميق
            if #scanLogs == 0 then
                local scanPrompt = Instance.new("TextLabel")
                scanPrompt.Text = "🚀 البحث العميق\n\nيقوم بمسح شامل للنموذج بحثاً عن:\n• سكربتات مخفية\n• روابط خارجية\n• مخاطر أمنية\n• محتوى مشبوه\n\nاضغط على زر SCAN_NOW للبدء"
                scanPrompt.TextColor3 = Color3.fromRGB(200, 200, 255)
                scanPrompt.TextSize = 13
                scanPrompt.BackgroundTransparency = 1
                scanPrompt.Size = UDim2.new(0.96, 0, 0, 150)
                scanPrompt.Position = UDim2.new(0.02, 0, 0.2, 0)
                scanPrompt.TextWrapped = true
                scanPrompt.Parent = contentFrame
            else
                -- عرض سجل المسح
                local logText = table.concat(scanLogs, "\n")
                local logLabel = Instance.new("TextLabel")
                logLabel.Text = logText
                logLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                logLabel.TextSize = 11
                logLabel.BackgroundTransparency = 1
                logLabel.Size = UDim2.new(0.96, 0, 0, 300)
                logLabel.Position = UDim2.new(0.02, 0, 0, yOffset)
                logLabel.TextWrapped = true
                logLabel.TextXAlignment = Enum.TextXAlignment.Left
                logLabel.Parent = contentFrame
                yOffset += 310
            end
            
        elseif tabIndex == 5 then -- النسخ
            local copyOptions = {
                {"📋 نسخ كل Asset IDs", function()
                    local allIds = {"=== Dragon Chalice Asset IDs ==="}
                    table.insert(allIds, "النموذج: " .. (collectedData.Model.AssetId or "N/A"))
                    
                    for _, mesh in ipairs(collectedData.Meshes) do
                        table.insert(allIds, "Mesh - " .. mesh.Name .. ": " .. mesh.AssetId)
                    end
                    
                    setclipboard(table.concat(allIds, "\n"))
                end},
                
                {"📊 نسخ المعلومات", function()
                    local info = {
                        "=== معلومات Dragon Chalice ===",
                        "الاسم: " .. collectedData.Model.Name,
                        "المسار: ReplicatedStorage.Assets.Models.Chalices",
                        "Meshes: " .. #collectedData.Meshes,
                        "Textures: " .. #collectedData.Textures,
                        "Scripts: " .. #collectedData.Scripts
                    }
                    setclipboard(table.concat(info, "\n"))
                end},
                
                {"💻 نسخ كل السكربتات", function()
                    local allScripts = {"=== سكربتات Dragon Chalice ==="}
                    
                    for _, script in ipairs(collectedData.Scripts) do
                        table.insert(allScripts, "\n=== " .. script.Name .. " ===")
                        table.insert(allScripts, script.Content)
                    end
                    
                    setclipboard(table.concat(allScripts, "\n"))
                end}
            }
            
            for i, option in ipairs(copyOptions) do
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = option[1]
                copyBtn.TextSize = 12
                copyBtn.Font = Enum.Font.Gotham
                copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                copyBtn.Size = UDim2.new(0.92, 0, 0, 35)
                copyBtn.Position = UDim2.new(0.04, 0, 0, yOffset)
                copyBtn.Parent = contentFrame
                
                copyBtn.MouseButton1Click:Connect(option[2])
                
                yOffset += 40
            end
        end
        
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
    end
    
    -- تعريف الأحداث بعد إنشاء الدالة
    -- زر المسح الأساسي
    scanButton.MouseButton1Click:Connect(function()
        scanButton.Text = "⏳ جاري المسح..."
        scanButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        local model, message = findDragonChalice()
        
        if model then
            collectedData = collectAllAssetIds(model)
            scanButton.Text = "✅ تم المسح!"
            scanButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            
            -- إضافة رسالة نجاح
            local successMsg = Instance.new("TextLabel")
            successMsg.Text = "✅ " .. message .. "\n📊 تم جمع بيانات " .. 
                (#collectedData.Meshes + #collectedData.Textures + #collectedData.Scripts) .. " أصل"
            successMsg.TextColor3 = Color3.fromRGB(100, 255, 100)
            successMsg.TextSize = 12
            successMsg.BackgroundTransparency = 1
            successMsg.Size = UDim2.new(0.96, 0, 0, 40)
            successMsg.Position = UDim2.new(0.02, 0, 0.02, 0)
            successMsg.TextWrapped = true
            successMsg.Parent = contentFrame
            
            updateContent(currentTab)
        else
            scanButton.Text = "❌ فشل المسح"
            scanButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            
            local errorMsg = Instance.new("TextLabel")
            errorMsg.Text = message
            errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
            errorMsg.TextSize = 12
            errorMsg.BackgroundTransparency = 1
            errorMsg.Size = UDim2.new(0.96, 0, 0, 60)
            errorMsg.Position = UDim2.new(0.02, 0, 0.3, 0)
            errorMsg.TextWrapped = true
            errorMsg.Parent = contentFrame
        end
    end)
    
    -- زر البحث العميق
    deepScanButton.MouseButton1Click:Connect(function()
        if isScanning then
            return
        end
        
        if not collectedData then
            deepScanButton.Text = "❌ امسح أولاً"
            deepScanButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            task.wait(1)
            deepScanButton.Text = "🚀 SCAN_NOW"
            deepScanButton.BackgroundColor3 = Color3.fromRGB(215, 80, 0)
            return
        end
        
        deepScanButton.Text = "🌀 جاري البحث..."
        deepScanButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        
        local model = findDragonChalice()
        if model then
            currentTab = 4
            updateContent(4)
            
            task.spawn(function()
                local scanResults, report = deepScanNow(model)
                
                deepScanButton.Text = "✅ اكتمل!"
                deepScanButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                
                -- إضافة التقرير للواجهة
                if report then
                    table.insert(scanLogs, "\n" .. table.concat(report, "\n"))
                    updateContent(4)
                end
                
                task.wait(2)
                deepScanButton.Text = "🚀 SCAN_NOW"
                deepScanButton.BackgroundColor3 = Color3.fromRGB(215, 80, 0)
            end)
        end
    end)
    
    -- تهيئة المحتوى
    updateContent(1)
    
    return screenGui
end

-- ============== بدء التشغيل ==============
print("========================================")
print("   Dragon Chalice Deep Scanner v3.0     ")
print("        Mobile Professional Edition     ")
print("========================================")

-- إنشاء الواجهة
local ui = createMobileUI()

print("✅ تم تحميل الماسح الضوئي بنجاح!")
print("🔍 اضغط على 'مسح Dragon Chalice' للبدء")
print("🚀 استخدم 'SCAN_NOW' للبحث العميق")
