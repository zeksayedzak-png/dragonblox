-- Dragon Chalice Asset Analyzer - Mobile Version
-- يعمل على الهاتف عبر loadstring(game:HttpGet(""))

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local localPlayer = Players.LocalPlayer

-- ============== دالة البحث عن النموذج ==============
local function findDragonChalice()
    local path = "ReplicatedStorage.Assets.Models.Chalices.Dragon (East)-Dragon (East)"
    local nodes = {"ReplicatedStorage", "Assets", "Models", "Chalices", "Dragon (East)-Dragon (East)"}
    
    local current = game
    for _, node in ipairs(nodes) do
        current = current:FindFirstChild(node)
        if not current then
            return nil, "❌ لم يتم العثور على: " .. node
        end
    end
    
    return current, "✅ النموذج موجود في: " .. path
end

-- ============== دالة جمع كل Asset IDs ==============
local function collectAllAssetIds(model)
    local assetData = {
        Model = {AssetId = nil, Name = model.Name},
        Meshes = {},
        Textures = {},
        Sounds = {},
        Animations = {},
        Scripts = {},
        OtherAssets = {}
    }
    
    -- جمع كل Asset IDs من النموذج وأجزائه
    for _, descendant in pairs(model:GetDescendants()) do
        -- AssetId للموديل نفسه
        if descendant == model and descendant:IsA("Model") then
            assetData.Model.AssetId = descendant.AssetId
        end
        
        -- Meshes
        if descendant:IsA("MeshPart") then
            table.insert(assetData.Meshes, {
                Name = descendant.Name,
                AssetId = descendant.MeshId,
                Type = "MeshPart"
            })
        elseif descendant:IsA("SpecialMesh") or descendant:IsA("FileMesh") then
            table.insert(assetData.Meshes, {
                Name = descendant.Name,
                AssetId = descendant.MeshId,
                Type = descendant.ClassName
            })
        end
        
        -- Textures
        if descendant:IsA("Decal") then
            table.insert(assetData.Textures, {
                Name = descendant.Name,
                AssetId = descendant.Texture,
                Type = "Decal"
            })
        elseif descendant:IsA("Texture") then
            table.insert(assetData.Textures, {
                Name = descendant.Name,
                AssetId = descendant.Texture,
                Type = "Texture"
            })
        end
        
        -- Sounds
        if descendant:IsA("Sound") then
            table.insert(assetData.Sounds, {
                Name = descendant.Name,
                AssetId = descendant.SoundId,
                Type = "Sound"
            })
        end
        
        -- Animations
        if descendant:IsA("Animation") then
            table.insert(assetData.Animations, {
                Name = descendant.Name,
                AssetId = descendant.AnimationId,
                Type = "Animation"
            })
        end
        
        -- Scripts (جمع الأكواد)
        if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
            local scriptContent = "غير قابل للقراءة"
            if pcall(function() scriptContent = descendant.Source end) then
                table.insert(assetData.Scripts, {
                    Name = descendant.Name,
                    Type = descendant.ClassName,
                    Content = scriptContent,
                    Disabled = descendant.Disabled,
                    LineCount = #(string.split(scriptContent, "\n"))
                })
            end
        end
        
        -- أي AssetId آخر
        if descendant:GetAttribute("AssetId") then
            table.insert(assetData.OtherAssets, {
                Name = descendant.Name,
                AssetId = descendant:GetAttribute("AssetId"),
                Type = descendant.ClassName
            })
        end
    end
    
    return assetData
end

-- ============== دالة إنشاء رابط AssetDelivery ==============
local function generateAssetDeliveryLinks(assetId)
    if not assetId or assetId == "" or assetId == "rbxassetid://0" then
        return nil
    end
    
    -- استخراج الرقم من AssetId
    local id = tostring(assetId):match("%d+")
    if not id or id == "0" then
        return nil
    end
    
    return {
        Direct = "https://assetdelivery.roblox.com/v1/asset/?id=" .. id,
        CDN = "https://roblox.com/asset/?id=" .. id,
        API = "https://api.roblox.com/marketplace/productinfo?assetId=" .. id
    }
