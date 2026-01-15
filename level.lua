-- initiates the list of actors
game_state = 1

function init_level()
	
	-- a value of 1 means the tile is alive, 0 means the cell has been destroyed 
	ground = {}
	for i = 0, 16 do
		ground[i] = 1
	end

	ground[-1] = 0
	ground[16] = 0

	actors = {}
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