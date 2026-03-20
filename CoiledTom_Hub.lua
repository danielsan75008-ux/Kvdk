--[[
╔═══════════════════════════════════════════════════════╗
║            CoiledTom Hub  |  WindUI v2               ║
║   ESP Box2D + Chams + Tracers + Distance + Health     ║
║   Anti-AFK · Anti-Kick · Anti-Void · Performance     ║
║              PC & Mobile Ready                        ║
╚═══════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════
--  LOAD WindUI v2
-- ═══════════════════════════════════
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ═══════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")
local PhysicsService   = game:GetService("PhysicsService")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera

-- ═══════════════════════════════════
--  ESTADO GLOBAL
-- ═══════════════════════════════════
local State = {
    TouchFling    = false,
    AntiFling     = false,
    GodMode       = false,
    _godConn      = nil,
    AntiVoid      = false,
    AntiStun      = false,
    DeleteRagdoll = false,
    AutoRejoin    = false,
    AntiAFK       = false,
    AntiKick      = false,
    WalkSpeed     = 16,
    JumpPower     = 50,
    SpeedEnabled  = false,
    JumpEnabled   = false,
    InfiniteJump  = false,
    AimbotEnabled = false,
    TeamCheck     = false,
    AimbotFOV     = 120,
    AimbotSmooth  = 5,
    ESPEnabled    = false,
    ESPColor      = Color3.fromRGB(255, 50, 50),
    ESPFill       = false,
    ESPFillAlpha  = 0.15,
    ChamEnabled   = false,
    ChamColor     = Color3.fromRGB(255, 100, 0),
    TracerEnabled = false,
    TracerColor   = Color3.fromRGB(0, 255, 128),
    DistESP       = false,
    HealthESP     = false,
    HitboxEnabled = false,
    HitboxSize    = 5,
    HitboxAlpha   = 1,
    HitboxPart    = "HumanoidRootPart",
    AntiLag          = false,
    FPSBoost         = false,
    DisableParticles = false,
    TextureLow       = false,
    RemoveDecals     = false,
    DynRender        = false,
    EntityLimiter    = false,
    LightingClean    = false,
    LowPoly          = false,
}

-- ═══════════════════════════════════
--  HELPERS
-- ═══════════════════════════════════
local function getChar()
    return LocalPlayer.Character
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function isEnemy(p)
    if not State.TeamCheck then return true end
    return p.Team ~= LocalPlayer.Team
end

-- ═══════════════════════════════════
--  WINDOW
-- ═══════════════════════════════════
local Window = WindUI:CreateWindow({
    Title       = "CoiledTom Hub",
    Icon        = "solar:planet-bold",
    Author      = "by CoiledTom",
    Folder      = "CoiledTomHub",
    Size        = UDim2.fromOffset(600, 500),
    Theme       = "Dark",
    Transparent = true,
})

-- ═══════════════════════════════════
--  TABS
-- ═══════════════════════════════════
local TabLogs    = Window:Tab({ Title = "Logs",       Icon = "solar:document-text-bold"  })
local TabUseful  = Window:Tab({ Title = "Useful",     Icon = "solar:bomb-bold"           })
local TabScripts = Window:Tab({ Title = "Scripts",    Icon = "solar:code-square-bold"    })
local TabPlayer  = Window:Tab({ Title = "Player",     Icon = "solar:running-round-bold"  })
local TabCombat  = Window:Tab({ Title = "Combat",     Icon = "solar:target-bold"         })
local TabPerf    = Window:Tab({ Title = "Desempenho", Icon = "solar:cpu-bolt-bold"       })
local TabSettings= Window:Tab({ Title = "Settings",   Icon = "solar:settings-bold"       })

-- ══════════════════════════════════════════════════════
--  ABA: LOGS
-- ══════════════════════════════════════════════════════
do
    TabLogs:Section({ Title = "💬 Suporte" })

    TabLogs:Section({
        Title = "Aqui está o Discord caso ache um bug ou erro:",
    })

    TabLogs:Button({
        Title = "Copiar link do Discord",
        Desc  = "discord.gg/xzHe9QeqVv",
        Icon  = "link",
        Callback = function()
            setclipboard("https://discord.gg/xzHe9QeqVv")
            WindUI:Notify({
                Title    = "Discord",
                Content  = "Link copiado! discord.gg/xzHe9QeqVv",
                Duration = 3,
            })
        end,
    })

    TabLogs:Section({ Title = "📋 Histórico de Atualizações" })

    local changelog = {
        {
            ver   = "v4.0  —  Hitbox & Player Update",
            items = {
                "[\\] Hitbox funciona de dentro e de fora",
                "[\\] Hitbox nao trava players nem colide",
                "[\\] CanCollide=false + Massless=true nas parts",
                "[\\] CollisionGroup isolado anti-colisao",
                "[\\] Transparencia controla visibilidade real",
                "[\\] Logs reformatado com [\\ + -]",
                "[+] Noclip na aba Player",
                "[+] Fly na aba Player",
            },
        },
        {
            ver   = "v3.0  —  Mega Update",
            items = {
                "[+] Nome: CoiledTom Hub",
                "[+] Aba Logs com Discord + changelog",
                "[+] WindUI v2 (latest release)",
                "[+] Anti-AFK, Anti-Kick / Anti-Ban",
                "[+] God Mode (vida infinita)",
                "[+] Chams, Tracers, Distance ESP, Health ESP",
                "[+] Anti-Void, Anti-Stun, Delete Ragdoll",
                "[+] Auto Rejoin, Server Hopper inteligente",
                "[+] Aba Desempenho — 9 toggles",
                "[\\] ESP Box 2D mais preciso",
                "[\\] Compatibilidade mobile melhorada",
            },
        },
        {
            ver   = "v2.0",
            items = {
                "[+] ESP Box 2D com Drawing API",
                "[+] Aimbot com FOV Circle",
                "[+] Hitbox Expander com fill",
            },
        },
        {
            ver   = "v1.0  —  Lancamento",
            items = {
                "[+] Hub base com WindUI",
                "[+] WalkSpeed / JumpPower / InfiniteJump",
                "[+] Tools e GUIs via loadstring",
            },
        },
    }

    for _, entry in ipairs(changelog) do
        TabLogs:Section({ Title = "🔖 " .. entry.ver })
        local txt = ""
        for _, item in ipairs(entry.items) do
            txt = txt .. item .. "\n"
        end
        TabLogs:Section({ Title = txt })
    end
end

-- ══════════════════════════════════════════════════════
--  SISTEMAS
-- ══════════════════════════════════════════════════════

-- Noclip
local noclipConn = nil
local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end)
end
local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    -- Restaura colisão
    local char = getChar()
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = true
        end
    end
end

-- Fly
local flyConn    = nil
local flyBody    = nil
local flyGyro    = nil
local FLY_SPEED  = 50

local function startFly()
    if flyConn then return end
    local root = getRoot()
    if not root then return end

    flyBody = Instance.new("BodyVelocity")
    flyBody.Velocity  = Vector3.zero
    flyBody.MaxForce  = Vector3.new(1e5, 1e5, 1e5)
    flyBody.Parent    = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyGyro.D         = 100
    flyGyro.CFrame    = root.CFrame
    flyGyro.Parent    = root

    flyConn = RunService.RenderStepped:Connect(function()
        local r = getRoot()
        if not r or not flyBody or not flyBody.Parent then
            stopFly(); return
        end
        local cam = Camera
        local dir = Vector3.zero
        local cf  = cam.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - cf.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + cf.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            dir = dir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or
           UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir = dir - Vector3.new(0, 1, 0)
        end

        flyBody.Velocity = dir.Magnitude > 0
            and dir.Unit * FLY_SPEED
            or Vector3.zero

        flyGyro.CFrame = cf
    end)
end
function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody and flyBody.Parent then flyBody:Destroy() end
    if flyGyro and flyGyro.Parent then flyGyro:Destroy() end
    flyBody = nil; flyGyro = nil
end
local touchConn = nil
local function startFling()
    if touchConn then return end
    touchConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p ~= root
               and (p.Position - root.Position).Magnitude < 5 then
                local bv    = Instance.new("BodyVelocity")
                bv.Velocity = (p.Position - root.Position).Unit * -500
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.P        = 1e9
                bv.Parent   = p
                game:GetService("Debris"):AddItem(bv, 0.1)
            end
        end
    end)
