-- Dragon (East)-Dragon (East) Complete Analyzer
-- للهاتف عبر loadstring(game:HttpGet(""))

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

print("🐉 Dragon (East)-Dragon (East) Analyzer Loading...")

-- البحث عن النموذج المحدد
local function FIND_DRAGON_MODEL()
    print("\n🔍 Searching for Dragon (East)-Dragon (East)...")
    
    local success, model = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Assets")
            :WaitForChild("Models")
            :WaitForChild("Chalices")
            :WaitForChild("Dragon (East)-Dragon (East)")
    end)
    
    if success and model then
        print("✅ Found: Dragon (East)-Dragon (East)")
        print("📍 Path: ReplicatedStorage.Assets.Models.Chalices")
        print("📦 Model Type: " .. model.ClassName)
        
        return model
    else
        print("❌ NOT FOUND!")
        print("💡 Check if path exists:")
        print("   ReplicatedStorage: " .. tostring(game:GetService("ReplicatedStorage")))
        print("   Assets: " .. tostring(game:GetService("ReplicatedStorage"):FindFirstChild("Assets")))
        print("   Models: " .. tostring(game:GetService("ReplicatedStorage").Assets:FindFirstChild("Models")))
        print("   Chalices: " .. tostring(game:GetService("ReplicatedStorage").Assets.Models:FindFirstChild("Chalices")))
        return nil
    end
end

-- جمع كل المعلومات عن النموذج
local function ANALYZE_DRAGON_MODEL(model)
    print("\n📊 Analyzing Dragon (East)-Dragon (East)...")
    
    local analysis = {
        BasicInfo = {},
        Meshes = {},
        Textures = {},
        Sounds = {},
        Scripts = {},
        Parts = {},
        Children = {}
    }
    
    -- المعلومات الأساسية
    analysis.BasicInfo = {
        Name = model.Name,
        ClassName = model.ClassName,
        AssetId = model.AssetId or "N/A",
        PrimaryPart = model.PrimaryPart and model.PrimaryPart.Name or "None",
        ChildrenCount = #model:GetChildren(),
        DescendantsCount = #model:GetDescendants()
    }
    
    print("📦 Basic Info:")
    print("   • Name: " .. analysis.BasicInfo.Name)
    print("   • AssetId: " .. analysis.BasicInfo.AssetId)
    print("   • Children: " .. analysis.BasicInfo.ChildrenCount)
    print("   • Descendants: " .. analysis.BasicInfo.DescendantsCount)
    
    -- تحليل كل الأجزاء
    local totalMeshes = 0
    local totalTextures = 0
    local totalSounds = 0
    local totalScripts = 0
    local totalParts = 0
    
    for _, obj in pairs(model:GetDescendants()) do
        -- Parts
        if obj:IsA("BasePart") then
            table.insert(analysis.Parts, {
                Name = obj.Name,
                Class = obj.ClassName,
                Size = obj.Size,
                Position = obj.Position,
                Color = obj.Color
            })
            totalParts = totalParts + 1
            
            -- Meshes في Parts
            if obj:IsA("MeshPart") then
                if obj.MeshId and obj.MeshId ~= "" then
                    table.insert(analysis.Meshes, {
                        Name = obj.Name,
                        Type = "MeshPart",
                        MeshId = obj.MeshId,
                        TextureId = obj.TextureID or "N/A"
                    })
                    totalMeshes = totalMeshes + 1
                end
            end
        end
        
        -- Meshes مستقلة
        if obj:IsA("SpecialMesh") or obj:IsA("FileMesh") then
            if obj.MeshId and obj.MeshId ~= "" then
                table.insert(analysis.Meshes, {
                    Name = obj.Name,
                    Type = obj.ClassName,
                    MeshId = obj.MeshId,
                    TextureId = obj.TextureId or "N/A"
                })
                totalMeshes = totalMeshes + 1
            end
        end
        
        -- Textures
        if obj:IsA("Decal") then
            if obj.Texture and obj.Texture ~= "" then
                table.insert(analysis.Textures, {
                    Name = obj.Name,
                    Texture = obj.Texture,
                    Face = obj.Face.Name
                })
                totalTextures = totalTextures + 1
            end
        end
        
        -- Sounds
        if obj:IsA("Sound") then
            if obj.SoundId and obj.SoundId ~= "" then
                table.insert(analysis.Sounds, {
                    Name = obj.Name,
                    SoundId = obj.SoundId,
                    Volume = obj.Volume,
                    Playing = obj.Playing
                })
                totalSounds = totalSounds + 1
            end
        end
        
        -- Scripts (الأهم!)
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local scriptInfo = {
                Name = obj.Name,
                Type = obj.ClassName,
                Disabled = obj.Disabled,
                SourceLength = 0,
                Content = "N/A"
            }
            
            -- محاولة قراءة الكود
            if pcall(function() scriptInfo.Content = obj.Source end) then
                scriptInfo.SourceLength = #scriptInfo.Content
                scriptInfo.LineCount = #(string.split(scriptInfo.Content, "\n"))
                
                -- تحليل بسيط للكود
                if #scriptInfo.Content > 0 then
                    scriptInfo.HasLoadstring = scriptInfo.Content:find("loadstring") ~= nil
                    scriptInfo.HasHttpGet = scriptInfo.Content:find("HttpGet") ~= nil
                    scriptInfo.HasRemoteEvents = scriptInfo.Content:find("RemoteEvent") ~= nil
                end
            end
            
            table.insert(analysis.Scripts, scriptInfo)
            totalScripts = totalScripts + 1
        end
        
        -- Children مباشرة تحت النموذج
        if obj.Parent == model then
            table.insert(analysis.Children, {
                Name = obj.Name,
                Class = obj.ClassName
            })
        end
    end
    
    print("\n📊 Detailed Analysis:")
    print("   • Parts: " .. totalParts)
    print("   • Meshes: " .. totalMeshes)
    print("   • Textures: " .. totalTextures)
    print("   • Sounds: " .. totalSounds)
    print("   • Scripts: " .. totalScripts)
    
    return analysis, totalParts, totalMeshes, totalTextures, totalSounds, totalScripts
