-- #include draw_world.lua
-- #include player.lua
-- #include actors.lua
-- #include level.lua

-- the above lines should be commented out to run the game, they're just here to help the compiler locate the functions when coding.
-- pico 8 will crash when reading these lines as it doesn't start looking for files from the same file 

max_actors = 64
counter = 0.1
delay = 1

function _init()
	init_actor_data()
	init_level()

	timer = 0.5
	
	palt(0, false)
	palt(1, true)			
end


function _update()
	if  t() > counter 
	then
		spawn_ennemy()
		counter = t() + delay
	end

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