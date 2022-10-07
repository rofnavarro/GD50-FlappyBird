PipePair = Class{}

local GAP_HEIGHT = 90

--	used to instantiate the object and set it own variables
function PipePair:init(y)
    --  setting the starting position of the object
	self.x = VIRTUAL_WIDTH + 32
	self.y = y

	--	instantiate two pipes each time
	self.pipes = {
		['upper'] = Pipe('top', self.y),
		['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
	}
	--	if its ready to be removes from the scene
	self.remove = false

	--	if the player passed through the pipes
	self.scored = false
end

--	used to update the position of the object
function PipePair:update(dt)
	--	updating the position of the objects
	if self.x > -PIPE_WIDTH then
		self.x = self.x - PIPE_SPEED * dt
		self.pipes['lower'].x = self.x
		self.pipes['upper'].x = self.x
	else
		self.remove = true
	end
end

--	used to draw the objects in table
function PipePair:render()
   	--	render the objects updated
	for k, pipe in pairs(self.pipes) do
		pipe:render()
	end
end