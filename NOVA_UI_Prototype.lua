-- NOVA UI Prototype (Roblox LocalScript)
-- Standalone redesigned menu prototype inspired by the section names in the supplied script.
-- IMPORTANT: This is a UI-only prototype. Toggles and buttons update the interface only;
-- they are not connected to the original script's farming, stealing, hopping, or config logic.
-- Run as a LocalScript in a Roblox test place / your own experience.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("NOVA_UI_Prototype")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(13, 16, 25), panel = Color3.fromRGB(20, 24, 36), panel2 = Color3.fromRGB(27, 32, 47),
    line = Color3.fromRGB(43, 51, 72), text = Color3.fromRGB(239, 243, 255), muted = Color3.fromRGB(143, 154, 180),
    cyan = Color3.fromRGB(76, 220, 235), purple = Color3.fromRGB(153, 113, 255), green = Color3.fromRGB(90, 224, 157), red = Color3.fromRGB(255, 105, 126)
}
local function corner(obj, r) local x = Instance.new("UICorner"); x.CornerRadius = UDim.new(0, r or 10); x.Parent = obj end
local function stroke(obj, color, transparency, thickness)
    local x = Instance.new("UIStroke"); x.Color = color or C.line; x.Transparency = transparency or 0; x.Thickness = thickness or 1; x.Parent = obj
end
local function padding(obj, a, b, c, d)
    local x = Instance.new("UIPadding"); x.PaddingLeft = UDim.new(0, a or 0); x.PaddingTop = UDim.new(0, b or 0); x.PaddingRight = UDim.new(0, c or 0); x.PaddingBottom = UDim.new(0, d or 0); x.Parent = obj
end
local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1; l.Text = text; l.TextSize = size or 14
    l.TextColor3 = color or C.text; l.Font = font or Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center; l.Parent = parent; return l
end
local function button(parent, text, size, bg, fg)
    local b = Instance.new("TextButton"); b.AutoButtonColor = false; b.Text = text; b.TextSize = size or 13
    b.Font = Enum.Font.GothamMedium; b.TextColor3 = fg or C.text; b.BackgroundColor3 = bg or C.panel2; b.Parent = parent
    corner(b, 8); return b
end

local gui = Instance.new("ScreenGui")
gui.Name = "NOVA_UI_Prototype"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.Parent = playerGui

local main = Instance.new("Frame"); main.Name = "Main"; main.Size = UDim2.fromOffset(760, 500); main.Position = UDim2.new(0.5, -380, 0.5, -250)
main.BackgroundColor3 = C.bg; main.Parent = gui; corner(main, 16); stroke(main, C.line, 0.12, 1)
local scale = Instance.new("UIScale"); scale.Scale = 1; scale.Parent = main
local top = Instance.new("Frame"); top.Size = UDim2.new(1, 0, 0, 64); top.BackgroundColor3 = C.panel; top.Parent = main; corner(top, 16)
local topMask = Instance.new("Frame"); topMask.Size = UDim2.new(1, 0, 0, 18); topMask.Position = UDim2.new(0,0,1,-18); topMask.BackgroundColor3 = C.panel; topMask.BorderSizePixel = 0; topMask.Parent = top
local logo = Instance.new("Frame"); logo.Size = UDim2.fromOffset(36,36); logo.Position = UDim2.fromOffset(18,14); logo.BackgroundColor3 = C.cyan; logo.Parent = top; corner(logo, 11)
local logoText = label(logo, "N", 21, C.bg, Enum.Font.GothamBlack); logoText.Size = UDim2.fromScale(1,1); logoText.TextXAlignment = Enum.TextXAlignment.Center
local brand = label(top, "NOVA", 18, C.text, Enum.Font.GothamBold); brand.Position = UDim2.fromOffset(64,10); brand.Size = UDim2.fromOffset(100,24)
local sub = label(top, "CONTROL CENTER  /  UI PREVIEW", 9, C.muted, Enum.Font.GothamMedium); sub.Position = UDim2.fromOffset(65,34); sub.Size = UDim2.fromOffset(250,16)
local previewTag = label(top, "PROTOTYPE", 10, C.cyan, Enum.Font.GothamBold); previewTag.Size = UDim2.fromOffset(80,26); previewTag.Position = UDim2.new(1,-134,0,19); previewTag.TextXAlignment = Enum.TextXAlignment.Center; previewTag.BackgroundColor3 = Color3.fromRGB(24,57,68); previewTag.BackgroundTransparency = 0; corner(previewTag, 8)
local close = button(top, "×", 24, C.panel2, C.muted); close.Size = UDim2.fromOffset(30,30); close.Position = UDim2.new(1,-43,0,17)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local sidebar = Instance.new("Frame"); sidebar.Position = UDim2.fromOffset(14,78); sidebar.Size = UDim2.fromOffset(170,408); sidebar.BackgroundTransparency = 1; sidebar.Parent = main
local sideTitle = label(sidebar, "WORKSPACE", 10, C.muted, Enum.Font.GothamBold); sideTitle.Size = UDim2.new(1,0,0,20); sideTitle.Position = UDim2.fromOffset(10,0)
local nav = Instance.new("Frame"); nav.Position = UDim2.fromOffset(0,27); nav.Size = UDim2.new(1,0,0,250); nav.BackgroundTransparency = 1; nav.Parent = sidebar
local navLayout = Instance.new("UIListLayout"); navLayout.Padding = UDim.new(0,6); navLayout.SortOrder = Enum.SortOrder.LayoutOrder; navLayout.Parent = nav
local pages = {}
local activeTab = "Dashboard"
local content = Instance.new("Frame"); content.Position = UDim2.fromOffset(198,78); content.Size = UDim2.new(1,-212,1,-92); content.BackgroundTransparency = 1; content.Parent = main

