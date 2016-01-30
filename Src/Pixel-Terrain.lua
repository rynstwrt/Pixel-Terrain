--------VARIABLES----------------------------------------------------------------------------------------------
local mouse = game.Players.LocalPlayer:GetMouse()
script:WaitForChild("ModuleScript")
local t = require(script.ModuleScript)
local gridSize = 1
local clickIndex = 1


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
	--main.Material = "Slate"
	main.BrickColor = BrickColor.new("Dirt brown")
	main.FormFactor = "Custom"
	main.Size = Vector3.new(1, 1, 1)
	main.Anchored = true
	local grass = Instance.new("Part", game.Workspace)
	grass.TopSurface = "Smooth"
	grass.BottomSurface = "Smooth"
	--grass.Material = "Grass"
	grass.BrickColor = BrickColor.new("Medium green")
	grass.FormFactor = "Custom"
	grass.Size = Vector3.new(1, 1, 1)
	grass.Position = main.Position + Vector3.new(0, main.Size.Y / 2 - grass.Size.Y / 2, 0)
	grass.Anchored = true
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
	guide.Size = Vector3.new(main.Size.X * sizeX, 1, main.Size.Z * sizeZ)
	guide.Position = main.Position + Vector3.new(guide.Size.X / 2 - main.Size.X /2, (-(main.Size.Y / 2)) - (guide.Size.Y / 2), guide.Size.Z / 2 - main.Size.Z / 2)
	guide.Name = "guide"
	guide.Transparency = 1
	
	--t.gen(cell, 3, 10, 50, math.random(1, 10e6))
	t.gen(cell, 3, 20, guide.Size.X, guide.Size.Z, math.random(1, 10e6))	
	
	t.clean()
		
	
end

--makes the region
function regionCreate(p1, p2)
	--destroys any previous regions
	if game.Workspace:FindFirstChild("RegionPart") ~= nil then
		game.Workspace.RegionPart:Destroy()
	end
	--creates the part
	local r = Instance.new("Part", game.Workspace)
	r.Anchored = true
	r.FormFactor = Enum.FormFactor.Custom
	r.Name = "RegionPart"
	r.CanCollide = false
	r.TopSurface = "Smooth"
	r.BottomSurface = "Smooth"
	r.Transparency = 1
	r.Size = Vector3.new(math.abs(p1.X - p2.X), math.abs(p1.Y - p2.Y), math.abs(p1.Z - p2.Z))
	
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
end

--creates the two waypoints
function createPart(color)
	local part = Instance.new("Part", game.Workspace)
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
	local partD, position = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character, false, true)
	local distance = (ray.Origin - position).magnitude
	part.Size = Vector3.new(1, 1, 1)
	if mouse.Target ~= nil then
		part.Position = mouse.Hit.p
	else
		part.CFrame = CFrame.new(mouse.Origin.p, position) * CFrame.new(0, 0, -100)
	end
	
	if clickIndex == 2 then
		regionCreate(game.Workspace.blue.Position, game.Workspace.red.Position)
	end
end

--------EVENTS------------------------------------------------------------------------------------------------
mouse.Button1Down:connect(function()
	if clickIndex == 1 then
		--first click
		if game.Workspace:FindFirstChild("blue") ~= nil then
			game.Workspace.blue:Destroy()
		end
		createPart("Toothpaste")
		clickIndex = clickIndex + 1
	elseif clickIndex == 2 then
		--second click
		if game.Workspace:FindFirstChild("red") ~= nil then
			game.Workspace.red:Destroy()
		end
		createPart("Really red")
		clickIndex = 1
	end
end)

