-- the above lines should be commented out to run the game, they're just here to help the compiler locate the functions when coding.
-- pico 8 will crash when reading these lines as it doesn't start looking for files from the same file

max_actors = 64
counter = 0.5
delay = 2
debug = 0

current_game_state = "titleScreen"

function u_playing()
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

game_states = {
	titleScreen = {
		init = function()
			canStart = false
			sfx(9, 3) 
		end,
		update = function()
			if not btn(4) then
				canStart = true
			end
			-- update title screen variables here
			if btn(4) and canStart then
				set_game_state("playing")
			end
		end,
		draw = function()
			cls(1)
			print("FROPPY", 48, 20, 7)
			print("PRESS X TO START", 32, 40, 7)
		end
	},

	playing = {
		init = function()
			sfx(-1, 3)
			init_actor_data()
			init_level()
			timer = 0.5
			music(0)
			palt(0, false)
			palt(1, true)
		end,
		update = u_playing,
		draw = function()
			cls(1)
			draw_map()
			print("SCORE: " .. score, 48, 0, 6)
		end
	},

	gameOver = {
		init = function()
			music(-1)
			sfx(8, 3)
		end,
		update = function()
			u_playing()
			if btn(4) then
				set_game_state("titleScreen")
			end
		end,
		draw = function()
			cls(1)
			draw_map()
			print("SCORE: " .. score, 48, 0, 6)
			print("GAME OVER", 48, 20, 7)
			print("PRESS X TO RESTART", 32, 40, 7)
		end

	}
}

function set_game_state(new_state)
	if current_game_state == new_state then
		return
	end
	current_game_state = new_state
	printh(game_states[new_state].init, "debug_log.txt")
	_init()
end


function _init()
	game_states[current_game_state].init()
end

function _update()
	game_states[current_game_state].update()
end

function _draw()

	game_states[current_game_state].draw()

end