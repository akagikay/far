-- Adopt Me Zotti Autofarm by 0_Void
getgenv().farmsettings = {
    pet = "", -- Leave blank for auto-select
    babyfarm = true,
    switchpetsongrown = false, -- False for age potions
	prioritizeeggs = false,
    webhook = "",
	gui = true,
}
--writefile("adoptmeautofarm.txt")
if getgenv().running then 
    warn("Script already running")
    return 
end
getgenv().running = true

repeat task.wait() until game:IsLoaded()
local t = require(game:GetService("ReplicatedStorage"):WaitForChild("ClientModules").Game.Tutorial.LegacyTutorial)
hookfunction(t.run_avatar_tutorial,function()end)
hookfunction(t.run_housing_tutorial,function()end)
hookfunction(t.run_nursery_tutorial,function()end)

-- Set default settings if not provided
getgenv().farmsettings = getgenv().farmsettings or {
    pet = "Aztec Egg",
    babyfarm = true,
    switchpetsongrown = true,
    prioritizeeggs = false,
    webhook = "",
	gui = true
}

-- Initialize settings with defaults
getgenv().farmsettings.pet = getgenv().farmsettings.pet or ""
getgenv().farmsettings.babyfarm = getgenv().farmsettings.babyfarm == nil and true or getgenv().farmsettings.babyfarm
getgenv().farmsettings.switchpetsongrown = if getgenv().farmsettings.switchpetsongrown == nil then false else getgenv().farmsettings.switchpetsongrown
getgenv().farmsettings.prioritizeeggs = if getgenv().farmsettings.prioritizeeggs == nil then false else getgenv().farmsettings.prioritizeeggs
getgenv().farmsettings.gui = getgenv().farmsettings.gui == nil and true or getgenv().farmsettings.gui
-- Wait for game to load
repeat task.wait() until game:IsLoaded()
task.wait(2.5)
setthreadidentity(2)
-- Services and modules
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local plr = Players.LocalPlayer
local router = require(ReplicatedStorage.ClientModules.Core.RouterClient.RouterClient)
local cd = require(ReplicatedStorage.ClientModules.Core.ClientData)
local petentitymanager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
local inventorydb = require(ReplicatedStorage.ClientDB.Inventory.InventoryDB)

local terrainhelper = require(game:GetService("ReplicatedStorage").SharedModules.TerrainHelper)
local Fsys = require(ReplicatedStorage.Fsys)
local liveopstime = Fsys.load("LiveOpsTime")
setthreadidentity(8)
if plr.Character == nil then
	router.get("LegacyTutorialAPI/MarkTutorialCompleted"):FireServer()
	router.get("LegacyTutorialAPI/EquipTutorialEgg"):FireServer()
    repeat 
        local playbutton = game:GetService("Players").LocalPlayer.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Buttons.PlayButton
        firesignal(playbutton.MouseButton1Down)
        firesignal(playbutton.MouseButton1Up)
        firesignal(playbutton.MouseButton1Click)
        task.wait(1)
		if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Visible then
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Info.Response:GetChildren()[8].MouseButton1Down)
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Info.Response:GetChildren()[8].MouseButton1Up)
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Info.Response:GetChildren()[8].MouseButton1Click)
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Buttons.ButtonTemplate.MouseButton1Down)
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Buttons.ButtonTemplate.MouseButton1Up)
            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Buttons.ButtonTemplate.MouseButton1Click)
        else
			firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.SpawnChooserDialog.UpperCardContainer.ChoicesContent.Choices.Home.Button.MouseButton1Down)
			firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.SpawnChooserDialog.UpperCardContainer.ChoicesContent.Choices.Home.Button.MouseButton1Up)
			firesignal(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.SpawnChooserDialog.UpperCardContainer.ChoicesContent.Choices.Home.Button.MouseButton1Click)
		end
    until not (plr.Character == nil)
end
-- GUI Creation
local function createGUI()
    local screenGui = Instance.new("ScreenGui", gethui())
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = -1
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 1 -- Make the mainFrame background transparent
    mainFrame.Size = UDim2.new(1, 0, 1, 100)
    mainFrame.Position = UDim2.new(0, 0, -0.1, 0)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.Visible = getgenv().farmsettings.gui

    local title = Instance.new("TextLabel", mainFrame)
    title.BorderSizePixel = 0
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1 -- Make the title background transparent
    title.TextSize = 84
    title.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    title.TextColor3 = Color3.fromRGB(50, 150, 255) -- Lighter blue font
    title.Size = UDim2.new(0, 260, 0, 82)
    title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    title.Text = "Zotti autofarm"
    title.Name = "Title"
    title.Position = UDim2.new(0.45, 0, 0.116, 0)

    local labels = {
        {name = "Pet", text = "Current pet: None", position = UDim2.new(-0.57227, 0, 1.93902, 0)},
        {name = "Task", text = "Current task: None", position = UDim2.new(-0.57227, 0, 2.54878, 0)},
        {name = "Money", text = "Money farmed: 0", position = UDim2.new(-0.57227, 0, 3.15854, 0)},
        {name = "Potions", text = "Gained potions: 0", position = UDim2.new(-0.57227, 0, 4.37805, 0)},
        {name = "Time", text = "Time elapsed: 00:00.000", position = UDim2.new(-0.57227, 0, 4.9878, 0)}
    }

    for _, labelInfo in ipairs(labels) do
        local label = Instance.new("TextLabel", title)
        label.BorderSizePixel = 0
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1 -- Make the label background transparent
        label.TextSize = 33
        label.FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        label.TextColor3 = Color3.fromRGB(50, 150, 255) -- Lighter blue font
        label.Size = UDim2.new(0, 533, 0, 50)
        label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        label.Text = labelInfo.text
        label.Name = labelInfo.name
        label.Position = labelInfo.position
    end

    return screenGui
end
local gui = createGUI()

-- New function to buy Aztec Eggs
local function buyAztecEggs()
    local eggsBought = 0
    local maxEggs = 50
    
    warn("[DEBUG] buyAztecEggs() called")
    warn("[DEBUG] Current money: " .. tostring(cd.get("money")))
    
    for i = 1, maxEggs do
        warn("[DEBUG] Attempting to buy egg #" .. i)
        
        local success, result = pcall(function()
            local args = {"pets", "aztec_egg_2025_aztec_egg", {}}
            local response = game:GetService("ReplicatedStorage").API:FindFirstChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
            warn("[DEBUG] Shop response: " .. tostring(response))
            return response
        end)
        
        if success then
            if result then
                eggsBought = eggsBought + 1
                warn("[DEBUG] Successfully bought Aztec Egg #" .. eggsBought)
                warn("[DEBUG] Money after purchase: " .. tostring(cd.get("money")))
                task.wait(0.5) -- Wait for inventory to update
                
                -- Check if we actually got an egg in inventory
                local hasNewEgg = false
                for petId, petData in pairs(cd.get("inventory").pets) do
                    if inventorydb.pets[petData.kind] and inventorydb.pets[petData.kind].name == "Aztec Egg" then
                        hasNewEgg = true
                        warn("[DEBUG] Confirmed Aztec Egg in inventory: " .. petId)
                        break
                    end
                end
                
                if hasNewEgg then
                    warn("[DEBUG] Successfully confirmed egg purchase")
                    return eggsBought -- Return immediately after successful purchase
                else
                    warn("[DEBUG] Purchase successful but no egg found in inventory")
                end
            else
                warn("[DEBUG] Shop returned false/nil - likely insufficient funds or unavailable")
                break
            end
        else
            warn("[DEBUG] Failed to buy Aztec Egg #" .. i .. ": " .. tostring(result))
            break -- Stop trying if we get an error
        end
        
        -- Stop if we've tried 3 times without getting an egg
        if i >= 3 and eggsBought == 0 then
            warn("[DEBUG] Tried 3 times without success, stopping purchase attempts")
            break
        end
    end
    
    warn("[DEBUG] Finished buying process. Total successful purchases: " .. eggsBought)
    return eggsBought
