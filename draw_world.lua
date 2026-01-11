function draw_map()
	
	cls(1)
	map(0,0,0,0,128,64)
	for a in all(actors) do
		a:draw()
	end
	
end