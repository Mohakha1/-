-- NOVA HUB | Fresh UI shell
-- A standalone Roblox UI shell. Visual controls are intentionally not connected
-- to game automation; connect them to legitimate in-experience functionality you own.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

-- Clean up a previous copy so rerunning the script won't stack menus.
pcall(function()
    local old = playerGui:FindFirstChild("NOVA_HUB_UI")
    if old then old:Destroy() end
end)
pcall(function()
    local old = CoreGui:FindFirstChild("NOVA_HUB_UI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NOVA_HUB_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local parented = pcall(function() gui.Parent = CoreGui end)
if not parented or not gui.Parent then gui.Parent = playerGui end

local C = {
    bg = Color3.fromRGB(13, 16, 25),
    panel = Color3.fromRGB(20, 24, 36),
    panel2 = Color3.fromRGB(27, 32, 47),
    stroke = Color3.fromRGB(52, 62, 85),
    text = Color3.fromRGB(239, 243, 255),
    muted = Color3.fromRGB(146, 157, 183),
    accent = Color3.fromRGB(105, 92, 255),
    accent2 = Color3.fromRGB(49, 199, 218),
    green = Color3.fromRGB(67, 205, 145),
}

local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(parent, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end
local function stroke(parent, color, thickness, transparency)
    create("UIStroke", {Color = color or C.stroke, Thickness = thickness or 1, Transparency = transparency or 0}, parent)
end
local function label(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1, Text = text, TextColor3 = color or C.text,
        Font = font or Enum.Font.Gotham, TextSize = size or 13,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 0, 22),
    }, parent)
end

local main = create("Frame", {
    Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(760, 485), BackgroundColor3 = C.bg, BorderSizePixel = 0,
}, gui)
corner(main, 16); stroke(main, C.stroke, 1, 0.1)
create("UISizeConstraint", {MinSize = Vector2.new(340, 300), MaxSize = Vector2.new(900, 620)}, main)

local top = create("Frame", {Name="TopBar", Size=UDim2.new(1,0,0,66), BackgroundColor3=C.panel, BorderSizePixel=0}, main)
corner(top, 16)
create("Frame", {Position=UDim2.new(0,0,1,-16), Size=UDim2.new(1,0,0,16), BackgroundColor3=C.panel, BorderSizePixel=0}, top)
local logo = create("Frame", {Position=UDim2.fromOffset(18,14), Size=UDim2.fromOffset(38,38), BackgroundColor3=C.accent, BorderSizePixel=0}, top)
corner(logo, 12)
label(logo, "N", 21, Color3.new(1,1,1), Enum.Font.GothamBlack).TextXAlignment = Enum.TextXAlignment.Center
local title = label(top, "NOVA HUB", 17, C.text, Enum.Font.GothamBold)
title.Position = UDim2.fromOffset(68, 10); title.Size = UDim2.new(0, 210, 0, 24)
local subtitle = label(top, "FRESH INTERFACE  •  BETA", 9, C.muted, Enum.Font.GothamMedium)
subtitle.Position = UDim2.fromOffset(69, 34); subtitle.Size = UDim2.new(0, 230, 0, 16)
local status = create("Frame", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-62,0.5,0), Size=UDim2.fromOffset(86,26), BackgroundColor3=Color3.fromRGB(24,53,49), BorderSizePixel=0}, top)
corner(status, 13)
local dot = create("Frame", {Position=UDim2.fromOffset(10,10), Size=UDim2.fromOffset(6,6), BackgroundColor3=C.green, BorderSizePixel=0}, status); corner(dot, 5)
local statText = label(status, "READY", 10, C.green, Enum.Font.GothamBold); statText.Position=UDim2.fromOffset(22,1); statText.Size=UDim2.new(1,-24,1,-2)
local close = create("TextButton", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-16,0.5,0), Size=UDim2.fromOffset(28,28), BackgroundColor3=C.panel2, Text="×", TextColor3=C.text, TextSize=22, Font=Enum.Font.Gotham, AutoButtonColor=true, BorderSizePixel=0}, top)
corner(close, 9)

