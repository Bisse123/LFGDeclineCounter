local _, core = ...
core.DB = {}

local DB = core.DB

function DB:init()
	if not LFGDeclineCounterDB then
		LFGDeclineCounterDB = {}
	end

	if not LFGDeclineCounterCharacterDB then
		LFGDeclineCounterCharacterDB = {}
	end

	if  not LFGDeclineCounterDB.theme then
		LFGDeclineCounterDB.theme = {
			r = 0,
			g = 0.8,
			b = 1,
			hex = "00ccff"
		}
	end

	if not LFGDeclineCounterDB.options then
		LFGDeclineCounterDB.options = {
			anchor = "top left",
			orientation = "right",
			xOffset = 0,
			yOffset = 2,
			padding = 2,
			scale = 1
		}
	end

	if not LFGDeclineCounterDB.accountLife then
		LFGDeclineCounterDB.accountLife = {
			applyCount = 0,
			declineCount = 0,
			cancelCount = 0,
			delistCount = 0,
			inviteCount = 0,
			acceptCount = 0,
			show = true
		}
	end

	if not LFGDeclineCounterCharacterDB.charLife then
		LFGDeclineCounterCharacterDB.charLife = {
			applyCount = 0,
			declineCount = 0,
			cancelCount = 0,
			delistCount = 0,
			inviteCount = 0,
			acceptCount = 0,
			show = true
		}
	end
	
	if not LFGDeclineCounterDB.showCounters then
		LFGDeclineCounterDB.showCounters = {
		cancel = true,
		delist = true,
		invite = true,
		accept = true
		}
	end

	if not LFGDeclineCounterDB.session then
		LFGDeclineCounterDB.session = {
			applyCount = 0,
			declineCount = 0,
			cancelCount = 0,
			delistCount = 0,
			inviteCount = 0,
			acceptCount = 0,
			crossCharacter = true,
			currentCharacter = {UnitFullName("player")}
		}
	end

	if not LFGDeclineCounterDB.timer then
		LFGDeclineCounterDB.timer = {
			time = GetTime(),
			expiration = GetTime() + 60 * 5 --5 min,
		}
	end

	core.DB.options = LFGDeclineCounterDB.options
	core.DB.accountLife = LFGDeclineCounterDB.accountLife
	core.DB.charLife = LFGDeclineCounterCharacterDB.charLife
	core.DB.showCounters = LFGDeclineCounterDB.showCounters
	core.DB.session = LFGDeclineCounterDB.session
	core.DB.timer = LFGDeclineCounterDB.timer

end

function DB:exit()
	LFGDeclineCounterDB.options = core.DB.options
    LFGDeclineCounterDB.accountLife = core.DB.accountLife
	LFGDeclineCounterCharacterDB.charLife = core.DB.charLife
	LFGDeclineCounterDB.showCounters = core.DB.showCounters
	LFGDeclineCounterDB.session = core.DB.session
	core.DB.timer.expiration = GetTime() + 60 * 5 --5 min
	LFGDeclineCounterDB.timer = core.DB.timer
end