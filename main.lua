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
push = require 'util/push'

--	class library allow to use classes and objects in lua
--	https://github.com/vrld/hump/blob/master/class.lua
Class = require 'util/class'

--  calling the classes
require 'class/Butterfly'

require 'class/Pipe'

require 'class/PipePair'

require 'class/StateMachine'
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
local background = love.graphics.newImage('png/background.png')
local backgroundScroll = 0
local BACKGROUND_SPEED = 15
local BACKGROUND_LOOPING_POINT = 413

--	ground variables
local ground = love.graphics.newImage('png/ground.png')
local goundScroll = 0
local GROUND_SPEED = 60

--	butterfly object
local butterfly = Butterfly()

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
    love.window.setTitle("Drunk Butterfly")

    --  setting the seed for the random number
    math.randomseed(os.time())

	--	starting all the sound used in game
	soundsInit()

	--	setting the music and loop
	sounds['music']:setLooping(true)
	sounds['music']:play()

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

	--	setting the track of the mouse
	love.mouse.buttonsPressed = {}

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
	Mouse handling, called each frame
]]
function love.mousepressed(x, y, button)
	love.mouse.buttonsPressed[button] = true
end

--[[
    Re-write of the keyboard input
]]
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
	Re-write of the mouse input
]]
function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
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
	love.mouse.buttonsPressed = {}
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
	smallFont = love.graphics.newFont('font/font.ttf', 8)
	mediumFont = love.graphics.newFont('font/flappy.ttf', 14)
	flappyFont = love.graphics.newFont('font/flappy.ttf', 28)
	hugeFont = love.graphics.newFont('font/flappy.ttf', 56)
end

--[[

]]
function soundsInit()
	sounds = {
		['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
		['explosion'] = love.audio.newSource('audio/explosion.wav', 'static'),
		['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
		['score'] = love.audio.newSource('audio/score.wav', 'static'),

		--	https://freesound.org/people/xsgianni/sounds/388079/
		['music'] = love.audio.newSource('audio/marios_way.mp3', 'static')
	}
end