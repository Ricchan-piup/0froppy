function draw_ui()
    draw_points()
    draw_magic_gauges()
end

function makePoints(a)
	local p = {
		x = (a.x > 112) and 112 or a.x,
		y = a.y - 4,
		points = calculatePoints(a),
		timer = 30,
		update = u_points,
		draw = d_points
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
		sfx(33, 3)
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

function u_points(p)
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

function d_points(p)
	print(p.points, p.x, p.y, p.color)
	end


function draw_points(points)
    for p in all(points) do
		p:draw()
	end
end


function draw_magic_gauges(pl)
	if pl.plant == 0 then
		spr(64, -4, 2, 4, 1) 
	else
		spr(68+16*(pl.plant-1), -4, 2, 4, 1) 
	end

	if pl.water == 0 then
		spr(64, -4, 10, 4, 1) 
	else
		spr(72+16*(pl.water-1), -4, 10, 4, 1) 
	end
	
	if pl.fire == 0 then
		spr(64, -4, 18, 4, 1) 
	else
		spr(76+16*(pl.fire-1), -4, 18, 4, 1) 
	end
end