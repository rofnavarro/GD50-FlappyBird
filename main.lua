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
end