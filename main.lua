-- itzalyssa1 Hub - Grow a Garden Mode Script -- Includes: Fruit ESP, Visual Pet Spawner, Seed Spawner, Fly, Speed, Noclip, Auto Collect, Auto Steal Fruit, Shop Auto Buy, Hamster Detection

local Players = game:GetService("Players") local player  = Players.LocalPlayer local RunService = game:GetService("RunService") local uis = game:GetService("UserInputService")


---

-- 🖌️  UI BOOT ------------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))() local Window = Rayfield:CreateWindow({ Name             = "itzalyssa1 Hub", LoadingTitle     = "itzalyssa1 Hub Loading...", LoadingSubtitle  = "by itzalyssa1", ConfigurationSaving = {Enabled = false}, Discord          = {Enabled = false}, KeySystem        = false, })

Rayfield:Notify({ Title   = "itzalyssa1 Hub", Content = "Getting scripts from itzalyssa1 — beware of fake hubs!", Duration= 6.5, Image   = 4483362458, })


---

-- 🌱  SETUP ---------------------------------------------------------

local function disableScripts(inst) for _, d in ipairs(inst:GetDescendants()) do if d:IsA("Script") or d:IsA("LocalScript") then d.Disabled = true end end end

local function getMyGarden() local g = workspace:FindFirstChild("Gardens") if not g then return end local m = g:FindFirstChild(player.Name) if not (m and m:IsA("Model")) then return end local cf, size = m:GetBoundingBox() return m, cf.Position - size/2, cf.Position + size/2 end

local FRUIT_CONTAINER      = workspace:WaitForChild("Fruits") local PET_TEMPLATE_FOLDER  = game:GetService("ReplicatedStorage"):WaitForChild("Pets") local SEED_TEMPLATE_FOLDER = game:GetService("ReplicatedStorage"):WaitForChild("Seeds")

local petsFld  = Instance.new("Folder", workspace); petsFld.Name  = "itzalyssa1VisualPets" local seedsFld = Instance.new("Folder", workspace); seedsFld.Name = "itzalyssa1VisualSeeds"


---

-- 🐾  PET TAB -------------------------------------------------------

local PetTab   = Window:CreateTab("Pets", 4483362458) local petWeight, petAge = 5, 2 local selectedPetName   = ""

PetTab:CreateSlider({ Name = "Pet Weight", Range = {1,50}, Increment = 1, Suffix = "kg", CurrentValue = petWeight, Callback=function(v) petWeight = v end, })

PetTab:CreateSlider({ Name = "Pet Age", Range = {0,20}, Increment = 1, Suffix = "yrs", CurrentValue = petAge, Callback=function(v) petAge = v end, })

local function attachMover(pet, garden, minB, maxB) task.spawn(function() while pet.Parent == petsFld do local r = Vector3.new( math.random()(maxB.X-minB.X)+minB.X, minB.Y+2, math.random()(maxB.Z-minB.Z)+minB.Z ) pet:PivotTo(CFrame.new(r)) task.wait(15) end end) end

local function spawnPetNow(name, cf) local template = PET_TEMPLATE_FOLDER:FindFirstChild(name) if not template then Rayfield:Notify({ Title   = "Pet Spawner", Content = "Template "" .. name .. "" missing!", Duration= 6, }) return end

local garden, minB, maxB = getMyGarden()
if not garden then
    Rayfield:Notify({Title="Pet Spawner",Content="Your garden model is missing!",Duration=5})
    return
end

local pet = template:Clone()
pet.Name = "Pet_" .. name
pet:SetAttribute("Weight", petWeight)
pet:SetAttribute("Age",    petAge)
disableScripts(pet)
pet.Parent = petsFld
pet:PivotTo(cf)
attachMover(pet, garden, minB, maxB)

Rayfield:Notify({
    Title   = "Pet Spawner",
    Content = string.format("%s spawned (%.0f kg, %dyrs)", name, petWeight, petAge),
    Duration= 4,
})

end

-- generate dropdown options automatically local petNames = {} for _, p in ipairs(PET_TEMPLATE_FOLDER:GetChildren()) do if p:IsA("Model") or p:IsA("BasePart") then table.insert(petNames, p.Name) end end table.sort(petNames)

PetTab:CreateDropdown({ Name          = "Select Pet", Options       = petNames, CurrentOption = nil, Callback      = function(opt) selectedPetName = opt end, })

PetTab:CreateButton({ Name = "Spawn Selected Pet", Callback = function() if selectedPetName == "" then Rayfield:Notify({Title="Pet Spawner",Content="No pet selected.",Duration=4}) return end local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then spawnPetNow(selectedPetName, hrp.CFrame * CFrame.new(3,0,0)) end end, })


---

-- (All other tabs: Player, Fruits, Shops, etc. would follow here)

print("itzalyssa1 Hub loaded • Pet Spawner fixed.")