end

-- ============== واجهة المستخدم للجوال ==============
local function createAdvancedMobileUI()
    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "AssetAnalyzerMobile"
    mobileGui.ResetOnSpawn = false
    mobileGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    -- لوحة التحكم الرئيسية
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = mobileGui
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "🐉 Dragon Chalice Asset Analyzer"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.Position = UDim2.new(0, 0, 0.01, 0)
    title.Parent = mainFrame
    
    -- منطقة التبويبات
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.Size = UDim2.new(1, 0, 0.08, 0)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0.1, 0)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Parent = mainFrame
    
    -- التبويبات
    local tabs = {"📊 المعلومات", "🔗 Asset Links", "💻 السكربتات", "📋 النسخ"}
    local currentTab = 1
    
    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. i
        tabBtn.Text = tabName
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        tabBtn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        tabBtn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        tabBtn.Parent = tabButtonsFrame
        
        tabBtn.MouseButton1Click:Connect(function()
            currentTab = i
            -- سيتم تحديث المحتوى لاحقاً
        end)
    end
    
    -- منطقة المحتوى الرئيسية
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(0.98, 0, 0.7, 0)
    contentFrame.Position = UDim2.new(0.01, 0, 0.2, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 8
    contentFrame.Parent = mainFrame
    
    -- زر التحليل
    local analyzeBtn = Instance.new("TextButton")
    analyzeBtn.Name = "AnalyzeButton"
    analyzeBtn.Text = "🔍 بدء تحليل Dragon Chalice"
    analyzeBtn.TextSize = 14
    analyzeBtn.Font = Enum.Font.GothamBold
    analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    analyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    analyzeBtn.Size = UDim2.new(0.6, 0, 0.08, 0)
    analyzeBtn.Position = UDim2.new(0.2, 0, 0.92, 0)
    analyzeBtn.Parent = mainFrame
    
    -- متغيرات التخزين
    local collectedData = nil
    
    -- دالة تحديث المحتوى
    local function updateContent(tabIndex)
        contentFrame:ClearAllChildren()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        if not collectedData then
            local msg = Instance.new("TextLabel")
            msg.Text = "⚠️ لم يتم تحليل البيانات بعد.\nاضغط على زر التحليل أولا."
            msg.TextColor3 = Color3.fromRGB(255, 200, 100)
            msg.TextSize = 14
            msg.BackgroundTransparency = 1
            msg.Size = UDim2.new(1, 0, 0.3, 0)
            msg.Position = UDim2.new(0, 0, 0.3, 0)
            msg.TextWrapped = true
            msg.Parent = contentFrame
            return
        end
        
        local yOffset = 10
        
        if tabIndex == 1 then -- المعلومات
            -- معلومات النموذج
            local modelInfo = Instance.new("TextLabel")
            modelInfo.Text = string.format(
                "📦 النموذج: %s\n📍 المسار: ReplicatedStorage.Assets.Models.Chalices\n🎯 AssetId: %s",
                collectedData.Model.Name,
                collectedData.Model.AssetId or "N/A"
            )
            modelInfo.TextColor3 = Color3.fromRGB(0, 255, 150)
            modelInfo.TextSize = 12
            modelInfo.BackgroundTransparency = 1
            modelInfo.Size = UDim2.new(0.98, 0, 0, 60)
            modelInfo.Position = UDim2.new(0.01, 0, 0, yOffset)
            modelInfo.TextWrapped = true
            modelInfo.TextXAlignment = Enum.TextXAlignment.Left
            modelInfo.Parent = contentFrame
            yOffset += 70
            
            -- إحصائيات
            local stats = Instance.new("TextLabel")
            stats.Text = string.format(
                "📊 الإحصائيات:\n🔷 Meshes: %d\n🎨 Textures: %d\n🔊 Sounds: %d\n💃 Animations: %d\n💻 Scripts: %d\n📎 أصول أخرى: %d",
                #collectedData.Meshes,
                #collectedData.Textures,
                #collectedData.Sounds,
                #collectedData.Animations,
                #collectedData.Scripts,
                #collectedData.OtherAssets
            )
            stats.TextColor3 = Color3.fromRGB(200, 200, 255)
            stats.TextSize = 12
            stats.BackgroundTransparency = 1
            stats.Size = UDim2.new(0.98, 0, 0, 80)
            stats.Position = UDim2.new(0.01, 0, 0, yOffset)
            stats.TextWrapped = true
            stats.TextXAlignment = Enum.TextXAlignment.Left
            stats.Parent = contentFrame
            yOffset += 90
            
        elseif tabIndex == 2 then -- Asset Links
            yOffset = 10
            
            -- جمع كل الروابط
            local allLinks = {}
            
            -- رابط النموذج
            if collectedData.Model.AssetId then
                local links = generateAssetDeliveryLinks(collectedData.Model.AssetId)
                if links then
                    table.insert(allLinks, {Name = "النموذج الرئيسي", Links = links})
                end
            end
            
            -- روابط Meshes
            for _, mesh in ipairs(collectedData.Meshes) do
                if mesh.AssetId then
                    local links = generateAssetDeliveryLinks(mesh.AssetId)
                    if links then
                        table.insert(allLinks, {Name = "Mesh: " .. mesh.Name, Links = links})
                    end
                end
            end
            
            -- عرض الروابط
            for i, asset in ipairs(allLinks) do
                local assetFrame = Instance.new("Frame")
                assetFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                assetFrame.Size = UDim2.new(0.98, 0, 0, 60)
                assetFrame.Position = UDim2.new(0.01, 0, 0, yOffset)
                assetFrame.Parent = contentFrame
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Text = "🔗 " .. asset.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
                nameLabel.TextSize = 11
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
                nameLabel.Position = UDim2.new(0, 5, 0, 5)
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = assetFrame
                
                local linkLabel = Instance.new("TextLabel")
                linkLabel.Text = asset.Links.Direct
                linkLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
                linkLabel.TextSize = 10
                linkLabel.BackgroundTransparency = 1
                linkLabel.Size = UDim2.new(1, -10, 0.5, 0)
                linkLabel.Position = UDim2.new(0, 5, 0.3, 0)
                linkLabel.TextXAlignment = Enum.TextXAlignment.Left
                linkLabel.TextWrapped = true
                linkLabel.Parent = assetFrame
                
                -- زر نسخ الرابط
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋 نسخ"
                copyBtn.TextSize = 10
                copyBtn.Size = UDim2.new(0.2, 0, 0.3, 0)
                copyBtn.Position = UDim2.new(0.78, 0, 0.65, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                copyBtn.Parent = assetFrame
                
                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard(asset.Links.Direct)
                    copyBtn.Text = "✅ تم!"
                    task.wait(1)
                    copyBtn.Text = "📋 نسخ"
                end)
                
                yOffset += 65
            end
            
        elseif tabIndex == 3 then -- السكربتات
            yOffset = 10
            
            if #collectedData.Scripts == 0 then
                local noScripts = Instance.new("TextLabel")
                noScripts.Text = "📭 لا توجد سكربتات في هذا النموذج"
                noScripts.TextColor3 = Color3.fromRGB(255, 150, 150)
                noScripts.TextSize = 14
                noScripts.BackgroundTransparency = 1
                noScripts.Size = UDim2.new(1, 0, 0.1, 0)
                noScripts.Position = UDim2.new(0, 0, 0, yOffset)
                noScripts.Parent = contentFrame
                return
            end
            
            for i, scriptData in ipairs(collectedData.Scripts) do
                local scriptFrame = Instance.new("Frame")
                scriptFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                scriptFrame.Size = UDim2.new(0.98, 0, 0, 100)
                scriptFrame.Position = UDim2.new(0.01, 0, 0, yOffset)
                scriptFrame.Parent = contentFrame
                
                -- معلومات السكربت
                local infoLabel = Instance.new("TextLabel")
                infoLabel.Text = string.format(
                    "💻 %s\n📝 النوع: %s | 📊 الأسطر: %d | ⚡ مفعل: %s",
                    scriptData.Name,
                    scriptData.Type,
                    scriptData.LineCount,
                    scriptData.Disabled and "❌ لا" or "✅ نعم"
                )
                infoLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
                infoLabel.TextSize = 11
                infoLabel.BackgroundTransparency = 1
                infoLabel.Size = UDim2.new(1, 0, 0.3, 0)
                infoLabel.Position = UDim2.new(0, 5, 0, 5)
                infoLabel.TextXAlignment = Enum.TextXAlignment.Left
                infoLabel.Parent = scriptFrame
                
                -- عرض جزء من الكود
                local previewText = scriptData.Content
                if #previewText > 300 then
                    previewText = previewText:sub(1, 300) .. "..."
                end
                
                local codePreview = Instance.new("TextLabel")
                codePreview.Text = "📜 الكود:\n" .. previewText
                codePreview.TextColor3 = Color3.fromRGB(200, 200, 200)
                codePreview.TextSize = 10
                codePreview.BackgroundTransparency = 1
                codePreview.Size = UDim2.new(1, -10, 0.5, 0)
                codePreview.Position = UDim2.new(0, 5, 0.3, 0)
                codePreview.TextXAlignment = Enum.TextXAlignment.Left
                codePreview.TextWrapped = true
                codePreview.Parent = scriptFrame
                
                -- زر نسخ الكود
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋 نسخ الكود"
                copyBtn.TextSize = 10
                copyBtn.Size = UDim2.new(0.3, 0, 0.2, 0)
                copyBtn.Position = UDim2.new(0.68, 0, 0.78, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
                copyBtn.Parent = scriptFrame
                
                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard(scriptData.Content)
                    copyBtn.Text = "✅ تم النسخ!"
                    task.wait(1)
                    copyBtn.Text = "📋 نسخ الكود"
                end)
                
                yOffset += 105
            end
            
        elseif tabIndex == 4 then -- النسخ
            yOffset = 10
            
            local copyOptions = {
                {"📋 نسخ كل Asset IDs", function()
                    local allIds = {}
                    table.insert(allIds, "🔷 Dragon Chalice - All Asset IDs")
                    
                    if collectedData.Model.AssetId then
                        table.insert(allIds, "📦 النموذج: " .. collectedData.Model.AssetId)
                    end
                    
                    for _, mesh in ipairs(collectedData.Meshes) do
                        if mesh.AssetId then
                            table.insert(allIds, "🔷 " .. mesh.Name .. ": " .. mesh.AssetId)
                        end
                    end
                    
                    for _, texture in ipairs(collectedData.Textures) do
                        if texture.AssetId then
                            table.insert(allIds, "🎨 " .. texture.Name .. ": " .. texture.AssetId)
                        end
                    end
                    
                    setclipboard(table.concat(allIds, "\n"))
                end},
                
                {"📊 نسخ المعلومات الكاملة", function()
                    local fullData = {
                        "=== Dragon Chalice Asset Analysis ===",
                        "📅 التاريخ: " .. os.date("%Y-%m-%d %H:%M:%S"),
                        "👤 اللاعب: " .. localPlayer.Name,
                        "",
                        "📦 معلومات النموذج:",
                        "الاسم: " .. collectedData.Model.Name,
                        "AssetId: " .. (collectedData.Model.AssetId or "N/A"),
                        "",
                        "📊 الإحصائيات:",
                        "Meshes: " .. #collectedData.Meshes,
                        "Textures: " .. #collectedData.Textures,
                        "Sounds: " .. #collectedData.Sounds,
                        "Animations: " .. #collectedData.Animations,
                        "Scripts: " .. #collectedData.Scripts,
                        "Other Assets: " .. #collectedData.OtherAssets
                    }
                    
                    setclipboard(table.concat(fullData, "\n"))
                end},
                
                {"🔗 نسخ روابط AssetDelivery", function()
                    local links = {"=== Asset Delivery Links ==="}
                    
                    if collectedData.Model.AssetId then
                        local modelLinks = generateAssetDeliveryLinks(collectedData.Model.AssetId)
                        if modelLinks then
                            table.insert(links, "📦 النموذج:")
                            table.insert(links, modelLinks.Direct)
                        end
                    end
                    
                    for _, mesh in ipairs(collectedData.Meshes) do
                        if mesh.AssetId then
                            local meshLinks = generateAssetDeliveryLinks(mesh.AssetId)
                            if meshLinks then
                                table.insert(links, "\n🔷 " .. mesh.Name .. ":")
                                table.insert(links, meshLinks.Direct)
                            end
                        end
                    end
                    
                    setclipboard(table.concat(links, "\n"))
                end},
                
                {"💻 نسخ كل السكربتات", function()
                    if #collectedData.Scripts == 0 then
                        setclipboard("⚠️ لا توجد سكربتات في هذا النموذج")
                        return
                    end
                    
                    local allScripts = {"=== Dragon Chalice Scripts ==="}
                    
                    for i, scriptData in ipairs(collectedData.Scripts) do
                        table.insert(allScripts, "\n" .. string.rep("=", 40))
                        table.insert(allScripts, "💻 " .. scriptData.Name .. " [" .. scriptData.Type .. "]")
                        table.insert(allScripts, "📊 الأسطر: " .. scriptData.LineCount)
                        table.insert(allScripts, "⚡ مفعل: " .. (scriptData.Disabled and "لا" or "نعم"))
                        table.insert(allScripts, string.rep("-", 40))
                        table.insert(allScripts, scriptData.Content)
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
                copyBtn.Size = UDim2.new(0.96, 0, 0, 35)
                copyBtn.Position = UDim2.new(0.02, 0, 0, yOffset)
                copyBtn.Parent = contentFrame
                
                copyBtn.MouseButton1Click:Connect(option[2])
                
                yOffset += 40
            end
        end
        
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    end
    
    -- دالة التحليل الرئيسية
    analyzeBtn.MouseButton1Click:Connect(function()
        analyzeBtn.Text = "⏳ جاري التحليل..."
        analyzeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        task.wait(0.5)
        
        local model, message = findDragonChalice()
        
        if model then
            collectedData = collectAllAssetIds(model)
            analyzeBtn.Text = "✅ تم التحليل!"
            analyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            
            -- تحديث التبويب الأول
            updateContent(1)
        else
            analyzeBtn.Text = "❌ فشل التحليل"
            analyzeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        end
    end)
    
    -- تهيئة المحتوى الأولي
    updateContent(1)
    
    -- تكيف مع الشاشات الصغيرة
    if UserInputService.TouchEnabled then
        mainFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
        mainFrame.Position = UDim2.new(0.025, 0, 0.075, 0)
        
        contentFrame.Size = UDim2.new(0.98, 0, 0.75, 0)
        analyzeBtn.Size = UDim2.new(0.7, 0, 0.07, 0)
        analyzeBtn.Position = UDim2.new(0.15, 0, 0.92, 0)
    end
    
    return mobileGui
end

-- ============== بدء التشغيل ==============
print("========================================")
print("   Dragon Chalice Asset Analyzer v2.0   ")
print("         Mobile Professional Edition    ")
print("========================================")

-- إنشاء الواجهة
local ui = createAdvancedMobileUI()

print("✅ تم تحميل المحلل بنجاح!")
print("🔍 اضغط على زر 'بدء تحليل Dragon Chalice'")
