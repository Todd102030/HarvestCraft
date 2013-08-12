
--THINGS TO DO
--Make tilesize adjustable without breaking everything //SEEMS FIXED
--Make graphics for each height level; dark water, light water, sand, grass, dirt, rock, snow
--Fix the radiuses on the terrain gen
--Fix the out of bounds errors
--Fix painting so that it normalizes properly and stops getting out of line with the mouse.
--//optimize minimap
--Fix rotation on dynamic lighting 
--Make dynamic lighting keep moving outwards uphill until it reaches a peak and starts going downwards. 
--^^Makes more sense than current method. Can do this by storing previous height value and seeing if the 
--^^new one is lower. Only break the for loop if the next step outwards is lower than the previous one. //DON'T GIVE A FUCK ANY MORE
--Bigger maps
--Make maps infinitely generate? Can do this by having a big grid, each value representing a 100x100 grid of the map.
--^^Just not sure how to make each chunk merge nicely with the adjacent one.

--Hide skill points as items in chests in dungeons
--Make it so that the map doesn't jitter as you walk


--TERRAIN STUFF
--seriously need wells
--teepees too
--bushes
--flowers
--boulders
--long grass (things you can walk behind or in front of need to be layered correctly. Might need to see if there's laying options in Love)

--BIOME TYPES
--snowy 
--forest
--spooky
--islands (kinda done)
--desert
--alien/space biome
--swamp


--Add a new array so that one stores height values and one stores item values. Or use the Table data style of Lua and 
--^^stick them both in one array

require "generation"

function love.load()
	
	characterimg = love.graphics.newImage("resources/tiles/character.png")
	water1 = love.graphics.newImage("resources/tiles/Water1.png")
	water2 = love.graphics.newImage("resources/tiles/Water2.png")
	water3 = love.graphics.newImage("resources/tiles/Water3.png")
	water4 = love.graphics.newImage("resources/tiles/Water4.png")
	water=water1
	grass = love.graphics.newImage("resources/tiles/Grass.png")
	beach = love.graphics.newImage("resources/tiles/Beach.png")
	tree = love.graphics.newImage("resources/tiles/Tree.png")
	longGrass = love.graphics.newImage("resources/tiles/Longgrass.png")
	horiBridge = love.graphics.newImage("resources/tiles/HoriBridge.png")
	vertBridge = love.graphics.newImage("resources/tiles/VertBridge.png")
	
	waterLadder = love.graphics.newImage("resources/tiles/WaterLadder.jpg")

	love.window.setCaption("Terrain Generation Alpha")
	love.window.setMode(800,800,{vsync = false})

	--length/width of map and tile squares 
	minimapsize = 4
	tilesize = 32

	--main character
	character = {}
	character.x = 400
	character.y = 400
	
	--variables to aid in making the camera follow the character; xrange
	xrange = (character.x + 16) / tilesize
	yrange = (character.y + 16) / tilesize
	
	
	--variable that determines whether or not to use the lighting engine
	cave = false
	

	--outermost range of map array
	xmin = 0
	ymin = 0
	xmax = 500
	ymax = 500
	
	--radius of dynamic lighting around player
	sightradius = 16
	
	
	
	minimapcanvas = love.graphics.newCanvas(500,500)
	mapcanvas = love.graphics.newCanvas(1000,1000)
	
	
	
	
	minimapdraw = true
	lighting = false
	
	watercount = 0
	togglecount = 0
	
	--initialize a bunch of grids
	map={}
	mapblocked={}
	minimap={}
	mapheight={}
	for i=ymin,ymax do
		map[i]={}
		mapblocked[i]={}
		minimap[i]={}
		mapheight[i]={}
		for n=xmin,xmax do
			mapblocked[i][n] = {}
			map[i][n]=1
			mapheight[i][n]=1
			minimap[i][n]={}
			minimap[i][n].mapvisible = false
			
		end
	end
	
	
	genIslands(2000)
	genBridges(400)
	genPonds(100)	
	genTrees(20000)
	genLongGrass(70000)
	
	
	
	
	
	--[[
	for y = ymin, ymax do
		for x = xmax, xmax do
			if y > ymin and y < ymax and x > xmin and x < xmax then
				average = 0
				for y2 = y - 1, y + 1 do
					for x2 = x - 1, x + 1 do
						average = average + map[y2][x2]
					end
				end
				average = math.floor(average / 9)
				map[y][x]=average
			end
		end
	end
	--]]
	
	
	
	
	
	love.graphics.setCanvas(minimapcanvas)
		minimapcanvas:clear()
		--love.graphics.setColor(0,0,0,255)
		--love.graphics.rectangle("fill", 0,0,2010,2010)
		for x=0,500 do
			for y=0,500 do
				--if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
				if map[y][x]>=0 then
					if map[y][x]==1 then
						love.graphics.setColor(65,150,240,255)
					elseif map[y][x]==2 or map[y][x]==8 then
						love.graphics.setColor(75,190,60,255)
					elseif map[y][x]==5 or map[y][x]==6 then
						love.graphics.setColor(120,95,0,255)
					elseif map[y][x]==4 then
						love.graphics.setColor(220,210,120,255)
					elseif map[y][x]==3 then
						love.graphics.setColor(55,170,40,255)
					else
						love.graphics.setColor(0,255,0,255)
					end
					love.graphics.rectangle("fill",x,y,1,1)
					--love.graphics.rectangle("fill",x--[[*minimapsize]],y--[[*minimapsize]],minimapsize,minimapsize)
				end
					--end
				--end
			end
		end
	love.graphics.setCanvas()
		
	
	love.graphics.setCanvas(mapcanvas)
		mapcanvas:clear()
		for x=xmin,xmax do
			for y=ymin,ymax do
				if y > ymin and y < ymax and x > xmin and x < xmax then
					--map[x][y]=math.random(0,3)
					if mapblocked[y][x].blocked == false or lighting == false or cave == false then
						if map[y][x]>=0 then
							if map[y][x]==1 then
								love.graphics.setColor(mapheight[y][x]*3+200,mapheight[y][x]*3+200,mapheight[y][x]*3+200,255)
								love.graphics.draw(water,x*tilesize, y*tilesize)
							elseif map[y][x]==2 then
								--love.graphics.setColor(mapheight[y][x]*3+180,mapheight[y][x]*3+180,mapheight[y][x]*3+180,255)
								love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
								love.graphics.draw(grass,x*tilesize, y*tilesize)	
							elseif map[y][x]==3 then
								love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
								love.graphics.draw(tree,x*tilesize, y*tilesize)
							elseif map[y][x]==4 then
								love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
								love.graphics.draw(beach,x*tilesize, y*tilesize)
							elseif map[y][x]==5 then
								love.graphics.setColor(210,210,210,255)
								love.graphics.draw(horiBridge,x*tilesize, y*tilesize)
							elseif map[y][x]==6 then
								love.graphics.setColor(210,210,210,255)
								love.graphics.draw(vertBridge,x*tilesize, y*tilesize)
							elseif map[y][x]==7 then
								love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
								love.graphics.draw(waterLadder,x*tilesize, y*tilesize)
							elseif map[y][x]==8 then
								love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
								love.graphics.draw(longGrass,x*tilesize, y*tilesize)
							else 
								love.graphics.setColor(0,255,0,255)
								love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
							end
							
						end
					else
						if map[y][x]<=10 then
								love.graphics.setColor(map[y][x]*3+100,map[y][x]*3+100,map[y][x]*3+100,255)
								love.graphics.draw(water,x*tilesize, y*tilesize)
							elseif map[y][x]<=50 then
								love.graphics.setColor(255-map[y][x]*3-100,255-map[y][x]*3-100,255-map[y][x]*3-100,255)
								love.graphics.draw(grass,x*tilesize, y*tilesize)
							else
								love.graphics.setColor(0,255,0,255)
								love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
							end
						--love.graphics.setColor(0,0,0,90)
						--love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
					end
					
					--love.graphics.print(mapheight[y][x], x*tilesize +10, y*tilesize+10)
					
					mapblocked[y][x].blocked = true
				end
			end
		end
	love.graphics.setCanvas()
	
	
	--camera code found on http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
	--very useful, but I don't know exactly what it's doing
	camera = {}
	camera.x = 0
	camera.y = 0
	camera.scaleX = 1
	camera.scaleY = 1
	camera.rotation = 0

	function camera:set()
	  love.graphics.push()
	  love.graphics.rotate(-self.rotation)
	  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
	  love.graphics.translate(-self.x, -self.y)
	end

	function camera:unset()
	  love.graphics.pop()
	end

	function camera:move(dx, dy)
	  self.x = self.x + (dx or 0)
	  self.y = self.y + (dy or 0)
	end

	function camera:rotate(dr)
	  self.rotation = self.rotation + dr
	end

	function camera:scale(sx, sy)
	  sx = sx or 1
	  self.scaleX = self.scaleX * sx
	  self.scaleY = self.scaleY * (sy or sx)
	end

	function camera:setPosition(x, y)
	  self.x = x or self.x
	  self.y = y or self.y
	end

	function camera:setScale(sx, sy)
	  self.scaleX = sx or self.scaleX
	  self.scaleY = sy or self.scaleY
	end
end


function love.update(dt)
	
	watercount = watercount + dt
	watertemp = watercount
	if watertemp <= 0.1 then
		water = water1
	elseif watertemp <= 0.2 then
		water = water2
	elseif watertemp <= 0.3 then
		water = water3
	elseif watertemp <= 0.4 then
		water = water4
	end
	
	
	
	if watercount > 0.4 then
		watercount = 0.05
	end
	
	--Makes character move based on Delta t so movement is the same no matter the framerate
	charspeed = 380*dt
	
	togglecount = togglecount + dt
	
	--and map[yrange][xrange] >=10 
	
	--Character movement, pretty straightforward
	if love.keyboard.isDown("d") then 
		--if map[yrange][xrange+1] ==2 then
			character.x = character.x + charspeed
		--end
    end
	if love.keyboard.isDown("a") then 
		--if map[yrange][xrange-1] ==2 then
			character.x = character.x - charspeed
		--end
    end
    if love.keyboard.isDown("w") then 
		--if map[yrange-1][xrange] ==2 then
			character.y = character.y - charspeed
		--end
    end
    if love.keyboard.isDown("s") then 
		--if map[yrange+1][xrange] ==2 then
			character.y = character.y + charspeed
		--end
    end
    
    --Keeps character bound within a certain area of the screen
    if character.y > 450+camera.y then
		camera.y = roundnum(camera.y + charspeed)
		character.y = 450+camera.y
	end
	if character.y < 350+camera.y then
		camera.y = roundnum(camera.y - charspeed)
		character.y = 350+camera.y
	end
	if character.x > 450+camera.x then
		camera.x = roundnum(camera.x + charspeed)
		character.x = 450+camera.x
		
	end
	if character.x < 350+camera.x then
		camera.x = roundnum(camera.x - charspeed)
		character.x = 350+camera.x
	end
    
    --xrange and yrange are variables that show where the character is
    --on the full map
    xrangefloat= (character.x + 16) / tilesize
	xrange = math.floor(xrangefloat)
    
    yrangefloat= (character.y + 16) / tilesize
	yrange = math.floor(yrangefloat)
	
	--these will be 
	xrangenorm = math.floor((camera.x+400)/tilesize)
	yrangenorm = math.floor((camera.y+400)/tilesize)
	
    if togglecount > 1 then
		if love.keyboard.isDown("m") then 
			if minimapdraw == true then
				minimapdraw = false
				togglecount = 0
			elseif minimapdraw == false then
				minimapdraw = true
				togglecount = 0
			end
		end
	end
		
    if togglecount > 1 then
		if love.keyboard.isDown("l") then 
			if lighting == true then
				lighting = false
				togglecount = 0
			elseif lighting == false then
				lighting = true
				togglecount = 0
			end
		end
	end
    
    
    
    if love.mouse.isDown("l") then
		xmouse, ymouse = love.mouse.getPosition()
		--map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]=map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]+3
		
		y = math.floor((camera.y + ymouse) / tilesize)---yrangenorm --math.floor(mapy/tilesize)+yrangenorm-tilesize
		x = math.floor((camera.x + xmouse) / tilesize)---xrangenorm --math.floor(mapx/tilesize)+xrangenorm-tilesize
		if y > ymin and y < ymax and x > xmin and x < xmax then
			if mapheight[y-1][x] < 25 then
				mapheight[y-1][x] = mapheight[y-1][x] + 1
			end
			if mapheight[y][x] < 25 then
				mapheight[y][x] = mapheight[y][x] + 1
			end
			if mapheight[y+1][x] < 25 then
				mapheight[y+1][x] = mapheight[y+1][x] + 1
			end
			if mapheight[y-1][x-1] < 25 then
				mapheight[y-1][x-1] = mapheight[y-1][x-1] + 1
			end
			if mapheight[y][x-1] < 25 then
				mapheight[y][x-1] = mapheight[y][x-1] + 1
			end
			if mapheight[y+1][x-1] < 25 then
				mapheight[y+1][x-1] = mapheight[y+1][x-1] + 1
			end
			if mapheight[y-1][x+1] < 25 then
				mapheight[y-1][x+1] = mapheight[y-1][x+1] + 1
			end
			if mapheight[y][x+1] < 25 then
				mapheight[y][x+1] = mapheight[y][x+1] + 1
			end
			if mapheight[y+1][x+1] < 25 then
				mapheight[y+1][x+1] = mapheight[y+1][x+1] + 1
			end
		end
		
	end
	
	if love.mouse.isDown("r") then
		xmouse, ymouse = love.mouse.getPosition()
		--map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]=map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]+3
		
		y = math.floor((camera.y + ymouse) / tilesize)---yrangenorm --math.floor(mapy/tilesize)+yrangenorm-tilesize
		x = math.floor((camera.x + xmouse) / tilesize)---xrangenorm --math.floor(mapx/tilesize)+xrangenorm-tilesize
		if y > ymin and y < ymax and x > xmin and x < xmax then
			if mapheight[y-1][x] > 1 then
				mapheight[y-1][x] = mapheight[y-1][x] - 1
			end
			if mapheight[y][x] > 1 then
				mapheight[y][x] = mapheight[y][x] - 1
			end
			if mapheight[y+1][x] > 1 then
				mapheight[y+1][x] = mapheight[y+1][x] - 1
			end
			if mapheight[y-1][x-1] > 1 then
				mapheight[y-1][x-1] = mapheight[y-1][x-1] - 1
			end
			if mapheight[y][x-1] > 1 then
				mapheight[y][x-1] = mapheight[y][x-1] - 1
			end
			if mapheight[y+1][x-1] > 1 then
				mapheight[y+1][x-1] = mapheight[y+1][x-1] - 1
			end
			if mapheight[y-1][x+1] > 1 then
				mapheight[y-1][x+1] = mapheight[y-1][x+1] - 1
			end
			if mapheight[y][x+1] > 1 then
				mapheight[y][x+1] = mapheight[y][x+1] - 1
			end
			if mapheight[y+1][x+1] > 1 then
				mapheight[y+1][x+1] = mapheight[y+1][x+1] - 1
			end
		end
	end
    
    
    --------------------
    --------------------
    --------------------
    
    
    --Make dynamic lighting keep moving outwards uphill until it reaches a peak and starts going downwards. 
	--^^Makes more sense than current method. Can do this by storing previous height value and seeing if the 
	--^^new one is lower. Only break the for loop if the next step outwards is lower than the previous one. 
    
    
    if lighting == true and cave == true then
		--I don't know why this part isn't using x/yrange or x/yrangenorm but it seems to work. Will look into this.
		character.xpos = roundnum(character.x / tilesize)
		character.ypos = roundnum(character.y / tilesize)

		--All sorts of trigonometry to determine the dynamic lighting effect around the character.
		--It honestly makes no sense to me any more. 
		resolution = 500
		for rotation = 1, resolution do
			heightval = 0
			for distance = 1, sightradius do
				theta = 6.28 / 100 * rotation + 0.005
				xdist = math.ceil(math.sin(theta)*distance)
				ydist = math.ceil(math.cos(theta)*distance)
				
				if rotation <= resolution * 0.25 then
					if character.ypos - ydist > ymin and character.ypos - ydist < ymax and character.xpos + xdist > xmin and character.xpos + xdist < xmax then	
						if map[character.ypos - ydist][character.xpos + xdist] > map[character.ypos][character.xpos]+2 then
							mapblocked[character.ypos - ydist][character.xpos + xdist].blocked = true
							break
						else
							mapblocked[character.ypos - ydist][character.xpos + xdist].blocked = false
							minimap[character.ypos - ydist][character.xpos + xdist].mapvisible = true
						end
					end
				elseif rotation <= resolution * 0.5 then
					if character.ypos - math.abs(ydist) > ymin and character.ypos - math.abs(ydist) < ymax and character.xpos - xdist > xmin and character.xpos - xdist < xmax then
						if map[character.ypos - math.abs(ydist)][character.xpos - xdist] > map[character.ypos][character.xpos]+2 then
							mapblocked[character.ypos - math.abs(ydist)][character.xpos - xdist].blocked = true
							break
						else
							mapblocked[character.ypos - math.abs(ydist)][character.xpos - xdist].blocked = false
							minimap[character.ypos - math.abs(ydist)][character.xpos - xdist].mapvisible = true
						end
					end
				elseif rotation <= resolution * 0.75 then
					if character.ypos + math.abs(ydist) > ymin and character.ypos + math.abs(ydist) < ymax and character.xpos - math.abs(xdist) > xmin and character.xpos - math.abs(xdist) < xmax then	
						if map[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)] > map[character.ypos][character.xpos]+2 then
							mapblocked[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].blocked = true
							break
						else
							mapblocked[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].blocked = false
							minimap[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].mapvisible = true
						end
					end
				elseif rotation <= resolution then
					if character.ypos + ydist > ymin and character.ypos + ydist < ymax and character.xpos + math.abs(xdist) > xmin and character.xpos + math.abs(xdist) < xmax then	
						if map[character.ypos + ydist][character.xpos + math.abs(xdist)] > map[character.ypos][character.xpos]+2 then
							mapblocked[character.ypos + ydist][character.xpos + math.abs(xdist)].blocked = true
							break
						else
							mapblocked[character.ypos + ydist][character.xpos + math.abs(xdist)].blocked = false
							minimap[character.ypos + ydist][character.xpos + math.abs(xdist)].mapvisible = true
						end
					end
				end
			end
		end
	end
	
	
	
	
	
	
    
    --[[
    for y = character.ypos - sightradius, character.ypos - sightradius do
		for x = character.xpos - sightradius, character.xpos - sightradius do
			
		end
	end
	--]]
    
