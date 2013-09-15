
--THINGS TO DO
--//Make tilesize adjustable without breaking everything //SEEMS FIXED
--Make graphics for each height level; dark water, light water, sand, grass, dirt, rock, snow
--Fix the radiuses on the terrain gen
--Fix the out of bounds errors
--//Fix painting so that it normalizes properly and stops getting out of line with the mouse.
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
	
	iconimg = love.image.newImageData("resources/tiles/character.png")
	characterimg = love.graphics.newImage("resources/tiles/character.png")
	
	sprites = love.graphics.newImage("resources/tiles/Spritesheet.png")
	charSprite = love.graphics.newImage("resources/tiles/characterSprite.png")
	
	charUp = love.graphics.newQuad(2*32, 0*32, 32, 32, 128,32)
	charDown = love.graphics.newQuad(3*32, 0*32, 32, 32, 128,32)
	charLeft = love.graphics.newQuad(1*32, 0*32, 32, 32, 128,32)
	charRight = love.graphics.newQuad(0*32, 0*32, 32, 32, 128,32)
	
	char=charUp
	
	grass = love.graphics.newQuad(0*32, 0*32, 32, 32, 640,128)
	water1 = love.graphics.newQuad(1*32, 0*32, 32, 32, 640,128)
	water2 = love.graphics.newQuad(1*32, 0*32, 32, 32, 640,128)
	water3 = love.graphics.newQuad(1*32, 0*32, 32, 32, 640,128)
	water4 = love.graphics.newQuad(1*32, 0*32, 32, 32, 640,128)
	beach = love.graphics.newQuad(2*32, 0*32, 32, 32, 640,128)
	tree = love.graphics.newQuad(0*32, 1*32, 32, 32, 640,128)
	longGrass = love.graphics.newQuad(6*32, 0*32, 32, 32, 640,128)
	horiBridge = love.graphics.newQuad(0*32, 3*32, 32, 32, 640,128)
	vertBridge = love.graphics.newQuad(1*32, 3*32, 32, 32, 640,128)
	waterLadder = love.graphics.newQuad(2*32, 3*32, 32, 32, 640,128)
	
	fence = love.graphics.newQuad(0*32, 2*32, 32, 32, 640,128)
	fence1 = love.graphics.newQuad(1*32, 2*32, 32, 32, 640,128)
	fence2 = love.graphics.newQuad(3*32, 2*32, 32, 32, 640,128)
	fence3 = love.graphics.newQuad(2*32, 2*32, 32, 32, 640,128)
	fence4 = love.graphics.newQuad(4*32, 2*32, 32, 32, 640,128)
	fence12 = love.graphics.newQuad(7*32, 2*32, 32, 32, 640,128)
	fence23 = love.graphics.newQuad(9*32, 2*32, 32, 32, 640,128)
	fence34 = love.graphics.newQuad(10*32, 2*32, 32, 32, 640,128)
	fence41 = love.graphics.newQuad(8*32, 2*32, 32, 32, 640,128)
	fence13 = love.graphics.newQuad(5*32, 2*32, 32, 32, 640,128)
	fence24 = love.graphics.newQuad(6*32, 2*32, 32, 32, 640,128)
	fence123 = love.graphics.newQuad(14*32, 2*32, 32, 32, 640,128)
	fence234 = love.graphics.newQuad(11*32, 2*32, 32, 32, 640,128)
	fence341 = love.graphics.newQuad(12*32, 2*32, 32, 32, 640,128)
	fence412 = love.graphics.newQuad(13*32, 2*32, 32, 32, 640,128)
	fence1234 = love.graphics.newQuad(15*32, 2*32, 32, 32, 640,128)
	
	fenceType = fence
	water=water1
	--[[
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
	]]
	love.window.setCaption("HarvestCraft Alpha")
	love.window.setIcon(iconimg)
	--love.window.setMode(tonumber(arg[2]),tonumber(arg[3]),{vsync = false, resizable=true})
	xwindow = 800
	ywindow = 800
	
	love.window.setMode(xwindow,ywindow,{vsync = false})
	
	
	
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
	cave = true
	

	--outermost range of map array
	xmin = 0
	ymin = 0
	xmax = 500
	ymax = 500
	
	--radius of dynamic lighting around player
	sightradius = 8
	
	
	xdungeon = 100
	ydungeon = 100
	countdungeon=0
	
	
	minimapcanvas = love.graphics.newCanvas(500,500)
	mapcanvas = love.graphics.newCanvas(1000,1000)
	
	
	
	mousewheelitem = 1
	wheelitemcount = 255
	
	
	minimapdraw = false
	lighting = false
	dungeon = false
	
	
	maptypetoggle = false
	mapheighttoggle = false
	objectmaptoggle = false
	drawgui = true
	drawstats = true
	
	renderSize = 10
	
	watercount = 0
	togglecount = 0
	
	--initialize a bunch of grids
	map={}
	mapblocked={}
	minimap={}
	mapheight={}
	objectmap={}
	for i=ymin,ymax do
		map[i]={}
		mapblocked[i]={}
		minimap[i]={}
		mapheight[i]={}
		objectmap[i]={}
		for n=xmin,xmax do
			mapblocked[i][n] = {}
			map[i][n]=1
			mapheight[i][n]=1
			minimap[i][n]={}
			minimap[i][n].mapvisible = false
			objectmap[i][n]=0
		end
	end
	
	
	genComplexDungeons(15,75,75,0)
	
	
	--genIslands(1200)
	--genBridges(400)
	--genPonds(100)	
	--genTrees(20000)
	--genLongGrass(7000)
	
	genLinearDungeons(75,175,75,0)
	
	
	
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
	
	
	
	
	
	--[[love.graphics.setCanvas(minimapcanvas)
		minimapcanvas:clear()
		--love.graphics.setColor(0,0,0,255)
		--love.graphics.rectangle("fill", 0,0,2010,2010)
		for x=xmin,xmax do
			for y=ymin,ymax do
				--if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
				--if map[y][x]>=0 then
				if map[y][x]==1 then
					love.graphics.setColor(65,150,240,255)
				elseif map[y][x]==2 then
					love.graphics.setColor(75,190,60,255)
				elseif map[y][x]==4 then
					love.graphics.setColor(220,210,120,255)
				else
					love.graphics.setColor(0,255,0,255)
				end
				if objectmap[y][x]==5 or objectmap[y][x]==6 then
					love.graphics.setColor(120,95,0,255)
				elseif objectmap[y][x]==3 then
					love.graphics.setColor(55,170,40,255)
				end
				love.graphics.rectangle("fill",x,y,1,1)
					--love.graphics.rectangle("fill",x,minimapsize,minimapsize)
				--end
					--end
				--end
			end
		end
	love.graphics.setCanvas()]]
	if madeupvariable == true then	
	if dungeon == true then	
		love.graphics.setCanvas(minimapcanvas)
			minimapcanvas:clear()
			--love.graphics.setColor(0,0,0,255)
			--love.graphics.rectangle("fill", 0,0,2010,2010)
			for x=xmin,xmax do
				for y=ymin,ymax do
					--if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
						--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
					--if map[y][x]>=0 then
					--[[if map[y][x]==1 then
						love.graphics.setColor(65,150,240,255)
					elseif map[y][x]==2 then
						love.graphics.setColor(75,190,60,255)
					elseif map[y][x]==4 then
						love.graphics.setColor(220,210,120,255)
					else
						love.graphics.setColor(0,255,0,255)
					end
					if objectmap[y][x]==5 or objectmap[y][x]==6 then
						love.graphics.setColor(120,95,0,255)
					elseif objectmap[y][x]==3 then
						love.graphics.setColor(55,170,40,255)
					end]]
					
					love.graphics.setColor(0,0,0,255)
					
					love.graphics.rectangle("fill",x,y,1,1)
						--love.graphics.rectangle("fill",x--[[*minimapsize]],y--[[*minimapsize]],minimapsize,minimapsize)
					--end
						--end
					--end
				end
			end
		love.graphics.setCanvas()
	else 
		updateMiniMap()
	end
	end
	
	
	--[[love.graphics.setCanvas(mapcanvas)
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
					
					--love.graphics.print(map[y][x], x*tilesize +10, y*tilesize+10)
					
					mapblocked[y][x].blocked = true
				end
			end
		end
	love.graphics.setCanvas()]]
	
	
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
	
	
	
	--xrange = math.floor((character.x + 16) / tilesize)
	--yrange = math.floor((character.y + 16) / tilesize)
	--and map[yrange][xrange] >=10 
	
	--Character movement, pretty straightforward
	if love.keyboard.isDown("d") then 
		--if map[yrange][math.floor((character.x + 16 + charspeed) / tilesize)] ==2 then
			character.x = character.x + charspeed
		--end
		char = charRight
    end
	if love.keyboard.isDown("a") then 
		--if map[yrange][math.floor((character.x + 16 - charspeed) / tilesize)] ==2 then
			character.x = character.x - charspeed
		--end
		char = charLeft
    end
    if love.keyboard.isDown("w") then 
		--if map[math.floor((character.y + 16 - charspeed) / tilesize)][xrange] ==2 then
			character.y = character.y - charspeed
		--end
		char = charUp
    end
    if love.keyboard.isDown("s") then 
		--if map[math.floor((character.y + 16 + charspeed) / tilesize)][xrange] ==2 then
			character.y = character.y + charspeed
		--end
		char = charDown
    end
    
    --Keeps character bound within a certain area of the screen
    if character.y > camera.y + (love.window.getHeight()*0.75) then
		camera.y = roundnum(camera.y + charspeed)
		character.y = camera.y + (love.window.getHeight()*0.75)
	end
	if character.y < camera.y + (love.window.getHeight()*0.25) then
		camera.y = roundnum(camera.y - charspeed)
		character.y = camera.y + (love.window.getHeight()*0.25)
	end
	if character.x > camera.x + (love.window.getWidth()*0.75) then
		camera.x = roundnum(camera.x + charspeed)
		character.x = camera.x + (love.window.getWidth()*0.75)
		
	end
	if character.x < camera.x + (love.window.getWidth()*0.25) then
		camera.x = roundnum(camera.x - charspeed)
		character.x = camera.x + (love.window.getWidth()*0.25)
	end
    
    --xrange and yrange are variables that show where the character is
    --on the full map
    xrangefloat= (character.x + 16) / tilesize
	xrange = math.floor(xrangefloat)
    
    yrangefloat= (character.y + 16) / tilesize
	yrange = math.floor(yrangefloat)
	
	--these will be 
	xrangenorm = math.floor((camera.x+love.window.getWidth()/2)/tilesize)
	yrangenorm = math.floor((camera.y+love.window.getHeight()/2)/tilesize)
	--[[
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
	]]
	
	
	
	
	
	
	
	
	
	if love.keyboard.isDown("m") then 
		if minimapdraw == true and maptoggle == false then
			minimapdraw = false
		elseif minimapdraw == false and maptoggle == false then
			minimapdraw = true
		end
		maptoggle=true
	else
		maptoggle = false
	end
	
	
	if love.keyboard.isDown("z") then 
		if maptypetoggle == true and maptoggle1 == false then
			maptypetoggle = false
		elseif maptypetoggle == false and maptoggle1 == false then
			maptypetoggle = true
		end
		maptoggle1=true
	else
		maptoggle1 = false
	end
	
	if love.keyboard.isDown("x") then 
		if mapheighttoggle == true and maptoggle2 == false then
			mapheighttoggle = false
		elseif mapheighttoggle == false and maptoggle2 == false then
			mapheighttoggle = true
		end
		maptoggle2=true
	else
		maptoggle2 = false
	end
	
	if love.keyboard.isDown("c") then 
		if objectmaptoggle == true and maptoggle3 == false then
			objectmaptoggle = false
		elseif objectmaptoggle == false and maptoggle3 == false then
			objectmaptoggle = true
		end
		maptoggle3=true
	else
		maptoggle3 = false
	end
	
	
	if love.keyboard.isDown("f") then 
		if drawstats == true and maptoggle4 == false then
			drawstats = false
		elseif drawstats == false and maptoggle4 == false then
			drawstats = true
		end
		maptoggle4=true
	else
		maptoggle4 = false
	end
	
	
	if love.keyboard.isDown("g") then 
		if drawgui == true and maptoggle5 == false then
			drawgui = false
		elseif drawgui == false and maptoggle5 == false then
			drawgui = true
		end
		maptoggle5=true
	else
		maptoggle5 = false
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
    --[[
    
    if love.mouse.isDown("wd") then
		mousewheelitem = mousewheelitem -1
		if mousewheelitem < 1 then
			mousewheelitem = 8
		end
	end
	if love.mouse.isDown("wu") then
		mousewheelitem = mousewheelitem +1
		if mousewheelitem >8 then
			mousewheelitem = 1
		end
	end
    
    ]]
    
    wheelitemcount = math.floor(wheelitemcount - (dt*200))
    
    if wheelitemcount < 0 then
		wheelitemcount = 0
	end
    
    if love.mouse.isDown("l") then
		xmouse, ymouse = love.mouse.getPosition()
		y = math.floor((camera.y + ymouse) / tilesize)---yrangenorm --math.floor(mapy/tilesize)+yrangenorm-tilesize
		x = math.floor((camera.x + xmouse) / tilesize)---xrangenorm --math.floor(mapx/tilesize)+xrangenorm-tilesize
		if y > ymin and y < ymax and x > xmin and x < xmax then
			--if y ~= yrange and x ~= xrange then
				love.graphics.setCanvas(minimapcanvas)
					if mousewheelitem==1 then
						map[y][x] = mousewheelitem
						love.graphics.setColor(65,150,240,255)
					elseif mousewheelitem==2 then
						map[y][x] = mousewheelitem
						love.graphics.setColor(75,190,60,255)
					elseif mousewheelitem==5 or mousewheelitem==6 then
						objectmap[y][x] = mousewheelitem
						love.graphics.setColor(120,95,0,255)
					elseif mousewheelitem==4 then
						map[y][x] = mousewheelitem
						love.graphics.setColor(220,210,120,255)
					elseif mousewheelitem==3 then
						objectmap[y][x] = mousewheelitem
						love.graphics.setColor(55,170,40,255)
					elseif mousewheelitem==7 then
						objectmap[y][x] = 0
						love.graphics.setColor(55,170,40,255)
					elseif mousewheelitem==8 then
						objectmap[y][x] = mousewheelitem
						love.graphics.setColor(55,170,40,255)
					elseif mousewheelitem==9 then
						objectmap[y][x] = mousewheelitem
						love.graphics.setColor(55,170,40,255)
						--updateFence(x, y)
					else
						love.graphics.setColor(0,255,0,255)
					end
					if objectmap[y][x] == 0 then
						love.graphics.rectangle("fill",x,y,1,1)
					end
				love.graphics.setCanvas()
			--end
		end
	end
		
    --[[
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
		
	end]]
	
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
    
    
    
    
    
    --genDungeons(2,xdungeon,ydungeon,0)
    
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
				
				--[[if rotation <= resolution * 0.25 then
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
				end]]
				if rotation <= resolution * 0.25 then
					if character.ypos - ydist > ymin and character.ypos - ydist < ymax and character.xpos + xdist > xmin and character.xpos + xdist < xmax then	
						if map[character.ypos - ydist][character.xpos + xdist] ~=2 then
							mapblocked[character.ypos - ydist][character.xpos + xdist].blocked = true
							break
						else
							mapblocked[character.ypos - ydist][character.xpos + xdist].blocked = false
							minimap[character.ypos - ydist][character.xpos + xdist].mapvisible = true
						end
					end
				elseif rotation <= resolution * 0.5 then
					if character.ypos - math.abs(ydist) > ymin and character.ypos - math.abs(ydist) < ymax and character.xpos - xdist > xmin and character.xpos - xdist < xmax then
						if map[character.ypos - math.abs(ydist)][character.xpos - xdist] ~=2 then
							mapblocked[character.ypos - math.abs(ydist)][character.xpos - xdist].blocked = true
							break
						else
							mapblocked[character.ypos - math.abs(ydist)][character.xpos - xdist].blocked = false
							minimap[character.ypos - math.abs(ydist)][character.xpos - xdist].mapvisible = true
						end
					end
				elseif rotation <= resolution * 0.75 then
					if character.ypos + math.abs(ydist) > ymin and character.ypos + math.abs(ydist) < ymax and character.xpos - math.abs(xdist) > xmin and character.xpos - math.abs(xdist) < xmax then	
						if map[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)] ~= 2 then
							mapblocked[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].blocked = true
							break
						else
							mapblocked[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].blocked = false
							minimap[character.ypos + math.abs(ydist)][character.xpos - math.abs(xdist)].mapvisible = true
						end
					end
				elseif rotation <= resolution then
					if character.ypos + ydist > ymin and character.ypos + ydist < ymax and character.xpos + math.abs(xdist) > xmin and character.xpos + math.abs(xdist) < xmax then	
						if map[character.ypos + ydist][character.xpos + math.abs(xdist)] ~= 2 then
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
	
	
	love.graphics.setCanvas(minimapcanvas)
		--love.graphics.setColor(0,0,0,255)
		--love.graphics.rectangle("fill", 0,0,2010,2010)
		for x=xrangenorm-renderSize,xrangenorm +renderSize do
			for y=yrangenorm-renderSize,yrangenorm +renderSize do
				if y > ymin and y < ymax and x > xmin and x < xmax then
					--if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
					if mapblocked[y][x].blocked == false then
						--if map[y][x]>=0 then
						if map[y][x]==1 then
							love.graphics.setColor(65,150,240,255)
						elseif map[y][x]==2 then
							love.graphics.setColor(75,190,60,255)
						elseif map[y][x]==4 then
							love.graphics.setColor(220,210,120,255)
						else
							love.graphics.setColor(0,255,0,255)
						end
						if objectmap[y][x]==5 or objectmap[y][x]==6 then
							love.graphics.setColor(120,95,0,255)
						elseif objectmap[y][x]==3 then
							love.graphics.setColor(55,170,40,255)
						end
						
						love.graphics.rectangle("fill",x,y,1,1)
							--love.graphics.rectangle("fill",x--[[*minimapsize]],y--[[*minimapsize]],minimapsize,minimapsize)
						--end
							--end
						--end
					end
				end
			end
		end
	love.graphics.setCanvas()
	
	
	
    
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
	for x=xrangenorm-renderSize,xrangenorm +renderSize do
		for y=yrangenorm-renderSize,yrangenorm +renderSize do
			if y > ymin and y < ymax and x > xmin and x < xmax then
				--map[x][y]=math.random(0,3)
				if mapblocked[y][x].blocked == false or lighting == false or cave == false then
					if map[y][x]>=0 then
						if map[y][x]==1 then
							love.graphics.setColor(mapheight[y][x]*3+200,mapheight[y][x]*3+200,mapheight[y][x]*3+200,255)
							love.graphics.drawq(sprites,water,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==2 then
							--love.graphics.setColor(mapheight[y][x]*3+180,mapheight[y][x]*3+180,mapheight[y][x]*3+180,255)
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,grass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)	
						elseif map[y][x]==3 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,tree,x*tilesize, y*tilesize, 0, tilesize/32, tilesize/32)
						elseif map[y][x]==4 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,beach,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==5 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,horiBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==6 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,vertBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==7 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,waterLadder,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==8 then
							love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,longGrass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						else 
							love.graphics.setColor(0,255,0,255)
							love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
						end
						if objectmap[y][x]==5 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,horiBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==6 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,vertBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==3 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,tree,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==7 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,waterLadder,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==8 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,longGrass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==9 then
							love.graphics.setColor(210,210,210,255)
							--love.graphics.drawq(sprites,fence,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
							updateFence(x,y)
						end
					end
				else
					if map[y][x]>=0 then
						love.graphics.setColor(110,110,110,255)
						if map[y][x]==1 then
							--love.graphics.setColor(mapheight[y][x]*3+200,mapheight[y][x]*3+200,mapheight[y][x]*3+200,255)
							love.graphics.drawq(sprites,water,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==2 then
							--love.graphics.setColor(mapheight[y][x]*3+180,mapheight[y][x]*3+180,mapheight[y][x]*3+180,255)
							--love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,grass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)	
						elseif map[y][x]==3 then
							--love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,tree,x*tilesize, y*tilesize, 0, tilesize/32, tilesize/32)
						elseif map[y][x]==4 then
							--love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,beach,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==5 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,horiBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==6 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,vertBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==7 then
							--love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,waterLadder,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif map[y][x]==8 then
							--love.graphics.setColor(255-mapheight[y][x]*3,255-mapheight[y][x]*3,255-mapheight[y][x]*3,255)
							love.graphics.drawq(sprites,longGrass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						else 
							--love.graphics.setColor(0,255,0,255)
							love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
						end
						if objectmap[y][x]==5 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,horiBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==6 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,vertBridge,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==3 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,tree,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==7 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,waterLadder,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==8 then
							--love.graphics.setColor(210,210,210,255)
							love.graphics.drawq(sprites,longGrass,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
						elseif objectmap[y][x]==9 then
							--love.graphics.setColor(210,210,210,255)
							--love.graphics.drawq(sprites,fence,x*tilesize, y*tilesize,0,tilesize/32,tilesize/32)
							updateFence(x,y)
						end
					end
					--love.graphics.setColor(0,0,0,90)
					--love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
				end
				if maptypetoggle == true then
					love.graphics.setColor(255,0,0,255)
					love.graphics.print(map[y][x], x*tilesize +5, y*tilesize+10)
				end
				if mapheighttoggle == true then
					love.graphics.setColor(0,255,0,255)
					love.graphics.print(mapheight[y][x], x*tilesize +10, y*tilesize+10)
				end
				if objectmaptoggle == true then
					love.graphics.setColor(255,255,255,255)
					love.graphics.print(objectmap[y][x], x*tilesize +15, y*tilesize+10)
				end
				mapblocked[y][x].blocked = true
			end
		end
	end
	
	xmouse, ymouse = love.mouse.getPosition()
	y = math.floor((camera.y + ymouse) / tilesize)---yrangenorm --math.floor(mapy/tilesize)+yrangenorm-tilesize
	x = math.floor((camera.x + xmouse) / tilesize)---xrangenorm --math.floor(mapx/tilesize)+xrangenorm-tilesize
	if y > ymin and y < ymax and x > xmin and x < xmax then
		love.graphics.setColor(200,20,20,255)
		love.graphics.rectangle("line", x * tilesize, y*tilesize, tilesize, tilesize)
	end
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.drawq(charSprite,char,character.x,character.y)
	
	if drawgui == true then
		--love.graphics.draw(mapcanvas)
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill",camera.x + love.window.getWidth()-220, camera.y+5, 215, 215)
		love.graphics.setColor(255,255,255,200)
		minimapcanvas:setFilter("nearest", "nearest")
		minimapquad = love.graphics.newQuad(xrange - 26, yrange - 26, 51, 51, 500,500)
		love.graphics.drawq(minimapcanvas, minimapquad,camera.x + love.window.getWidth()-215, camera.y+10,0,4,4)
		
		
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle("fill",camera.x + love.window.getWidth()-280,camera.y+75,42,42)
		
		
		-----funfunfunfunfufnunfufnction
		displayMouseItem(mousewheelitem-1, wheelitemcount, camera.x + love.window.getWidth()-275, camera.y + 40)
		displayMouseItem(mousewheelitem, 255, camera.x + love.window.getWidth()-275, camera.y + 80)
		displayMouseItem(mousewheelitem+1, wheelitemcount, camera.x + love.window.getWidth()-275, camera.y + 120)
	end
	
	--minimapdraw=false
	if minimapdraw==true then
		love.graphics.setColor(0,0,0,255)
		--love.graphics.line(camera.x+150, camera.y+150,camera.x+650,camera.y+150,camera.x+650,camera.y+650,camera.x+150,camera.y+650,camera.x+150,camera.y+150)
		love.graphics.rectangle("line",camera.x+149, camera.y+249,503,503)
		love.graphics.setColor(255,255,255,180)
		--love.graphics.rectangle("fill", 585+camera.x, camera.y, 215, 215)
		love.graphics.draw(minimapcanvas, camera.x +150, camera.y +250)
		love.graphics.setColor(255,0,0,255)
		love.graphics.circle("fill",xrange+camera.x+150, yrange+camera.y+250,3,10)
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
	end
	
	
	
	
	
	if drawstats == true then
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
	end
	
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

function love.keypressed(button)
	if button == "9" then
		renderSize = renderSize - 1
	end
	if button == "0" then
		renderSize = renderSize + 1
	end
	if button == "1" then
		xwindow = xwindow - 50
		love.window.setMode(xwindow,ywindow,{vsync = false})
	end
	if button == "2" then
		xwindow = xwindow + 50
		love.window.setMode(xwindow,ywindow,{vsync = false})
	end
	if button == "3" then
		ywindow = ywindow - 50
		love.window.setMode(xwindow,ywindow,{vsync = false})
	end
	if button == "4" then
		ywindow = ywindow + 50
		love.window.setMode(xwindow,ywindow,{vsync = false})
	end
	if button == "u" then
		updateMiniMap()
	end
end

function love.mousepressed( x, y, button )
	if button == "wd" then
		mousewheelitem = mousewheelitem +1
		if mousewheelitem >9 then
			mousewheelitem = 1
		end
		wheelitemcount = 255
		--character.x = xrange * (tilesize-1)
		--character.y = yrange * (tilesize-1)
		--tilesize = tilesize - 1
		
	end
	if button == "wu" then
		mousewheelitem = mousewheelitem -1
		if mousewheelitem < 1 then
			mousewheelitem = 9
		end
		wheelitemcount = 255
		--character.x = xrange * (tilesize-1)
		--character.y = yrange * (tilesize-1)
		--tilesize = tilesize + 1
		
	end
end

function displayMouseItem (mousewheelitem, alpha, xpos, ypos)
	if mousewheelitem == 1 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,water,xpos,ypos)
	elseif mousewheelitem == 2 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,grass,xpos,ypos)
	elseif mousewheelitem == 3 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,tree,xpos,ypos)
	elseif mousewheelitem == 4 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,beach,xpos,ypos)
	elseif mousewheelitem == 5 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,horiBridge,xpos,ypos)
	elseif mousewheelitem == 6 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,vertBridge,xpos,ypos)
	elseif mousewheelitem == 7 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,waterLadder,xpos,ypos)
	elseif mousewheelitem == 8 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,longGrass,xpos,ypos)
	elseif mousewheelitem == 9 then
		love.graphics.setColor(255,255,255,alpha)
		love.graphics.drawq(sprites,fence,xpos,ypos)
	end
