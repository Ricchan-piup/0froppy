-- initiates the list of actors
game_state = 1
score = 0

function init_level()
	
	-- a value of 1 means the tile is alive, 0 means the cell has been destroyed 
	ground = {}
	for i = 0, 16 do
		ground[i] = 1
	end
	ground[-1] = 0
	ground[16] = 0

	actors = {}
	points = {}
	pl = make_player()
	
end

-- spawn a random ennemy
function spawn_ennemy() 
	
	x = flr(rnd(128))

	if x > 120 then
		x = 120
	end
	
	n = rnd(ennemies)
	
	make_actor(n, x, 0)
	
end	

function is_floor(x)
	
	local x = flr((x+4)/8)
	return ground[x] == 1

end	


-- destroy the floor tile "closest" to x coordinate
function destroy_floor(x)

	local x=flr((x+4)/8)

	if (ground[x] != 0) then
		mset(x, 15, 0)
		ground[x] = 0
		return true
	end

	return false
end

function makePoints(a)
	local p = {
		x = (a.x > 112) and 112 or a.x,
		y = a.y - 4,
		points = calculatePoints(a),
		timer = 30,
		update = updatePoints,
		draw = drawPoints
	}
	p.color = computeColor(p)
	
	add(points, p)
	score += p.points

	return p
	
end

function calculatePoints(a)
	local points
	if a.y < 40 then
		points = 1000
	elseif a.y < 80 then
		points = 100
	else
		points = 10
	end
	return points
end

function computeColor(p)
	local points = p.points
	if points == 1000 then
		return 10
	elseif points == 100 then
		return 3
	else
		return 2
	end
end

function updatePoints(p)
	local timer = p.timer
	if timer < 0 then
		del(points, p)
		p = nil
	else
	local points = p.points
	
	if p.points == 1000 then
		p.color = (p.color == 10) and 13 or 10
	end

	p.timer -= 1
	end
end

function drawPoints(p)
	print(p.points, p.x, p.y, p.color)
	end


