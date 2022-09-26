--[[
    CS50 - GD50 - Flappy Bird Game

    Student: Rodrigo Ferrero

    Flappy Bird is a game originaly released in 2013 and it was
    made by Nguyễn Hà Đông.

	This is a study of the implementation of the game 
	in lua programming language.
]]

--[[
    Requires
]]
--	push library allow to draw the game at a virtual resolution
--	https://github.com/Ulydev/push
push = require 'push'

--	class library allow to use classes and objects in lua
--	https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

--  calling the classes
require 'Bird'

--[[
    Global Variables
]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--[[
    Local Variables
]]
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local BACKGROUND_SPEED = 15
local BACKGROUND_LOOPING_POINT = 413

local ground = love.graphics.newImage('ground.png')
local goundScroll = 0
local GROUND_SPEED = 60

--[[
    Game
]]

--[[
    Runs when the game first runs, only once
	The bootstrap of the game
]]
function love.load()

	--	setting filter to point blank, to take out the blurry from virtualization
    love.graphics.setDefaultFilter('nearest', 'nearest')

	--	setting the title of the screen
    love.window.setTitle("Feno's Bird")

	--	setting the virtualization of the window, to make it look like old SNES
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

--[[
	Function to resize the window of the game with push library
]]
function love.resize(w, h)
	push:resize(w, h)
end

--[[
	Keyboard handling, called each frame
	key is the key pressed so we can access
]]
function love.keypressed(key)

    --	condition to verify if the 'esc' key is pressed to close the game
	if key == 'escape' then
		--	end the game if the event occurs
		love.event.quit()
    end
end

--[[
	Runs every frame
	dt is for delta time
]]
function love.update(dt)

    --  make the background moves by the delta time
    backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    goundScroll = (goundScroll + GROUND_SPEED * dt)
        % VIRTUAL_WIDTH
end

--[[
	Called after update, used to draw anything in the screen
]]
function love.draw()

    --	push virtualization initialized
	push:apply('start')
    
    -- draw the image initiated
    love.graphics.draw(background, -backgroundScroll, 0)
    
    love.graphics.draw(ground, -goundScroll, VIRTUAL_HEIGHT - 16)

    --	push virtualization must switch to end state
	 push:apply('end')
end