end

-- إنشاء رابط AssetDelivery
local function GET_ASSET_LINKS(assetId)
    if not assetId or assetId == "" or assetId == "N/A" then
        return nil
    end
    
    -- استخراج الرقم من assetId
    local id = assetId:match("%d+")
    if not id then
        return nil
    end
    
    return {
        AssetDelivery = "https://assetdelivery.roblox.com/v1/asset/?id=" .. id,
        RobloxCDN = "https://www.roblox.com/library/" .. id,
        DirectLink = "rbxassetid://" .. id
    }
end

-- واجهة الهاتف المخصصة
local function CREATE_MOBILE_INTERFACE()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DragonAnalyzerMobile"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    -- الإطار الرئيسي
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.9, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.05, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = screenGui
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🐉 Dragon (East)-Dragon (East) Analyzer"
    title.Size = UDim2.new(1, 0, 0.08, 0)
    title.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- زر التحليل
    local analyzeBtn = Instance.new("TextButton")
    analyzeBtn.Text = "🔍 FIND & ANALYZE"
    analyzeBtn.Size = UDim2.new(0.9, 0, 0.08, 0)
    analyzeBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    analyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    analyzeBtn.TextColor3 = Color3.new(1, 1, 1)
    analyzeBtn.Font = Enum.Font.GothamBold
    analyzeBtn.TextScaled = true
    analyzeBtn.Parent = mainFrame
    
    -- منطقة النتائج
    local resultFrame = Instance.new("ScrollingFrame")
    resultFrame.Name = "ResultFrame"
    resultFrame.Size = UDim2.new(0.94, 0, 0.7, 0)
    resultFrame.Position = UDim2.new(0.03, 0, 0.2, 0)
    resultFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    resultFrame.BackgroundTransparency = 0.2
    resultFrame.ScrollBarThickness = 8
    resultFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    resultFrame.Parent = mainFrame
    
    -- حالة
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Ready to analyze Dragon (East)-Dragon (East)..."
    statusLabel.Size = UDim2.new(0.94, 0, 0.05, 0)
    statusLabel.Position = UDim2.new(0.03, 0, 0.92, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextWrapped = true
    statusLabel.Parent = mainFrame
    
    -- زر نسخ الكل
    local copyAllBtn = Instance.new("TextButton")
    copyAllBtn.Text = "📋 COPY ALL INFO"
    copyAllBtn.Size = UDim2.new(0.45, 0, 0.07, 0)
    copyAllBtn.Position = UDim2.new(0.03, 0, 0.85, 0)
    copyAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    copyAllBtn.TextColor3 = Color3.new(1, 1, 1)
    copyAllBtn.Font = Enum.Font.GothamBold
    copyAllBtn.TextScaled = true
    copyAllBtn.Visible = false
    copyAllBtn.Parent = mainFrame
    
    -- متغيرات التخزين
    local currentAnalysis = nil
    local allInfoText = ""
    
    -- دالة عرض النتائج
    local function DISPLAY_RESULTS(analysis, parts, meshes, textures, sounds, scripts)
        resultFrame:ClearAllChildren()
        
        local yOffset = 10
        
        -- المعلومات الأساسية
        local basicInfoFrame = Instance.new("Frame")
        basicInfoFrame.Size = UDim2.new(0.96, 0, 0, 100)
        basicInfoFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
        basicInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        basicInfoFrame.Parent = resultFrame
        
        local basicTitle = Instance.new("TextLabel")
        basicTitle.Text = "📦 BASIC INFORMATION"
        basicTitle.Size = UDim2.new(1, 0, 0.2, 0)
        basicTitle.Position = UDim2.new(0, 0, 0, 0)
        basicTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        basicTitle.TextColor3 = Color3.new(1, 1, 1)
        basicTitle.Font = Enum.Font.GothamBold
        basicTitle.Parent = basicInfoFrame
        
        local basicText = Instance.new("TextLabel")
        basicText.Text = string.format(
            "Name: %s\nAssetId: %s\nChildren: %d\nDescendants: %d\nPrimary Part: %s",
            analysis.BasicInfo.Name,
            analysis.BasicInfo.AssetId,
            analysis.BasicInfo.ChildrenCount,
            analysis.BasicInfo.DescendantsCount,
            analysis.BasicInfo.PrimaryPart
        )
        basicText.Size = UDim2.new(0.98, 0, 0.7, 0)
        basicText.Position = UDim2.new(0.01, 0, 0.25, 0)
        basicText.BackgroundTransparency = 1
        basicText.TextColor3 = Color3.fromRGB(200, 220, 255)
        basicText.Font = Enum.Font.Gotham
        basicText.TextWrapped = true
        basicText.TextXAlignment = Enum.TextXAlignment.Left
        basicText.Parent = basicInfoFrame
        
        yOffset = yOffset + 110
        
        -- الإحصائيات
        local statsFrame = Instance.new("Frame")
        statsFrame.Size = UDim2.new(0.96, 0, 0, 70)
        statsFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
        statsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        statsFrame.Parent = resultFrame
        
        local statsText = Instance.new("TextLabel")
        statsText.Text = string.format(
            "📊 MODEL STATISTICS\n\nParts: %d  |  Meshes: %d\nTextures: %d  |  Sounds: %d\nScripts: %d",
            parts, meshes, textures, sounds, scripts
        )
        statsText.Size = UDim2.new(0.98, 0, 0.9, 0)
        statsText.Position = UDim2.new(0.01, 0, 0.05, 0)
        statsText.BackgroundTransparency = 1
        statsText.TextColor3 = Color3.fromRGB(255, 255, 200)
        statsText.Font = Enum.Font.GothamBold
        statsText.TextWrapped = true
        statsText.Parent = statsFrame
        
        yOffset = yOffset + 80
        
        -- السكربتات (الأهم)
        if #analysis.Scripts > 0 then
            local scriptsTitle = Instance.new("TextLabel")
            scriptsTitle.Text = "💻 SCRIPTS FOUND: " .. #analysis.Scripts
            scriptsTitle.Size = UDim2.new(0.96, 0, 0, 30)
            scriptsTitle.Position = UDim2.new(0.02, 0, 0, yOffset)
            scriptsTitle.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            scriptsTitle.TextColor3 = Color3.new(1, 1, 1)
            scriptsTitle.Font = Enum.Font.GothamBold
            scriptsTitle.Parent = resultFrame
            
            yOffset = yOffset + 40
            
            for i, script in ipairs(analysis.Scripts) do
                local scriptFrame = Instance.new("Frame")
                scriptFrame.Size = UDim2.new(0.96, 0, 0, 90)
                scriptFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
                scriptFrame.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
                scriptFrame.Parent = resultFrame
                
                local scriptName = Instance.new("TextLabel")
                scriptName.Text = script.Name .. " [" .. script.Type .. "]"
                scriptName.Size = UDim2.new(0.7, 0, 0.3, 0)
                scriptName.Position = UDim2.new(0.02, 0, 0.05, 0)
                scriptName.BackgroundTransparency = 1
                scriptName.TextColor3 = Color3.fromRGB(255, 200, 200)
                scriptName.Font = Enum.Font.GothamBold
                scriptName.TextXAlignment = Enum.TextXAlignment.Left
                scriptName.Parent = scriptFrame
                
                local scriptInfo = Instance.new("TextLabel")
                scriptInfo.Text = string.format(
                    "Lines: %d | Size: %d chars\nDisabled: %s\nLoadstring: %s | HttpGet: %s",
                    script.LineCount or 0,
                    script.SourceLength,
                    script.Disabled and "Yes" or "No",
                    script.HasLoadstring and "Yes" or "No",
                    script.HasHttpGet and "Yes" or "No"
                )
                scriptInfo.Size = UDim2.new(0.7, 0, 0.5, 0)
                scriptInfo.Position = UDim2.new(0.02, 0, 0.4, 0)
                scriptInfo.BackgroundTransparency = 1
                scriptInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
                scriptInfo.Font = Enum.Font.Gotham
                scriptInfo.TextWrapped = true
                scriptInfo.TextXAlignment = Enum.TextXAlignment.Left
                scriptInfo.Parent = scriptFrame
                
                -- زر نسخ الكود
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋 Copy"
                copyBtn.Size = UDim2.new(0.25, 0, 0.3, 0)
                copyBtn.Position = UDim2.new(0.73, 0, 0.35, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                copyBtn.TextColor3 = Color3.new(1, 1, 1)
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.Parent = scriptFrame
                
                copyBtn.MouseButton1Click:Connect(function()
                    if script.Content and script.Content ~= "N/A" then
                        setclipboard(script.Content)
                        copyBtn.Text = "✅ Copied!"
                        wait(1)
                        copyBtn.Text = "📋 Copy"
                    end
                end)
                
                yOffset = yOffset + 100
            end
        else
            local noScripts = Instance.new("TextLabel")
            noScripts.Text = "📭 NO SCRIPTS FOUND IN THIS MODEL"
            noScripts.Size = UDim2.new(0.96, 0, 0, 40)
            noScripts.Position = UDim2.new(0.02, 0, 0, yOffset)
            noScripts.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            noScripts.TextColor3 = Color3.new(1, 1, 1)
            noScripts.Font = Enum.Font.Gotham
            noScripts.Parent = resultFrame
            
            yOffset = yOffset + 50
        end
        
        -- Asset Links
        if analysis.BasicInfo.AssetId and analysis.BasicInfo.AssetId ~= "N/A" then
            local linksFrame = Instance.new("Frame")
            linksFrame.Size = UDim2.new(0.96, 0, 0, 60)
            linksFrame.Position = UDim2.new(0.02, 0, 0, yOffset)
            linksFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
            linksFrame.Parent = resultFrame
            
            local linksText = Instance.new("TextLabel")
            linksText.Text = "🔗 ASSET LINKS\nAsset ID: " .. analysis.BasicInfo.AssetId
            linksText.Size = UDim2.new(0.7, 0, 1, 0)
            linksText.Position = UDim2.new(0.02, 0, 0, 0)
            linksText.BackgroundTransparency = 1
            linksText.TextColor3 = Color3.fromRGB(200, 220, 255)
            linksText.Font = Enum.Font.Gotham
            linksText.TextWrapped = true
            linksText.TextXAlignment = Enum.TextXAlignment.Left
            linksText.Parent = linksFrame
            
            local copyLinkBtn = Instance.new("TextButton")
            copyLinkBtn.Text = "📋 Copy Link"
            copyLinkBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
            copyLinkBtn.Position = UDim2.new(0.73, 0, 0.2, 0)
            copyLinkBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            copyLinkBtn.TextColor3 = Color3.new(1, 1, 1)
            copyLinkBtn.Font = Enum.Font.GothamBold
            copyLinkBtn.Parent = linksFrame
            
            copyLinkBtn.MouseButton1Click:Connect(function()
                local links = GET_ASSET_LINKS(analysis.BasicInfo.AssetId)
                if links then
                    setclipboard(links.AssetDelivery)
                    copyLinkBtn.Text = "✅ Copied!"
                    wait(1)
                    copyLinkBtn.Text = "📋 Copy Link"
                end
            end)
            
            yOffset = yOffset + 70
        end
        
        resultFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
        
        -- تحضير نص النسخ
        allInfoText = string.format(
            "🐉 Dragon (East)-Dragon (East) Analysis\n%s\n\n📊 Statistics:\n• Parts: %d\n• Meshes: %d\n• Textures: %d\n• Sounds: %d\n• Scripts: %d\n\n📦 Asset ID: %s\n\n",
            os.date("%Y-%m-%d %H:%M:%S"),
            parts, meshes, textures, sounds, scripts,
            analysis.BasicInfo.AssetId
        )
        
        -- إضافة معلومات السكربتات
        if #analysis.Scripts > 0 then
            allInfoText = allInfoText .. "💻 SCRIPTS:\n"
            for i, script in ipairs(analysis.Scripts) do
                allInfoText = allInfoText .. string.format(
                    "\n[%d] %s (%s)\nLines: %d | Size: %d chars\nDisabled: %s\n",
                    i, script.Name, script.Type,
                    script.LineCount or 0, script.SourceLength,
                    script.Disabled and "Yes" or "No"
                )
                
                if script.HasLoadstring then
                    allInfoText = allInfoText .. "⚠️ Contains loadstring\n"
                end
                if script.HasHttpGet then
                    allInfoText = allInfoText .. "⚠️ Contains HttpGet\n"
                end
                
                allInfoText = allInfoText .. string.rep("-", 30) .. "\n"
            end
        end
        
        copyAllBtn.Visible = true
    end
    
    -- حدث زر التحليل
    analyzeBtn.MouseButton1Click:Connect(function()
        analyzeBtn.Text = "🔍 SEARCHING..."
        analyzeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        statusLabel.Text = "Looking for Dragon (East)-Dragon (East)..."
        
        local model = FIND_DRAGON_MODEL()
        
        if model then
            analyzeBtn.Text = "📊 ANALYZING..."
            statusLabel.Text = "Model found! Analyzing contents..."
            
            local analysis, parts, meshes, textures, sounds, scripts = ANALYZE_DRAGON_MODEL(model)
            currentAnalysis = analysis
            
            DISPLAY_RESULTS(analysis, parts, meshes, textures, sounds, scripts)
            
            analyzeBtn.Text = "✅ ANALYSIS COMPLETE"
            analyzeBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            statusLabel.Text = string.format(
                "Found: %d Parts, %d Meshes, %d Textures, %d Sounds, %d Scripts",
                parts, meshes, textures, sounds, scripts
            )
        else
            analyzeBtn.Text = "❌ NOT FOUND"
            analyzeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            statusLabel.Text = "Dragon (East)-Dragon (East) not found at specified path!"
            
            -- إظهار رسالة الخطأ
            resultFrame:ClearAllChildren()
            
            local errorMsg = Instance.new("TextLabel")
            errorMsg.Text = "❌ Dragon (East)-Dragon (East) NOT FOUND!\n\nPlease check:\n1. Path exists: ReplicatedStorage.Assets.Models.Chalices\n2. Model name is exact: Dragon (East)-Dragon (East)\n3. You're in the right game"
            errorMsg.Size = UDim2.new(0.9, 0, 0.8, 0)
            errorMsg.Position = UDim2.new(0.05, 0, 0.1, 0)
            errorMsg.BackgroundTransparency = 1
            errorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
            errorMsg.Font = Enum.Font.GothamBold
            errorMsg.TextWrapped = true
            errorMsg.Parent = resultFrame
            
            copyAllBtn.Visible = false
        end
    end)
    
    -- حدث نسخ الكل
    copyAllBtn.MouseButton1Click:Connect(function()
        if allInfoText and allInfoText ~= "" then
            setclipboard(allInfoText)
            copyAllBtn.Text = "✅ COPIED!"
            statusLabel.Text = "All information copied to clipboard!"
            
            wait(2)
            copyAllBtn.Text = "📋 COPY ALL INFO"
        end
    end)
    
    return screenGui
end

-- ============================================
-- 🚀 START
-- ============================================

CREATE_MOBILE_INTERFACE()

print("\n" .. string.rep("=", 60))
print("🐉 Dragon (East)-Dragon (East) Analyzer v1.0")
print("📱 Mobile-Compatible for Delta Roblox")
print("🎯 Target: ReplicatedStorage.Assets.Models.Chalices")
print(string.rep("=", 60))
print("\n✅ Interface loaded! Press 'FIND & ANALYZE' to start")
