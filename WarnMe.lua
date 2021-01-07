WarnMe = { }

-- function WarnMe:HelloWorld()
--     message("Hello World!")
-- end

-- WarnMe:HelloWorld()

local eventHandlers = {}
local combatStartTime = nil

function eventHandlers.PLAYER_REGEN_DISABLED(...)
	combatStartTime = GetTime()
end

function eventHandlers.PLAYER_REGEN_ENABLED(...)
	local timeInCombat = GetTime() - combatStartTime
	message("Time in combat: " .. timeInCombat)
	combatStartTime = nil
end

local function getEventHandler(self, event, ...)
	return eventHandlers[event](...)
end

local function onUpdate() 
	if combatStartTime == nil then
		return
	end

	local passedTimeInCombat = math.floor(GetTime() - combatStartTime)
	if (passedTimeInCombat) < 1 then
		return
	end

	print(passedTimeInCombat)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", getEventHandler)
local lastElapsedTime = 0
frame:SetScript("OnUpdate", function(self, elapsed) 
	lastElapsedTime = lastElapsedTime + elapsed
	if lastElapsedTime >= 0.3 then
		lastElapsedTime = 0
		return onUpdate(self, elapsed)
	end
end)