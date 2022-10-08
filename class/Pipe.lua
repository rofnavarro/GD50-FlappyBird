Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('png/pipe.png')

PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

--	used to instantiate the object and set it own variables
function Pipe:init(orientation, y)
    --  setting the starting position of the object
	self.x = VIRTUAL_WIDTH
	self.y = y

	self.width = PIPE_IMAGE:getWidth()
	self.height = PIPE_HEIGHT

	self.orientation = orientation
end

--	used to update the position of the object
function Pipe:update(dt)

end

--	used to draw the object
function Pipe:render()
   	--	render the object updated
	love.graphics.draw(PIPE_IMAGE, self.x,
		(self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
		0,	--	rotation 
		1,	--	X scale
		self.orientation == 'top' and -1 or 1)	--	Y scale
end
