-- #include draw_world.lua
-- #include player.lua
-- #include actors.lua
-- #include level.lua

-- the above lines should be commented out to run the game, they're just here for the compiler to work when coding


max_actors = 64


function _init()
	init_actor_data()
	init_level()
	make_player()
	spawn_ennemy()
	timer = 0.5
	
	palt(0, false)
	palt(1, true)			
end


function _update()

	for a in all(actors)
		do
		a:move()	
	end
	
	if (timer - t() < 0) then
		timer = t() + 4
	end		
	
end

function _draw()
	draw_map()
end