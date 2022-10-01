Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

--	used to instantiate the object and set it own variables
function Pipe:init()
    --  setting the starting position of the object
	self.x = VIRTUAL_WIDTH + 40
	self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 60)

	self.width = PIPE_IMAGE:getWidth()
end

--	used to update the position of the object
function Pipe:update(dt)
    --  updating the position of the object
	self.x = self.x + PIPE_SCROLL * dt
end

--	used to draw the object
function Pipe:render()
   	--	render the object updated
	love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end