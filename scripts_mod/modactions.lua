local _G = GLOBAL
local ACTIONS = _G.ACTIONS

--Cooking

local old_cook_fn = ACTIONS.COOK.fn
ACTIONS.COOK.fn = function(act)
	if act.target.components.constructer ~= nil then
		if act.target.components.constructer:IsConstructing() then
			return true
		end

		local container = act.target.components.container
		if container ~= nil and container:IsOpen() and not container:IsOpenedBy(act.doer) then
			return false, "INUSE"
		elseif not act.target.components.constructer:CanConstruct() then
			return false
		end

		act.target.components.constructer:StartConstructing()
		return true
	end
	return old_cook_fn(act)
end