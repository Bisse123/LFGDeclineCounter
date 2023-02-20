local _, core = ...


core.commands = {
	["options"] = core.Config.Toggle,
	["rc"] = core.Config.resetCharacterLife,
	["ra"] = core.Config.resetAccountLife
}

local function HandleSlashCommands(str)	
	if (#str == 0) then
		core:Print("List of slash commands:")
		core:Print("|cff00cc66/dc options|r - Open options")
		core:Print("|cff00cc66/dc rc|r - Resets Character count")
		core:Print("|cff00cc66/dc ra|r - Resets Account count")
		return
	end	
	
	local args = {}
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg)
		end
	end
	
	local path = core.commands
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then
			arg = arg:lower()
			if (path[arg]) then
				if (type(path[arg]) == "function") then
					path[arg](select(id + 1, unpack(args)))
					return
				elseif (type(path[arg]) == "table") then
				end
			else
				core:Print("List of slash commands:")
				core:Print("|cff00cc66/dc options|r - Open options")
				core:Print("|cff00cc66/dc rc|r - Resets Character count")
				core:Print("|cff00cc66/dc ra|r - Resets Account count")
				return
			end
		end
	end
end

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor())
    local prefix = string.format("|cff%s%s|r", hex:upper(), "LFG Decline Counter:")
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...))
end


function core:init(event, ...)
	if event == "ADDON_LOADED" and select(1,...) == "LFGDeclineCounter" then
		SLASH_LFGDeclineCounter1 = "/dc"
		SlashCmdList.LFGDeclineCounter = HandleSlashCommands
		core.DB.init()
		core.Counter.initSession()
		core.Counter.initCountFrames()
	elseif event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
		core.Counter.newCount(...)
	elseif event == "PLAYER_LOGOUT" then
		core.DB.exit()
	end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGOUT")
events:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
events:SetScript("OnEvent", core.init)