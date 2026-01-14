-- initiates the list of actors
function init_level()
	
	actors = {}
	
end

-- spawn a random ennemy
function spawn_ennemy() 
	
	x = flr(rnd(16))
	
	n = rnd(ennemies)
	
	make_actor(n, x*8, 0, 1)
	
end	
