function init_actor_data()
	
	ennemies = {17, 21}
	
	actor_dat = {
			
			-- cat
			[17] = {
				k = 17, 
				frames = 4, 
				y = 0, 
				dx = 0,
				dy =  1
			},
									
			-- water drop
			[21] = {
				k = 21,
				frames = 4,
				dx = cos(t()), 
				y = 0,
				dy = 0.5,
				move = move_water_drop
			}
										
		}							
	
end


function make_actor(k, x0, y0, d)

	local a = {
		k=k, -- sprite of actor
		
		current_sprite = k,
		anim_frame = 0,
		anim_timer = 0,
		state = "iddle",

		animations = { 
			iddle = {start = k, frames = 4, length = 10, loop = true}
		},

		x=x0, y=y0, -- position 
		dx=0, dy=0, -- velocity
		ddx=0, ddy=0, -- acceleration
		d = 1 or d, -- direction
		draw=draw_actor,
		move=move_actor

		}
		
		for k, v in pairs(actor_dat[k])
		do
			a[k] = v
		end
		
		if (#actors < max_actors) then
			add(actors, a)
		end
	
	return a
		
end


function move_actor(a)

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


function draw_actor(a)

	local current_anim = a.animations[a.state]

	spr(current_anim.start + a.anim_frame, a.x, a.y, 1, 1, not (a.d == 1))
	if a.is_player then
		print(a.state)
	end   
	
end


function set_state(a, new_state)
	    if a.state != new_state then 
        a.state = new_state
        a.anim_frame = 0 -- Reset frame when state changes
        a.anim_timer = 0
    end
end


function move_water_drop(a)
	move_actor(a)
	a.dx = cos(t())
end