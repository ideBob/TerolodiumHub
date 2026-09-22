local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

local ENV = (typeof(getgenv) == "function" and getgenv()) or _G
pcall(function()
if ENV.TerolodiumHubConnections then
for _, c in pairs(ENV.TerolodiumHubConnections) do pcall(function() c:Disconnect() end) end
end
ENV.TerolodiumHubConnections = {}
if ENV.TeroDrawings then for _, d in pairs(ENV.TeroDrawings) do pcall(function() d:Remove() end) end end
ENV.TeroDrawings = {}
local function wipe(p)
pcall(function()
local a = p:FindFirstChild("TerolodiumHub") if a then a:Destroy() end
local b = p:FindFirstChild("TerolodiumNotifs") if b then b:Destroy() end
end)
end
if typeof(gethui) == "function" then pcall(function() wipe(gethui()) end) end
pcall(function() wipe(game:GetService("CoreGui")) end)
local lp = Players.LocalPlayer
local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
if pg then wipe(pg) end
pcall(function()
for _, p in ipairs(Players:GetPlayers()) do
local ch = p.Character
local h = ch and ch:FindFirstChildOfClass("Humanoid")
if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end
end
end)
end)
ENV.TerolodiumRunId = (ENV.TerolodiumRunId or 0) + 1
local runId = ENV.TerolodiumRunId
ENV.TerolodiumHubLoaded = true

local lplr = Players.LocalPlayer
local executorName = "Unknown"
pcall(function()
if typeof(identifyexecutor) == "function" then local n,v = identifyexecutor() if n then executorName = tostring(n)..(v and " "..tostring(v) or "") end
elseif typeof(getexecutorname) == "function" then executorName = tostring(getexecutorname()) end
end)
local platformRaw = "Unknown"
pcall(function() platformRaw = tostring(UserInputService:GetPlatform()):gsub("Enum.Platform.","") end)
local deviceType = "Unknown"
pcall(function()
if UserInputService.VREnabled then deviceType = "VR"
elseif GuiService:IsTenFootInterface() then deviceType = "Console"
elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then deviceType = "Mobile"
elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then deviceType = "Console"
else deviceType = "PC" end
end)
local userName = lplr and lplr.Name or "Unknown"
local displayName = lplr and lplr.DisplayName or "Unknown"

local StarbornFont
local success = pcall(function()
if typeof(getcustomasset) ~= "function" then error("no getcustomasset") end
if not isfile("Starborn.ttf") then writefile("Starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf")) end
writefile("Starborn.json", HttpService:JSONEncode({name="Starborn",faces={{name="Regular",weight=400,style="normal",assetId=getcustomasset("Starborn.ttf")}}}))
StarbornFont = Font.new(getcustomasset("Starborn.json"))
end)
if not success then StarbornFont = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold) end