local sidebar = create("Frame", {Position=UDim2.fromOffset(14,80), Size=UDim2.new(0,174,1,-94), BackgroundColor3=C.panel, BorderSizePixel=0}, main)
corner(sidebar, 13)
label(sidebar, "WORKSPACE", 10, C.muted, Enum.Font.GothamBold).Position = UDim2.fromOffset(14,13)
local nav = create("Frame", {Position=UDim2.fromOffset(8,39), Size=UDim2.new(1,-16,1,-48), BackgroundTransparency=1}, sidebar)
create("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder}, nav)

local content = create("Frame", {Position=UDim2.new(0,200,0,80), Size=UDim2.new(1,-214,1,-94), BackgroundTransparency=1}, main)
local pageTitle = label(content, "Dashboard", 20, C.text, Enum.Font.GothamBold); pageTitle.Size=UDim2.new(1,0,0,30)
local pageSub = label(content, "Your new menu is open.", 11, C.muted); pageSub.Position=UDim2.fromOffset(0,31); pageSub.Size=UDim2.new(1,0,0,20)
local pages = {}
local selected = nil

local function makePage(name)
    local page = create("ScrollingFrame", {
        Name=name, Position=UDim2.fromOffset(0,61), Size=UDim2.new(1,0,1,-61),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=3,
        ScrollBarImageColor3=C.accent, CanvasSize=UDim2.new(0,0,0,0), Visible=false,
    }, content)
    local list = create("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder}, page)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y+8)
    end)
    create("UIPadding", {PaddingBottom=UDim.new(0,8), PaddingRight=UDim.new(0,4)}, page)
    pages[name] = page
    return page
end

local function card(parent, height)
    local f = create("Frame", {Size=UDim2.new(1,-2,0,height or 74), BackgroundColor3=C.panel, BorderSizePixel=0}, parent)
    corner(f, 12); stroke(f, C.stroke, 1, 0.35)
    return f
end
local function addInfo(parent, heading, detail, order)
    local f = card(parent, 78); f.LayoutOrder=order or 1
    local h = label(f, heading, 14, C.text, Enum.Font.GothamBold); h.Position=UDim2.fromOffset(15,10); h.Size=UDim2.new(1,-30,0,22)
    local d = label(f, detail, 11, C.muted); d.Position=UDim2.fromOffset(15,35); d.Size=UDim2.new(1,-30,0,28); d.TextWrapped=true
end
local function addSwitch(parent, heading, detail, order)
    local f = card(parent, 72); f.LayoutOrder=order or 1
    local h = label(f, heading, 13, C.text, Enum.Font.GothamBold); h.Position=UDim2.fromOffset(14,9); h.Size=UDim2.new(1,-100,0,22)
    local d = label(f, detail, 10, C.muted); d.Position=UDim2.fromOffset(14,33); d.Size=UDim2.new(1,-100,0,24); d.TextWrapped=true
    local enabled = false
    local btn = create("TextButton", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-14,0.5,0), Size=UDim2.fromOffset(48,26), BackgroundColor3=C.panel2, Text="OFF", TextColor3=C.muted, TextSize=10, Font=Enum.Font.GothamBold, BorderSizePixel=0}, f)
    corner(btn, 9)
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "ON" or "OFF"
        btn.BackgroundColor3 = enabled and C.accent or C.panel2
        btn.TextColor3 = enabled and Color3.new(1,1,1) or C.muted
    end)
end