end
local function stopFling()
    if touchConn then touchConn:Disconnect(); touchConn = nil end
end

-- Anti-Fling
local antiFlingConn = nil
local function startAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart")
               and p.AssemblyLinearVelocity.Magnitude > 200 then
                p.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end
local function stopAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- God Mode
local function applyGodMode(hum)
    if State._godConn then State._godConn:Disconnect() end
    hum.MaxHealth = math.huge
    hum.Health    = math.huge
    State._godConn = hum.HealthChanged:Connect(function()
        if State.GodMode then hum.Health = math.huge end
    end)
end
local function removeGodMode(hum)
    if State._godConn then State._godConn:Disconnect(); State._godConn = nil end
    hum.MaxHealth = 100
    hum.Health    = 100
end

-- Anti-Void
local antiVoidConn = nil
local safePos      = Vector3.new(0, 50, 0)
local function startAntiVoid()
    if antiVoidConn then return end
    antiVoidConn = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        if not root then return end
        if root.Position.Y > -50 then
            safePos = root.Position
        else
            root.CFrame = CFrame.new(safePos)
        end
    end)
end
local function stopAntiVoid()
    if antiVoidConn then antiVoidConn:Disconnect(); antiVoidConn = nil end
end

-- Anti-Stun
local antiStunConn = nil
local function startAntiStun()
    if antiStunConn then return end
    antiStunConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if not hum then return end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Stunned
           or s == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end
local function stopAntiStun()
    if antiStunConn then antiStunConn:Disconnect(); antiStunConn = nil end
end

-- Delete Ragdoll
local function deleteRagdoll()
    local char = getChar()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint")
           or v.Name == "Ragdoll" or v.Name == "RagdollConstraint" then
            v:Destroy()
        end
    end
end

-- Anti-AFK
local antiAFKConn = nil
local function startAntiAFK()
    if antiAFKConn then return end
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Anti-AFK", Text = "Kick evitado!", Duration = 2,
                })
            end)
        end
    end)
    antiAFKConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true,  Enum.KeyCode.W, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    end)
end
local function stopAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn = nil end
end

-- Anti-Kick
local kickHooked = false
local function hookAntiKick()
    if kickHooked then return end
    kickHooked = true
    local mt = getrawmetatable and getrawmetatable(game)
    if not mt then return end
    local oldNC = mt.__namecall
    pcall(setreadonly, mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if method == "Kick" and self == LocalPlayer and State.AntiKick then
            WindUI:Notify({ Title="Anti-Kick", Content="Kick bloqueado!", Duration=3 })
            return
        end
        return oldNC(self, ...)
    end)
    pcall(setreadonly, mt, true)
end

-- Auto Rejoin
local function setupAutoRejoin()
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Failed and State.AutoRejoin then
            task.wait(3)
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId, game.JobId, LocalPlayer
            )
        end
    end)
end

-- Server Hopper
local hopperActive = false
local function startServerHop()
    if hopperActive then return end
    hopperActive = true
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/"
                .. game.PlaceId
                .. "/servers/Public?sortOrder=Asc&limit=25"
            ))
        end)
        if ok and data and data.data then
            local best, bestPing = nil, math.huge
            for _, s in ipairs(data.data) do
                local ping = s.ping or 9999
                if s.id ~= game.JobId and s.playing and s.maxPlayers
                   and s.playing < s.maxPlayers and ping < bestPing then
                    best = s; bestPing = ping
                end
            end
            if best then
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Conectando...", Duration = 3,
                })
                task.wait(2)
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId, best.id, LocalPlayer
                )
            else
                WindUI:Notify({
                    Title = "Server Hopper", Content = "Nenhum server melhor.", Duration = 3,
                })
            end
        end
        hopperActive = false
    end)
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ══════════════════════════════════════════════════════
--  PERFORMANCE
-- ══════════════════════════════════════════════════════
local removedDecals   = {}
local origMaterials   = {}
local dynConn         = nil
local entityConn      = nil

