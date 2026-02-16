-- overwrites make_actor to initialize the player (player is added to the actors table by make_actor)
function make_player()

	local a = make_actor(2, 64, 14*8, 1)

	a.is_player = true
	a.move = move_player
	a.score = 0
	a.tongue = nil
	a.cooldown = false

	a.states = {"iddle", "walk", "attack", "tongue_out", "eating_ennemy"}

	a.animations = {
		iddle = {start = 2, frames = 1, length = 0, loop = true},
		walk = {start = 1, frames = 2, length = 5, loop = true},
		attack = {start = 3, frames = 3, length = 1, loop = false, next_state = "tongue_out"},
		tongue_out = {start =  6, frames = 1, length = 0, loop = false},
		eating_ennemy = {start = 7, frames = 1, length = 0, loop = false}
	}

		
	return a
end

-- makes the tongue at the player's location, the data for the tongue can be seen in the actor's table in actors
function make_tongue(pl)

	local a = make_actor(6, pl.x, pl.y, pl.d)

	a.k = 6
	a.x0 = pl.x
	a.y0 = pl.y

	a.dx = pl.d * 1
	a.dy = -1
	a.d = pl.d
	a.w = 0.5
	a.h = 0.5

	a.move = move_tongue
	a.draw = draw_tongue
	a.collide_test = tongue_actor_collision_test
	a.stuck_ennemy = nil

	return a

end
 
--TODO: heavy in calculations, I could look for a flag at precise location and then check which ennemy is there instead.
function tongue_actor_collision_test(a) 

	if a.y > 108  then --hitbox isn't immediatly active when the tongue is spawned.
		return
	end
	for a2 in all(actors) do 
		if a2 != a and (not a2.is_player) then 

			-- if the frogue is facing right, the hit point is a bit more to the right
			local hit_point_x_coordinate = (a.d == 1) and a.x + 6 or a.x + 2 
			local hit_point_y_coordinate = a.y
		
			if (a2.x < hit_point_x_coordinate and hit_point_x_coordinate < a2.x + a2.w) and (a2.y < hit_point_y_coordinate and hit_point_y_coordinate < a2.y + a2.h) 
			then
				if not a2.is_player then
					a.stuck_ennemy = a2
					set_state(pl, "eating_ennemy")
					-- del(actors, a)
					-- a=nil
					-- del(actors, a2)
					-- set_state(pl, "iddle")
					-- pl.cooldown = true
					return
				end
			end
		end	
	end
end	

function move_tongue(a)

	if pl.state == "eating_ennemy" then
		return
	end

	move_actor(a)
	a:collide_test()
	if a.stuck_ennemy != nil then -- prevents the tongue from eating two ennemies
		return
	end
	move_actor(a)
	a:collide_test()

end

function eat_ennemy(a)
	if a.dy < 0 then
		a.dy *= -2
		a.dx *= -2
		a.stuck_ennemy.dx = a.dx
		a.stuck_ennemy.dy = a.dy
		a.stuck_ennemy.y = a.y - 4
		a.stuck_ennemy.eaten = true
	end

	--TODO: The tongue can collide with ennemy on the way back, correct it
	if (a.stuck_ennemy).y < 108 then
		move_actor(a)
		move_actor(a)
		a.stuck_ennemy.x += a.dx
		a.stuck_ennemy.y += a.dy
		a.stuck_ennemy.x += a.dx
		a.stuck_ennemy.y += a.dy
	else
		a.stuck_ennemy.eaten = false
		del(actors, a.stuck_ennemy)

		a.dy *= -1/2
		a.dx *= -1/2
		a.stuck_ennemy = nil
		a = nil
		set_state(pl, "iddle")
		pl.cooldown = true
	end	
end

-- draws the tongue and the trail for the tongue to give the impression it stretches al
function draw_tongue(a)

	for i = 0, abs(a.x-a.x0) do 
		spr(a.k, a.x0 + a.d*i, a.y0 - i, 1, 1, a.d != 1)
	end
end

-- movements for the player
function move_player(pl) 

	pl.dx = 0

	if pl.state == "eating_ennemy" then
		eat_ennemy(pl.tongue)	
		return
	end

	if not pl.is_attacking then
		if btn(➡️) then
			pl.d = 1
			if is_floor(pl.x + 4) == true then
				pl.dx = 1
			end
		end
		
		if btn(⬅️) then
			pl.d = -1
			if is_floor(pl.x - 5) == true then
				pl.dx = -1
			end
		end	
	end
	
	-- w
	if btn(4)
	then
		-- the player needs to release w after eating an ennemy to attack again	
		if not pl.cooldown then 
			set_state(pl, "attack") -- sets state to attack to play animation
			pl.dx = 0
			pl.is_attacking = true -- player can't move while pl.is_attacking is true

			if pl.tongue == nil -- makes the sure the tongue only gets spawned once
			then
				pl.tongue = make_tongue(pl)
			else
		end
	end

	else 
		pl.cooldown = false	
		pl.is_attacking = false
		del(actors, pl.tongue) -- deletes the tongue when player releases w
		pl.tongue = nil
	end
	
	-- makes sure the frog is in the right state
	if pl.dx != 0 
	then
		set_state(pl, "walk")
	end 

	if pl.dx == 0 and not pl.is_attacking 
	then 
		set_state(pl, "iddle")
	end
		
	move_actor(pl)
end