end


function love.draw()
	
	camera:set()
	--Pretty straightforward code to determine what tiles to draw on the screen
	love.graphics.setColor(0,0,0,255)
	for x=xrangenorm-13,xrangenorm +13 do
		for y=yrangenorm-13,yrangenorm +13 do
			if y > ymin and y < ymax and x > xmin and x < xmax then
				--map[x][y]=math.random(0,3)
				if mapblocked[y][x].blocked == false or lighting == false or cave == false then
					if map[y][x]>=0 then
						if map[y][x]==1 then
							love.graphics.setColor(mapheight[y][x]*3+200,mapheight[y][x]*3+200,mapheight[y][x]*3+200,255)
							love.graphics.draw(water,x*tilesize, y*tilesize)
						elseif map[y][x]==2 then
							--love.graphics.setColor(mapheight[y][x]*3+180,mapheight[y][x]*3+180,mapheight[y][x]*3+180,255)
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.draw(grass,x*tilesize, y*tilesize)	
						elseif map[y][x]==3 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.draw(tree,x*tilesize, y*tilesize)
						elseif map[y][x]==4 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.draw(beach,x*tilesize, y*tilesize)
						elseif map[y][x]==5 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.draw(horiBridge,x*tilesize, y*tilesize)
						elseif map[y][x]==6 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.draw(vertBridge,x*tilesize, y*tilesize)
						elseif map[y][x]==7 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.draw(waterLadder,x*tilesize, y*tilesize)
						elseif map[y][x]==8 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.draw(longGrass,x*tilesize, y*tilesize)
						else 
							love.graphics.setColor(0,255,0,255)
							love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
						end
						
					end
				else
					if map[y][x]<=10 then
							love.graphics.setColor(map[y][x]*3+100,map[y][x]*3+100,map[y][x]*3+100,255)
							love.graphics.draw(water,x*tilesize, y*tilesize)
						elseif map[y][x]<=50 then
							love.graphics.setColor(255-map[y][x]*3-100,255-map[y][x]*3-100,255-map[y][x]*3-100,255)
							love.graphics.draw(grass,x*tilesize, y*tilesize)
						else
							love.graphics.setColor(0,255,0,255)
							love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
						end
					--love.graphics.setColor(0,0,0,90)
					--love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
				end
				
				--love.graphics.print(mapheight[y][x], x*tilesize +10, y*tilesize+10)
				
				mapblocked[y][x].blocked = true
			end
		end
	end
	
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(characterimg,character.x,character.y)
	
	
	--love.graphics.draw(mapcanvas)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 585+camera.x, camera.y, 215, 215)
	love.graphics.setColor(255,255,255,255)
	minimapcanvas:setFilter("nearest", "nearest")
	minimapquad = love.graphics.newQuad(xrange - 26, yrange - 26, 51, 51, 500,500)
	love.graphics.drawq(minimapcanvas, minimapquad,590+camera.x, 5+camera.y,0,4,4)
	
	
	--minimapdraw=false
	if minimapdraw==true then
		love.graphics.setColor(0,0,0,255)
		--love.graphics.line(camera.x+150, camera.y+150,camera.x+650,camera.y+150,camera.x+650,camera.y+650,camera.x+150,camera.y+650,camera.x+150,camera.y+150)
		love.graphics.rectangle("line",camera.x+149, camera.y+149,503,503)
		love.graphics.setColor(255,255,255,180)
		--love.graphics.rectangle("fill", 585+camera.x, camera.y, 215, 215)
		love.graphics.draw(minimapcanvas, camera.x +150, camera.y +150)
		love.graphics.setColor(255,0,0,255)
		love.graphics.circle("fill",xrange+camera.x+150, yrange+camera.y+150,3,10)
		--[[
		--MINIMAP DRAWING
		for x=0,50 do
			for y=0,50 do
				if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
						if map[y+yrangenorm-25][x+xrangenorm-25]>=0 then
							if map[y+yrangenorm-25][x+xrangenorm-25]==1 then
								love.graphics.setColor(65,150,240,255)
							elseif map[y+yrangenorm-25][x+xrangenorm-25]==2 or map[y+yrangenorm-25][x+xrangenorm-25]==8 then
								love.graphics.setColor(75,190,60,255)
							elseif map[y+yrangenorm-25][x+xrangenorm-25]==5 or map[y+yrangenorm-25][x+xrangenorm-25]==6 then
								love.graphics.setColor(120,95,0,255)
							elseif map[y+yrangenorm-25][x+xrangenorm-25]==4 then
								love.graphics.setColor(220,210,120,255)
							elseif map[y+yrangenorm-25][x+xrangenorm-25]==3 then
								love.graphics.setColor(55,170,40,255)
							else
								love.graphics.setColor(0,255,0,255)
							end
							love.graphics.rectangle("fill",x*minimapsize+590+camera.x,y*minimapsize+5 + camera.y,minimapsize,minimapsize)
						end
					--end
				end
			end
		end]]
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Minimap on", 150 +camera.x, 10+camera.y)
	else
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Minimap off", 150 +camera.x, 10+camera.y)
	end
	
	
	
	
	
	
	--A bunch of stats displayed on screen to make things easier to debug
	love.graphics.setColor(255,255,255,255)

	--love.graphics.draw(,x*tilesize, y*tilesize)
	
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10+math.floor(camera.x), 10+math.floor(camera.y))

	love.graphics.print("Xrange: "..tostring(xrange), 10+math.floor(camera.x), 50+math.floor(camera.y))
	love.graphics.print("Yrange: "..tostring(yrange), 10+math.floor(camera.x), 70+math.floor(camera.y))
	
	love.graphics.print("Xrangenorm: "..tostring(xrangenorm), 10+math.floor(camera.x), 90+math.floor(camera.y))
	love.graphics.print("Yrangenorm: "..tostring(yrangenorm), 10+math.floor(camera.x), 110+math.floor(camera.y))
	
	mapx, mapy = love.mouse.getPosition()
	love.graphics.print("Xmouse: "..tostring(mapx), 10+math.floor(camera.x), 130+math.floor(camera.y))
	love.graphics.print("Ymouse: "..tostring(mapy), 10+math.floor(camera.x), 150+math.floor(camera.y))
	
	
	--love.timer.sleep(0.5)
	
	camera:unset()
	
	
end


function roundnum (int)
	if int - math.floor(int) >= 0.5 then
		return math.ceil(int)
	else
		return math.floor(int)
	end
end








