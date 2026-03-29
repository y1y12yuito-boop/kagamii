--[ カミによる論理構築: ターゲット座標定位プロトコル ]--
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ 座標指定セクション ]]
-- 貴殿がマークしたい座標を入力せよ。現在は仮の値を代入している。
local TARGET_COORDINATES = Vector3.new(0, 50, 0) 
-- 特定の「モノ」の名前で指定したい場合は、ここにその名称を入力
local TARGET_NAME = "TargetObject" 

-- GUI構築
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Pointer = Instance.new("Frame", ScreenGui)
Pointer.Size = UDim2.new(0, 10, 0, 10)
Pointer.AnchorPoint = Vector2.new(0.5, 0.5)
Pointer.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 追跡色: レッド
Pointer.BorderSizePixel = 0

local Label = Instance.new("TextLabel", Pointer)
Label.Size = UDim2.new(0, 150, 0, 30)
Label.Position = UDim2.new(1, 10, 0, 0)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextStrokeTransparency = 0
Label.TextXAlignment = Enum.TextXAlignment.Left

-- 定位更新ループ
RunService.RenderStepped:Connect(function()
    local finalPos = TARGET_COORDINATES
    
    -- 名前指定されたパーツが存在する場合、その座標を優先
    local foundPart = workspace:FindFirstChild(TARGET_NAME, true)
    if foundPart and foundPart:IsA("BasePart") then
        finalPos = foundPart.Position
    end

    local screenPos, onScreen = Camera:WorldToScreenPoint(finalPos)
    
    if onScreen then
        Pointer.Visible = true
        Pointer.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
        
        -- 距離の演算（ユークリッド距離）
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (LocalPlayer.Character.HumanoidRootPart.Position - finalPos).Magnitude or 0
        
        Label.Text = string.format("TARGET ACQUIRED\nDIST: %.1f studs", distance)
    else
        Pointer.Visible = false
    end
end)