local function disableParticles(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke")
           or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not on
        end
    end
end

local function setTextureLow(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if on then
                origMaterials[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif origMaterials[v] then
                pcall(function() v.Material = origMaterials[v] end)
            end
        end
    end
end

local function removeDecals(on)
    if on then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                table.insert(removedDecals, { obj = v, par = v.Parent })
                v.Parent = nil
            end
        end
    else
        for _, e in ipairs(removedDecals) do
            pcall(function() e.obj.Parent = e.par end)
        end
        removedDecals = {}
    end
end

local function cleanLighting(on)
    if on then
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 1e6
        Lighting.FogStart      = 1e6
        Lighting.Brightness    = 2
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
               or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect")
               or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    else
        Lighting.GlobalShadows = true
        for _, v in ipairs(Lighting:GetChildren()) do
            pcall(function() v.Enabled = true end)
        end
    end
end

local function setLowPoly(on)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") then
            pcall(function() v.LODFactor = on and 0.25 or 1 end)
        end
    end
end

local function setDynRender(on)
    if dynConn then dynConn:Disconnect(); dynConn = nil end
    if on then
        dynConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                settings().Rendering.QualityLevel =
                    (LocalPlayer.NetworkPing or 0) > 0.15 and 1 or 5
            end)
        end)
    else
        pcall(function() settings().Rendering.QualityLevel = 5 end)
    end
end

local function setEntityLimiter(on)
    if entityConn then entityConn:Disconnect(); entityConn = nil end
    if on then
        entityConn = RunService.Heartbeat:Connect(function()
            local n = 0
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then
                    n = n + 1
                    if n > 80 then v:Destroy() end
                end
            end
        end)
    end
end

local function applyFPSBoost(on)
    pcall(function()
        settings().Rendering.QualityLevel = on and 1 or 5
    end)
    if on then cleanLighting(true); disableParticles(true) end
end

local function applyAntiLag(on)
    if on then
        pcall(function()
            settings().Physics.PhysicsEnvironmentalThrottle =
                Enum.EnviromentalPhysicsThrottle.Disabled
        end)
    end
end

-- ══════════════════════════════════════════════════════
--  ESP — Drawing Objects
-- ══════════════════════════════════════════════════════
local espObjects = {}

local function mkLine(col, thick)
    local l = Drawing.new("Line")
    l.Visible     = false
    l.Color       = col   or Color3.fromRGB(255, 50, 50)
    l.Thickness   = thick or 1.5
    pcall(function() l.AlwaysOnTop = true end)
    return l
end

local function mkText(size, col)
    local t = Drawing.new("Text")
    t.Visible  = false
    t.Size     = size or 14
    t.Outline  = true
    t.Color    = col or Color3.fromRGB(255, 255, 255)
    t.Text     = ""
    pcall(function() t.AlwaysOnTop = true end)
    return t
end

local function mkQuad()
    local q = Drawing.new("Quad")
    q.Visible      = false
    q.Filled       = true
    q.Color        = Color3.fromRGB(255, 50, 50)
    q.Transparency = 0.85
    pcall(function() q.AlwaysOnTop = true end)
    return q
end

-- Highlight: ESP nativo do Roblox que aparece ATRAVÉS de paredes
-- Funciona em qualquer executor sem Drawing API
local espHighlights = {}  -- [player] = Highlight

local function removeHighlight(player)
    if espHighlights[player] then
        pcall(function() espHighlights[player]:Destroy() end)
        espHighlights[player] = nil
    end
end

local function applyHighlight(player)
    removeHighlight(player)
    if not State.ESPEnabled then return end
    local char = player.Character
    if not char then return end
    local hl = Instance.new("Highlight")
    hl.Adornee          = char
    hl.FillColor        = State.ESPColor
    hl.OutlineColor     = State.ESPColor
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent           = char
    espHighlights[player] = hl
end

local function cleanESP(player)
    local o = espObjects[player]
    if not o then return end
    for _, l in ipairs(o.lines) do l:Remove() end
    o.label:Remove(); o.fill:Remove()
    o.tracer:Remove(); o.dist:Remove()
    o.hpBg:Remove();  o.hpBar:Remove()
    for _, sb in ipairs(o.chams) do
        pcall(function() sb:Destroy() end)
    end
    espObjects[player] = nil
    removeHighlight(player)
end

local function buildESP(player)
    cleanESP(player)
    local lines = {}
    for _ = 1, 4 do table.insert(lines, mkLine()) end
    espObjects[player] = {
        lines  = lines,
        label  = mkText(14),
        fill   = mkQuad(),
        tracer = mkLine(State.TracerColor, 1.5),
        dist   = mkText(12, Color3.fromRGB(255, 220, 80)),
        hpBg   = mkLine(Color3.fromRGB(40, 40, 40), 4),
        hpBar  = mkLine(Color3.fromRGB(0, 220, 80),  4),
        chams  = {},
    }
end

local function applyCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
    local char = player.Character
    if not char then return end
    local sb = Instance.new("SelectionBox")
    sb.Color3              = State.ChamColor
    sb.LineThickness       = 0.05
    sb.SurfaceColor3       = State.ChamColor
    sb.SurfaceTransparency = 0.5
    sb.Adornee             = char
    sb.Parent              = workspace
    table.insert(o.chams, sb)
end

local function removeCham(player)
    local o = espObjects[player]
    if not o then return end
    for _, sb in ipairs(o.chams) do pcall(function() sb:Destroy() end) end
    o.chams = {}
end

-- Calcula bounding box 2D universal — funciona em R6, R15 e custom rigs
-- Ignora parts expandidas pelo hitbox (Transparency = 1 E Size > 4)
local function getBox(char)
    local parts = {}

    -- Pega apenas parts ORIGINAIS do personagem (não hitbox expandidas)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            -- Ignora parts que o hitbox expandiu (ficam com Transparency=1)
            -- mas mantém parts originalmente transparentes do personagem
            local isHitboxExpanded = (v.Transparency >= 1 and
                                      v.Size.X > 4 and
                                      v.Size.Y > 4)
            if not isHitboxExpanded then
                table.insert(parts, v)
            end
        end
    end

    if #parts == 0 then
        -- fallback: pega tudo
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then table.insert(parts, v) end
        end
    end
    if #parts == 0 then return nil end

    -- Projeta todos os 8 cantos de cada part (funciona com rotações)
    local minX, minY =  math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyVisible = false

    for _, part in ipairs(parts) do
        local sz = part.Size * 0.5
        local cf = part.CFrame
        local corners = {
            cf * Vector3.new( sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y,  sz.Z),
            cf * Vector3.new( sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y,  sz.Z),
            cf * Vector3.new( sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X,  sz.Y, -sz.Z),
            cf * Vector3.new( sz.X, -sz.Y, -sz.Z),
            cf * Vector3.new(-sz.X, -sz.Y, -sz.Z),
        }
        for _, corner in ipairs(corners) do
            local sp = Camera:WorldToViewportPoint(corner)
            -- sp.Z > 0 = na frente da câmera (inclui atrás de paredes)
            if sp.Z > 0 then
                anyVisible = true
                if sp.X < minX then minX = sp.X end
                if sp.Y < minY then minY = sp.Y end
                if sp.X > maxX then maxX = sp.X end
                if sp.Y > maxY then maxY = sp.Y end
            end
        end
    end

    if not anyVisible then return nil end

    local pad = 2
    minX = minX - pad; minY = minY - pad
    maxX = maxX + pad; maxY = maxY + pad

    return {
        tl  = Vector2.new(minX, minY),
        tr  = Vector2.new(maxX, minY),
        br  = Vector2.new(maxX, maxY),
        bl  = Vector2.new(minX, maxY),
        cx  = (minX + maxX) / 2,
        top = minY,
        bot = maxY,
    }
end

-- ══════════════════════════════════════════════════════
--  HITBOX EXPANDER
--
--  Expande as parts ORIGINAIS do personagem inimigo.
--  O servidor conhece essas parts → dano funciona.
--  CanCollide = false em todas → não trava, não colide.
--  Transparency = 1 (invisível para você).
--  Restaura tudo ao desativar.
-- ══════════════════════════════════════════════════════
local hitboxData = {}
-- hitboxData[player] = {
--   entries = { {part, origSize, origCC, origTransp} },
--   conn    = RBXScriptConnection,
-- }

local function removeHitbox(player)
    local d = hitboxData[player]
    if not d then return end
    if d.conn then d.conn:Disconnect() end
    for _, e in ipairs(d.entries or {}) do
        pcall(function()
            if e.part and e.part.Parent then
                e.part.Size                      = e.origSize
                e.part.CanCollide                = e.origCC
                e.part.Massless                  = e.origMass
                e.part.LocalTransparencyModifier = e.origLTM or 0
            end
        end)
    end
    hitboxData[player] = nil
end

local function applyHitbox(player)
    if player == LocalPlayer then return end
    removeHitbox(player)

    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
             or char:FindFirstChild("Torso")
    if not hrp then return end

    local size = math.max(State.HitboxSize or 10, 1)

    local partNames = {
        "HumanoidRootPart","Head",
        "UpperTorso","LowerTorso","Torso",
        "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
        "LeftHand","RightHand",
        "LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg",
        "LeftFoot","RightFoot",
        "Left Arm","Right Arm","Left Leg","Right Leg",
    }

    local entries = {}

    for _, name in ipairs(partNames) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            pcall(function()
                table.insert(entries, {
                    part     = part,
                    origSize = part.Size,
                    origCC   = part.CanCollide,
                    origMass = part.Massless,
                    origLTM  = part.LocalTransparencyModifier,
                })
                part.Size         = Vector3.new(size, size, size)
                part.CanCollide   = false
                part.Massless     = true
                -- SEMPRE invisível para o cliente:
                -- as parts expandidas ficam escondidas, personagem animado
                -- continua visível através dos MeshParts/accessories que
                -- não foram expandidos
                part.LocalTransparencyModifier = 1
            end)
        end
    end

    if #entries == 0 then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                pcall(function()
                    table.insert(entries, {
                        part     = v,
                        origSize = v.Size,
                        origCC   = v.CanCollide,
                        origMass = v.Massless,
                        origLTM  = v.LocalTransparencyModifier,
                    })
                    v.Size         = Vector3.new(size, size, size)
                    v.CanCollide   = false
                    v.Massless     = true
                    v.LocalTransparencyModifier = 1
                end)
            end
        end
    end

    if #entries == 0 then return end

    local conn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then
            removeHitbox(player); return
        end
        local ns = math.max(State.HitboxSize or 10, 1)
        for _, e in ipairs(entries) do
            if e.part and e.part.Parent then
                e.part.CanCollide              = false
                e.part.Massless                = true
                e.part.LocalTransparencyModifier = 1
                if e.part.Size.X ~= ns then
                    e.part.Size = Vector3.new(ns, ns, ns)
                end
            end
        end
    end)

    hitboxData[player] = { entries = entries, conn = conn }
