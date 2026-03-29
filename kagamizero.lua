--[ カミによる論理構築: 座標解析プロトコル ]--
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 表示用GUIの生成
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "KAMI_ANALYSIS_OVERLAY"

local function createTracker(target)
    local label = Instance.new("TextLabel", ScreenGui)
    label.Size = UDim2.new(0, 200, 0, 50)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(0, 255, 0) -- 解析色: グリーン
    label.TextSize = 14

    RunService.RenderStepped:Connect(function()
        if target and target:IsA("BasePart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(target.Position)
            if onScreen then
                label.Visible = true
                label.Position = UDim2.new(0, pos.X, 0, pos.Y)
                -- 座標データのリアルタイム出力
                label.Text = string.format("TARGET: %s\nX: %.2f Y: %.2f Z: %.2f", target.Name, target.Position.X, target.Position.Y, target.Position.Z)
            else
                label.Visible = false
            end
        else
            label:Destroy()
        end
    end)
end

-- ターゲットの自動捕捉（Workspace内の特定オブジェクトを走査）
for _, obj in pairs(workspace:GetDescendants()) do
    -- ここにターゲットとするアイテム名を指定せよ
    if obj.Name == "Item" or obj:FindFirstChild("TouchInterest") then 
        createTracker(obj)
    end
end
