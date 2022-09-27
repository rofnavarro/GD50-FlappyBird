Bird = Class{}

local GRAVITY = 20

--	used to instantiate the object and set it own variables
function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    --  setting the starting position of the object
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    --  setting the starting vertical velocity
    self.dy = 0
end

--	used to update the position of the object
function Bird:update(dt)
    --  updating speed by gravity
    self.dy = self.dy + GRAVITY * dt

    --  updating the position of the object
    self.y = self.y + self.dy
end

--	used to draw the object
function Bird:render()
   	--	render the object updated
    love.graphics.draw(self.image, self.x, self.y)
end