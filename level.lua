function init_level()
	
	actors = {}
	
end

function spawn_ennemy() 
	
	x = flr(rnd(16))
	
	n = rnd(ennemies)
	
	make_actor(n, x, 0, 1)
	
end	
