function make_player()

	local a = make_actor(2, 64, 14*8, 1)

	a.is_player = true
	a.move = move_player
	a.score = 0

	a.states = {"iddle", "walk", "attack", "tongue_out"}

	a.animations = {
		iddle = {start = 2, frames = 1, length = 0, loop = true},
		walk = {start = 1, frames = 2, length = 5, loop = true},
		attack = {start = 3, frames = 3, length = 2, loop = false, next_state = "tongue_out"},
		tongue_out = {start =  6, frames = 1, length = 0, loop = true},
	}
		
	return a
end

function move_player(pl) 

	move_actor(pl)	
	pl.dx = 0

	if btn(➡️) then
  		pl.dx = 1
		pl.d = 1
	end
	
	if btn(⬅️) then
		pl.dx = -1
		pl.d = -1
	end

	if btn(4) 
	then
		set_state(pl, "attack")
		pl.dx = 0
		pl.is_attacking = true
	else 
		pl.is_attacking = false
	end
	
	if pl.dx != 0
	then
		set_state(pl, "walk")
	end 

	if pl.dx == 0 and not pl.is_attacking
	then 
		set_state(pl, "iddle")
	end
		
end