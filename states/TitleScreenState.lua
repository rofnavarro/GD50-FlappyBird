--[[
	TitleScreenState is the starting screen of the game.
]]
TitleScreenState = Class{__includes = BaseState}

--	used to update the screen
function TitleScreenState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end

--	used to render the text on screen
function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Feno's Bird", 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end