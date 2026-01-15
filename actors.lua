function init_actor_data()
	
	--list of index that corresponds to ennemies
	ennemies = {21, 37, 53}
	
	--data of all the actors in the game
	actor_dat = {
		
		-- tongue
		[6] = {
			k = 6,
		},
		-- cat
		[17] = {
			k = 17,

			animations = {
				iddle = {start = 17, frames = 4, length = 5, loop = true}
			},

			y = 0, 
			dx = 0,
			dy =  1,
		},
								
		-- water drop
		[21] = {
			k = 21,
			animations = {
				iddle = {start = 21, frames = 6, length = 3, loop = true}
			},
			dx = 0, 
			y = 0,
			dy = 0.5, -- example of the move function being overwritten
		},

		-- fire 
		[37] = {
			k = 37,
			animations = {
				iddle = {start = 37, frames = 1, length = 0, loop = false}
			},
			dx = 0,
			y = 0,
			dy = 1
		},

		-- plant
		[53] = {
			k = 53,
			animations = {
				iddle = {start = 53, frames = 1, length = 0, loop = false}
			},
			dx = 0.2,
			y = 0,
			dy = 0.7
		}
										
	}							
	
end


-- makes an actor and add it to the "actors" created by init_level (in level.lua)
-- during _init()

-- every actor has a draw and move function by default, it can be artificially over-written
-- by simply assigning a new variable to the move or draw attribute.
function make_actor(k, x0, y0, d)

	local a = {
		k=k, -- sprite of actor/identificator in the actor database
		
		current_sprite = k,
		anim_frame = 0,
		anim_timer = 0,
		state = "iddle",
		animations = { 
			iddle = {start = k, frames = 4, length = 10, loop = true}
		},

		x=x0, y=y0, 
		dx=0, dy=0, 
		ddx=0, ddy=0, 
		d = 1 or d,
		w=8, -- hitbox width
		h=8, -- hitbox height
		
		draw=draw_actor, 
		move=move_actor,
		}

		if fget(a.k, 7) then
			a.collide_test = ennemy_collision_test
		else
			a.collide_test = default_collision_test
		end
		
		-- assigns the specific actor stats specified in init_actor_data
		for k, v in pairs(actor_dat[k])
		do
			a[k] = v
		end
		
		if (#actors < max_actors) then
			add(actors, a)
		end
	
	return a
		
end

-- default move function for all the actors, can be overwritten
function move_actor(a)

	a:collide_test()
	if a.y > 127 then
		del(actors, a)
	end

	local current_anim = a.animations[a.state]

	if a.anim_frame == (current_anim.frames - 1) and not current_anim.loop 
	then
		a.anim_timer = 0
		-- freeze on last frame
	else	
		if (current_anim.length > 0 and a.anim_timer > current_anim.length) then
			a.anim_frame = (a.anim_frame + 1)%current_anim.frames
			a.anim_timer = 0
		end	
	end 

	a.anim_timer += 1
	
 	a.x += a.dx
	a.y += a.dy

end

-- default draw function for all the actors, can be overwritten
function draw_actor(a)
	local current_anim = a.animations[a.state]

	spr(current_anim.start + a.anim_frame, a.x, a.y, 1, 1, not (a.d == 1))
end



function default_collision_test(a)
	return -- dummy function
end

function ennemy_collision_test(a)

		if pl != nil then -- no need to check for collision when the projectile is far from the ground
			local x = abs(a.x - pl.x) -- difference of x position between player and projectile
			local y = abs(a.y - pl.y) -- difference of y position betweeb player and projectile
			if x < 5 and y < 5  then -- game over if more than half the player overlaps with projectile
				del(actors, pl)
				pl = nil
				del(actors, a)
				game_state = 0
			end	
		end
		if a.y > 111 then
			if destroy_floor(a.x) then
				del(actors, a)
			end
		end				
end
					
					
					
	
-- sets a new state, this will start a new animation cycle. 
-- The state should be defined in the animations attribute of the actor 

-- A state defines an animation cycle, it has a starting frame, a number of frames, 
-- a length for each frame and wether it loops or not
function set_state(a, new_state)
	    if a.state != new_state then 
        a.state = new_state
        a.anim_frame = 0 -- Reset frame when state changes
        a.anim_timer = 0
    end
end


