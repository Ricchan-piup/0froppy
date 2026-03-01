-- the above lines should be commented out to run the game, they're just here to help the compiler locate the functions when coding.
-- pico 8 will crash when reading these lines as it doesn't start looking for files from the same file

max_actors = 64
counter = 0.5
delay = 2

current_game_state = "titleScreen"

game_states = {
	titleScreen = {
		init = function()
			canStart = false
			sfx(9, 3) 
		end,
		update = function()
			if not btn(5) then
				canStart = true
			end
			-- update title screen variables here
			if btn(5) and canStart then
				set_game_state("playing")
			end
		end,
		draw = function()
			cls(1)
			print("FROPPY", 48, 20, 7)
			print("PRESS X TO START", 32, 64, 7)
						-- sprite #44 top-left on sheet is (96,16)
			local sx,sy = 96,16
			local sw,sh = 24,16
			local scale = 3
			local dw,dh = sw*scale, sh*scale
			
			local x = 64 - dw/2
			local y = 104 - dh/2
			palt(0, false)
			sspr(sx,sy, sw,sh, x,y, dw,dh)
			-- spr(45,0,0)
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
		update = function()
			u_level()
		end,
		draw = function()
			cls(1)
			draw_level()
			print("SCORE: " .. score, 48, 0, 6)
		end
	},

	gameOver = {
		init = function()
			music(-1)
			sfx(8, 3)
		end,
		update = function()
			u_level()
			if btn(5) then
				set_game_state("titleScreen")
			end
		end,
		draw = function()
			cls(1)
			draw_level()
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