local function makePage(name)
    local p = Instance.new("ScrollingFrame"); p.Name = name; p.Size = UDim2.fromScale(1,1); p.BackgroundTransparency = 1; p.BorderSizePixel = 0; p.ScrollBarThickness = 3; p.ScrollBarImageColor3 = C.cyan; p.CanvasSize = UDim2.new(); p.AutomaticCanvasSize = Enum.AutomaticSize.Y; p.Visible = false; p.Parent = content
    local lay = Instance.new("UIListLayout"); lay.Padding = UDim.new(0,11); lay.SortOrder = Enum.SortOrder.LayoutOrder; lay.Parent = p
    padding(p, 0, 0, 7, 8); pages[name] = p; return p
end
local function section(parent, title, desc)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,-4,0,desc and 58 or 42); f.BackgroundColor3 = C.panel; f.Parent = parent; corner(f, 10); stroke(f, C.line, 0.35)
    local t = label(f, title, 14, C.text, Enum.Font.GothamBold); t.Position = UDim2.fromOffset(13, desc and 8 or 0); t.Size = UDim2.new(1,-26,0,24)
    if desc then local d = label(f, desc, 10, C.muted); d.Position = UDim2.fromOffset(13,32); d.Size = UDim2.new(1,-26,0,16) end
    return f
end
local function card(parent, title, desc, height)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,-4,0,height or 60); f.BackgroundColor3 = C.panel; f.Parent = parent; corner(f, 10); stroke(f, C.line, 0.45)
    local t = label(f, title, 13, C.text, Enum.Font.GothamMedium); t.Position = UDim2.fromOffset(13, desc and 8 or 0); t.Size = UDim2.new(1,-105,0,24)
    if desc then local d = label(f, desc, 10, C.muted); d.Position = UDim2.fromOffset(13,32); d.Size = UDim2.new(1,-115,0,18) end
    return f
end
local function toggle(parent, title, desc, default)
    local f = card(parent, title, desc, 60); local state = default == true
    local t = button(f, state and "ON" or "OFF", 10, state and Color3.fromRGB(25,79,73) or C.panel2, state and C.green or C.muted)
    t.Size = UDim2.fromOffset(55,28); t.Position = UDim2.new(1,-68,0.5,-14)
    local function paint() t.Text = state and "ON" or "OFF"; t.BackgroundColor3 = state and Color3.fromRGB(25,79,73) or C.panel2; t.TextColor3 = state and C.green or C.muted end
    t.MouseButton1Click:Connect(function() state = not state; paint() end)
    return function() return state end
