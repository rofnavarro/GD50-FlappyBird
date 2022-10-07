CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

--	used to initialize the CountdownState and the timer
function CountdownState:init()
	self.count = 3
	self.timer = 0
end

--	used to update the timer and change to PlayState when gets to zero
function CountdownState:update(dt)
	self.timer = self.timer + dt

	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1

		if self.count == 0 then
			gStateMachine:change('play')
		end
	end
end

--	used to render the text on screen
function CountdownState:render()
	love.graphics.setFont(hugeFont)
	love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end