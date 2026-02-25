-- the above lines should be commented out to run the game, they're just here to help the compiler locate the functions when coding.
-- pico 8 will crash when reading these lines as it doesn't start looking for files from the same file

max_actors = 64
counter = 0.5
delay = 2
debug = 0

function _init()
	init_actor_data()
	init_level()

	timer = 0.5
	music(0)
	palt(0, false)
	palt(1, true)
end

function _update()
	if t() > counter then
		spawn_ennemy()
		counter = t() + delay
	end

	for a in all(actors) do
		a:move()
	end

	for p in all(points) do
		p:update()
	end

	if (timer - t() < 0) then
		timer = t() + 4
	end
end

function _draw()

	cls(1)
	draw_map()
	print("SCORE: " .. score, 48, 0, 6)

end