end
local function action(parent, title, desc, actionText, color)
    local f = card(parent, title, desc, 60); local b = button(f, actionText or "RUN", 11, color or Color3.fromRGB(29,55,70), C.cyan)
    b.Size = UDim2.fromOffset(76,29); b.Position = UDim2.new(1,-89,0.5,-14)
    b.MouseButton1Click:Connect(function() local oldText = b.Text; b.Text = "PREVIEW"; task.delay(1.2,function() if b.Parent then b.Text = oldText end end) end)
    return b
end

local dashboard = makePage("Dashboard")
section(dashboard, "Welcome back", "A cleaner workspace for your controls")
local stats = Instance.new("Frame"); stats.Size = UDim2.new(1,-4,0,88); stats.BackgroundTransparency = 1; stats.Parent = dashboard
local statsLayout = Instance.new("UIListLayout"); statsLayout.FillDirection = Enum.FillDirection.Horizontal; statsLayout.Padding = UDim.new(0,9); statsLayout.Parent = stats
for _, item in ipairs({{"01","Farm tools"},{"02","Hop options"},{"05","Quick bars"}}) do
    local s = Instance.new("Frame"); s.Size = UDim2.new(1/3,-6,1,0); s.BackgroundColor3 = C.panel; s.Parent = stats; corner(s,10); stroke(s,C.line,0.4)
    local n = label(s,item[1],24,C.cyan,Enum.Font.GothamBold); n.Position = UDim2.fromOffset(13,12); n.Size = UDim2.new(1,-20,0,30)
    local d = label(s,item[2],10,C.muted); d.Position = UDim2.fromOffset(13,49); d.Size = UDim2.new(1,-20,0,18)
end
section(dashboard, "Quick status", "Visual preview only — no game actions are connected")
toggle(dashboard,"Enable keybinds","Prototype toggle; no shortcuts are bound",false)
toggle(dashboard,"Show quick bars","Prototype toggle; no floating bars are created",true)
action(dashboard,"Interface check","Try the button interaction", "TEST UI")

local farm = makePage("Farm")
section(farm,"Farm controls","Layout preview for the original Farm section")
toggle(farm,"Auto Steal","UI switch only — not connected to game logic",false)
toggle(farm,"Auto Collect","UI switch only — not connected to game logic",false)
toggle(farm,"Auto Place Egg","UI switch only — not connected to game logic",false)
action(farm,"Steal value filter","Original-style setting placeholder", "EDIT")
action(farm,"Target egg filters","Original-style setting placeholder", "CONFIG")

local hop = makePage("Auto Hop")
section(hop,"Server discovery","Layout preview for egg-finding and hopping settings")
toggle(hop,"Enable Auto Hop","UI switch only — no server hopping occurs",false)
toggle(hop,"Until an egg matches","Example mode switch; not wired",false)
toggle(hop,"Steal then hop","Example mode switch; not wired",false)
action(hop,"Egg finder filters","Rarity, area, value and egg targets", "OPEN")
action(hop,"First hop delay","Placeholder for delay control", "SET")

local quick = makePage("Quick & Keys")
section(quick,"Quick access","Manage the appearance of shortcuts in this prototype")
toggle(quick,"Enable keybinds","Visual preference only",true)
toggle(quick,"Show quick bars","Visual preference only",true)
action(quick,"Visible quick bars","Quick Bar 1–5 selector placeholder", "SELECT")
action(quick,"Quick bar size","60%–200% size control placeholder", "ADJUST")
action(quick,"Reset keybinds","No actual keybinds are registered", "RESET", Color3.fromRGB(64,43,57))

local config = makePage("Config")
section(config,"Configuration center","Prototype controls; no settings are written to disk")
local nameCard = card(config,"Config name","Enter a name to preview config controls",76)
local nameBox = Instance.new("TextBox"); nameBox.Size = UDim2.new(0,150,0,30); nameBox.Position = UDim2.new(1,-164,0.5,-15); nameBox.BackgroundColor3 = C.panel2; nameBox.TextColor3 = C.text; nameBox.PlaceholderColor3 = C.muted; nameBox.PlaceholderText = "My Config"; nameBox.Text = ""; nameBox.TextSize = 11; nameBox.Font = Enum.Font.Gotham; nameBox.ClearTextOnFocus = false; nameBox.Parent = nameCard; corner(nameBox,7)
action(config,"Create config","UI preview — nothing is saved", "CREATE")
action(config,"Save config","UI preview — nothing is saved", "SAVE")
action(config,"Load config","UI preview — nothing is loaded", "LOAD")
action(config,"Export config","UI preview — no file is generated", "EXPORT")

