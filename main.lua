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

require 'Pipe'

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

local bird = Bird()

local pipes = {}

local spawnTimer = 0

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

    --  setting the seed for the random number
    math.randomseed(os.time())

	--	setting the virtualization of the window, to make it look like old SNES
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --  setting the track of the keyboard
    love.keyboard.keysPressed = {}
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

    --  track of the keyboard input
    love.keyboard.keysPressed[key] = true
    
    --	condition to verify if the 'esc' key is pressed to close the game
	if key == 'escape' then
		--	end the game if the event occurs
		love.event.quit()
    end
end

--[[
    Re-write of the keyboard input
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
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

	--	updates the timer to make it spawn pipes objects on table
	spawnTimer = spawnTimer + dt
	if spawnTimer > 2 then
		table.insert(pipes, Pipe())
		spawnTimer = 0
	end

    --  updates the bird
    bird:update(dt)

	--	updates all pipes on table position
	for k, pipe in pairs(pipes) do
		pipe:update(dt)

		--	removes the pipes when they are completly out of the screen
		if pipe.x < -pipe.width then
			table.remove(pipes, k)
		end
	end

    --  reset the table of the keyboard input
    love.keyboard.keysPressed = {}
end

--[[
	Called after update, used to draw anything in the screen
]]
function love.draw()

    --	push virtualization initialized
	push:apply('start')
    
    --	draw the image initiated
    love.graphics.draw(background, -backgroundScroll, 0)
    
	--	iterates over the table to render all pipes in it
	for k, pipe in pairs(pipes) do
		pipe:render()
	end

	love.graphics.draw(ground, -goundScroll, VIRTUAL_HEIGHT - 16)

    bird:render()
    --	push virtualization must switch to end state
	 push:apply('end')
end
