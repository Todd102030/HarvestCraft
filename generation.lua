
function genIslands(amount)
	--basic terrain generation algorithm
	--needs more detail
	for i=1,amount do
		mapy = math.random(ymin,ymax)
		mapx = math.random(xmin,xmax)
		mapheight[mapy][mapx]=math.random(1,8)
		
		xrand = math.random(5,15)
		--yrand = math.random(5,15)
		yrand=xrand
		
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
						mapheight[y][x] = mapheight[y-1][x]
					else
						mapheight[y][x] = mapheight[y][x] + radius
					end
					if mapheight[y][x] < 0 then
						mapheight[y][x] = 0
					end
					if mapheight[y][x] > 24 then
						mapheight[y][x] = 24
					end
					if mapheight[y][x] < 10 then
						map[y][x] = 1
					elseif mapheight[y][x] <= 24 then
						map[y][x] = 2
					end
					if mapheight[y][x] == 9 or mapheight[y][x] == 8 --[[or mapheight[y][x] == 7 or mapheight[y][x] == 6]] then
						map[y][x] = 4
					end
				end
				
			end
		end
	end
end


function genBridges(amount)
	for i=1,amount do
	--drawBridge = false
	--while drawBridge == false do 
		foundGround = false
		while foundGround == false do
			mapyBridge = math.random(ymin,ymax)
			mapxBridge = math.random(xmin,xmax)
			if map[mapyBridge][mapxBridge]==2 then
				foundGround = true
			end
		end
		
		--startBridgex = mapx
		--startBridgey = mapy
		startBridge = false
		madeBridge = false
		previousGround = map[mapyBridge][mapxBridge]
		startBridgex = 0
		startBridgey = 0
		endBridgex = 0
		endBridgey = 0
		--countBridge=0
		randbridge = math.random(2)
		if randbridge == 1 then
			for num = 1,25 do
				if mapyBridge > ymin and mapyBridge < ymax and mapxBridge + num > xmin and mapxBridge + num < xmax then
					--previousGround = map[mapyBridge][mapxBridge+num]
					if previousGround ==2 and startBridge == false then
						if map[mapyBridge][mapxBridge+num] ==1 or map[mapyBridge][mapxBridge+num] ==3 then
							startBridgex = mapxBridge+num -1
							startBridgey = mapyBridge
							previousGround = map[mapyBridge][mapxBridge+num]
							--map[mapy][mapx+num] = 101
							startBridge = true
						end
					end
					if madeBridge == false and previousGround ==1 then
						if map[mapyBridge][mapxBridge+num] ==2 or objectmap[mapyBridge][mapxBridge+num] ==5 or objectmap[mapyBridge][mapxBridge+num] ==6 then
							madeBridge = true
							endBridgex = mapxBridge+num-1
							endBridgey = mapyBridge
							drawBridge = true
							bridgeOrientation = 0 
							--map[mapy][mapx+num] = 102
							break
						end
					end
					--previousGround = map[mapyBridge][mapxBridge+num]
				end
			end
		else
			for num = 1,25 do
				if mapyBridge + num > ymin and mapyBridge + num < ymax and mapxBridge > xmin and mapxBridge < xmax then
					--previousGround = map[mapyBridge+num][mapxBridge]
					if previousGround ==2 and startBridge == false then
						if map[mapyBridge+num][mapxBridge] ==1 or map[mapyBridge+num][mapxBridge] ==3 then
							startBridgex = mapxBridge
							startBridgey = mapyBridge+num -1
							previousGround = map[mapyBridge+num][mapxBridge]
							--map[mapy][mapx+num] = 101
							startBridge = true
						end
					end
					if madeBridge == false and previousGround ==1 then
						if map[mapyBridge+num][mapxBridge] ==2 or objectmap[mapyBridge+num][mapxBridge] ==5 or objectmap[mapyBridge+num][mapxBridge] ==6 then
							madeBridge = true
							endBridgex = mapxBridge
							endBridgey = mapyBridge+num-1
							drawBridge = true
							bridgeOrientation = 1 
							--map[mapy][mapx+num] = 102
							break
						end
					end
					--previousGround = map[mapyBridge+num][mapxBridge]
				end
			end
		end
		
		
		if drawBridge == true and bridgeOrientation == 0 and endBridgex - startBridgex > 3 then			
			for x = startBridgex, endBridgex do
				if endBridgex - startBridgex < 13 then
					objectmap[endBridgey][x] = 5
				else
					objectmap[endBridgey][x] = 5
					objectmap[endBridgey+1][x] = 5
				end
			end
			--drawBridge = false
			--madeBridge = false
			--countBridge = 0
		end
		if drawBridge == true and bridgeOrientation == 1 and endBridgey - startBridgey > 3 then
			for y = startBridgey, endBridgey do	
				if endBridgey - startBridgey < 13 then
					objectmap[y][endBridgex] = 6
				else
					objectmap[y][endBridgex] = 6
					objectmap[y][endBridgex+1] = 6
				end
			end
			--drawBridge = false
			--madeBridge = false
			--countBridge = 0
		end	
	end
end



