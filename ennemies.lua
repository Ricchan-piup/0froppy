function init_actor_data()
	
	ennemies = {17, 21}
	
	actor_dat = {
			
			-- cat
			[17] = {
				k = 17, 
				frames = 4, 
				y = 0, 
				dx = 0,
				dy =  1
			},
									
			-- water drop
			[21] = {
				k = 21,
				frames = 4,
				dx = cos(t()), 
				y = 0,
				dy = 0.5,
				move = move_water_drop
			}
										
		}							
	
end

function move_water_drop(a)
	move_actor(a)
	a.dx = cos(t())
end



function spawn_ennemy() 
	
	x = flr(rnd(16))
	
	n = rnd(ennemies)
	
	make_actor(n, x, 0, 1)
	
end	
