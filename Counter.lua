local _, core = ...
core.Counter = {}

local Counter = core.Counter

----------------------------------
-- Count function
----------------------------------

function Counter:newCount(newStatus)
    if (newStatus == "applied") then
        core.DB.session.applyCount = core.DB.session.applyCount + 1
        core.DB.charLife.applyCount = core.DB.charLife.applyCount  + 1
        core.DB.accountLife.applyCount = core.DB.accountLife.applyCount + 1
        core.Config.applyTextUpdate()
    elseif (newStatus == "declined") or (newStatus == "declined_full") or (newStatus == "timedout") then
        core.DB.session.declineCount = core.DB.session.declineCount + 1
        core.DB.charLife.declineCount = core.DB.charLife.declineCount + 1
        core.DB.accountLife.declineCount = core.DB.accountLife.declineCount + 1
        core.Config.declineTextUpdate()
    elseif (newStatus == "cancelled") then
        core.DB.session.cancelCount = core.DB.session.cancelCount + 1
        core.DB.charLife.cancelCount = core.DB.charLife.cancelCount + 1
        core.DB.accountLife.cancelCount = core.DB.accountLife.cancelCount + 1
        core.Config.cancelTextUpdate()
    elseif (newStatus == "declined_delisted") then
        core.DB.session.delistCount = core.DB.session.delistCount + 1
        core.DB.charLife.delistCount = core.DB.charLife.delistCount + 1
        core.DB.accountLife.delistCount = core.DB.accountLife.delistCount + 1
        core.Config.delistTextUpdate()
    elseif (newStatus == "invited") then
        core.DB.session.invitedCount = core.DB.session.invitedCount + 1
        core.DB.charLife.invitedCount = core.DB.charLife.invitedCount + 1
        core.DB.accountLife.invitedCount = core.DB.accountLife.invitedCount + 1
        core.Config.inviteTextUpdate()
    elseif (newStatus == "inviteaccepted") then
        core.DB.session.acceptedCount = core.DB.session.acceptedCount + 1
        core.DB.charLife.acceptedCount = core.DB.charLife.acceptedCount + 1
        core.DB.accountLife.acceptedCount = core.DB.accountLife.acceptedCount + 1
        core.Config.acceptTextUpdate()
    end
end