function genPonds(amount)
	for i=1,amount do

		foundGround = false
		while foundGround == false do
			mapyPond = math.random(ymin,ymax)
			mapxPond = math.random(xmin,xmax)
			countPond = 0
			
			for y = -3 , 5 do
				for x = -4 , 4 do
					if mapyPond + y > ymin and mapyPond + y < ymax and mapxPond + x > xmin and mapxPond + x < xmax then
						if map[mapyPond + y][mapxPond + x]==2 then
							countPond = countPond + 1
						end
					end
				end
			end
			
			if countPond == 81 then
				foundGround = true
			end
		end
		for y = 1 , 3 do
			for x = -2 , 2 do
				if mapyPond - y > ymin and mapyPond + y < ymax and mapxPond + x > xmin and mapxPond + x < xmax then
					map[mapyPond + y][mapxPond + x] = 1
					mapheight[mapyPond + y][mapxPond + x] = 5
				end
			end
		end
		map[mapyPond][mapxPond] = 7
		
				
		
	end
end


function genTrees(amount)
	for i=1,amount do
		mapyTree = math.random(ymin,ymax)
		mapxTree = math.random(xmin,xmax)
		if map[mapxTree][mapyTree]==2 then
			objectmap[mapxTree][mapyTree]=3
		end
	end
end

function genLongGrass(amount)
	for i=1,amount do
		mapyGrass = math.random(ymin,ymax)
		mapxGrass = math.random(xmin,xmax)
		if map[mapxGrass][mapyGrass]==2 then
			objectmap[mapxGrass][mapyGrass]=8
		end
	end
end



function genDungeon(rooms, x, y,count)
	lastRoomX = x
	lastRoomY = y
	--for i=0,rooms do
	width = math.random(5,10)
	height = math.random(5,10)
	xpos = math.random(0,100)
	ypos = math.random(0,100)
	for x=0,width do
		for y=0,rooms do
			if y+ypos > ymin and y +ypos < ymax and x+xpos > xmin and x +xpos < xmax then
				map[y+ypos][x+xpos] = 2
			end
		end
	end
		
	connectRooms(lastRoomX, lastRoomY, xpos, ypos)
	count = count + 1
	if count < rooms then
		genDungeon(rooms, xpos, ypos, count)
	end
	
	--end
end

function connectRooms(oldx,oldy,newx,newy)
	for x = oldx,newx do
		map[newy][x] = 2
	end
	for y = oldy,newy do
		map[y][oldx] = 2
	end
end

function genDungeons(rooms, xin, yin,count)
	lastRoomX = xin
	lastRoomY = yin
	--for i=0,rooms do
	width = math.random(1,4)
	height = math.random(1,4)
	xpos = math.random(width,20)+xin-10
	ypos = math.random(height,20)+yin-10
	for xadd=0-width,width do
		for yadd=0-height,height do
			if yadd+ypos > ymin and yadd +ypos < ymax and xadd+xpos > xmin and xadd +xpos < xmax then
				map[yadd+ypos][xadd+xpos] = 2
			end
		end
	end
	
	if count > 0 then
		if xpos <= lastRoomX then
			for xadd = xpos, lastRoomX do
				
				map[lastRoomY][xadd] = 2
			
			end
		else
			for xadd = lastRoomX, xpos do
				map[lastRoomY][xadd] = 2
			end
		end
			
		if ypos <= lastRoomY then
			for yadd = ypos, lastRoomY do
				map[yadd][xpos] = 2
			end
		else
			for yadd = lastRoomY, ypos do
				map[yadd][xpos] = 2
			end
		end
	end
	--connectRooms(lastRoomX, lastRoomY, xpos, ypos)
	count = count + 1
	if count <= rooms then
		genDungeons(rooms, xpos, ypos, count)
	end

end



function genDungeons2(rooms, x, y,count)
	xpos=x
	ypos=y
	if y > ymin and y < ymax and x > xmin and x < xmax then
		objectmap[y][x]=9
	end
	xdungeon = x
	ydungeon = y
	
	randnum = math.random(1,6)
	count = countdungeon + 1
	countdungeon = countdungeon + 1
	if count < rooms then
		if randnum == 1 then
			genDungeons(rooms, xpos+1, ypos, count)
		elseif randnum == 2 then
			genDungeons(rooms, xpos-1, ypos, count)
		elseif randnum == 3 then
			genDungeons(rooms, xpos, ypos+1, count)
		elseif randnum == 4 then
			genDungeons(rooms, xpos, ypos-1, count)
		elseif randnum == 5 then
			genDungeons(rooms, xpos+1, ypos+1, count)
			genDungeons(rooms, xpos, ypos+1, count)
		elseif randnum == 6 then
			genDungeons(rooms, xpos-1, ypos-1, count)
			genDungeons(rooms, xpos-1, ypos, count)
		elseif randnum == 7 then
			genDungeons(rooms, xpos, ypos, count)
		elseif randnum == 8 then
			genDungeons(rooms, xpos, ypos, count)
		elseif randnum == 9 then
			genDungeons(rooms, xpos, ypos, count)
		elseif randnum == 10 then
			genDungeons(rooms, xpos, ypos, count)
		end
	end
	
	
	if y > ymin and y < ymax and x > xmin and x < xmax then
		love.graphics.setCanvas(minimapcanvas)
			love.graphics.setColor(65,220,60,255)
			love.graphics.rectangle("fill",x,y,1,1)
		love.graphics.setCanvas()
	end
end
