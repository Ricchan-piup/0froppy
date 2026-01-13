-- overwrites make_actor to initialize the player (player is added to the actors table by make_actor)
function make_player()

	local a = make_actor(2, 64, 14*8, 1)

	a.is_player = true
	a.move = move_player
	a.score = 0
	a.tongue = nil

	a.states = {"iddle", "walk", "attack", "tongue_out"}

	a.animations = {
		iddle = {start = 2, frames = 1, length = 0, loop = true},
		walk = {start = 1, frames = 2, length = 5, loop = true},
		attack = {start = 3, frames = 3, length = 1, loop = false, next_state = "tongue_out"},
		tongue_out = {start =  6, frames = 1, length = 0, loop = true},
	}
		
	return a
end

-- makes the tongue at the player's location, the data for the tongue can be seen in the actor's table in actors
function make_tongue(pl)

	local a = make_actor(6, pl.x, pl.y, pl.d)

	a.x0 = pl.x
	a.y0 = pl.y

	a.dx = pl.d * 2
	a.dy = -2
	a.d = pl.d

	a.move = move_tongue
	a.draw = draw_tongue

	return a


end

-- TODO: will maybe overwrite this later
function move_tongue(a)

	move_actor(a)

end

-- draws the tongue and the trail for the tongue to give the impression it stretches al
function draw_tongue(a)

	for i = 0, abs(a.x-a.x0) do 
		spr(a.k, a.x0 + a.d*i, a.y0 - i, 1, 1, a.d != 1)
	end

	print(a.x0)
end

-- movements for the player
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
	
	-- w
	if btn(4) 

	then	
		set_state(pl, "attack") -- sets state to attack to play animation
		pl.dx = 0
		pl.is_attacking = true -- player can't move while pl.is_attacking is true

		if pl.tongue == nil -- makes the sure the tongue only gets spawned once
		then
			pl.tongue = make_tongue(pl)
		else
		end

	else 	
		pl.is_attacking = false
		del(actors, pl.tongue) -- deletes the tongue when player releases w
		pl.tongue = nil
	end
	
	-- makes sure the frog is in the write state
	if pl.dx != 0 
	then
		set_state(pl, "walk")
	end 

	if pl.dx == 0 and not pl.is_attacking
	then 
		set_state(pl, "iddle")
	end
		
end