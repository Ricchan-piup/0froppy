--[[
The different states for the player are defined as integer constants
]]

pl_idle = 1
pl_walk = 2
pl_attack = 3
pl_stretching_tongue = 4
pl_pulling_tongue = 5
pl_eating_ennemy = 6

-- overwrites make_actor to initialize the player (player is added to the actors table by make_actor)
function make_player()

	local a = make_actor(2, 64, 14*8, 1)

	a.is_player = true
	a.move = update_player
	a.score = 0
	a.tongue = nil
	a.cooldown = false
	a.state = pl_idle

	a.states = {
		[pl_idle] = {
			enter = function(a)
				a.dx = 0
			end, 
			update = u_idle, 
			exit = nil
		},
		
		[pl_walk] = {
			enter = function(a)
				sfx(0)
			end, 
			update = u_walk, 
			exit = function(a)
				a.dx = 0
			end
		},

		[pl_attack] = {
			enter = nil,
			update = function(a)
				a.x += a.dx
				a.y += a.dy
			end,
			exit = nil
		},

		--TODO: prevent tongue from being created again just after it came back (boolean)
		[pl_stretching_tongue] = {
			enter = function(a)
				a.tongue = make_tongue(a)
			end,
			update = u_stretching_tongue,
			exit = function(a)
				local tongue = a.tongue
				tongue.cancollide = false
				if tongue != nil then
					tongue.dx *= -2 
					tongue.dy *= -2
					debug += 1
				end
			end
		},

		[pl_pulling_tongue] = {
			enter = nil,
			update = u_pulling_tongue,
			exit = function(a)
				del(actors, a.tongue)
				a.tongue = nil
			end
		},

		[pl_eating_ennemy] = {
			enter = nil,
			update = function(a)
				eat_ennemy(a)
			end,
			exit = nil
		}
}

	-- a.animations = {
	-- 	iddle = {start = 2, frames = 1, length = 0, loop = true},
	-- 	walk = {start = 1, frames = 2, length = 5, loop = true},
	-- 	attack = {start = 3, frames = 3, length = 1, loop = false, next_state = "tongue_out"},
	-- 	tongue_out = {start =  6, frames = 1, length = 0, loop = false},
	-- 	eating_ennemy = {start = 7, frames = 1, length = 0, loop = false}
	-- }
		a.animations = {
		[pl_idle] = {start = 2, frames = 1, length = 0, loop = true},
		[pl_walk] = {start = 1, frames = 2, length = 5, loop = true},
		[pl_attack] = {start = 3, frames = 3, length = 1, loop = false, next_state = pl_stretching_tongue},
		[pl_stretching_tongue] = {start =  3, frames = 3, length = 1, loop = false},
		[pl_pulling_tongue] = {start = 7, frames = 1, length = 0, loop = false},
		[pl_eating_ennemy] = {start = 7, frames = 1, length = 0, loop = false}
	}
	return a
end

-- 0 is the right button, 1 is left, 4 is w, 5 is x
function u_idle(pl)
	if btn(0) or btn(1) then
		set_state(pl, pl_walk)
	elseif btn(4) then
		set_state(pl, pl_stretching_tongue)
	end
end

function u_walk(pl)

	if btn(4) then 
		set_state(pl, pl_stretching_tongue)

	elseif btn(1) then
		pl.d = 1
		if is_floor(pl.x + 4) == false then
			pl.dx = 0
		else
			pl.dx = 1
		end

	elseif btn(0) then
		pl.d = -1
		if is_floor(pl.x - 5) == false then
			pl.dx = 0
		else
			pl.dx = -1
		end

	else 
		set_state(pl, pl_idle)
	end
end

function u_stretching_tongue(pl)
	local tongue = pl.tongue 
	if not btn(4) then 
		set_state(pl, pl_pulling_tongue)
	elseif tongue.x < 0 or tongue.x > 120 or tongue.y < 0 then
		set_state(pl, pl_pulling_tongue)
	end
end

function u_pulling_tongue(pl)

	local tongue = pl.tongue

	if tongue.y > pl.y then
		set_state(pl, pl_idle)
		return
	end
end

-- makes the tongue at the player's location, the data for the tongue can be seen in the actor's table in actors
function make_tongue(pl)

	local a = make_actor(6, pl.x, pl.y, pl.d)

	a.k = 6
	a.x0 = pl.x
	a.y0 = pl.y

	a.dx = pl.d * 2
	a.dy = -2
	a.d = pl.d
	a.w = 0.5
	a.h = 0.5

	a.move = move_tongue
	a.draw = draw_tongue
	a.collide_test = tongue_actor_collision_test
	a.stuck_ennemy = nil
	a.cancollide = true

	return a

end
 
--TODO: heavy in calculations, I could look for a flag at precise location and then check which ennemy is there instead.
	--Also the collision is not very clean, i should probably do something with a hitbox
function tongue_actor_collision_test(a) 
	if a.cancollide == false then
		return
	end
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
					set_state(pl, pl_pulling_tongue)
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

--TODO: make a better function for this.
function move_tongue(a)

	-- I call move_actor twice to have more control over how I update the position of the tongue.
	move_actor(a)
	a:collide_test()

end


function eat_ennemy(a)
	if a.dy < 0 then
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

function update_player(pl)
	local update = pl.states[pl.state].update
	update(pl)
	move_actor(pl)
end