end

-- Modified function to check if we have the specified egg
local function hasSpecifiedEgg()
    if not getgenv().farmsettings.pet or getgenv().farmsettings.pet == "" then
        return true -- No specific pet required
    end
    
    for petId, petData in pairs(cd.get("inventory").pets) do
        if inventorydb.pets[petData.kind] and inventorydb.pets[petData.kind].name and 
           string.lower(inventorydb.pets[petData.kind].name) == string.lower(getgenv().farmsettings.pet) then
            return true
        end
    end
    return false
end

-- Utility Functions
local function formatTime(elapsedTime)
    local minutes = math.floor(elapsedTime / 60)
    local seconds = math.floor(elapsedTime % 60)
    local milliseconds = math.floor((elapsedTime * 1000) % 1000)
    return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
end
-- Define minigame helper functions based on your script's structure
-- The most common and robust way to execute these system calls.
local function loadInteriorForJoin(name)
    -- 1. Ensure the thread has elevated privileges for system calls
    setthreadidentity(2) 
    
    local Fsys = game:GetService("ReplicatedStorage"):WaitForChild("Fsys", 5)
    if not Fsys then warn("[Hauntlet] Fsys module not found.") end
    
    -- 2. Execute the module loading and entry in a single, reliable block
    local success, result = pcall(function()
        local FsysModule = require(Fsys)
        local load = FsysModule.load
        local interiors = load("InteriorsM")
        local enter = interiors.enter
        
        -- Directly call 'enter' on the current thread, passing necessary arguments
        -- task.spawn is often unreliable for passing remote arguments
        enter(name, "", {})
        
        return true
    end)

    if not success or not result then
        warn(string.format("[Hauntlet] CRITICAL FAILURE: Interior load failed! Error: %s", tostring(result)))
    end
    
    -- 3. Reset identity immediately after the operation
    setthreadidentity(8) 
end

-- New primary function to be called inside your main farming loop.
local function checkAndJoinHauntlet()
    -- Ensure minigame functions are available (assuming global scope based on your script)
    if not liveopstime or not getminigametable then
        return 
    end

    local minigamet = getminigametable()
    
    -- Check if the minigame join window is approaching (e.g., less than 30 seconds)
    local timeUntilJoin = liveopstime.get_time_until(minigamet.join_zone_helper:get_next_time())
    
    if timeUntilJoin and timeUntilJoin > 0 and timeUntilJoin < 30 then
        warn(string.format("[Hauntlet] Join window detected (Time until next join: %d seconds). Initiating join sequence.", timeUntilJoin))

        -- Execute the join sequence:
        loadInteriorForJoin("MainMap!Fall")
        task.wait(2) -- Wait for the map to load and character to be placed
        
        -- INVOKE SERVER JOIN
        local joinRemote = game:GetService("ReplicatedStorage"):WaitForChild("API", 5):WaitForChild("HalloweenEventAPI/JoinMinigame", 5)
        if joinRemote then
            local success, result = pcall(function()
                joinRemote:InvokeServer() 
            end)

            if success and result and result.success then
                warn("[Hauntlet] Server Invocation SUCCESS! You should be teleporting now.")
            else
                warn("[Hauntlet] Server Invocation FAILED. Result: " .. tostring(result))
            end
        end
        
        -- Now, we force the main thread to WAIT for the minigame to end.
        local waitTime = 7 * 60 + 30 
        warn(string.format("[Hauntlet] Join sequence complete. Thread sleeping for ~%d seconds until minigame is over...", waitTime))
        
        task.wait(waitTime) 
        
        warn("[Hauntlet] Minigame wait complete. Resuming autofarm loop.")
        return true
    end
    
    return false
end

local function tryJoinHauntlet()
    local oldPos = plr.Character:WaitForChild("HumanoidRootPart").CFrame
    
    warn("[Hauntlet ACTION] Executing interior load and join.")
    
    -- 1. Load the interior map (This is the "teleport")
    loadInteriorForJoin("MainMap!Fall")
    task.wait(1) 
    
    -- 2. INVOKE SERVER JOIN
    local joinRemote = game:GetService("ReplicatedStorage"):WaitForChild("API", 5):WaitForChild("HalloweenEventAPI/JoinMinigame", 5)
    if joinRemote then
        local success, result = pcall(function()
            joinRemote:InvokeServer() 
        end)

        if success and result and result.success then
            warn("[Hauntlet] Server Invocation SUCCESS! Entering minigame.")
            -- We now let the main autofarm loop and your waitforailmentfinish logic handle the rest!
            return true
        else
            warn("[Hauntlet] Server Invocation FAILED. Result: " .. tostring(result))
        end
    end
    
    -- Failsafe: return to old position if join failed or remote not found
    plr.Character:WaitForChild("HumanoidRootPart").CFrame = oldPos
    return false
end
local function autoClaimTreatBag()
    -- Function to execute the remote bypass and claim logic
    local function claimBag()
        warn("[TreatBag] Executing remote bypass and claiming Treat Bag...")
        
        -- Bypass/Execution Code
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Xenijo/AdoptMe-RemoteBypass/main/Bypass.lua"))()
        task.wait(0.1)
        
        -- Invoke the server to claim the bag
        local success, result = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HalloweenEventAPI/ClaimTreatBag"):InvokeServer()
        end)
        
        if success and result ~= nil then
             warn("[TreatBag] Claim successful.")
        elseif not success then
             warn("[TreatBag] Claim failed (Bypass may not be loaded or remote changed): " .. tostring(result))
        else
             warn("[TreatBag] Claim completed (Response unknown).")
        end
    end

    -- 1. Execute once at the start
    claimBag()

    -- 2. Loop and execute every 10 minutes (600 seconds)
    while task.wait(600) do
        claimBag()
    end
end

-- Helper function defined once outside the main loop
local function loadInteriorForJoin(name)
    -- Setting identity is often required to access and call internal modules/remotes
    setthreadidentity(2) 
    
    local Fsys = game:GetService("ReplicatedStorage"):WaitForChild("Fsys", 5)
    if not Fsys then warn("[Hauntlet] Fsys module not found. Cannot load interior.") return end
    
    local success, load = pcall(function() return require(Fsys).load end)
    if not success or not load then warn("[Hauntlet] Fsys.load failed.") return end

    local interiors = load("InteriorsM")
    local enter = interiors.enter
    
    -- Execute the interior load on a new thread
    task.spawn(enter, name, "", {}) 
    
    -- Reset identity after execution
    setthreadidentity(8) 
end