local function getUIParent()
local ok, hui = pcall(function() if typeof(gethui) == "function" then return gethui() end end)
if ok and hui then return hui end
return game:GetService("CoreGui")
end
local UIParent = getUIParent()
local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name="TerolodiumHub" ScreenGui.ResetOnSpawn=false ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling ScreenGui.Parent=UIParent
local NotifyGui = Instance.new("ScreenGui") NotifyGui.Name="TerolodiumNotifs" NotifyGui.ResetOnSpawn=false NotifyGui.IgnoreGuiInset=true NotifyGui.DisplayOrder=999 NotifyGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling NotifyGui.Parent=UIParent
local NotifHolder = Instance.new("Frame") NotifHolder.Size=UDim2.new(1,0,1,0) NotifHolder.BackgroundTransparency=1 NotifHolder.Parent=NotifyGui
local BOTTOM_PAD, NOTIF_H, NOTIF_GAP = 34, 50, 8
local activeNotifs = {}
local function notifTarget(i) return UDim2.new(1,-20,1,-BOTTOM_PAD-((i-1)*(NOTIF_H+NOTIF_GAP))) end
local function Notify(t, d, dur)
if runId ~= ENV.TerolodiumRunId then return end
dur = dur or 3
while #activeNotifs >= 4 do local o = table.remove(activeNotifs,1) if o and o.Parent then o:Destroy() end end
local target = notifTarget(#activeNotifs+1)
local N = Instance.new("CanvasGroup")
N.Size = UDim2.new(0,230,0,NOTIF_H) N.AnchorPoint = Vector2.new(1,1)
N.Position = target + UDim2.new(0,260,0,0)
N.BackgroundColor3 = Color3.fromRGB(0,0,0) N.BorderSizePixel = 0
N.ClipsDescendants = true N.GroupTransparency = 1 N.Parent = NotifHolder
local C = Instance.new("UICorner") C.CornerRadius = UDim.new(0,12) C.Parent = N
local S = Instance.new("UIStroke") S.Color = Color3.fromRGB(20,20,20) S.Thickness = 1.2 S.Parent = N
local T1 = Instance.new("TextLabel")
T1.Text = t T1.FontFace = StarbornFont T1.TextSize = 13
T1.TextColor3 = Color3.fromRGB(255,255,255) T1.BackgroundTransparency = 1
T1.TextXAlignment = Enum.TextXAlignment.Left T1.TextTruncate = Enum.TextTruncate.AtEnd
T1.Size = UDim2.new(1,-24,0,18) T1.Position = UDim2.new(0,12,0,5) T1.Parent = N
local T2 = Instance.new("TextLabel")
T2.Text = d T2.Font = Enum.Font.Gotham T2.TextSize = 11
T2.TextColor3 = Color3.fromRGB(180,180,180) T2.BackgroundTransparency = 1
T2.TextXAlignment = Enum.TextXAlignment.Left T2.TextWrapped = true
T2.Size = UDim2.new(1,-24,0,16) T2.Position = UDim2.new(0,12,0,25) T2.Parent = N
table.insert(activeNotifs, N)
TweenService:Create(N, TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {Position = target, GroupTransparency = 0}):Play()
task.delay(dur, function()
if runId ~= ENV.TerolodiumRunId then return end
if N.Parent then
TweenService:Create(N, TweenInfo.new(0.4,Enum.EasingStyle.Quad,Enum.EasingDirection.In), {Position = target + UDim2.new(0,260,0,0), GroupTransparency = 1}):Play()
task.wait(0.42)
for i,v in ipairs(activeNotifs) do if v == N then table.remove(activeNotifs,i) break end end
N:Destroy()
end
end)
end

local Main = Instance.new("Frame") Main.Size=UDim2.new(0,230,0,266) Main.Position=UDim2.new(0.5,-115,0.5,-133) Main.BackgroundColor3=Color3.fromRGB(0,0,0) Main.BorderSizePixel=0 Main.Active=true Main.ClipsDescendants=true Main.Parent=ScreenGui
local UICorner=Instance.new("UICorner") UICorner.CornerRadius=UDim.new(0,12) UICorner.Parent=Main
local UIStroke=Instance.new("UIStroke") UIStroke.Color=Color3.fromRGB(20,20,20) UIStroke.Thickness=1.2 UIStroke.Parent=Main
local Title=Instance.new("TextLabel") Title.Text="Terolodium Hub" Title.FontFace=StarbornFont Title.TextSize=16 Title.TextColor3=Color3.fromRGB(255,255,255) Title.BackgroundTransparency=1 Title.TextXAlignment=Enum.TextXAlignment.Left Title.TextTruncate=Enum.TextTruncate.AtEnd Title.Size=UDim2.new(1,-52,0,36) Title.Position=UDim2.new(0,12,0,0) Title.ZIndex=2 Title.Parent=Main
local MinimizeBtn=Instance.new("TextButton") MinimizeBtn.Text="-" MinimizeBtn.Font=Enum.Font.GothamBold MinimizeBtn.TextSize=18 MinimizeBtn.TextColor3=Color3.fromRGB(255,255,255) MinimizeBtn.BackgroundColor3=Color3.fromRGB(25,25,25) MinimizeBtn.BorderSizePixel=0 MinimizeBtn.AutoButtonColor=false MinimizeBtn.Size=UDim2.new(0,28,0,28) MinimizeBtn.AnchorPoint=Vector2.new(1,0.5) MinimizeBtn.Position=UDim2.new(1,-8,0,18) MinimizeBtn.ZIndex=2 MinimizeBtn.Parent=Main
local MinCorner=Instance.new("UICorner") MinCorner.CornerRadius=UDim.new(0,6) MinCorner.Parent=MinimizeBtn
local ClickSound=Instance.new("Sound") ClickSound.SoundId="rbxassetid://88442833509532" ClickSound.Volume=0.5 ClickSound.Parent=MinimizeBtn
pcall(function() ContentProvider:PreloadAsync({ClickSound}) end)

local EspRow=Instance.new("Frame") EspRow.BackgroundTransparency=1 EspRow.Size=UDim2.new(1,-24,0,32) EspRow.Position=UDim2.new(0,12,0,44) EspRow.ZIndex=2 EspRow.Parent=Main
local EspLabel=Instance.new("TextLabel") EspLabel.Text="Tero's Esp" EspLabel.FontFace=StarbornFont EspLabel.TextSize=13 EspLabel.TextColor3=Color3.fromRGB(255,255,255) EspLabel.BackgroundTransparency=1 EspLabel.TextXAlignment=Enum.TextXAlignment.Left EspLabel.Size=UDim2.new(1,-56,1,0) EspLabel.ZIndex=2 EspLabel.Parent=EspRow
local EspTrack=Instance.new("Frame") EspTrack.Size=UDim2.new(0,44,0,22) EspTrack.AnchorPoint=Vector2.new(1,0.5) EspTrack.Position=UDim2.new(1,0,0.5,0) EspTrack.BackgroundColor3=Color3.fromRGB(40,40,40) EspTrack.BorderSizePixel=0 EspTrack.ZIndex=2 EspTrack.Parent=EspRow
local EspTrackC=Instance.new("UICorner") EspTrackC.CornerRadius=UDim.new(1,0) EspTrackC.Parent=EspTrack
local EspKnob=Instance.new("Frame") EspKnob.Size=UDim2.new(0,18,0,18) EspKnob.Position=UDim2.new(0,2,0.5,0) EspKnob.AnchorPoint=Vector2.new(0,0.5) EspKnob.BackgroundColor3=Color3.fromRGB(255,255,255) EspKnob.BorderSizePixel=0 EspKnob.ZIndex=3 EspKnob.Parent=EspTrack
local EspKnobC=Instance.new("UICorner") EspKnobC.CornerRadius=UDim.new(1,0) EspKnobC.Parent=EspKnob
local EspHit=Instance.new("TextButton") EspHit.Text="" EspHit.BackgroundTransparency=1 EspHit.Size=UDim2.new(1,0,1,0) EspHit.ZIndex=4 EspHit.Parent=EspTrack
local EspSound=Instance.new("Sound") EspSound.SoundId="rbxassetid://88442833509532" EspSound.Volume=0.5 EspSound.Parent=EspTrack

local espCache, espRenderConn, espOn, nativeConns = {}, nil, false, {}
local function trackDraw(d) table.insert(ENV.TeroDrawings, d) return d end
local function stripNative(char)
local h = char and char:FindFirstChildOfClass("Humanoid")
if h then pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end) end
end
local function restoreAllNatives()
for _, p in ipairs(Players:GetPlayers()) do
if p.Character then
local h = p.Character:FindFirstChildOfClass("Humanoid")
if h then pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end) end
end
end
end
local function makeBox(p)
if espCache[p] then return espCache[p] end
local o = trackDraw(Drawing.new("Square")) o.Visible=false o.Color=Color3.fromRGB(0,0,0) o.Thickness=5 o.Transparency=1 o.Filled=false
local b = trackDraw(Drawing.new("Square")) b.Visible=false b.Color=Color3.fromRGB(255,255,255) b.Thickness=3 b.Transparency=1 b.Filled=false
local n = trackDraw(Drawing.new("Text")) n.Visible=false n.Color=Color3.fromRGB(255,255,255) n.Size=16 n.Center=true n.Outline=true n.Transparency=1 n.Text=""
local data = {Outline=o, Box=b, Name=n}
espCache[p] = data
return data
end
local function hideBox(d) d.Outline.Visible=false d.Box.Visible=false d.Name.Visible=false end
local function updatePlayer(player)
local data = makeBox(player)
local char = player.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
if not espOn or not char or not hum or not root or not cam or player == lplr or hum.Health <= 0 then
hideBox(data) return
end
local ok, cf, bsize = pcall(function() return char:GetBoundingBox() end)
if not ok or not cf or not bsize then hideBox(data) return end
local center = cf.Position
local topW = center + Vector3.new(0, bsize.Y/2 + 0.3, 0)
local botW = center - Vector3.new(0, bsize.Y/2 + 0.3, 0)
local t, tVis = cam:WorldToViewportPoint(topW)
local b, bVis = cam:WorldToViewportPoint(botW)
local c, cVis = cam:WorldToViewportPoint(center)
if not tVis or not bVis or not cVis or t.Z <= 0 or b.Z <= 0 or c.Z <= 0 then
hideBox(data) return
end
local height = math.clamp(b.Y - t.Y, 14, 600)
local width = math.clamp(height * math.clamp(bsize.X / math.max(bsize.Y, 0.001), 0.3, 0.8), 14, 400)
local left = math.clamp(c.X - width/2, 0, cam.ViewportSize.X - width)
local top = math.clamp((t.Y + b.Y)/2 - height/2, 20, cam.ViewportSize.Y - height)
data.Outline.Size = Vector2.new(width, height) data.Outline.Position = Vector2.new(left, top) data.Outline.Visible = true
data.Box.Size = Vector2.new(width, height) data.Box.Position = Vector2.new(left, top) data.Box.Visible = true
data.Name.Text = player.DisplayName
data.Name.Position = Vector2.new(math.clamp(c.X, 50, cam.ViewportSize.X - 50), top - 20)
data.Name.Visible = true
end
local function clearESP()
if espRenderConn then pcall(function() espRenderConn:Disconnect() end) espRenderConn = nil end
for _, c in ipairs(nativeConns) do pcall(function() c:Disconnect() end) end
nativeConns = {}
restoreAllNatives()
for _, d in pairs(espCache) do pcall(function() d.Outline:Remove() d.Box:Remove() d.Name:Remove() end) end
espCache = {}
end
table.insert(ENV.TerolodiumHubConnections, Players.PlayerRemoving:Connect(function(p)
local d = espCache[p]
if d then pcall(function() d.Outline:Remove() d.Box:Remove() d.Name:Remove() end) espCache[p] = nil end
end))
local function hookNatives()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= lplr then
if p.Character then stripNative(p.Character) end
local c = p.CharacterAdded:Connect(function(ch)
if not espOn then return end
task.wait(0.3) stripNative(ch)
end)
table.insert(nativeConns, c) table.insert(ENV.TerolodiumHubConnections, c)
end
end
local jc = Players.PlayerAdded:Connect(function(p)
if p.Character then stripNative(p.Character) end
local c = p.CharacterAdded:Connect(function(ch)
if not espOn then return end
task.wait(0.3) stripNative(ch)
end)
table.insert(nativeConns, c) table.insert(ENV.TerolodiumHubConnections, c)
end)
table.insert(nativeConns, jc) table.insert(ENV.TerolodiumHubConnections, jc)
end
local function setEsp(on)
espOn = on
pcall(function() EspSound:Play() end)
TweenService:Create(EspKnob,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position = on and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)}):Play()
TweenService:Create(EspTrack,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3 = on and Color3.fromRGB(0,200,120) or Color3.fromRGB(40,40,40)}):Play()
if on then
hookNatives()
if espRenderConn then pcall(function() espRenderConn:Disconnect() end) end
espRenderConn = RunService.RenderStepped:Connect(function()
if runId ~= ENV.TerolodiumRunId then return end
for _, p in ipairs(Players:GetPlayers()) do pcall(updatePlayer, p) end
end)
table.insert(ENV.TerolodiumHubConnections, espRenderConn)
Notify("Tero's Esp", "ESP: ON", 3)
else
clearESP()
Notify("Tero's Esp", "ESP: OFF", 3)
end
end
EspHit.MouseButton1Click:Connect(function() setEsp(not espOn) end)