local searchCard = Instance.new("Frame"); searchCard.Name = "Search"; searchCard.Position = UDim2.new(1,-360,0,18); searchCard.Size = UDim2.fromOffset(210,30); searchCard.BackgroundColor3 = C.panel2; searchCard.Parent = top; corner(searchCard,8)
local search = Instance.new("TextBox"); search.Size = UDim2.new(1,-18,1,0); search.Position = UDim2.fromOffset(9,0); search.BackgroundTransparency = 1; search.Text = ""; search.PlaceholderText = "Search sections..."; search.PlaceholderColor3 = C.muted; search.TextColor3 = C.text; search.TextSize = 11; search.Font = Enum.Font.Gotham; search.ClearTextOnFocus = false; search.Parent = searchCard

local navButtons = {}
local function showTab(name)
    activeTab = name
    for n,p in pairs(pages) do p.Visible = n == name end
    for n,b in pairs(navButtons) do
        local selected = n == name; b.BackgroundColor3 = selected and Color3.fromRGB(26,54,68) or C.panel
        b.TextColor3 = selected and C.cyan or C.muted
        local mark = b:FindFirstChild("Mark"); if mark then mark.BackgroundTransparency = selected and 0 or 1 end
    end
end
for i, name in ipairs({"Dashboard","Farm","Auto Hop","Quick & Keys","Config"}) do
    local b = button(nav,name,12,C.panel,C.muted); b.Size = UDim2.new(1,0,0,39); b.LayoutOrder = i; b.TextXAlignment = Enum.TextXAlignment.Left; padding(b,37,0,0,0)
    local mark = Instance.new("Frame"); mark.Name = "Mark"; mark.Size = UDim2.fromOffset(3,21); mark.Position = UDim2.fromOffset(8,9); mark.BackgroundColor3 = C.cyan; mark.BackgroundTransparency = 1; mark.Parent = b; corner(mark,3)
    local glyph = label(b,({Dashboard="⌂",Farm="✦",["Auto Hop"]="↗",["Quick & Keys"]="⌘",Config="⚙"})[name],16,C.muted,Enum.Font.GothamBold); glyph.Size = UDim2.fromOffset(22,30); glyph.Position = UDim2.fromOffset(10,4); glyph.TextXAlignment = Enum.TextXAlignment.Center
    navButtons[name] = b; b.MouseButton1Click:Connect(function() showTab(name) end)
end
local footer = Instance.new("Frame"); footer.Size = UDim2.new(1,0,0,67); footer.Position = UDim2.new(0,0,1,-67); footer.BackgroundColor3 = C.panel; footer.Parent = sidebar; corner(footer,10)
local dot = Instance.new("Frame"); dot.Size = UDim2.fromOffset(8,8); dot.Position = UDim2.fromOffset(12,15); dot.BackgroundColor3 = C.green; dot.Parent = footer; corner(dot,4)
local ft = label(footer,"UI PREVIEW",10,C.text,Enum.Font.GothamBold); ft.Position = UDim2.fromOffset(27,8); ft.Size = UDim2.fromOffset(110,20)
local fd = label(footer,"Local interface only",9,C.muted); fd.Position = UDim2.fromOffset(12,32); fd.Size = UDim2.fromOffset(145,18)

search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(search.Text)
    if q == "" then showTab(activeTab); return end
    -- Search navigates to the first section whose tab name matches the query.
    for name in pairs(pages) do
        if string.find(string.lower(name), q, 1, true) then showTab(name); return end
    end
end)

-- Drag window by the top bar.
local dragging, dragStart, startPos
 top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

showTab("Dashboard")
local camera = workspace.CurrentCamera
if camera then
    local function fit()
        local v = camera.ViewportSize
        scale.Scale = math.clamp(math.min(v.X/820, v.Y/550), 0.62, 1)
    end
    fit(); camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end
