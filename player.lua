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
	a.canAttack = true -- used to prevent player from spamming tongue by holding btn(4)
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

		[pl_stretching_tongue] = {
			enter = function(a)
				a.tongue = make_tongue(a)
			end,
			update = u_stretching_tongue,
			exit = function(a)
				local tongue = a.tongue
				tongue.cancollide = false
				if tongue != nil then
					tongue.speed *=3
					tongue.dx *= -1
					tongue.dy *= -1
					debug += 1
				end
			end
		},

		[pl_pulling_tongue] = {
			enter = function(a)
				local tongue = a.tongue
				local ennemy = tongue.stuck_ennemy
				if ennemy != nil then
					ennemy.isActive = false
				end
			end,
			update = u_pulling_tongue,
			exit = function(a)
				local tongue = a.tongue
				local ennemy = tongue.stuck_ennemy
				if ennemy != nil then
					del(actors, ennemy)
					ennemy = nil
				end
				del(actors, a.tongue)
				a.tongue = nil
				a.canAttack = false
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
	-- player needs to release the button before being able to attack again
	if not btn(4) then
		pl.canAttack = true
	end
	if btn(0) or btn(1) then
		set_state(pl, pl_walk)
	elseif btn(4) and pl.canAttack then
		set_state(pl, pl_stretching_tongue)
	end
end

function u_walk(pl)
	-- player needs to release the button before being able to attack again
	if not btn(4) then
		pl.canAttack = true
	end

	if btn(4) and pl.canAttack then 
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
	local ennemy = tongue.stuck_ennemy
	if ennemy != nil then
		ennemy.x = tongue.x
		ennemy.y = tongue.y
	end

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

	a.speed = 3
	a.dx = pl.d * 1
	a.dy = -1
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
		return false
	end
	if a.y > 108  then -- doesn't detect ennemies too close to frog.
		return false
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
					updateScore(a2)
					set_state(pl, pl_pulling_tongue)
					return true
					-- TODO: updateScore()
					-- del(actors, a)
					-- a=nil
					-- del(actors, a2)
					-- set_state(pl, "iddle")
					-- pl.cooldown = true
				end
			end
		end	
	end
	return false
end	

--TODO: make a better function for this.
function move_tongue(a)

	-- If there is a collision, the tongue stops moving
	for i=1,a.speed do
		move_actor(a)
		if  a:collide_test() then
			break
		end
	end

end


function eat_ennemy(a)
	if a.dy < 0 then
		a.stuck_ennemy.dx = a.dx
		a.stuck_ennemy.dy = a.dy
		a.stuck_ennemy.y = a.y - 4
		a.stuck_ennemy.eaten = true
	end

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