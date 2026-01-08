-- // Script by: Dragon (East) Researcher
-- // Purpose: Find & Copy AssetId of a specific Chalice model.

-- // Loadstring for Phone (paste this in your executor):
-- loadstring(game:HttpGet("https://pastebin.com/raw/YourPastebinCode"))()

-- ==================== UI SETUP ====================
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/1xw9pU57"))()
local Window = Library:CreateWindow("Chalice Asset Scanner")

local MainTab = Window:AddTab("Main")
local Section = MainTab:AddSection("Search Target: Dragon (East)")

-- ==================== VARIABLES ====================
local TargetName = "Dragon (East)-Dragon (East)"
local TargetPath = "ReplicatedStorage.Assets.Models.Chalices." .. TargetName
local FoundAssets = {}

-- ==================== SCAN FUNCTION ====================
local function DeepScan(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == TargetName then
            -- Check if it's in the correct path
            local fullPath = child:GetFullName()
            if string.find(fullPath, TargetPath) then
                -- Get AssetId (if exists)
                local assetId = "N/A"
                pcall(function()
                    if child:IsA("Model") or child:IsA("MeshPart") or child:IsA("Decal") then
                        assetId = tostring(child.AssetId)
                    elseif child:IsA("Tool") then
                        assetId = tostring(child.ToolId)
                    end
                end)
                
                -- Store result
                table.insert(FoundAssets, {
                    Instance = child,
                    Path = fullPath,
                    AssetId = assetId
                })
            end
        end
        -- Recursive search
        DeepScan(child)
    end
end

-- ==================== UI ELEMENTS ====================
local OutputLabel = Section:AddLabel("Ready to scan.")
local ResultsFolder = Instance.new("Folder")
ResultsFolder.Name = "ChaliceResults"
ResultsFolder.Parent = game:GetService("CoreGui")

-- Scan Button
Section:AddButton("🔍 SCAN NOW", function()
    FoundAssets = {}
    OutputLabel:SetText("⏳ Scanning... Please wait.")
    
    -- Start scan from all top-level services
    for _, service in ipairs({
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("ServerStorage"),
        game:GetService("ServerScriptService"),
        game:GetService("StarterPack"),
        game:GetService("StarterGui"),
        game:GetService("StarterPlayer")
    }) do
        DeepScan(service)
    end
    
    -- Display results
    if #FoundAssets > 0 then
        OutputLabel:SetText("✅ Found " .. #FoundAssets .. " instances!")
        
        -- Clear old buttons
        for _, v in ipairs(ResultsFolder:GetChildren()) do
            if v:IsA("TextButton") then
                v:Destroy()
        end end
        
        -- Create new buttons for each found asset
        for i, data in ipairs(FoundAssets) do
            local btn = Instance.new("TextButton")
            btn.Name = "AssetBtn_" .. i
            btn.Text = "📋 #" .. i .. " | AssetId: " .. data.AssetId
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.Position = UDim2.new(0.05, 0, 0, (i-1)*40)
            btn.Parent = ResultsFolder
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.SourceSansBold
            
            btn.MouseButton1Click:Connect(function()
                -- Copy to clipboard
                setclipboard(data.AssetId)
                OutputLabel:SetText("📋 Copied: " .. data.AssetId)
                btn.Text = "✅ Copied!"
                task.wait(1)
                btn.Text = "📋 #" .. i .. " | AssetId: " .. data.AssetId
            end)
        end
    else
        OutputLabel:SetText("❌ No instances found.")
    end
end)

-- Copy All Button
Section:AddButton("📋 COPY ALL AssetIds", function()
    if #FoundAssets == 0 then
        OutputLabel:SetText("⚠️ Scan first!")
        return
    end
    
    local allText = ""
    for i, data in ipairs(FoundAssets) do
        allText = allText .. data.AssetId .. "\n"
    end
    
    setclipboard(allText)
    OutputLabel:SetText("📋 All " .. #FoundAssets .. " AssetIds copied!")
end)

-- Clear Button
Section:AddButton("🗑️ CLEAR RESULTS", function()
    FoundAssets = {}
    for _, v in ipairs(ResultsFolder:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
    end end
    OutputLabel:SetText("🧹 Cleared. Ready for new scan.")
end)

-- ==================== INFO ====================
Section:AddLabel("Target: " .. TargetName)
Section:AddLabel("Expected Path: " .. TargetPath)

-- ==================== FINAL MESSAGE ====================
OutputLabel:SetText("✅ Loaded! Press SCAN NOW to start.")