-- Auto Fuse (SOON) - UI only, no logic yet
local FuseRow=Instance.new("Frame") FuseRow.BackgroundTransparency=1 FuseRow.Size=UDim2.new(1,-24,0,32) FuseRow.Position=UDim2.new(0,12,0,80) FuseRow.ZIndex=2 FuseRow.Parent=Main
local FuseLabel=Instance.new("TextLabel") FuseLabel.Text="Auto Fuse (SOON)" FuseLabel.FontFace=StarbornFont FuseLabel.TextSize=13 FuseLabel.TextColor3=Color3.fromRGB(255,255,255) FuseLabel.BackgroundTransparency=1 FuseLabel.TextXAlignment=Enum.TextXAlignment.Left FuseLabel.Size=UDim2.new(1,-56,1,0) FuseLabel.ZIndex=2 FuseLabel.Parent=FuseRow
local FuseTrack=Instance.new("Frame") FuseTrack.Size=UDim2.new(0,44,0,22) FuseTrack.AnchorPoint=Vector2.new(1,0.5) FuseTrack.Position=UDim2.new(1,0,0.5,0) FuseTrack.BackgroundColor3=Color3.fromRGB(40,40,40) FuseTrack.BorderSizePixel=0 FuseTrack.ZIndex=2 FuseTrack.Parent=FuseRow
local FuseTrackC=Instance.new("UICorner") FuseTrackC.CornerRadius=UDim.new(1,0) FuseTrackC.Parent=FuseTrack
local FuseKnob=Instance.new("Frame") FuseKnob.Size=UDim2.new(0,18,0,18) FuseKnob.Position=UDim2.new(0,2,0.5,0) FuseKnob.AnchorPoint=Vector2.new(0,0.5) FuseKnob.BackgroundColor3=Color3.fromRGB(255,255,255) FuseKnob.BorderSizePixel=0 FuseKnob.ZIndex=3 FuseKnob.Parent=FuseTrack
local FuseKnobC=Instance.new("UICorner") FuseKnobC.CornerRadius=UDim.new(1,0) FuseKnobC.Parent=FuseKnob
local FuseHit=Instance.new("TextButton") FuseHit.Text="" FuseHit.BackgroundTransparency=1 FuseHit.Size=UDim2.new(1,0,1,0) FuseHit.ZIndex=4 FuseHit.Parent=FuseTrack
local FuseSound=Instance.new("Sound") FuseSound.SoundId="rbxassetid://88442833509532" FuseSound.Volume=0.5 FuseSound.Parent=FuseTrack
local fuseOn=false
FuseHit.MouseButton1Click:Connect(function()
fuseOn = not fuseOn
pcall(function() FuseSound:Play() end)
TweenService:Create(FuseKnob,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position = fuseOn and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)}):Play()
TweenService:Create(FuseTrack,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3 = fuseOn and Color3.fromRGB(0,200,120) or Color3.fromRGB(40,40,40)}):Play()
end)

