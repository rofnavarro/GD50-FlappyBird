--[[
	States are added with a string identifier and an intialisation function.
	It is expect the init function, when called, will return a table with
	Render, Update, Enter and Exit methods.

	gStateMachine = StateMachine {
 		['MainMenu'] = function()
 			return MainMenu()
 		end,
 		['InnerGame'] = function()
 			return InnerGame()
 		end,
 		['GameOver'] = function()
 			return GameOver()
 		end,
	}
	gStateMachine:change("MainGame")

	Arguments passed into the Change function after the state name
	will be forwarded to the Enter function of the state being changed too.

	State identifiers should have the same name as the state table, unless there's a good
	reason not to. i.e. MainMenu creates a state using the MainMenu table. This keeps things
	straight forward.
]]
StateMachine = Class{}

--	used to initialize the state machine and an empty table
function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}

	self.states = states or {}
	self.current = self.empty
end

--	used to change the state machine by the state name in a correct way
function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName])
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

--	used to update the current state
function StateMachine:update(dt)
	self.current:update(dt)
end

--	used to render the current state
function StateMachine:render()
	self.current:render()
end