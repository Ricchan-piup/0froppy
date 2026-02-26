-- initiates the list of actors
function init_level()
	score = 0
	-- a value of 1 means the tile is alive, 0 means the cell has been destroyed 
	ground = {}
	for i = 0, 16 do
		ground[i] = 1
		mset(i, 15, 48) -- resets floor tiles in case of restart
	end
	ground[-1] = 0
	ground[16] = 0

	actors = {}
	points = {}
	pl = make_player()
	-- make_actor(53, 90, 80)
end

function u_level()
	if t() > counter then
		spawn_ennemy()
		counter = t() + delay
	end

	for a in all(actors) do
		a:move()
	end

	for p in all(points) do
		p:update()
	end

	if (timer - t() < 0) then
		timer = t() + 4
	end
end

-- draw the map and the actors
function draw_level()
	
	map(0,0,0,0,128,64)
	for a in all(actors) do
		a:draw()
	end
	draw_points(points)
	draw_magic_gauges(pl)

end

-- spawn a random ennemy
function spawn_ennemy() 
	
	x = flr(rnd(128))

	if x > 120 then
		x = 120
	end
	
	n = rnd(ennemies) -- selects a random ennemy in the ennemies table (see 3actors.lua)
	
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
		if not is_floor(pl.x) then
			set_state(pl, pl_dead)
		end
		return true
	end

	return false
end





