--Pixel Terrain Plugin
--Created by CarbonAPI, 2016.


--------PLUGIN VARIABLES----------------------------------------------------------------------------------------------
local plugin = PluginManager():CreatePlugin() or plugin
local toolbar = plugin:CreateToolbar("CarbonAPI's Plugins")
local button = toolbar:CreateButton("PixelTerrain", "Start PixelTerrain", "rbxassetid://345163727")
local open = false
plugin:Activate(true)
local mouse = plugin:GetMouse()

--------VARIABLES----------------------------------------------------------------------------------------------
script:WaitForChild("ModuleScript")
local t = require(script.ModuleScript)
local gridSize = 50 --how man we want in the grid
local clickIndex = 1
local globSize = Vector3.new(5, 5, 5)

--------FUNCTIONS----------------------------------------------------------------------------------------------
--generates the terrain
function terrGen(sizeX, sizeY, sizeZ, pos, intensity)
	--if plugin is run multiple times, it clears
	if game.Workspace:FindFirstChild("PixelTerrain") ~= nil then
		game.Workspace.PixelTerrain:Destroy()
	end
	--makes first cell
	local main = Instance.new("Part", game.Workspace)
	main.TopSurface = "Smooth"
	main.BottomSurface = "Smooth"
	main.Material = "Slate"
	main.BrickColor = BrickColor.new("Dirt brown")
	main.FormFactor = "Custom"
	main.Size = Vector3.new(sizeX / gridSize, (sizeX / gridSize) * 2, sizeX / gridSize)
	main.Anchored = true
	main.CanCollide = false
	local grass = Instance.new("Part", game.Workspace)
	grass.TopSurface = "Smooth"
	grass.BottomSurface = "Smooth"
	grass.Material = "Grass"
	grass.BrickColor = BrickColor.new("Mint")
	grass.FormFactor = "Custom"
	grass.Size = Vector3.new(main.Size.X, main.Size.Y / 6, main.Size.Z)
	grass.Position = main.Position + Vector3.new(0, (main.Size.Y / 2) + (grass.Size.Y / 2), 0) 
	grass.Anchored = true
	grass.CanCollide = false
	grass.Name = "grass"
	local cell = Instance.new("Model", game.Workspace)
	cell.Name = "Cell"
	main.Parent = cell
	grass.Parent = cell
	cell.PrimaryPart = main
	local guide = Instance.new("Part", game.Workspace)
	guide.CanCollide = false
	guide.Anchored = true
	guide.FormFactor = Enum.FormFactor.Custom
	guide.Size = Vector3.new(sizeX, sizeY, sizeZ)
	guide.Position = main.Position + Vector3.new(guide.Size.X / 2 - main.Size.X /2, (-(main.Size.Y / 2)) - (guide.Size.Y / 2), guide.Size.Z / 2 - main.Size.Z / 2)
	guide.Name = "guide"
	guide.Transparency = 1
	
	
	t.gen(cell, 3, main.Size.X * 6, guide.Size.X, guide.Size.Z, math.random(1, 10e6), gridSize)	
	
	t.bindTerr()
	cell:Destroy()
	
	game.Workspace.PixelTerrainAssets:Destroy()
end

--makes the region
function regionCreate(p1, p2)
	--destroys any previous regions
	if game.Workspace.PixelTerrainAssets:FindFirstChild("RegionPart") ~= nil then
		game.Workspace.PixelTerrainAssets.RegionPart:Destroy()
	end
	--creates the part
	local r = Instance.new("Part", game.Workspace.PixelTerrainAssets)
	r.Anchored = true
	r.FormFactor = Enum.FormFactor.Custom
	r.Name = "RegionPart"
	r.CanCollide = false
	r.TopSurface = "Smooth"
	r.BottomSurface = "Smooth"
	r.Transparency = 1
	r.Size = Vector3.new(math.abs(p1.X - p2.X), .2, math.abs(p1.Z - p2.Z))
	
	r.Position = p1
	--find width
	if p1.X > p2.X then
		r.Position = r.Position - Vector3.new(r.Size.X / 2, 0, 0)
	else
		r.Position = r.Position + Vector3.new(r.Size.X / 2, 0, 0)
	end
	--find height
	if p1.Y > p2.Y then
		r.Position = r.Position - Vector3.new(0, r.Size.Y / 2, 0)
	else
		r.Position = r.Position + Vector3.new(0, r.Size.Y / 2, 0)
	end
	--find depth
	if p1.Z > p2.Z then
		r.Position = r.Position - Vector3.new(0, 0, r.Size.Z / 2)
	else
		r.Position = r.Position + Vector3.new(0, 0, r.Size.Z / 2)
	end
	
	terrGen(r.Size.X, r.Size.Y, r.Size.Z, r.Position, 4)
	game.Workspace.PixelTerrain:SetPrimaryPartCFrame(CFrame.new(r.Position) - Vector3.new(0, 0, 0))
	t.makeCollide()
end

--creates the two waypoints
function createPart(color)
	local part = Instance.new("Part", game.Workspace.PixelTerrainAssets)
	part.Anchored = true
	part.CanCollide = false
	part.BrickColor = BrickColor.new(color)
	part.TopSurface = "Smooth"
	part.BottomSurface = "Smooth"
	part.Material = "Neon"
	part.Transparency = .5
	if color == "Really red" then
		part.Name = "red"
	elseif color == "Toothpaste" then
		part.Name = "blue"
	end
	local ray = mouse.UnitRay
	local ignore = game.Workspace.Terrain
	local partD, position = workspace:FindPartOnRay(ray, ignore, false, true)
	local distance = (ray.Origin - position).magnitude
	part.Size = Vector3.new(1, 1, 1)
	if mouse.Target ~= nil then
		part.Position = mouse.Hit.p
	else
		part.CFrame = CFrame.new(mouse.Origin.p, position) * CFrame.new(0, 0, -100)
	end
	
	if clickIndex == 2 then
		regionCreate(game.Workspace.PixelTerrainAssets.blue.Position, game.Workspace.PixelTerrainAssets.red.Position)
	end
end

--------EVENTS------------------------------------------------------------------------------------------------
mouse.Button1Down:connect(function()
	if game.Workspace:FindFirstChild("PixelTerrainAssets") == nil then
		local f = Instance.new("Folder", game.Workspace)
		f.Name = "PixelTerrainAssets"
	end	
	
	if clickIndex == 1 then
		--first click
		if game.Workspace.PixelTerrainAssets:FindFirstChild("blue") ~= nil then
			game.Workspace.PixelTerrainAssets.blue:Destroy()
		end
		createPart("Toothpaste")
		clickIndex = clickIndex + 1
	elseif clickIndex == 2 then
		--second click
		if game.Workspace.PixelTerrainAssets:FindFirstChild("red") ~= nil then
			game.Workspace.PixelTerrainAssets.red:Destroy()
		end
		createPart("Really red")
		clickIndex = 1
	end
end)

--------EVENTS------------------------------------------------------------------------------------------------
button.Click:connect(function()
	if open == false then
		open = true
		script.PixelTerrainScreen:Clone().Parent = game.CoreGui
		button:SetActive(true)
	else
		open = false
		game.CoreGui:FindFirstChild("PixelTerrainScreen"):Destroy()
		button:SetActive(false)
	end
end)