local function autoJoinPoller()
    local MinigameAPI = game:GetService("ReplicatedStorage"):WaitForChild("API", 5):WaitForChild("MinigameAPI", 5)
    local minigameService = require(MinigameAPI)
    
    -- We assume the functions are globally defined based on your snippet.
    -- If 'liveopstime' and 'getminigametable' are not defined globally, this will fail.
    if not liveopstime or not getminigametable then
        warn("[Hauntlet] ERROR: liveopstime or getminigametable not defined. Cannot poll minigame timer.")
        return 
    end
    
    while task.wait(5) do
        local minigamet = getminigametable()
        
        -- Check if the timer is approaching the join window (e.g., within 30 seconds of joining)
        local timeUntilJoin = liveopstime.get_time_until(minigamet.join_zone_helper:get_next_time())
        
        if timeUntilJoin and timeUntilJoin <= 30 then
            -- Attempt to join
            local joined = tryJoinHauntlet()
            
            if joined then
                warn("[Hauntlet] Successfully joined minigame. Poller suspended for 8 minutes.")
                task.wait(8 * 60) -- Wait for the minigame to fully finish before checking again
            else
                warn("[Hauntlet] Join failed. Continuing to poll.")
            end
        end
    end
end

local function getPetKind()
    for id, petData in pairs(inventorydb.pets) do
        if petData and petData.name and getgenv().farmsettings.pet and string.lower(petData.name) == string.lower(getgenv().farmsettings.pet) then
            return id
        end
    end
    return ""
end

local function getPetNameFromId(id)
    for petId, petData in pairs(cd.get("inventory").pets) do
        if petId == id and inventorydb.pets[petData.kind].name then
            return inventorydb.pets[petData.kind].name
        end
    end
    return ""
end

local function isPetOwner(kind)
    for _, petData in pairs(cd.get("inventory").pets) do
        if petData.kind == kind then
            return true
        end
    end
    return false
end

local function getPetId()
    local highestAge = 0
    local highestFriendship = 0
    local petKind = getPetKind()
    
    -- Debug logging
    warn("[DEBUG] getPetId called")
    warn("[DEBUG] prioritizeeggs: " .. tostring(getgenv().farmsettings.prioritizeeggs))
    warn("[DEBUG] farmsettings.pet: " .. tostring(getgenv().farmsettings.pet))
    warn("[DEBUG] petKind: " .. tostring(petKind))
    
    -- Prioritize eggs if enabled
    if getgenv().farmsettings.prioritizeeggs then
        warn("[DEBUG] Prioritizing eggs enabled")
        
        -- First, check if we have any eggs
        local foundEgg = false
        local eggCount = 0
        for petId, petData in pairs(cd.get("inventory").pets) do
            if inventorydb.pets[petData.kind] and inventorydb.pets[petData.kind].is_egg then
                foundEgg = true
                eggCount = eggCount + 1
                warn("[DEBUG] Found egg: " .. tostring(inventorydb.pets[petData.kind].name) .. " (ID: " .. petId .. ")")
				if petKind ~= "" and petData.kind == petKind then
                	warn("[DEBUG] Returning matching egg: " .. petId)
                	return petId
				elseif petKind == "" then
					warn("[DEBUG] Returning any egg: " .. petId)
					return petId
				end
            end
        end
        
        warn("[DEBUG] Total eggs found: " .. eggCount)
        
        -- If no eggs found at all, try to buy Aztec Eggs
        if not foundEgg then
            warn("[DEBUG] No eggs found in inventory")
            
            if getgenv().farmsettings.pet and string.lower(getgenv().farmsettings.pet) == "aztec egg" then
                warn("[DEBUG] Aztec Egg specified, attempting to buy...")
                local bought = buyAztecEggs()
                
                if bought > 0 then
                    warn("[DEBUG] Successfully bought eggs, rechecking inventory...")
                    task.wait(2) -- Wait longer for inventory to update
                    
                    -- Check again for eggs after buying
                    for petId, petData in pairs(cd.get("inventory").pets) do
                        if inventorydb.pets[petData.kind] and inventorydb.pets[petData.kind].is_egg then
                            warn("[DEBUG] Found egg after buying: " .. tostring(inventorydb.pets[petData.kind].name) .. " (ID: " .. petId .. ")")
                            if inventorydb.pets[petData.kind].name and string.lower(inventorydb.pets[petData.kind].name) == "aztec egg" then
                                warn("[DEBUG] Found Aztec Egg after buying: " .. petId)
                                return petId
                            end
                        end
                    end
                    
                    -- If still no eggs, return any pet
                    warn("[DEBUG] No eggs found after buying, continuing to normal pet selection")
                else
                    warn("[DEBUG] Failed to buy eggs, disabling prioritizeeggs")
                    getgenv().farmsettings.prioritizeeggs = false
                end
            else
                warn("[DEBUG] No specific egg type or not Aztec Egg, disabling prioritizeeggs")
                getgenv().farmsettings.prioritizeeggs = false
            end
        end
    end
    
    warn("[DEBUG] Proceeding with normal pet selection")
    
    if #cd.get("inventory").pets == 1 then
		local singlePet = next(cd.get("inventory").pets)
		warn("[DEBUG] Only one pet available: " .. tostring(singlePet))
		return singlePet
	end
    
    -- Find highest age and friendship levels
    for _, petData in pairs(cd.get("inventory").pets) do
        if petData.properties and petData.properties.age and petData.properties.age > highestAge and petData.id ~= "practice_dog" then
            highestAge = petData.properties.age
        end
        if petData.properties and petData.properties.friendship_level and petData.properties.friendship_level > highestFriendship then
            highestFriendship = petData.properties.friendship_level
        end
    end
    
    warn("[DEBUG] Highest age: " .. highestAge .. ", Highest friendship: " .. highestFriendship)
    
    -- Select appropriate pet
    for petId, petData in pairs(cd.get("inventory").pets) do
        if petKind ~= "" and petData.kind == petKind then
            warn("[DEBUG] Found matching pet kind: " .. petId)
            return petId
        elseif petKind ~= "" and isPetOwner(petKind) then
            continue
        end
        
        if highestFriendship > 0 then
            if petData.properties and petData.properties.friendship_level == highestFriendship then
                warn("[DEBUG] Selecting pet with highest friendship: " .. petId)
                return petId
            else
                continue
            end
        end
        
        if petData.properties and petData.properties.age == 6 and not getgenv().farmsettings.switchpetsongrown and petData.id ~= "practice_dog" then
            warn("[DEBUG] Selecting fully grown pet: " .. petId)
            return petId
        elseif highestAge == 0 and petData.id ~= "practice_dog" then -- All pets full grown
            warn("[DEBUG] Selecting any pet (all grown): " .. petId)
            return petId
        elseif petData.properties and petData.properties.age == highestAge and petData.id ~= "practice_dog" then
            warn("[DEBUG] Selecting pet with highest age: " .. petId)
            return petId
        end
    end
    
    warn("[DEBUG] No suitable pet found, returning nil")
    return nil
end

local function getAilments(ailmentType, pet)
    if ailmentType == "baby" then
        return cd.get("ailments_manager").baby_ailments or {}
    else
        return cd.get("ailments_manager").ailments[pet] or {}
    end
end

local function getStrollerId()
    for strollerId, strollerData in pairs(cd.get("inventory").strollers) do
        if strollerData.kind == "stroller-default" then
            return strollerId
        end
    end
end

local function getPetChar(pet)
    local petEntities = debug.getupvalue(petentitymanager.get_pet_entity, 1)
    for char, entity in pairs(petEntities) do
        if entity.unique_id == pet.."-"..tostring(plr.UserId) then
            return char
        end
    end