end

local function startHitboxSync() end
local function stopHitboxSync()  end

local function refreshHitboxes()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if State.HitboxEnabled then applyHitbox(pl)
        else removeHitbox(pl) end
    end
end

-- ══════════════════════════════════════════════════════
--  FOV CIRCLE + AIMBOT TARGET
-- ══════════════════════════════════════════════════════
local fovCircle     = Drawing.new("Circle")
fovCircle.Visible   = false
fovCircle.Radius    = State.AimbotFOV
fovCircle.Color     = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1.5
fovCircle.Filled    = false

local function getTarget()
    local best, bestD = nil, math.huge
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl == LocalPlayer then continue end
        if not isEnemy(pl) then continue end
        local ch = pl.Character
        if not ch then continue end
        local hd = ch:FindFirstChild("Head")
        if not hd then continue end
        local sp, on = Camera:WorldToViewportPoint(hd.Position)
        if not on then continue end
        local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
        if d < State.AimbotFOV and d < bestD then
            best = hd; bestD = d
        end
    end
    return best
end

-- ══════════════════════════════════════════════════════
--  RENDER LOOP
-- ══════════════════════════════════════════════════════
RunService.RenderStepped:Connect(function()
    local vcx = Camera.ViewportSize.X / 2
    local vcy = Camera.ViewportSize.Y / 2

    -- FOV circle
    fovCircle.Position = Vector2.new(vcx, vcy)
    fovCircle.Radius   = State.AimbotFOV
    fovCircle.Visible  = State.AimbotEnabled

    -- Aimbot
    if State.AimbotEnabled then
        local tgt = getTarget()
        if tgt then
            local alpha = 1 / (State.AimbotSmooth + 1)
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.lookAt(Camera.CFrame.Position, tgt.Position), alpha
            )
        end
    end

    -- ESP loop
    local bottomY = Camera.ViewportSize.Y
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        -- Se não tem objeto ESP, cria automaticamente
        if not espObjects[player] then
            buildESP(player)
        end

        local o = espObjects[player]
        if not o then continue end

        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart")
                           or char:FindFirstChildWhichIsA("BasePart"))
        local anyOn = State.ESPEnabled or State.TracerEnabled
                   or State.DistESP   or State.HealthESP

        if not char or not root or not anyOn then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local box = getBox(char)
        if not box then
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible   = false
            o.tracer.Visible= false; o.dist.Visible   = false
            o.hpBg.Visible  = false; o.hpBar.Visible  = false
            continue
        end

        local col = State.ESPColor

        -- Box
        if State.ESPEnabled then
            local corners = { box.tl, box.tr, box.br, box.bl }
            for i = 1, 4 do
                o.lines[i].From    = corners[i]
                o.lines[i].To      = corners[(i % 4) + 1]
                o.lines[i].Color   = col
                o.lines[i].Visible = true
            end
            o.label.Text     = player.Name
            o.label.Color    = col
            o.label.Position = Vector2.new(box.cx, box.top - 16)
            o.label.Visible  = true
            o.fill.PointA    = box.tl; o.fill.PointB = box.tr
            o.fill.PointC    = box.br; o.fill.PointD = box.bl
            o.fill.Color     = col
            o.fill.Transparency = 1 - State.ESPFillAlpha
            o.fill.Visible   = State.ESPFill
        else
            for _, l in ipairs(o.lines) do l.Visible = false end
            o.label.Visible = false; o.fill.Visible = false
        end

        -- Tracer — aparece mesmo atrás de paredes
        if State.TracerEnabled and root then
            local sp, _ = Camera:WorldToViewportPoint(root.Position)
            o.tracer.From    = Vector2.new(vcx, bottomY)
            o.tracer.To      = Vector2.new(sp.X, sp.Y)
            o.tracer.Color   = State.TracerColor
            o.tracer.Visible = true
        else
            o.tracer.Visible = false
        end

        -- Distance
        if State.DistESP and root then
            local myRoot = getRoot()
            if myRoot then
                local d = math.floor((root.Position - myRoot.Position).Magnitude)
                o.dist.Text     = d .. " studs"
                o.dist.Position = Vector2.new(box.cx, box.bot + 3)
                o.dist.Visible  = true
            else
                o.dist.Visible = false
            end
        else
            o.dist.Visible = false
        end

        -- Health bar
        if State.HealthESP and hum then
            local ratio  = hum.MaxHealth > 0 and (hum.Health / hum.MaxHealth) or 0
            local barX   = box.tl.X - 5
            local barH   = box.bot - box.top
            o.hpBg.From  = Vector2.new(barX, box.top)
            o.hpBg.To    = Vector2.new(barX, box.bot)
            o.hpBg.Visible = true
            o.hpBar.From   = Vector2.new(barX, box.bot)
            o.hpBar.To     = Vector2.new(barX, box.bot - barH * ratio)
            o.hpBar.Color  = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(255 * ratio),
                50
            )
            o.hpBar.Visible = true
        else
            o.hpBg.Visible  = false
            o.hpBar.Visible = false
        end
    end