end

function updateFence(xpos, ypos)
	if objectmap[ypos-1][xpos] == 9 and objectmap[ypos+1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence1234,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence341,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos-1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence123,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos-1][xpos] == 9 and objectmap[ypos+1][xpos] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence412,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 and objectmap[ypos-1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 then
		love.graphics.drawq(sprites,fence234,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 then
		love.graphics.drawq(sprites,fence34,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos-1][xpos] == 9 and objectmap[ypos][xpos+1] == 9 then
		love.graphics.drawq(sprites,fence23,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence41,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos-1][xpos] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence12,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 and objectmap[ypos-1][xpos] == 9 then
		love.graphics.drawq(sprites,fence24,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos][xpos+1] == 9 and objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence13,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos+1][xpos] == 9 then
		love.graphics.drawq(sprites,fence4,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos-1][xpos] == 9 then
		love.graphics.drawq(sprites,fence2,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos][xpos+1] == 9 then
		love.graphics.drawq(sprites,fence3,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	elseif objectmap[ypos][xpos-1] == 9 then
		love.graphics.drawq(sprites,fence1,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	else
		love.graphics.drawq(sprites,fence,xpos*tilesize, ypos*tilesize,0,tilesize/32,tilesize/32)
	end
end


function updateMiniMap()
	love.graphics.setCanvas(minimapcanvas)
		minimapcanvas:clear()
		--love.graphics.setColor(0,0,0,255)
		--love.graphics.rectangle("fill", 0,0,2010,2010)
		for x=xmin,xmax do
			for y=ymin,ymax do
				--if y+yrangenorm-25 > ymin and y+yrangenorm-25 < ymax and x+xrangenorm-25 > xmin and x+xrangenorm-25 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
				--if map[y][x]>=0 then
				if map[y][x]==1 then
					love.graphics.setColor(65,150,240,255)
				elseif map[y][x]==2 then
					love.graphics.setColor(75,190,60,255)
				elseif map[y][x]==4 then
					love.graphics.setColor(220,210,120,255)
				else
					love.graphics.setColor(0,255,0,255)
				end
				if objectmap[y][x]==5 or objectmap[y][x]==6 then
					love.graphics.setColor(120,95,0,255)
				elseif objectmap[y][x]==3 then
					love.graphics.setColor(55,170,40,255)
				end
				love.graphics.rectangle("fill",x,y,1,1)
					--love.graphics.rectangle("fill",x,minimapsize,minimapsize)
				--end
					--end
				--end
			end
		end
	love.graphics.setCanvas()
end









