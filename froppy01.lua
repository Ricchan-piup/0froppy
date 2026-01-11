-- #include "game_state.lua"
-- #include "actors.lua"
-- #include "ennemies.lua"
-- #include "player.lua"
-- #include "draw_world.lua"

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