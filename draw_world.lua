-- draw the map and the actors
function draw_map()
	
	map(0,0,0,0,128,64)
	for a in all(actors) do
		a:draw()
	end

	for p in all(points) do
		p:draw()
	end

	if game_state == 0 then
		print("GAME OVER")
	end



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