end

local function useStroller(pet)
    router.get("ToolAPI/Equip"):InvokeServer(getStrollerId())
    if not plr.Character:WaitForChild("StrollerTool", 3) then
		useStroller(pet)
		return
	end
    local args = {
		plr,
        getPetChar(pet),
        plr.Character:WaitForChild("StrollerTool").ModelHandle.TouchToSits.TouchToSit
    }
    router.get("AdoptAPI/UseStroller"):InvokeServer(unpack(args))
end

local function unequipStroller(pet)
    router.get("AdoptAPI/EjectBaby"):FireServer(getPetChar(pet))
    router.get("ToolAPI/Unequip"):InvokeServer(getStrollerId())
end

local function randomMove()
    local rootPart = plr.Character:WaitForChild("HumanoidRootPart")
    plr.Character.Humanoid:MoveTo(rootPart.Position + Vector3.new(-10, 0, 0))
    task.wait(0.5)
    plr.Character.Humanoid:MoveTo(rootPart.Position + Vector3.new(10, 0, 0))
    task.wait(0.5)
    plr.Character.Humanoid:MoveTo(rootPart.Position)
end

local function resetPet(pet)
    router.get("ToolAPI/Unequip"):InvokeServer(pet)
    task.wait(0.1)
    router.get("ToolAPI/Equip"):InvokeServer(pet)
end

local function furnitureExists(kind, properties)
    for _, furniture in pairs(cd.get("house_interior").furniture) do
        if furniture.id == kind and furniture.cframe == properties.cframe then
            return true
        end
    end
    return false
end

local function buyFurnitureWithRetry(id, props)
    local args = {
        {
            {
                properties = props,
                kind = id
            }
        }
    }
    router.get("HousingAPI/BuyFurnitures"):InvokeServer(unpack(args))
    task.wait(0.1)
    if not furnitureExists(id, props) then
        warn("Couldn't buy furniture, retrying")
        buyFurnitureWithRetry(id, props)
    end
end	

local function getFurnitures()
    local furnitureIds = {
        "toilet",
        "modernshower",
        "ailments_refresh_2024_cheap_food_bowl",
        "ailments_refresh_2024_cheap_water_bowl",
        "cheapbathtub",
        "basiccrib",
		"lures_2023_normal_lure",
    }
    
    local furnitureToId = {}
    
    for _, furnitureId in ipairs(furnitureIds) do
        local found = false
        for furnitureDbId, furnitureData in pairs(cd.get("house_interior").furniture) do
            if furnitureData.id == furnitureId then
                furnitureToId[furnitureId] = furnitureDbId
                found = true
                break
            end
        end
        
        if not found then
            buyFurnitureWithRetry(furnitureId, {cframe = CFrame.new(0, 0, 0)})
            task.wait(0.1)
            for furnitureDbId, furnitureData in pairs(cd.get("house_interior").furniture) do
                if furnitureData.id == furnitureId then
                    furnitureToId[furnitureId] = furnitureDbId
                    found = true
                    break
                end
            end
        end
    end
    
    return furnitureToId
end
local function get_items_of_kind(kind, category)
	local items = {}
	for i,v in cd.get("inventory")[category] do
		if v.id == kind then
			table.insert(items, v)
		end
	end
	return items
end
local function getBoneId()
    for toyId, toyData in pairs(cd.get("inventory").toys) do
        if toyData.kind == "squeaky_bone_default" then
            return toyId
        end
    end
end

local function useBone()
    local args = {
        "__Enum_PetObjectCreatorType_1",
        {
            reaction_name = "ThrowToyReaction",
            unique_id = getBoneId()
        }
    }
    router.get("PetObjectAPI/CreatePetObject"):InvokeServer(unpack(args))
end

local function setupTeleportHook()
    local soaux = loadstring(game:HttpGet("https://raw.githubusercontent.com/0Void2391/Sulfoxide/refs/heads/main/soaux.lua"))()
    local constants = {
        "settings",
        "touch_to_enter",
        "destination_id",
        "current_location",
        "player_about_to_be_unanchored"
    }
    
    local func = soaux.searchClosure(ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM, 
                                    "unanchor_and_teleport_player_async", constants)
    
    local old
    old = hookfunction(func, function(var)
        if getgenv().teleport == false then
            return
        end
        return old(var)
    end)
end

local function loadInterior(interiorType, teleport, name)
    setthreadidentity(2)
    local interiors = Fsys.load("InteriorsM")
    local enter = interiors.enter
    
    getgenv().teleport = teleport
    
    if interiorType == "interior" then
		if not workspace.Interiors:GetChildren()[1] or not string.find(workspace.Interiors:GetChildren()[1].Name,name) then
			enter(name, "", {})
		end
    elseif interiorType == "house" then 
		if not workspace.HouseInteriors.blueprint:FindFirstChild(plr.Name) then
        	enter("housing", "MainDoor", {house_owner = name})
		end
    end
    
    setthreadidentity(8)
end