local dashboard = makePage("Dashboard")
local welcome = card(dashboard, 112); welcome.LayoutOrder=1
local welcomeTitle = label(welcome, "Welcome to NOVA", 18, C.text, Enum.Font.GothamBold); welcomeTitle.Position=UDim2.fromOffset(16,13); welcomeTitle.Size=UDim2.new(1,-32,0,28)
local welcomeDesc = label(welcome, "A clean, rebuilt interface with a compact sidebar and organized pages.", 12, C.muted); welcomeDesc.Position=UDim2.fromOffset(16,47); welcomeDesc.Size=UDim2.new(1,-32,0,44); welcomeDesc.TextWrapped=true
local grid = create("Frame", {Size=UDim2.new(1,-2,0,90), BackgroundTransparency=1, LayoutOrder=2}, dashboard)
local gridLayout = create("UIGridLayout", {CellSize=UDim2.new(0.5,-6,1,0), CellPadding=UDim2.fromOffset(10,0), SortOrder=Enum.SortOrder.LayoutOrder}, grid)
for i, item in ipairs({{"INTERFACE","Loaded"},{"SHORTCUT","RightShift"}}) do
    local f = create("Frame", {BackgroundColor3=C.panel, BorderSizePixel=0, LayoutOrder=i}, grid); corner(f,12); stroke(f,C.stroke,1,0.35)
    local a=label(f,item[1],9,C.muted,Enum.Font.GothamBold); a.Position=UDim2.fromOffset(13,12); a.Size=UDim2.new(1,-24,0,17)
    local b=label(f,item[2],15,C.text,Enum.Font.GothamBold); b.Position=UDim2.fromOffset(13,34); b.Size=UDim2.new(1,-24,0,25)
end
addInfo(dashboard, "Controls are visual placeholders", "The switches in this fresh shell only change their appearance. They are not connected to game automation.", 3)

local features = makePage("Features")
addSwitch(features, "Feature Toggle A", "Example switch for your own legitimate game features.", 1)
addSwitch(features, "Feature Toggle B", "A second working UI control placeholder.", 2)
addSwitch(features, "Feature Toggle C", "The switch state changes locally in this interface.", 3)

local settings = makePage("Settings")
addInfo(settings, "Menu controls", "Press RightShift to hide or show the menu. Use the close button to hide it too.", 1)
local accentCard = card(settings, 80); accentCard.LayoutOrder=2
local acTitle=label(accentCard,"Accent color",13,C.text,Enum.Font.GothamBold); acTitle.Position=UDim2.fromOffset(14,9); acTitle.Size=UDim2.new(1,-28,0,22)
local colors = {C.accent, C.accent2, Color3.fromRGB(255,100,135), Color3.fromRGB(255,176,76), C.green}
for i, color in ipairs(colors) do
    local swatch=create("TextButton", {Position=UDim2.fromOffset(14+(i-1)*36,42), Size=UDim2.fromOffset(26,24), BackgroundColor3=color, Text="", BorderSizePixel=0}, accentCard); corner(swatch,8)
    swatch.MouseButton1Click:Connect(function()
        C.accent=color; logo.BackgroundColor3=color; status.BackgroundColor3=Color3.fromRGB(24,53,49)
        for _, p in pairs(pages) do p.ScrollBarImageColor3=color end
        for _, obj in ipairs(nav:GetChildren()) do if obj:IsA("TextButton") and obj:GetAttribute("Selected") then obj.BackgroundColor3=color end end
    end)
end

local function selectPage(name)
    if selected == name then return end
    selected = name
    for key, page in pairs(pages) do page.Visible = key == name end
    pageTitle.Text = name
    pageSub.Text = ({Dashboard="Your new menu is open.", Features="Example controls for legitimate integrations.", Settings="Personalize the interface."})[name] or "NOVA HUB"
    for _, obj in ipairs(nav:GetChildren()) do
        if obj:IsA("TextButton") then
            local active = obj.Name == name
            obj:SetAttribute("Selected", active)
            obj.BackgroundColor3 = active and C.accent or C.panel
            obj.TextColor3 = active and C.text or C.muted
        end
    end
end
for i, name in ipairs({"Dashboard","Features","Settings"}) do
    local btn = create("TextButton", {Name=name, Size=UDim2.new(1,0,0,39), BackgroundColor3=C.panel, Text="   "..name, TextColor3=C.muted, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, BorderSizePixel=0, LayoutOrder=i}, nav)
    corner(btn,9)
    btn.MouseButton1Click:Connect(function() selectPage(name) end)
end
selectPage("Dashboard")

-- Drag the window from the header.
do
    local dragging, dragStart, startPos = false, nil, nil
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end

local visible = true
local function setVisible(value)
    visible = value
    main.Visible = value
end
close.MouseButton1Click:Connect(function() setVisible(false) end)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then setVisible(not visible) end
end)

print("[NOVA HUB] UI loaded. Press RightShift to toggle the menu.")