-- Tero's Loader: SmoothPlastic + Gray Sky FFlag for smoother rendering
local LoaderRow=Instance.new("Frame") LoaderRow.BackgroundTransparency=1 LoaderRow.Size=UDim2.new(1,-24,0,32) LoaderRow.Position=UDim2.new(0,12,0,116) LoaderRow.ZIndex=2 LoaderRow.Parent=Main
local LoaderLabel=Instance.new("TextLabel") LoaderLabel.Text="Tero's Loader" LoaderLabel.FontFace=StarbornFont LoaderLabel.TextSize=13 LoaderLabel.TextColor3=Color3.fromRGB(255,255,255) LoaderLabel.BackgroundTransparency=1 LoaderLabel.TextXAlignment=Enum.TextXAlignment.Left LoaderLabel.Size=UDim2.new(1,-56,1,0) LoaderLabel.ZIndex=2 LoaderLabel.Parent=LoaderRow
local LoaderTrack=Instance.new("Frame") LoaderTrack.Size=UDim2.new(0,44,0,22) LoaderTrack.AnchorPoint=Vector2.new(1,0.5) LoaderTrack.Position=UDim2.new(1,0,0.5,0) LoaderTrack.BackgroundColor3=Color3.fromRGB(40,40,40) LoaderTrack.BorderSizePixel=0 LoaderTrack.ZIndex=2 LoaderTrack.Parent=LoaderRow
local LoaderTrackC=Instance.new("UICorner") LoaderTrackC.CornerRadius=UDim.new(1,0) LoaderTrackC.Parent=LoaderTrack
local LoaderKnob=Instance.new("Frame") LoaderKnob.Size=UDim2.new(0,18,0,18) LoaderKnob.Position=UDim2.new(0,2,0.5,0) LoaderKnob.AnchorPoint=Vector2.new(0,0.5) LoaderKnob.BackgroundColor3=Color3.fromRGB(255,255,255) LoaderKnob.BorderSizePixel=0 LoaderKnob.ZIndex=3 LoaderKnob.Parent=LoaderTrack
local LoaderKnobC=Instance.new("UICorner") LoaderKnobC.CornerRadius=UDim.new(1,0) LoaderKnobC.Parent=LoaderKnob
local LoaderHit=Instance.new("TextButton") LoaderHit.Text="" LoaderHit.BackgroundTransparency=1 LoaderHit.Size=UDim2.new(1,0,1,0) LoaderHit.ZIndex=4 LoaderHit.Parent=LoaderTrack
local LoaderSound=Instance.new("Sound") LoaderSound.SoundId="rbxassetid://88442833509532" LoaderSound.Volume=0.5 LoaderSound.Parent=LoaderTrack
local loaderOn=false
local function applyLoader()
	-- Gray Sky FFlag
	pcall(function()
		if typeof(setfflag) == "function" then
			setfflag("FFlagDebugSkyGray", "True")
		elseif typeof(setfastflag) == "function" then
			setfastflag("FFlagDebugSkyGray", "True")
		end
	end)
	-- Change all BaseParts to SmoothPlastic for smoother rendering / FPS
	pcall(function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") and not v:IsA("Terrain") then
				pcall(function()
					v.Material = Enum.Material.SmoothPlastic
					v.CastShadow = false
				end)
			end
		end
	end)
	-- Also handle new parts that get added
	if not ENV.TeroLoaderDescConn then
		ENV.TeroLoaderDescConn = workspace.DescendantAdded:Connect(function(v)
			if not loaderOn then return end
			if v:IsA("BasePart") and not v:IsA("Terrain") then
				task.defer(function()
					pcall(function()
						v.Material = Enum.Material.SmoothPlastic
						v.CastShadow = false
					end)
				end)
			end
		end)
		table.insert(ENV.TerolodiumHubConnections, ENV.TeroLoaderDescConn)
	end
