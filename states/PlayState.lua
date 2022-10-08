PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

BUTTERFLY_WIDTH = 38
BUTTERFLY_HEIGHT = 24

--	used to initialize the PlayState and the objects
function PlayState:init()
	self.butterfly = Butterfly()
	self.pipePairs = {}
	self.timer = 0

	self.score = 0

	self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

--	used to update the screen
function PlayState:update(dt)

	self.timer = self.timer + dt

	--	used to create the new PipePair every 2s
	if self.timer > 2 then
		local y = math.max(-PIPE_HEIGHT + 10, math.min(
			self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 100 - PIPE_HEIGHT))
		self.lastY = y

		table.insert(self.pipePairs, PipePair(y))

		self.timer = 0
	end

	--	used to track the score
	for k, pair in pairs(self.pipePairs) do
		if not pair.scored then
			--	pass through the pipe
			if pair.x + PIPE_WIDTH < self.butterfly.x then
				--	increment the score
				self.score = self.score + 1
				--	to ignore if already scored the pipes
				pair.scored = true
				sounds['score']:play()
			end
		end

		pair:update(dt)
	end

	--	used to remove the PipePairs beyond the scene
	for k, pair in pairs(self.pipePairs) do
		if pair.remove then
			table.remove(self.pipePairs, k)
		end
	end

	self.butterfly:update(dt)

	--	used to track if the butterfly collides
	for k, pair in pairs(self.pipePairs) do
		for l, pipe in pairs(pair.pipes) do
			if self.butterfly:collides(pipe) then
				sounds['explosion']:play()
				sounds['hurt']:play()

				gStateMachine:change('score', {
					score = self.score
				})
			end
		end
	end

	-- used to track if the butterfly touches the floor
	if self.butterfly.y > VIRTUAL_HEIGHT - 15 then
		sounds['explosion']:play()
		sounds['hurt']:play()

		gStateMachine:change('score', {
			score = self.score
		})
	end
end

--	used to render the scene
function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

	self.butterfly:render()
end