end)

-- ══════════════════════════════════════════════════════
--  PLAYER EVENTS
-- ══════════════════════════════════════════════════════

local function connectCharacterEvents(pl)
    pl.CharacterAdded:Connect(function(char)
        buildESP(pl)
        -- Reaplica Highlight imediatamente no respawn
        if State.ESPEnabled then
            task.spawn(function()
                task.wait()   -- 1 frame para o char existir
                applyHighlight(pl)
            end)
        end
        if State.HitboxEnabled then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                applyHitbox(pl)
            else
                char.ChildAdded:Connect(function(child)
                    if child.Name == "HumanoidRootPart" and State.HitboxEnabled then
                        applyHitbox(pl)
                    end
                end)
            end
        end
        if State.ChamEnabled then applyCham(pl) end
    end)
end

-- Players já no jogo quando o script rodou
for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LocalPlayer then
        buildESP(pl)
        connectCharacterEvents(pl)
        if State.HitboxEnabled and pl.Character then
            task.spawn(function() applyHitbox(pl) end)
        end
        if State.ESPEnabled and pl.Character then
            task.spawn(function() applyHighlight(pl) end)
        end
    end
end

-- Novos players
Players.PlayerAdded:Connect(function(pl)
    buildESP(pl)
    connectCharacterEvents(pl)
end)

Players.PlayerRemoving:Connect(function(pl)
    cleanESP(pl)
    removeHitbox(pl)
end)

-- Nosso próprio respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        -- Só aplica speed/jump se o toggle estiver ativo
        if State.SpeedEnabled then hum.WalkSpeed = State.WalkSpeed end
        if State.JumpEnabled  then hum.JumpPower  = State.JumpPower  end
        if State.GodMode then applyGodMode(hum) end
    end
    if State.HitboxEnabled then refreshHitboxes() end
    if State.DeleteRagdoll then deleteRagdoll() end
end)

setupAutoRejoin()

