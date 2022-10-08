Butterfly = Class{}

local GRAVITY = 20

--	used to instantiate the object and set it own variables
function Butterfly:init()
    self.image = love.graphics.newImage('png/butterfly.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --  setting the starting position of the object
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    --  setting the starting vertical velocity
    self.dy = 0
end

--	used to detect the collision
function Butterfly:collides(pipe)
	--	the raw numbers 2 and 4 are used to make more flexible and user friendly
	if (self.x + 3) + (self.width - 6) >= pipe.x and self.x + 3 <= pipe.x + PIPE_WIDTH then
		if (self.y + 3) + (self.height - 6) >= pipe.y and self.y + 3 <= pipe.y + PIPE_HEIGHT then
			return true
		end
	end
end

--	used to update the position of the object
function Butterfly:update(dt)
    --  updating speed by gravity
    self.dy = self.dy + GRAVITY * dt

    --  condition to make jump
    if love.keyboard.wasPressed ('space') then
        self.dy = -5
		sounds['jump']:play()
    end

    --  updating the position of the object
    self.y = self.y + self.dy
end

--	used to draw the object
function Butterfly:render()
   	--	render the object updated
    love.graphics.draw(self.image, self.x, self.y)
end