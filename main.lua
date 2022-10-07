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

require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

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
--	background variables
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local BACKGROUND_SPEED = 15
local BACKGROUND_LOOPING_POINT = 413

--	ground variables
local ground = love.graphics.newImage('ground.png')
local goundScroll = 0
local GROUND_SPEED = 60

--	bird object
local bird = Bird()

--	pipe pairs table
local pipePairs = {}

--	spawner track to instatiate objects
local spawnTimer = 0

--	track of the gap of pipe pairs to make the game playable
local lastY = -PIPE_HEIGHT + math.random(80) + 20

--	track of collision
local scrolling = true

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

	--	starting all the fonts used in game and setting the base font
	fontsInit()
	love.graphics.setFont(flappyFont)

	--	setting the virtualization of the window, to make it look like old SNES
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

	--	initialize state machine with all state-returning functions
	gStateMachine = StateMachine {
		['title'] = function() return TitleScreenState() end,
		['countdown'] = function() return CountdownState() end,
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end
	}
	--	set the 'title state' to the state machine
	gStateMachine:change('title')

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
	backgroundScroll = (backgroundScroll + BACKGROUND_SPEED * dt) % BACKGROUND_LOOPING_POINT

	--	make the ground moves by delta time
	goundScroll = (goundScroll + GROUND_SPEED * dt) % VIRTUAL_WIDTH

	--	update the state machine
	gStateMachine:update(dt)

	--  reset the table of the keyboard input
	love.keyboard.keysPressed = {}
end

--[[
	Called after update, used to draw anything in the screen
]]
function love.draw()

    --	push virtualization initialized
	push:start()
    
    --	draw the background
    love.graphics.draw(background, -backgroundScroll, 0)
    
	--	render state machine
	gStateMachine:render()

	--	draw the ground
	love.graphics.draw(ground, -goundScroll, VIRTUAL_HEIGHT - 16)

    --	push virtualization must switch to end state
	 push:finish()
end

--[[
	Function to initialize all the fonts used in game
]]
function fontsInit()
	smallFont = love.graphics.newFont('font.ttf', 8)
	mediumFont = love.graphics.newFont('flappy.ttf', 14)
	flappyFont = love.graphics.newFont('flappy.ttf', 28)
	hugeFont = love.graphics.newFont('flappy.ttf', 56)
end