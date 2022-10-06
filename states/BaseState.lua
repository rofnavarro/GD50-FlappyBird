--[[
	BaseState works like a 'handler'.
	It implements empty methods so you can chose which methods you want to define
]]
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end