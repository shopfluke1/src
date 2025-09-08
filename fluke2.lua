-- โหลด Discord UI Library
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pndxvo/scr/main/ui.lua"))()
local win = DiscordLib:Window("Auto Restart")
local serv = win:Server("Main", "")
local ntfy = serv:Channel("Wave Control")

-- บริการที่จำเป็น
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ตัวแปรใช้งาน
local cw = ReplicatedStorage.Values.Waves.CurrentWave
local remoteRestart = ReplicatedStorage.Remote.Server.OnGame.RestartMatch
local voteRetryRemote = ReplicatedStorage.Remote.Server.OnGame.Voting.VoteRetry
local adventureModeEndRemote = ReplicatedStorage.Remote.AdventureModeEnd

-- สถานะ toggle
local bugEventEnabled = false
local autoRetryEnabled = false
local adventureModeEndEnabled = false

-- ✅ รีแมตช์เมื่อถึง Wave 2
ntfy:Toggle("Bug Event", false, function(state)
    bugEventEnabled = state
    if state then
        task.spawn(function()
            while bugEventEnabled do
                if cw.Value == 2 then
                    print("Wave 2/2 detected! Restarting match...")
                    remoteRestart:FireServer()
                    task.wait(2)
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ✅ Auto Vote Retry เมื่อจบเกม
ntfy:Toggle("Auto Retry", false, function(state)
    autoRetryEnabled = state
    if state then
        task.spawn(function()
            while autoRetryEnabled do
                if playerGui:FindFirstChild("GameEndedAnimationUI") then
                    print("Game ended detected! Sending VoteRetry...")
                    voteRetryRemote:FireServer()
                    task.wait(1)
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- ✅ กด Remote AdventureModeEnd (ส่ง false)
ntfy:Toggle("Adventure End Trigger", false, function(state)
    adventureModeEndEnabled = state
    if state then
        task.spawn(function()
            while adventureModeEndEnabled do
                print("Triggering AdventureModeEnd with false")
                adventureModeEndRemote:FireServer(false)
                task.wait(2) -- ป้องกัน spam เร็วเกินไป
            end
        end)
    end
end)
