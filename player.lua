function make_player()

	local a = make_actor(1, 64, 14*8, 1)

	a.is_player = true
	a.move = move_player
	a.score = 0
		
	return a
end

function move_player(pl) 

	pl.dx = 0
	pl.tongue_out = false
	
	if btn(➡️) then
  pl.dx = 1
		pl.d = 1
	end
	
	if btn(⬅️) then
		pl.dx = -1
		pl.d = -1
	end
	
	if pl.dx != 0 or pl.tongue_out
		then
		move_actor(pl)
		else 
		pl.frame = 0.85
	end 
		
end