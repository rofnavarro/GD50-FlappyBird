ScoreState = Class{__includes = BaseState}

--	used to get the data from the player
function ScoreState:enter(params)
	self.score = params.score
end

--	used to update to another state
function ScoreState:update(dt)
	if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
		gStateMachine:change('play')
	end
end

--	used to render the text on screen
function ScoreState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf('Ops! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

	love.graphics.setFont(mediumFont)
	love.graphics.printf('Score: ' ..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

	love.graphics.printf('Press ENTER to play again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