local function useFurniture(furniture, char)
    local furnitureToId = getFurnitures()
    local id = furnitureToId[furniture]
    local args = {
        plr,
        id,
        furniture == "toilet" and "Seat1" or "UseBlock",
        {
            cframe = plr.Character:WaitForChild("HumanoidRootPart").CFrame
        },
        char
    }
    router.get("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
end

local function heal()
    repeat task.wait() until cd.get("house_interior").furniture ~= nil
    for furnitureId, furnitureData in pairs(cd.get("house_interior").furniture) do
        if furnitureData.id == "doctor" then
            local args = {
                furnitureId,
                "UseBlock",
                "Yes",
                plr.Character
            }
            router.get("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))
        end
    end
end

local function refillFood()
    loadInterior("interior", false, "PizzaShop")
    task.wait(0.2)
    for _ = 1, 20 do
        local args = {
            "f-12",
            "Ham",
            nil,
            plr.Character
        }
        router.get("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))
    end
end

local function eatFood()
    local ham
    for foodId, foodData in pairs(cd.get("inventory").food) do
        if foodData.kind == "pizza_shop_ham" then
            ham = foodId
            break
        end
    end
    
    if not ham then
        refillFood()
        for foodId, foodData in pairs(cd.get("inventory").food) do
            if foodData.kind == "pizza_shop_ham" then
                ham = foodId
                break
            end
        end
    end
    
    router.get("ToolAPI/ServerUseTool"):FireServer(ham, "START")
    task.wait(0.5)
    router.get("ToolAPI/ServerUseTool"):FireServer(ham, "END")
    task.wait(0.5)
end

local function refillWater()
    loadInterior("interior", false, "PizzaShop")
    task.wait(0.2)
    for _ = 1, 20 do
        local args = {
            "f-90",
            "UseBlock",
            nil,
            plr.Character
        }
        router.get("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))
    end
end

local function drinkWater()
    local water
    for foodId, foodData in pairs(cd.get("inventory").food) do
        if foodData.kind == "water_paper_cup" then
            water = foodId
            break
        end
    end
    
    if not water then
        refillWater()
        for foodId, foodData in pairs(cd.get("inventory").food) do
            if foodData.kind == "water_paper_cup" then
                water = foodId
                break
            end
        end
    end
    
    router.get("ToolAPI/ServerUseTool"):FireServer(water, "START")
    task.wait(0.5)
    router.get("ToolAPI/ServerUseTool"):FireServer(water, "END")
    task.wait(0.5)
end

local function solveMysteryEnhanced(pet)
    -- Add safety checks
    if not cd.get("ailments_manager") or not cd.get("ailments_manager").ailments then 
        warn("[MYSTERY] No ailments manager found")
        return nil 
    end
    
    if not cd.get("ailments_manager").ailments[pet] then 
        warn("[MYSTERY] No ailments found for pet: " .. tostring(pet))
        return nil 
    end

    local success, result = pcall(function()
        setthreadidentity(2)
        local WeightedRandom = require(ReplicatedStorage.new.modules.Utilities.WeightedRandom)
        local LegacyLoad = require(ReplicatedStorage.new.modules.LegacyLoad)
        local CloudValues = LegacyLoad("CloudValues")
        local MysteryHelper = require(ReplicatedStorage.new.modules.Ailments.Helpers.MysteryHelper)
        
        local mystery = cd.get("ailments_manager").ailments[pet].mystery
        if not mystery or not mystery.components then 
            warn("[MYSTERY] No mystery data or components found")
            return nil 
        end
        
        warn("[MYSTERY] Mystery data found, processing...")
        
        local components = MysteryHelper.get_action(mystery)
        if not components or not components.options then
            warn("[MYSTERY] No components or options found")
            return nil
        end
        
        local seed = components.options.random_seed
        local get_ailment_slots = components.options.get_ailment_slots
        
        if not seed or not get_ailment_slots then
            warn("[MYSTERY] Missing seed or get_ailment_slots function")
            return nil
        end
        
        warn("[MYSTERY] Seed: " .. tostring(seed))
        
        local function get_slot_categories(v11)
            local zotti = CloudValues:getValue("ailments", "mysteryAilmentCategoryWeights")
            if not zotti then
                warn("[MYSTERY] No mystery ailment category weights found")
                return nil
            end
            return WeightedRandom.get_values(zotti, 3, v11)
        end
        
        local petTable = nil
        for _, v in pairs(getgc(true)) do
            if typeof(v) == "table" and rawget(v, "pet_id") and rawget(v, "player") == plr then
                petTable = v
                break
            end
        end
        
        if not petTable then
            warn("[MYSTERY] Could not find pet table in garbage collection")
            return nil
        end
        
        warn("[MYSTERY] Pet table found, solving...")
        
        local slots = get_slot_categories(seed)
        if not slots then
            warn("[MYSTERY] Failed to get slot categories")
            return nil
        end
        
        local toreturn = get_ailment_slots(seed, slots, petTable)
        warn("[MYSTERY] Mystery solved successfully!")
        return toreturn
    end)
    
    setthreadidentity(8)
    
    if not success then
        warn("[MYSTERY] Error solving mystery: " .. tostring(result))
        return nil
    end
    
    return result
end

local function antiAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for _, connection in pairs(getconnections(plr.Idled)) do
            if connection["Disable"] then
                connection["Disable"](connection)
            elseif connection["Disconnect"] then
                connection["Disconnect"](connection)
            end
        end
    else
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        plr.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end


local startAutoFarm
-- Ailment Handling
-- Fix for the waitForAilmentFinish function - this is likely where the syntax error is
local function waitForAilmentFinish(ailment, callback, ailmentType, pet)
    local started = tick()
    
    repeat 
        task.wait()
        if callback then 
            callback() 
        end
        
        local ailments = getAilments(ailmentType, pet)
        if not ailments[ailment] then
            break
        end
        
        if tick() - started >= 70 then
            print("[DEBUG] Too much time spent on task, restarting")
            task.spawn(startAutoFarm)
            repeat task.wait() until false -- This stops the current thread
        end
    until not getAilments(ailmentType, pet)[ailment]
end

local ailmentFunctions = {
["scale_the_organ"] = function(pet, ailmentType)
    local plr = game.Players.LocalPlayer

    loadInterior("interior", false, "MainMap!Fall")
    task.wait(0.5)

    -- YOUR 28 CAPTURED COORDINATES
    local step_positions = {
        Vector3.new(-335.31, 33.05, -1448.59), -- Step 1
        Vector3.new(-338.49, 34.48, -1447.55),
        Vector3.new(-343.19, 36.64, -1446.23),
        Vector3.new(-345.65, 38.63, -1442.83),
        Vector3.new(-349.2, 40.55, -1439.78),
        Vector3.new(-350.44, 42.8, -1435.09),
        Vector3.new(-351.23, 44.26, -1431.61),
        Vector3.new(-350.76, 46.42, -1426.64),
        Vector3.new(-348.43, 48.89, -1421.59),
        Vector3.new(-345.55, 50.33, -1419.6),
        Vector3.new(-341.97, 52.25, -1417.48),
        Vector3.new(-337.78, 54.32, -1415.81),
        Vector3.new(-333.76, 56.16, -1414.92),
        Vector3.new(-328.45, 58.66, -1415.77),
        Vector3.new(-324.91, 60.22, -1417),
        Vector3.new(-321.42, 62.31, -1420.06),
        Vector3.new(-319.07, 64.12, -1423.32),
        Vector3.new(-318.95, 65.77, -1426.79),
        Vector3.new(-318.72, 68.21, -1431.8),
        Vector3.new(-318.53, 70.24, -1436.03),
        Vector3.new(-319.19, 71.85, -1439.38),
        Vector3.new(-321.86, 74.05, -1443.46),
        Vector3.new(-325.87, 76.42, -1446.56),
        Vector3.new(-329.74, 78.31, -1448.4),
        Vector3.new(-333.65, 80.09, -1449.11),
        Vector3.new(-337.63, 82.19, -1446.86),
        Vector3.new(-341.83, 84.57, -1444.76),
        Vector3.new(-345.98, 86.8, -1442.68), 
        Vector3.new(-350.2, 89.1, -1440.5),
    }

    local character = plr.Character or plr.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local oldPos = rootPart.CFrame

    resetPet(pet)
    task.wait(0.5)

    -- Sequentially teleport up each step
    for _, position in ipairs(step_positions) do
        rootPart.CFrame = CFrame.new(position) + Vector3.new(0, 3, 0)
        task.wait(0.4) -- Wait 0.4 seconds between each step
    end

    task.wait(1) 
    
    -- Wait for the ailment to finish
    waitForAilmentFinish("scale_the_organ", nil, ailmentType, pet)
    
    -- Return to original spot
    rootPart.CFrame = oldPos
end,
    ["toilet"] = function(pet)
        loadInterior("house", false, plr)
        resetPet(pet)
        task.wait(0.2)
        task.spawn(useFurniture, "toilet", getPetChar(pet))
        waitForAilmentFinish("toilet", nil, "pet", pet)
    end,
    
    ["hungry"] = function(pet)
        loadInterior("house", false, plr)
        resetPet(pet)
        task.wait(0.2)
        task.spawn(useFurniture, "ailments_refresh_2024_cheap_food_bowl", getPetChar(pet))
        waitForAilmentFinish("hungry", nil, "pet", pet)
    end,
    
    ["sick"] = function(pet, ailmentType)
        loadInterior("interior", false, "Hospital")
        task.wait(0.5)
        heal()
        waitForAilmentFinish("sick", nil, ailmentType, pet)
    end,
    
    ["thirsty"] = function(pet)
        loadInterior("house", false, plr)
        resetPet(pet)
        task.wait(0.2)
        task.spawn(useFurniture, "ailments_refresh_2024_cheap_water_bowl", getPetChar(pet))
        waitForAilmentFinish("thirsty", nil, "pet", pet)
    end,
    
    ["sleepy"] = function(pet)
        loadInterior("house", false, plr)
        resetPet(pet)
        task.wait(0.2)
        task.spawn(useFurniture, "basiccrib", getPetChar(pet))
        waitForAilmentFinish("sleepy", nil, "pet", pet)
    end,
    
    ["camping"] = function(pet, ailmentType)
        loadInterior("interior", false, "MainMap")
		local oldPos = plr.Character:WaitForChild("HumanoidRootPart").CFrame
		local targetPos = workspace.StaticMap.Campsite.CampsiteOrigin.Position + Vector3.new(0, 3, 0)
		plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(targetPos)
        task.wait(0.2)
        resetPet(pet)
        waitForAilmentFinish("camping", nil, ailmentType, pet)
        plr.Character:WaitForChild("HumanoidRootPart").CFrame = oldPos
    end,
    
    ["bored"] = function(pet, ailmentType)
        loadInterior("interior", false, "MainMap")
		local oldPos = plr.Character:WaitForChild("HumanoidRootPart").CFrame
        local targetPos = workspace.StaticMap.Park.BoredAilmentTarget.Position + Vector3.new(0, 2, 0)
		plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(targetPos)
        task.wait(0.2)
        resetPet(pet)
        waitForAilmentFinish("bored", nil, ailmentType, pet)
        plr.Character:WaitForChild("HumanoidRootPart").CFrame = oldPos
    end,
    
    ["salon"] = function(pet, ailmentType)
        loadInterior("interior", false, "Salon")
        waitForAilmentFinish("salon", nil, ailmentType, pet)
    end,
    
    ["play"] = function(pet)
        resetPet(pet)
        waitForAilmentFinish("play", function() 
            useBone()
            task.wait(10.5) 
        end, "pet", pet)
    end,
    
    ["beach_party"] = function(pet, ailmentType)
        loadInterior("interior", false, "MainMap")
		local oldPos = plr.Character:WaitForChild("HumanoidRootPart").CFrame
        local targetPos = workspace.Interiors:FindFirstChildWhichIsA("Model").Buildings.BeachShop.Visual.BeachShopSetDressing:GetPivot().Position
		plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(targetPos)
        task.wait(0.2)
        resetPet(pet)
        waitForAilmentFinish("beach_party", nil, ailmentType, pet)
        plr.Character:WaitForChild("HumanoidRootPart").CFrame = oldPos
    end,
    
    ["ride"] = function(pet)
        plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(100, 1002, 100)
        resetPet(pet)
        useStroller(pet)
        waitForAilmentFinish("ride", randomMove, "pet", pet)
        plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(100, 1002, 100)
        unequipStroller(pet)
    end,
    
    ["dirty"] = function(pet)
        loadInterior("house", false, plr)
        task.spawn(useFurniture, "modernshower", getPetChar(pet))
        waitForAilmentFinish("dirty", nil, "pet", pet)
        resetPet(pet)
    end,
    
    ["walk"] = function(pet)
		router.get("AdoptAPI/HoldBaby"):FireServer(
    		getPetChar(pet)
		)
        waitForAilmentFinish("walk", randomMove, "pet", pet)
		router.get("AdoptAPI/EjectBaby"):FireServer(
			getPetChar(pet)
		)
		plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(100, 1002, 100)
    end,
    
["pet_me"] = function(pet)
    plr.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(100, 1002, 100)
    resetPet(pet)
    task.wait(0.5)
    
    local petChar = getPetChar(pet)
    
    local function complete()
        if petChar and petChar:FindFirstChild("HumanoidRootPart") then
            local camera = workspace.CurrentCamera
            local petPos = petChar.HumanoidRootPart.Position
            local viewportPoint = camera:WorldToViewportPoint(petPos)
            
            -- Click the pet to focus
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendMouseButtonEvent(viewportPoint.X, viewportPoint.Y, 0, true, game, 1)
                task.wait(0.05)
                vim:SendMouseButtonEvent(viewportPoint.X, viewportPoint.Y, 0, false, game, 1)
            end)
            
            task.wait(0.3)
            router.get("AilmentsAPI/ProgressPetMeAilment"):FireServer(pet)
        end
    end
    
    waitForAilmentFinish("pet_me", complete, "pet", pet)
    
    -- Click the back button to unfocus
    task.wait(0.3)
    local success, err = pcall(function()
        local backButton = plr.PlayerGui.FocusPetApp.Frame.BackButton
        if backButton then
            warn("[pet_me] Clicking back button to unfocus")
            firesignal(backButton.MouseButton1Down)
            firesignal(backButton.MouseButton1Up)
            firesignal(backButton.MouseButton1Click)
        end
    end)
    
    if not success then
        warn("[pet_me] Failed to click back button: " .. tostring(err))
    end
end,
    
    ["school"] = function(pet, ailmentType)
        loadInterior("interior", false, "School")
        waitForAilmentFinish("school", nil, ailmentType, pet)
    end,
    
    ["mystery"] = function(pet)
        warn("[MYSTERY] Starting mystery task for pet: " .. tostring(pet))
        
        local solved = solveMysteryEnhanced(pet)
        
        if not solved then
            warn("[MYSTERY] Enhanced solver failed, skipping mystery ailment")
            return
        end
        
        warn("[MYSTERY] Solution found: " .. tostring(solved))
        
        -- Try each choice until one works
        for choice = 1, 3 do
            if solved[choice] then
                local success = pcall(function()
                    warn("[MYSTERY] Attempting choice " .. choice .. " with value: " .. tostring(solved[choice]))
                    router.get("AilmentsAPI/ChooseMysteryAilment"):FireServer(pet, "mystery", choice, solved[choice])
                end)
                
                if success then
                    warn("[MYSTERY] Successfully sent choice " .. choice)
                    break
                else
                    warn("[MYSTERY] Failed to send choice " .. choice .. ", trying next...")
                end
            end
        end
        
        waitForAilmentFinish("mystery", nil, "pet", pet)
        warn("[MYSTERY] Mystery task completed")
    end,
    
    -- MYSTERY AILMENT REMOVED - This was causing the script to get stuck
    -- ["mystery"] = function(pet)
    --     local solved = solveMystery(pet)
    --     local randomChoice = math.random(1, 3)
    --     router.get("AilmentsAPI/ChooseMysteryAilment"):FireServer(pet, "mystery", randomChoice, solved[randomChoice])
    --     waitForAilmentFinish("mystery", nil, "pet", pet)
    -- end,
    
    ["pizza_party"] = function(pet, ailmentType)
        loadInterior("interior", false, "PizzaShop")
        waitForAilmentFinish("pizza_party", nil, ailmentType, pet)
    end
}

local babyAilmentsFunctions = {
["scale_the_organ"] = function()
    -- Define the player locally for Delta/Exploit compatibility
    local plr = game.Players.LocalPlayer

    loadInterior("interior", false, "MainMap!Fall")
    task.wait(0.5)

    -- YOUR 28 CAPTURED COORDINATES
    local step_positions = {
        Vector3.new(-335.31, 33.05, -1448.59), -- Step 1
        Vector3.new(-338.49, 34.48, -1447.55),
        Vector3.new(-343.19, 36.64, -1446.23),
        Vector3.new(-345.65, 38.63, -1442.83),
        Vector3.new(-349.2, 40.55, -1439.78),
        Vector3.new(-350.44, 42.8, -1435.09),
        Vector3.new(-351.23, 44.26, -1431.61),
        Vector3.new(-350.76, 46.42, -1426.64),
        Vector3.new(-348.43, 48.89, -1421.59),
        Vector3.new(-345.55, 50.33, -1419.6),
        Vector3.new(-341.97, 52.25, -1417.48),
        Vector3.new(-337.78, 54.32, -1415.81),
        Vector3.new(-333.76, 56.16, -1414.92),
        Vector3.new(-328.45, 58.66, -1415.77),
        Vector3.new(-324.91, 60.22, -1417),
        Vector3.new(-321.42, 62.31, -1420.06),
        Vector3.new(-319.07, 64.12, -1423.32),
        Vector3.new(-318.95, 65.77, -1426.79),
        Vector3.new(-318.72, 68.21, -1431.8),
        Vector3.new(-318.53, 70.24, -1436.03),
        Vector3.new(-319.19, 71.85, -1439.38),
        Vector3.new(-321.86, 74.05, -1443.46),
        Vector3.new(-325.87, 76.42, -1446.56),
        Vector3.new(-329.74, 78.31, -1448.4),
        Vector3.new(-333.65, 80.09, -1449.11),
        Vector3.new(-337.63, 82.19, -1446.86),
        Vector3.new(-341.83, 84.57, -1444.76),
        Vector3.new(-345.98, 86.8, -1442.68), 
        Vector3.new(-350.2, 89.1, -1440.5),
    }

    local character = plr.Character or plr.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local oldPos = rootPart.CFrame

    -- Sequentially teleport up each step
    for _, position in ipairs(step_positions) do
        rootPart.CFrame = CFrame.new(position) + Vector3.new(0, 3, 0)
        task.wait(0.4) -- Wait 0.4 seconds between each step for animation
    end

    -- Call the required function to clear the ailment.
    -- The game sometimes registers the completion after a short wait at the top.
    task.wait(1) 
    
    -- Corrected ailment name and wait
    waitForAilmentFinish("scale_the_organ", nil, "baby")
    
    -- Return to original spot
    rootPart.CFrame = oldPos
end,
    ["hungry"] = function()
        waitForAilmentFinish("hungry", eatFood, "baby")
    end,
    
    ["thirsty"] = function()
        waitForAilmentFinish("thirsty", drinkWater, "baby")
    end,
    
    ["sleepy"] = function()
        loadInterior("house", false, plr)
        task.spawn(useFurniture, "basiccrib", plr.Character)
        waitForAilmentFinish("sleepy", nil, "baby")
        router.get("PetAPI/ExitFurnitureUseStates"):InvokeServer()
        router.get("AdoptAPI/ExitSeatStates"):FireServer()
    end,
    
    ["dirty"] = function()
        loadInterior("house", false, plr)
        task.spawn(useFurniture, "modernshower", plr.Character)
        waitForAilmentFinish("dirty", nil, "baby")
        router.get("PetAPI/ExitFurnitureUseStates"):InvokeServer()
        router.get("AdoptAPI/ExitSeatStates"):FireServer()
    end
}
local function handlelures()
	loadInterior("house", false, plr)
	getFurnitures()
	local bait = get_items_of_kind("ice_dimension_2025_shiver_cone_bait", "food")[1] or get_items_of_kind("ice_dimension_2025_ice_soup_bait", "food")[1]
	local lure = cd.get("house_interior").furniture[getFurnitures()["lures_2023_normal_lure"]]
	if lure.lure and lure.lure.finished and lure.lure.reward then
		router.get("HousingAPI/ActivateFurniture"):InvokeServer(
			plr,
			getFurnitures()["lures_2023_normal_lure"],
			"UseBlock",
			{
				bait_unique = nil
			},
			plr.Character
		)
	end
	if not lure.lure then 
		router.get("HousingAPI/ActivateFurniture"):InvokeServer(
			plr,
			getFurnitures()["lures_2023_normal_lure"],
			"UseBlock",
			{
				bait_unique = bait.unique
			},
			plr.Character
		)
	end
end
local function questhandler()
	local quests = cd.get("quest_manager").quests_cached
	for i,v in pairs(quests) do
		if v.steps_completed >= 1 then
			router.get("QuestAPI/ClaimQuest"):InvokeServer(
				i
			)
		end
	end
end
-- Main AutoFarm Function
-- Main AutoFarm Function
startAutoFarm = function()
    plr.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(100, 1002, 100)
    task.wait(0.4)
    
    local currentPetId = getPetId()
    local stickToPet = true -- Flag to stick with current pet
    resetPet(currentPetId)

    
    for i = 1, 17 do
		if not cd.get("daily_login_manager").claimed_star_rewards["reward_"..i] then
			router.get("DailyLoginAPI/ClaimStarReward"):InvokeServer("reward_"..i)
			break
		end
	end
	router.get("DailyLoginAPI/ClaimDailyReward"):InvokeServer()
    
    while task.wait() do
        -- Check if current pet is still valid and exists
        local petExists = false
        local currentPetData = nil
        
        for petId, petData in pairs(cd.get("inventory").pets) do
            if petId == currentPetId then
                petExists = true
                currentPetData = petData
                break
            end
        end
        
        -- Only switch pets if current pet doesn't exist OR if it's fully grown and we want to switch
        local shouldSwitchPet = false
        
        if not petExists then
            warn("[DEBUG] Current pet no longer exists, finding new one")
            shouldSwitchPet = true
        elseif currentPetData and currentPetData.properties then
            -- Check if pet is fully grown (age 6) and we want to switch on grown
            if currentPetData.properties.age == 6 and getgenv().farmsettings.switchpetsongrown then
                warn("[DEBUG] Pet is fully grown and switchpetsongrown is enabled")
                shouldSwitchPet = true
            end
            -- Check if it was an egg and is no longer an egg (hatched)
            if inventorydb.pets[currentPetData.kind] then
                local petInfo = inventorydb.pets[currentPetData.kind]
                if not petInfo.is_egg and getgenv().farmsettings.prioritizeeggs then
                    -- Pet hatched, look for another egg
                    warn("[DEBUG] Pet hatched from egg, looking for next egg")
                    shouldSwitchPet = true
                end
            end
            
            -- If prioritizeeggs is disabled, check if there's a higher age pet available
            if not getgenv().farmsettings.prioritizeeggs and currentPetData.properties.age then
                local currentAge = currentPetData.properties.age
                local highestAge = currentAge
                local higherAgePetExists = false
                
                -- Find the actual highest age among all pets
                for petId, petData in pairs(cd.get("inventory").pets) do
                    if petData.properties and petData.properties.age and petData.id ~= "practice_dog" then
                        if petData.properties.age > highestAge then
                            highestAge = petData.properties.age
                            higherAgePetExists = true
                        end
                    end
                end
                
                -- Only switch if there's a pet with significantly higher age (to avoid constant switching)
                if higherAgePetExists and highestAge > currentAge then
                    warn("[DEBUG] Found pet with higher age (" .. highestAge .. " vs " .. currentAge .. "), switching")
                    shouldSwitchPet = true
                end
            end
        end
        
        if shouldSwitchPet then
            local newPetId = getPetId()
            if newPetId and newPetId ~= currentPetId then
                warn("[DEBUG] Switching from pet " .. currentPetId .. " to " .. newPetId)
                resetPet(newPetId)
                currentPetId = newPetId
            elseif not newPetId then
                warn("[DEBUG] No suitable pet found, keeping current pet")
                router.get("ToolAPI/Equip"):InvokeServer(currentPetId)
            end
        else
            -- Stick with current pet, just make sure it's equipped
            router.get("ToolAPI/Equip"):InvokeServer(currentPetId)
        end
        
        -- Update pet info in GUI
        local petText = "Current pet: " .. getPetNameFromId(currentPetId)
        setthreadidentity(8)
        gui.Frame.Title.Pet.Text = petText

        questhandler()
        
        -- Handle pet ailments
        setthreadidentity(8)
        gui.Frame.Title.Task.Text = "Current task: None"
        for ailment, _ in pairs(getAilments("pet", currentPetId)) do
            task.wait(0.1)
            setthreadidentity(8)
            gui.Frame.Title.Task.Text = "Current task: " .. ailment
            ailmentFunctions[ailment](currentPetId, "pet")
            setthreadidentity(8)
            gui.Frame.Title.Task.Text = "Current task: None"
        end
        
        -- Handle baby ailments if enabled
        if getgenv().farmsettings.babyfarm then
            for ailment, _ in pairs(getAilments("baby")) do
                task.wait(0.1)
                setthreadidentity(8)
                gui.Frame.Title.Task.Text = "Current task: baby " .. ailment
                
                if not getAilments(currentPetId)[ailment] and not babyAilmentsFunctions[ailment] then
                    ailmentFunctions[ailment](nil, "baby")
                elseif babyAilmentsFunctions[ailment] then
                    babyAilmentsFunctions[ailment]()
                end
                
                setthreadidentity(8)
                gui.Frame.Title.Task.Text = "Current task: None"
            end
        end
        handlelures()
    end
end
-- GUI Update Functions
local function getPotions()
    local count = 0
    for _, foodData in pairs(cd.get("inventory").food) do
        if foodData.id == "pet_age_potion" then
            count = count + 1
        end
    end
    setthreadidentity(8)
    return count
end

local function updateGUI()
    local startTime = tick()
    local startPotions = getPotions()
    local startMoney = cd.get_data()[plr.Name].money
  
    
    while task.wait() do
		--sorry for this but this is the only way to make it not break
        setthreadidentity(8)
        gui.Frame.Title.Time.Text = "Time elapsed: " .. formatTime(tick() - startTime)
		gui.Frame.Title.Money.Text = "Money farmed: " .. (cd.get_data()[plr.Name].money - startMoney)
		gui.Frame.Title.Potions.Text = "Gained potions: " .. (getPotions() - startPotions)
		
		gui.Frame.Visible = getgenv().farmsettings.gui
    end
end
local function webhookpost()
    local starttime = tick()
    if getgenv().farmsettings.webhook ~= "" then
        while task.wait() do
            local content;
            if getgenv().farmsettings['webhook']['pingeveryone'] then
                content = "@everyone"
            end
            if getgenv().farmsettings['webhook']['discordid'] ~= nil then
                content = '<@' .. getgenv().farmsettings['webhook']['discordid'] .. ">"
            end
            if not content then
                content = ""
            end
            local data = {
                ["content"] = "",
                ["tts"] =  false,
                ["embeds"] = {
                    {
                    ["id"] = 652627557,
                    ["title"] = "Autofarm stats",
                    ["description"] = "Current stats about your account:\n",
                    ["color"] = 2326507,
                    ["footer"] = {
                        ["text"] = "made by 0_Void "
                    },
                    ["author"] = {
                        ["name"] = plr.Name,
                        ["url"] = "https://www.roblox.com/users/"..plr.UserId.."/profile",
                        ["icon_url"] = ""
                    },
                    ["thumbnail"] = {
                        ["url"] = ""
                    },
                    ["fields"] = {
                        {
                        ["id"] = 825972658,
                        ["name"] = "Money",
                        ["value"] = cd.get("money"),
                        ["inline"] = true
                     
                        },
                        {
                        ["id"] = 290093250,
                        ["name"] = "Age potions",
                        ["value"] = getPotions(),
                        ["inline"] = true
                        },
                        {
                        ["id"] = 964803333,
                        ["name"] =  "Time elapsed",
                        ["value"] = formatTime(tick()-starttime),
                        ["inline"] = true
                        },
                    }
                    }
                },
                ["components"] = {},
                ["actions"] =  {},
                ["username"] = "Autofarm stats",
                ["avatar_url"] = ""
                }
            local newdata = game:GetService("HttpService"):JSONEncode(data)
            
                local headers = {
                ["content-type"] = "application/json"
                }
            request = http_request or request or HttpPost or syn.request
            local abcdef = {Url = getgenv().farmsettings['webhook'], Body = newdata, Method = "POST", Headers = headers}
            request(abcdef)
            task.wait(300)
        end
    end
end
local function init()
	if getgenv().farmsettings.babyfarm then
		local TeamAPIChooseTeam = router.get("TeamAPI/ChooseTeam") -- RemoteFunction 
		TeamAPIChooseTeam:InvokeServer(
			"Babies",
			{
				dont_respawn = true,
				source_for_logging = "avatar_editor"
			}
		)
	end
    setupTeleportHook()
    local baseplate = Instance.new("Part")
    baseplate.Size = Vector3.new(100,2,100)
    baseplate.CFrame = CFrame.new(100,1000,100)
    baseplate.Parent = workspace
    baseplate.Anchored = true
    --[=[local gs = game:GetService 'GuiService'
    local teleportservice = cloneref(game:GetService("TeleportService"))
	queue_on_teleport([[
		getgenv().farmsettings = ]]..le(getgenv().farmsettings,{Prettify = true})..[[    
		loadstring(readfile("adoptmeautofarm.txt"))()
	]])
    gs.ErrorMessageChanged:connect(
        function()
        setthreadidentity(8)
            local error_type = gs:GetErrorType()
            if error_type == Enum.ConnectionError.DisconnectErrors then
                print('Detected disconnection! Reconnecting...')
                while task.wait(5) do
                    teleportservice:Teleport(game.PlaceId, plr)
                end
            end
            setthreadidentity(2)
    end)]=]
    getgenv().running = true
    antiAFK()
    task.spawn(updateGUI)
    task.spawn(webhookpost)
    task.spawn(autoClaimTreatBag)
    task.spawn(autoJoinPoller)
	if not (#get_items_of_kind("trade_license", "toys") > 0) then
		loadInterior("interior", true, "SafetyHub")
		router.get("SettingsAPI/SetBooleanFlag"):FireServer(
			"has_talked_to_trade_quest_npc",
			true
		)

		loadInterior("interior", true, "TradeLicenseZone")
		router.get("TradeAPI/BeginQuiz"):FireServer()
		repeat task.wait() until cd.get("trade_license_quiz_manager")
		for i = 1,3 do

			router.get("TradeAPI/AnswerQuizQuestion"):FireServer(
				cd.get("trade_license_quiz_manager").quiz[i].answer
			)
		end
	end
    startAutoFarm()
end
task.wait(7)
init()
