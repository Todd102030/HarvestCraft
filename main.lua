
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


function love.load()
	
	characterimg = love.graphics.newImage("resources/tiles/character.png")
	water = love.graphics.newImage("resources/tiles/Water.jpg")
	grass = love.graphics.newImage("resources/tiles/Grass.jpg")
	tree = love.graphics.newImage("resources/tiles/Tree.jpg")
	horiBridge = love.graphics.newImage("resources/tiles/HoriBridge.jpg")
	vertBridge = love.graphics.newImage("resources/tiles/VertBridge.jpg")

	love.window.setCaption("Terrain Generation Alpha")
	love.window.setMode(800,800)

	--length/width of map and tile squares 
	minimapsize = 2
	tilesize = 32

	--main character
	character = {}
	character.x = 400
	character.y = 400
	
	--variables to aid in making the camera follow the character; xrange
	xrange = character.x / tilesize
	yrange = character.y / tilesize
	
	
	--variable that determines whether or not to use the lighting engine
	cave = false
	

	--outermost range of map array
	xmin = 0
	ymin = 0
	xmax = 500
	ymax = 500
	
	--radius of dynamic lighting around player
	sightradius = 16
	
	
	
	minimapdraw = true
	lighting = false
	
	togglecount = 0
	
	--initialize a bunch of grids
	map={}
	mapblocked={}
	minimap={}
	for i=ymin,ymax do
		map[i]={}
		mapblocked[i]={}
		minimap[i]={}
		for n=xmin,xmax do
			mapblocked[i][n] = {}
			map[i][n]=0
			minimap[i][n]={}
			minimap[i][n].mapvisible = false
			
		end
	end
	
	--basic terrain generation algorithm
	--needs more detail
	for i=1,1000 do
		mapy = math.random(ymin,ymax)
		mapx = math.random(xmin,xmax)
		map[mapy][mapx]=math.random(1,20)
		
		xrand = math.random(4,10)
		yrand = math.random(4,10)
		
		for y = mapy - yrand, mapy + yrand do
			for x = mapx - xrand, mapx + xrand do
				if y > ymin and y < ymax and x > xmin and x < xmax then
					--[[if xrand > yrand then
						radiussize = xrand
					else
						radiussize = yrand
					end
					radius = radiussize + 1 - (math.floor(math.sqrt(math.pow(mapy - y,2) + math.pow(mapx - x,2)))) 
					]]--
					if xrand > yrand then
						radiussize = xrand
					else
						radiussize = yrand
					end
					
					radius = radiussize + 1 - (math.floor(math.sqrt(math.pow(mapy - y,2) + math.pow(mapx - x,2)))) 
					--[[if xrand > yrand then
						radius = radius * (yrand/xrand)
					else
						radius = radius * (xrand/yrand)
					end]]--
					
					
					if mapx == x and mapy == y then
						map[y][x] = map[y-1][x]
					else
						map[y][x] = map[y][x] + radius
					end
					if map[y][x] < 0 then
						map[y][x] = 0
					end
				end
			end
		end
		
		
		
		
			
		--end
	end
		
	for i=1,1000 do
	--drawBridge = false
	--while drawBridge == false do 
		foundGround = false
		while foundGround == false do
			mapy = math.random(ymin,ymax)
			mapx = math.random(xmin,xmax)
			if map[mapy][mapx]>10 then
				foundGround = true
			end
		end
		
		--startBridgex = mapx
		--startBridgey = mapy
		madeBridge = false
		previousGround = 200
		startBridgex = 0
		startBridgey = 0
		endBridgex = 0
		endBridgey = 0
		for num = 1,25 do
			randbridge = math.random(2)
			if randbridge == 1 then
				if mapy > ymin and mapy < ymax and mapx + num > xmin and mapx + num < xmax then
					if previousGround >10 and map[mapy][mapx+num] <=10 then
						startBridgex = mapx+num
						startBridgey = mapy
						previousGround = map[mapy][mapx+num]
					end
					if madeBridge == false and map[mapy][mapx+num]>10 and previousGround < 50 then
						madeBridge = true
						endBridgex = mapx+num
						endBridgey = mapy
						drawBridge = true
						bridgeOrientation = 0 
						
					end
				end
			
			else
				if mapy + num > ymin and mapy + num < ymax and mapx > xmin and mapx < xmax then
					if previousGround >10 and map[mapy+num][mapx] <=10 then
						startBridgex = mapx
						startBridgey = mapy+num
						previousGround = map[mapy+num][mapx]
					end
					if madeBridge == false and map[mapy+num][mapx]>10 and previousGround < 50 then
						madeBridge = true
						endBridgex = mapx
						endBridgey = mapy+num
						drawBridge = true
						bridgeOrientation = 1
						
					end
				end
			end
			
			--[[elseif mapy - num > ymin and mapy - num < ymax and mapx > xmin and mapx < xmax then
				if previousGround >10 and map[mapy-num][mapx] <=10 then
					startBridgex = mapx
					startBridgey = mapy-num
					previousGround = map[mapy-num][mapx]
				end
				if madeBridge == false and map[mapy-num][mapx]>10 and previousGround < 50 then
					madeBridge = true
					endBridgex = mapx
					endBridgey = mapy-num
					drawBridge = true
					
				end
			
		
			elseif mapy > ymin and mapy < ymax and mapx - num > xmin and mapx - num < xmax then
				if previousGround >10 and map[mapy][mapx-num] <=10 then
					startBridgex = mapx-num
					startBridgey = mapy
					previousGround = map[mapy][mapx-num]
				end
				if madeBridge == false and map[mapy][mapx-num]>10 and previousGround < 50 then
					madeBridge = true
					endBridgex = mapx-num
					endBridgey = mapy
					drawBridge = true
					
				end
			end]]--
		end
		
			
		
		if drawBridge == true and bridgeOrientation == 0 then
			for y = startBridgey, endBridgey do
				for x = startBridgex, endBridgex do
					map[y][x] = 101
				end
			end
			drawBridge = false
		elseif drawBridge == true and bridgeOrientation == 1 then
			for y = startBridgey, endBridgey do
				for x = startBridgex, endBridgex do
					map[y][x] = 102
				end
			end
			drawBridge = false
		end
		
		
		
	end
	
	
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
	
	--Makes character move based on Delta t so movement is the same no matter the framerate
	charspeed = 350*dt
	
	togglecount = togglecount + dt
	
	--Character movement, pretty straightforward
	if love.keyboard.isDown("right") then 
		character.x = character.x + charspeed
		
    end
	if love.keyboard.isDown("left") then 
		character.x = character.x - charspeed
		
    end
    if love.keyboard.isDown("up") then 
		character.y = character.y - charspeed
		
    end
    if love.keyboard.isDown("down") then 
		character.y = character.y + charspeed
		
    end
    
    --Keeps character bound within a certain area of the screen
    if character.y > 450+camera.y then
		camera.y = camera.y + charspeed
		character.y = 450+camera.y
	end
	if character.y < 350+camera.y then
		camera.y = camera.y - charspeed
		character.y = 350+camera.y
	end
	if character.x > 450+camera.x then
		camera.x = camera.x + charspeed
		character.x = 450+camera.x
		
	end
	if character.x < 350+camera.x then
		camera.x = camera.x - charspeed
		character.x = 350+camera.x
	end
    
    --xrange and yrange are variables that show where the character is
    --on the full map
    xrangefloat= character.x / tilesize
	xrange = math.floor(xrangefloat)
    
    yrangefloat= character.y / tilesize
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
			if map[y-1][x] < 25 then
				map[y-1][x] = map[y-1][x] + 1
			end
			if map[y][x] < 25 then
				map[y][x] = map[y][x] + 1
			end
			if map[y+1][x] < 25 then
				map[y+1][x] = map[y+1][x] + 1
			end
			if map[y-1][x-1] < 25 then
				map[y-1][x-1] = map[y-1][x-1] + 1
			end
			if map[y][x-1] < 25 then
				map[y][x-1] = map[y][x-1] + 1
			end
			if map[y+1][x-1] < 25 then
				map[y+1][x-1] = map[y+1][x-1] + 1
			end
			if map[y-1][x+1] < 25 then
				map[y-1][x+1] = map[y-1][x+1] + 1
			end
			if map[y][x+1] < 25 then
				map[y][x+1] = map[y][x+1] + 1
			end
			if map[y+1][x+1] < 25 then
				map[y+1][x+1] = map[y+1][x+1] + 1
			end
		end
		
	end
	
	if love.mouse.isDown("r") then
		xmouse, ymouse = love.mouse.getPosition()
		--map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]=map[math.floor(mapy/tilesize)+yrange - 20][math.floor(mapx/tilesize)+xrange - 20]+3
		
		y = math.floor((camera.y + ymouse) / tilesize)---yrangenorm --math.floor(mapy/tilesize)+yrangenorm-tilesize
		x = math.floor((camera.x + xmouse) / tilesize)---xrangenorm --math.floor(mapx/tilesize)+xrangenorm-tilesize
		if y > ymin and y < ymax and x > xmin and x < xmax then
			if map[y-1][x] > 1 then
				map[y-1][x] = map[y-1][x] - 1
			end
			if map[y][x] > 1 then
				map[y][x] = map[y][x] - 1
			end
			if map[y+1][x] > 1 then
				map[y+1][x] = map[y+1][x] - 1
			end
			if map[y-1][x-1] > 1 then
				map[y-1][x-1] = map[y-1][x-1] - 1
			end
			if map[y][x-1] > 1 then
				map[y][x-1] = map[y][x-1] - 1
			end
			if map[y+1][x-1] > 1 then
				map[y+1][x-1] = map[y+1][x-1] - 1
			end
			if map[y-1][x+1] > 1 then
				map[y-1][x+1] = map[y-1][x+1] - 1
			end
			if map[y][x+1] > 1 then
				map[y][x+1] = map[y][x+1] - 1
			end
			if map[y+1][x+1] > 1 then
				map[y+1][x+1] = map[y+1][x+1] - 1
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
						if map[y][x]<=10 then
							love.graphics.setColor(map[y][x]*3+200,map[y][x]*3+200,map[y][x]*3+200,255)
							love.graphics.draw(water,x*tilesize, y*tilesize)
						elseif map[y][x]<=50 then
							love.graphics.setColor(255-map[y][x]*3,255-map[y][x]*3,255-map[y][x]*3,255)
							love.graphics.draw(grass,x*tilesize, y*tilesize)
						else
							love.graphics.setColor(0,255,0,255)
							love.graphics.rectangle("fill",x*tilesize,y*tilesize,tilesize,tilesize)
						end
						if map[y][x]==13 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.draw(tree,x*tilesize, y*tilesize)
						elseif map[y][x]==101 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.draw(horiBridge,x*tilesize, y*tilesize)
						elseif map[y][x]==102 then
							love.graphics.setColor(210,210,210,255)
							love.graphics.draw(vertBridge,x*tilesize, y*tilesize)
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
				
				mapblocked[y][x].blocked = true
			end
		end
	end
	--minimapdraw=false
	if minimapdraw==true then
	
		love.graphics.setColor(0,0,0,255)
		love.graphics.rectangle("fill", 590+camera.x, 5+camera.y, 210, 210)
		
		
		--MINIMAP DRAWING
		for x=0,100,3 do
			for y=0,100,3 do
				if y+yrangenorm-50 > ymin and y+yrangenorm-50 < ymax and x+xrangenorm-50 > xmin and x+xrangenorm-50 < xmax then
					--if minimap[y+yrange-50][x+xrange-50].mapvisible == true then
						if map[y+yrangenorm-50][x+xrangenorm-50]>=0 then
							if map[y+yrangenorm-50][x+xrangenorm-50]<=10 then
								love.graphics.setColor(0,0,200,255)
							elseif map[y+yrangenorm-50][x+xrangenorm-50]<=50 then
								love.graphics.setColor(140,200,80,255)
							else
								love.graphics.setColor(0,255,0,255)
							end
							love.graphics.rectangle("fill",x*minimapsize+595+camera.x,y*minimapsize+5 + camera.y,minimapsize*3,minimapsize*3)
						end
					--end
				end
			end
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Minimap on", 150 +camera.x, 10+camera.y)
	else
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Minimap off", 150 +camera.x, 10+camera.y)
	end
	--A bunch of stats displayed on screen to make things easier to debug
	love.graphics.setColor(255,255,255,255)
	--love.graphics.draw(,x*tilesize, y*tilesize)
	love.graphics.draw(characterimg,character.x,character.y)
	
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