end
LoaderHit.MouseButton1Click:Connect(function()
	loaderOn = not loaderOn
	pcall(function() LoaderSound:Play() end)
	TweenService:Create(LoaderKnob,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position = loaderOn and UDim2.new(1,-20,0.5,0) or UDim2.new(0,2,0.5,0)}):Play()
	TweenService:Create(LoaderTrack,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3 = loaderOn and Color3.fromRGB(0,200,120) or Color3.fromRGB(40,40,40)}):Play()
	if loaderOn then
		applyLoader()
		Notify("Tero's Loader", "Loader: ON (SmoothPlastic + Gray Sky)", 3)
	else
		Notify("Tero's Loader", "Loader: OFF", 3)
	end
end)

local minimized=false
table.insert(ENV.TerolodiumHubConnections, MinimizeBtn.MouseButton1Click:Connect(function()
pcall(function() ClickSound:Play() end)
minimized = not minimized MinimizeBtn.Text = minimized and "+" or "-"
TweenService:Create(Main, minimized and TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In) or TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
{Size = minimized and UDim2.new(0,230,0,36) or UDim2.new(0,230,0,266)}):Play()
end))
local dragging=false local dragStart,startPos=nil,nil
table.insert(ENV.TerolodiumHubConnections, Main.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
if Main.AbsoluteSize.X < 50 then return end
if i.Position.Y>Main.AbsolutePosition.Y+36 then return end
dragging=true dragStart=i.Position startPos=Main.Position
end
end))
table.insert(ENV.TerolodiumHubConnections, Main.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end))
table.insert(ENV.TerolodiumHubConnections, UserInputService.InputChanged:Connect(function(i)
if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
local d=i.Position-dragStart Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
end
end))

Notify("Terolodium Hub","Executor: "..executorName,3)
task.delay(0.6,function()
if runId == ENV.TerolodiumRunId then
Notify(displayName.." (@"..userName..")","Device: "..deviceType.." ("..platformRaw..")",3)
end
end)