-- ══════════════════════════════════════════════════════
--  ABA: USEFUL
-- ══════════════════════════════════════════════════════
do
    TabUseful:Section({ Title = "Fling" })

    TabUseful:Toggle({
        Title = "Touch Fling",
        Desc  = "Aplica força em objetos próximos",
        Value = false,
        Callback = function(v)
            State.TouchFling = v
            if v then startFling() else stopFling() end
        end,
    })

    TabUseful:Button({
        Title = "Anti-Fling (toggle)",
        Desc  = "Bloqueia velocity anormal",
        Icon  = "shield",
        Callback = function()
            State.AntiFling = not State.AntiFling
            if State.AntiFling then startAntiFling() else stopAntiFling() end
            WindUI:Notify({
                Title   = "Anti-Fling",
                Content = State.AntiFling and "ATIVADO ✅" or "DESATIVADO ❌",
                Duration = 2,
            })
        end,
    })

    TabUseful:Section({ Title = "Proteções" })

    TabUseful:Toggle({
        Title = "God Mode",
        Desc  = "Vida infinita — difícil de matar",
        Value = false,
        Callback = function(v)
            State.GodMode = v
            local hum = getHum()
            if not hum then return end
            if v then applyGodMode(hum) else removeGodMode(hum) end
        end,
    })

    TabUseful:Toggle({
        Title = "Anti-Void",
        Desc  = "Salva ao cair no void",
        Value = false,
        Callback = function(v)
            State.AntiVoid = v
            if v then startAntiVoid() else stopAntiVoid() end
        end,
    })

    TabUseful:Toggle({
        Title = "Anti-Stun",
        Desc  = "Remove stun e knock-down",
        Value = false,
        Callback = function(v)
            State.AntiStun = v
            if v then startAntiStun() else stopAntiStun() end
        end,
    })

    TabUseful:Button({
        Title = "Delete Ragdoll",
        Desc  = "Remove constraints de ragdoll",
        Icon  = "trash-2",
        Callback = function()
            deleteRagdoll()
            WindUI:Notify({ Title = "Ragdoll", Content = "Deletado!", Duration = 2 })
        end,
    })

    TabUseful:Section({ Title = "Tools" })

    local tools = {
        { "Instant Interact", "zap",    "https://pastefy.app/vg1Ap8MO/raw" },
        { "Destroy Tool",     "trash-2","https://rawscripts.net/raw/Universal-Script-destroy-tool-31432" },
        { "Fly Tool",         "wind",   "https://raw.githubusercontent.com/CoiledTom/Fly-tween-CoiledTom-/refs/heads/main/fly%20tween" },
        { "F3X Tool",         "box",    "https://rawscripts.net/raw/Universal-Script-F3X-Tool-44387" },
        { "Shift Lock",       "lock",   "https://raw.githubusercontent.com/CoiledTom/Shift-Lock-CoiledTom-/refs/heads/main/shift%20Lock%20CoiledTom" },
    }
    for _, t in ipairs(tools) do
        TabUseful:Button({
            Title    = t[1],
            Icon     = t[2],
            Callback = function() loadstring(game:HttpGet(t[3]))() end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: SCRIPTS
-- ══════════════════════════════════════════════════════
do
    TabScripts:Section({ Title = "GUIs Externas" })

    local guis = {
        { "Fly GUI",        "airplay",  "https://raw.githubusercontent.com/CoiledTom/Fly-gui/refs/heads/main/%25" },
        { "Refast GUI",     "activity", "https://raw.githubusercontent.com/CoiledTom/Refast-CoiledTom-/refs/heads/main/refast%20CoiledTom" },
        { "Speed GUI",      "zap",      "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Waypoint GUI",   "map-pin",  "https://raw.githubusercontent.com/CoiledTom/Way-point-universal-/refs/heads/main/Teleport%2Btween" },
        { "Speed X Hub",    "rocket",   "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua" },
        { "Infinite Yield", "terminal", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" },
        { "Reverse",        "refresh-cw","https://raw.githubusercontent.com/CoiledTom/Reverse/refs/heads/main/reverse%20script%20by%20CoiledTom" },
        { "Speed CoiledTom","zap",      "https://raw.githubusercontent.com/CoiledTom/Speed-CoiledTom-/refs/heads/main/speed%20CoiledTom" },
        { "Plataforma",     "layers",   "https://raw.githubusercontent.com/CoiledTom/CoiledTom-plataforma/refs/heads/main/By%2520CoiledTom" },
    }
    for _, g in ipairs(guis) do
        TabScripts:Button({
            Title    = g[1],
            Icon     = g[2],
            Callback = function() loadstring(game:HttpGet(g[3]))() end,
        })
    end
end

-- ══════════════════════════════════════════════════════
--  ABA: PLAYER
-- ══════════════════════════════════════════════════════
do
    TabPlayer:Section({ Title = "Movimento" })

    TabPlayer:Toggle({
        Title = "Speed Hack",
        Desc  = "Ativa / desativa o WalkSpeed customizado",
        Value = false,
        Callback = function(v)
            State.SpeedEnabled = v
            local hum = getHum()
            if not hum then return end
            hum.WalkSpeed = v and State.WalkSpeed or 16
        end,
    })

    TabPlayer:Slider({
        Title = "WalkSpeed",
        Desc  = "Velocidade de caminhada",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 16 },
        Callback = function(v)
            State.WalkSpeed = v
            local hum = getHum()
            if hum and State.SpeedEnabled then hum.WalkSpeed = v end
        end,
    })

    TabPlayer:Toggle({
        Title = "Jump Hack",
        Desc  = "Ativa / desativa o JumpPower customizado",
        Value = false,
        Callback = function(v)
            State.JumpEnabled = v
            local hum = getHum()
            if not hum then return end
            hum.JumpPower = v and State.JumpPower or 50
        end,
    })

    TabPlayer:Slider({
        Title = "JumpPower",
        Desc  = "Força do pulo",
        Step  = 1,
        Value = { Min = 0, Max = 500, Default = 50 },
        Callback = function(v)
            State.JumpPower = v
            local hum = getHum()
            if hum and State.JumpEnabled then hum.JumpPower = v end
        end,
    })

    TabPlayer:Section({ Title = "Pulo" })

    TabPlayer:Toggle({
        Title = "Infinite Jump",
        Desc  = "Pula no ar indefinidamente",
        Value = false,
        Callback = function(v) State.InfiniteJump = v end,
    })

    TabPlayer:Section({ Title = "Movimento Avançado" })

    TabPlayer:Toggle({
        Title = "Noclip",
        Desc  = "Atravessa paredes e objetos",
        Value = false,
        Callback = function(v)
            State.Noclip = v
            if v then startNoclip() else stopNoclip() end
        end,
    })

    TabPlayer:Toggle({
        Title = "Fly",
        Desc  = "Voa com WASD + Espaço (subir) + Ctrl (descer)",
        Value = false,
        Callback = function(v)
            State.Fly = v
            if v then
                startFly()
            else
                stopFly()
                -- Restaura gravidade
                local hum = getHum()
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end
            end
        end,
    })

    TabPlayer:Slider({
        Title = "Velocidade do Fly",
        Desc  = "Velocidade ao voar",
        Step  = 5,
        Value = { Min = 10, Max = 500, Default = 50 },
        Callback = function(v)
            FLY_SPEED = v
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: COMBAT
-- ══════════════════════════════════════════════════════
do
    TabCombat:Section({ Title = "Aimbot" })

    TabCombat:Toggle({
        Title = "Aimbot",
        Desc  = "Mira automática no alvo mais próximo",
        Value = false,
        Callback = function(v) State.AimbotEnabled = v end,
    })

    TabCombat:Toggle({
        Title = "Team Check",
        Desc  = "Ignora jogadores do mesmo time",
        Value = false,
        Callback = function(v) State.TeamCheck = v end,
    })

    TabCombat:Slider({
        Title = "FOV",
        Desc  = "Raio de alcance em pixels",
        Step  = 1,
        Value = { Min = 10, Max = 600, Default = 120 },
        Callback = function(v) State.AimbotFOV = v end,
    })

    TabCombat:Slider({
        Title = "Smooth",
        Desc  = "Suavidade da mira",
        Step  = 1,
        Value = { Min = 1, Max = 30, Default = 5 },
        Callback = function(v) State.AimbotSmooth = v end,
    })

    TabCombat:Section({ Title = "ESP — Box 2D" })

    TabCombat:Toggle({
        Title = "ESP Box",
        Desc  = "Box 2D + Highlight através de paredes",
        Value = false,
        Callback = function(v)
            State.ESPEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl == LocalPlayer then continue end
                if v then
                    applyHighlight(pl)
                else
                    removeHighlight(pl)
                    local o = espObjects[pl]
                    if o then
                        for _, l in ipairs(o.lines) do l.Visible = false end
                        o.label.Visible = false
                        o.fill.Visible  = false
                    end
                end
            end
        end,
    })

    TabCombat:Toggle({
        Title = "Fill",
        Desc  = "Preenchimento semitransparente",
        Value = false,
        Callback = function(v) State.ESPFill = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor do ESP",
        Default  = Color3.fromRGB(255, 50, 50),
        Callback = function(c)
            State.ESPColor = c
            -- Atualiza Highlights em tempo real
            for _, hl in pairs(espHighlights) do
                pcall(function()
                    hl.FillColor    = c
                    hl.OutlineColor = c
                end)
            end
        end,
    })

    TabCombat:Slider({
        Title = "Opacidade Fill",
        Step  = 0.05,
        Value = { Min = 0.05, Max = 1, Default = 0.15 },
        Callback = function(v) State.ESPFillAlpha = v end,
    })

    TabCombat:Section({ Title = "Chams" })

    TabCombat:Toggle({
        Title = "Chams",
        Desc  = "Highlight colorido no corpo dos players",
        Value = false,
        Callback = function(v)
            State.ChamEnabled = v
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer then
                    if v then applyCham(pl) else removeCham(pl) end
                end
            end
        end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Chams",
        Default  = Color3.fromRGB(255, 100, 0),
        Callback = function(c)
            State.ChamColor = c
            if State.ChamEnabled then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer then applyCham(pl) end
                end
            end
        end,
    })

    TabCombat:Section({ Title = "Tracers" })

    TabCombat:Toggle({
        Title = "Tracers",
        Desc  = "Linha do centro da tela até cada player",
        Value = false,
        Callback = function(v) State.TracerEnabled = v end,
    })

    TabCombat:Colorpicker({
        Title    = "Cor dos Tracers",
        Default  = Color3.fromRGB(0, 255, 128),
        Callback = function(c) State.TracerColor = c end,
    })

    TabCombat:Section({ Title = "Info Extra" })

    TabCombat:Toggle({
        Title = "Distance ESP",
        Desc  = "Distância em studs abaixo do box",
        Value = false,
        Callback = function(v) State.DistESP = v end,
    })

    TabCombat:Toggle({
        Title = "Health ESP",
        Desc  = "Barra de vida à esquerda do box",
        Value = false,
        Callback = function(v) State.HealthESP = v end,
    })

    TabCombat:Section({ Title = "Hitbox Expander" })

    TabCombat:Toggle({
        Title = "Hitbox Expander",
        Desc  = "Aumenta a hitbox dos players na parte selecionada",
        Value = false,
        Callback = function(v)
            State.HitboxEnabled = v
            if v then
                refreshHitboxes()
                startHitboxSync()
            else
                stopHitboxSync()
                refreshHitboxes()
            end
        end,
    })

    TabCombat:Slider({
        Title = "Tamanho",
        Desc  = "Tamanho da hitbox em volta do corpo",
        Step  = 1,
        Value = { Min = 1, Max = 50, Default = 10 },
        Callback = function(v)
            State.HitboxSize = v
            -- Atualiza em tempo real sem reaplica
            for _, d in pairs(hitboxData) do
                pcall(function()
                    if d.part and d.part.Parent then
                        d.part.Size = Vector3.new(v, v, v)
                    end
                end)
            end
        end,
    })

    TabCombat:Slider({
        Title = "Debug Visual",
        Desc  = "0 = mostra hitbox laranja  |  1 = invisível (padrão)",
        Step  = 0.05,
        Value = { Min = 0, Max = 1, Default = 1 },
        Callback = function(v)
            State.HitboxAlpha = v
            -- Mostra/esconde as parts expandidas para debug
            for _, d in pairs(hitboxData) do
                for _, e in ipairs(d.entries or {}) do
                    pcall(function()
                        if e.part and e.part.Parent then
                            e.part.LocalTransparencyModifier = v
                        end
                    end)
                end
            end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: DESEMPENHO
-- ══════════════════════════════════════════════════════
do
    TabPerf:Section({ Title = "⚡ Otimizações" })

    TabPerf:Toggle({
        Title = "Anti-Lag",
        Desc  = "Otimiza física e rendering engine",
        Value = false,
        Callback = function(v) State.AntiLag = v; applyAntiLag(v) end,
    })

    TabPerf:Toggle({
        Title = "FPS Boost",
        Desc  = "Reduz qualidade para mais FPS",
        Value = false,
        Callback = function(v) State.FPSBoost = v; applyFPSBoost(v) end,
    })

    TabPerf:Toggle({
        Title = "Disable Particles",
        Desc  = "Remove fumaça, fogo, faíscas e partículas",
        Value = false,
        Callback = function(v) State.DisableParticles = v; disableParticles(v) end,
    })

    TabPerf:Toggle({
        Title = "Texture Low",
        Desc  = "Substitui materiais por SmoothPlastic",
        Value = false,
        Callback = function(v) State.TextureLow = v; setTextureLow(v) end,
    })

    TabPerf:Toggle({
        Title = "Remove Decals",
        Desc  = "Remove decals e texturas do mapa",
        Value = false,
        Callback = function(v) State.RemoveDecals = v; removeDecals(v) end,
    })

    TabPerf:Toggle({
        Title = "Dynamic Render Distance",
        Desc  = "Ajusta qualidade automaticamente pelo ping",
        Value = false,
        Callback = function(v) State.DynRender = v; setDynRender(v) end,
    })

    TabPerf:Toggle({
        Title = "Entity Limiter",
        Desc  = "Limita modelos no workspace (máx 80)",
        Value = false,
        Callback = function(v) State.EntityLimiter = v; setEntityLimiter(v) end,
    })

    TabPerf:Toggle({
        Title = "Lighting Cleaner",
        Desc  = "Remove fog, bloom, DOF e sombras",
        Value = false,
        Callback = function(v) State.LightingClean = v; cleanLighting(v) end,
    })

    TabPerf:Toggle({
        Title = "Low Poly Mode",
        Desc  = "Reduz LOD de meshes para mais FPS",
        Value = false,
        Callback = function(v) State.LowPoly = v; setLowPoly(v) end,
    })
end

-- ══════════════════════════════════════════════════════
--  ABA: SETTINGS
-- ══════════════════════════════════════════════════════
do
    TabSettings:Section({ Title = "Aparência" })

    TabSettings:Colorpicker({
        Title   = "Cor da GUI",
        Desc    = "Muda a cor de destaque de toda a interface",
        Default = Color3.fromHex("#7B2FFF"),
        Callback = function(c)
            pcall(function()
                WindUI:AddTheme({
                    Name        = "HubTheme",
                    Accent      = c,
                    Background  = Color3.fromHex("#0d0d0f"),
                    Outline     = Color3.fromHex("#2a2a35"),
                    Text        = Color3.fromHex("#f0f0ff"),
                    Placeholder = Color3.fromHex("#666680"),
                    Button      = Color3.fromHex("#1e1e2e"),
                    Icon        = c,
                })
                WindUI:SetTheme("HubTheme")
            end)
        end,
    })

    TabSettings:Section({ Title = "Proteções" })

    TabSettings:Toggle({
        Title = "Anti-AFK",
        Desc  = "Evita kick por inatividade",
        Value = false,
        Callback = function(v)
            State.AntiAFK = v
            if v then startAntiAFK() else stopAntiAFK() end
        end,
    })

    TabSettings:Toggle({
        Title = "Anti-Kick / Anti-Ban",
        Desc  = "Bloqueia kick via metamétodo",
        Value = false,
        Callback = function(v)
            State.AntiKick = v
            if v then hookAntiKick() end
        end,
    })

    TabSettings:Section({ Title = "Servidor" })

    TabSettings:Toggle({
        Title = "Auto Rejoin",
        Desc  = "Caiu? Volta sozinho ao server automaticamente",
        Value = false,
        Callback = function(v) State.AutoRejoin = v end,
    })

    TabSettings:Button({
        Title = "Server Hopper",
        Desc  = "Vai para o server com menor ping disponível",
        Icon  = "wifi",
        Callback = function()
            WindUI:Notify({ Title = "Server Hopper", Content = "Buscando melhor server...", Duration = 3 })
            startServerHop()
        end,
    })

    TabSettings:Section({ Title = "Atalhos" })

    TabSettings:Keybind({
        Title = "Toggle UI",
        Desc  = "Abre/fecha o hub",
        Value = "RightShift",
        Callback = function(v)
            pcall(function()
                Window:SetToggleKey(Enum.KeyCode[v])
            end)
        end,
    })

    TabSettings:Section({ Title = "Configuração" })

    TabSettings:Button({
        Title = "Salvar Config",
        Icon  = "save",
        Desc  = "Salva em CoiledTomHub_Config.json",
        Callback = function()
            local ok, err = pcall(function()
                local data = {
                    WalkSpeed     = State.WalkSpeed,
                    JumpPower     = State.JumpPower,
                    InfiniteJump  = State.InfiniteJump,
                    AimbotEnabled = State.AimbotEnabled,
                    TeamCheck     = State.TeamCheck,
                    AimbotFOV    = State.AimbotFOV,
                    AimbotSmooth  = State.AimbotSmooth,
                    ESPEnabled    = State.ESPEnabled,
                    ESPFill       = State.ESPFill,
                    ESPFillAlpha  = State.ESPFillAlpha,
                    ChamEnabled   = State.ChamEnabled,
                    TracerEnabled = State.TracerEnabled,
                    DistESP       = State.DistESP,
                    HealthESP     = State.HealthESP,
                    HitboxEnabled = State.HitboxEnabled,
                    HitboxSize    = State.HitboxSize,
                    HitboxAlpha   = State.HitboxAlpha,
                    AntiAFK       = State.AntiAFK,
                    AntiKick      = State.AntiKick,
                }
                writefile("CoiledTomHub_Config.json", HttpService:JSONEncode(data))
            end)
            if ok then
                WindUI:Notify({ Title="✅ Config Salva!", Content="CoiledTomHub_Config.json", Duration=3 })
            else
                WindUI:Notify({ Title="❌ Erro", Content=tostring(err), Duration=5 })
            end
        end,
    })
end

-- ══════════════════════════════════════════════════════
--  NOTIFICAÇÃO INICIAL
-- ══════════════════════════════════════════════════════
WindUI:Notify({
    Title    = "CoiledTom Hub",
    Content  = "Carregado! Confira a aba Logs para novidades.",
    Duration = 5,
})
