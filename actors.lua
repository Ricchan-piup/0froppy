function make_actor(k, x0, y0, d)

	local a = {
		k=k, -- sprite of actor
		frame = 0, -- frame used
		frames = 2, -- number of animation frames
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

	a.frame += 0.15
 a.x += a.dx
 a.y += a.dy
 	
end

function draw_actor(a)

	local fr = a.k + (a.frame%a.frames)
	
	spr(fr, a.x, a.y, 1, 1, not (a.d == 1))   
	
end