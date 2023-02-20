local _, core = ...
core.Counter = {}

local Counter = core.Counter
local sessionFrame
local charFrame
local accFrame

local COUNT_FRAME_WIDTH = 300
local COUNT_FRAME_HEIGHT = 100
local TEXT_SIZE = 12
local TEXT_TITLE_SIZE = 20
local TEXT_TITLE_OFFSET = -10

local textColumns = {
    left = (COUNT_FRAME_WIDTH/16),
    right = (COUNT_FRAME_WIDTH*3/5)
}

local textRows = {
    [1] = -40,
    [2] = -60,
    [3] = -80
}

local textPositions = {
    [1] = {x = textColumns.left, y = textRows[1]},
    [2] = {x = textColumns.right, y = textRows[1]},
    [3] = {x = textColumns.left, y = textRows[2]},
    [4] = {x = textColumns.right, y = textRows[2]},
    [5] = {x = textColumns.left, y = textRows[3]},
    [6] = {x = textColumns.right, y = textRows[3]}
}

local sessionFrameAchor = {
    ["top left"] = {point = "BOTTOMLEFT", relativePoint = "TOPLEFT"},
    ["top right"] = {point = "BOTTOMRIGHT", relativePoint = "TOPRIGHT"},
    ["bottom left"] = {point = "TOPLEFT", relativePoint = "BOTTOMLEFT"},
    ["bottom right"] = {point = "TOPRIGHT", relativePoint = "BOTTOMRIGHT"},
    ["top"]  = {point = "BOTTOM", relativePoint = "TOP"},
    ["bottom"] = {point = "TOP", relativePoint = "BOTTOM"},
    ["left"] = {point = "RIGHT", relativePoint = "LEFT"},
    ["right"] = {point = "LEFT", relativePoint = "RIGHT"},
    ["center"] = {point = "CENTER", relativePoint = "CENTER"}
}

local frameOrientation = {
    ["up"] = {point = "BOTTOM", relativePoint = "TOP"},
    ["down"] = {point = "TOP", relativePoint = "BOTTOM"},
    ["left"] = {point = "RIGHT", relativePoint = "LEFT"},
    ["right"] = {point = "LEFT", relativePoint = "RIGHT"}
}


----------------------------------
-- GUI functions
----------------------------------
local function compareCharacterNames()
    local characterName = {UnitFullName("player")}
    return core.DB.session.currentCharacter[1] == characterName[1] and core.DB.session.currentCharacter[2] == characterName[2]
end

function Counter:initSession()
    core.DB.timer.time = GetTime()
    if (core.DB.timer.expiration < core.DB.timer.time) or (not (compareCharacterNames()) and not (core.DB.session.crossCharacter)) then
        core.DB.session = {
            applyCount = 0,
            declineCount = 0,
            cancelCount = 0,
            delistCount = 0,
            inviteCount = 0,
            acceptCount = 0
        }
    end
    core.DB.session.currentCharacter = {UnitFullName("player")}
end

function Counter:initCountFrames()
    Counter:createSessionFrame()
    Counter:createCharacterFrame()
    Counter:createAccFrame()
    Counter:setPadding()
    Counter:showHideAll()
    Counter:updateTextPoints()
end


local function createText(point, relativeFrame, relativePoint, xOffset, yOffset, input, size, parent)
	local text = relativeFrame:CreateFontString(parent, "OVERLAY", "GameFontHighlightLarge")
	text:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
	text:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	text:SetText(input)
	return text
end

----------------------------------
-- show/hide functions
----------------------------------

function Counter:showHideCancel()
    if core.DB.showCounters.cancel then
        sessionFrame.CancelText:Show()
        charFrame.CancelText:Show()
        accFrame.CancelText:Show()
    else
        sessionFrame.CancelText:Hide()
        charFrame.CancelText:Hide()
        accFrame.CancelText:Hide()
    end
end

function Counter:showHideDelist()
    if core.DB.showCounters.delist then
        sessionFrame.DelistText:Show()
        charFrame.DelistText:Show()
        accFrame.DelistText:Show()
    else
        sessionFrame.DelistText:Hide()
        charFrame.DelistText:Hide()
        accFrame.DelistText:Hide()
    end
end

function Counter:showHideInvite()
    if core.DB.showCounters.invite then
        sessionFrame.InviteText:Show()
        charFrame.InviteText:Show()
        accFrame.InviteText:Show()
    else
        sessionFrame.InviteText:Hide()
        charFrame.InviteText:Hide()
        accFrame.InviteText:Hide()
    end
end

function Counter:showHideAccept()
    if core.DB.showCounters.accept then
        sessionFrame.AcceptText:Show()
        charFrame.AcceptText:Show()
        accFrame.AcceptText:Show()
    else
        sessionFrame.AcceptText:Hide()
        charFrame.AcceptText:Hide()
        accFrame.AcceptText:Hide()
    end
end

function Counter:showHideAll()
    Counter:showHideCancel()
    Counter:showHideDelist()
    Counter:showHideInvite()
    Counter:showHideAccept()
end

----------------------------------
-- Update text functions
----------------------------------

function Counter:updateTextPoints()
    local count = 3
    
    if core.DB.showCounters.cancel then
        sessionFrame.CancelText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        charFrame.CancelText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        accFrame.CancelText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        count = count + 1
    end

    if core.DB.showCounters.delist then
        sessionFrame.DelistText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        charFrame.DelistText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        accFrame.DelistText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        count = count + 1
    end

    if core.DB.showCounters.invite then
        sessionFrame.InviteText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        charFrame.InviteText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        accFrame.InviteText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        count = count + 1
    end
    
    if core.DB.showCounters.accept then
        sessionFrame.AcceptText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        charFrame.AcceptText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        accFrame.AcceptText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x * core.DB.options.scale, textPositions[count].y * core.DB.options.scale)
        count = count + 1
    end

    if count < 4 then
        sessionFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 60 * core.DB.options.scale)
        charFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 60 * core.DB.options.scale)
        accFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 60 * core.DB.options.scale)
    elseif count < 6 then
        sessionFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 80 * core.DB.options.scale)
        charFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 80 * core.DB.options.scale)
        accFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, 80 * core.DB.options.scale)
    else 
        sessionFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
        charFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
        accFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
    end
end

local function applyTextUpdate()
    sessionFrame.ApplyText:SetText("Apply Count: " .. core.DB.session.applyCount)
    charFrame.ApplyText:SetText("Apply Count: " .. core.DB.charLife.applyCount)
    accFrame.ApplyText:SetText("Apply Count: " .. core.DB.accountLife.applyCount)
end

local function declineTextUpdate()
    sessionFrame.DeclineText:SetText("Decline Count: " .. core.DB.session.declineCount)
    charFrame.DeclineText:SetText("Decline Count: " .. core.DB.charLife.declineCount)
    accFrame.DeclineText:SetText("Decline Count: " .. core.DB.accountLife.declineCount)
end

local function cancelTextUpdate()
    sessionFrame.CancelText:SetText("Cancel Count: " .. core.DB.session.cancelCount)
    charFrame.CancelText:SetText("Cancel Count: " .. core.DB.charLife.cancelCount)
    accFrame.CancelText:SetText("Cancel Count: " .. core.DB.accountLife.cancelCount)
end

local function delistTextUpdate()
    sessionFrame.DelistText:SetText("Delist Count: " .. core.DB.session.delistCount)
    charFrame.DelistText:SetText("Delist Count: " .. core.DB.charLife.delistCount)
    accFrame.DelistText:SetText("Delist Count: " .. core.DB.accountLife.delistCount)
end

local function inviteTextUpdate()
    sessionFrame.InviteText:SetText("Invite Count: " .. core.DB.session.inviteCount)
    charFrame.InviteText:SetText("Invite Count: " .. core.DB.charLife.inviteCount)
    accFrame.InviteText:SetText("Invite Count: " .. core.DB.accountLife.inviteCount)
end

local function acceptTextUpdate()
    sessionFrame.AcceptText:SetText("Accept Count: " .. core.DB.session.acceptCount)
    charFrame.AcceptText:SetText("Accept Count: " .. core.DB.charLife.acceptCount)
    accFrame.AcceptText:SetText("Accept Count: " .. core.DB.accountLife.acceptCount)
end

function Counter:allTextUpdate()
    applyTextUpdate()
    declineTextUpdate()
    cancelTextUpdate()
    delistTextUpdate()
    inviteTextUpdate()
    acceptTextUpdate()
end

----------------------------------
-- Anchor functions
----------------------------------
local function findPadDirection()
    local padOrientation = {
        ["up"] = {pad = core.DB.options.padding, padDirection = "y"},
        ["down"] = {pad = -core.DB.options.padding, padDirection = "y"},
        ["left"] = {pad = -core.DB.options.padding, padDirection = "x"},
        ["right"] = {pad = core.DB.options.padding, padDirection = "x"}
    }
    local x = 0
    local y = 0
    if padOrientation[core.DB.options.orientation].padDirection == "y" then
        y = padOrientation[core.DB.options.orientation].pad
    elseif padOrientation[core.DB.options.orientation].padDirection == "x" then
        x = padOrientation[core.DB.options.orientation].pad
    end
    return x, y
end

function Counter:updateAnchorPosition()
    sessionFrame:ClearAllPoints()
    sessionFrame:SetPoint(sessionFrameAchor[core.DB.options.anchor].point, PVEFrame, sessionFrameAchor[core.DB.options.anchor].relativePoint, core.DB.options.xOffset, core.DB.options.yOffset)
end

function Counter:updateOrientation()
        local x, y = findPadDirection()
        charFrame:ClearAllPoints()
        charFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, sessionFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
    Counter:checkAccountAnchor()
end

function Counter:setPadding()
    local x, y = findPadDirection()
    charFrame:ClearAllPoints()
    charFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, sessionFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
    if core.DB.charLife.show then
        accFrame:ClearAllPoints()
        accFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, charFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
    else
        accFrame:ClearAllPoints()
        accFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, sessionFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
    end
end

function Counter:setOffset()
    sessionFrame:SetPoint(sessionFrameAchor[core.DB.options.anchor].point, PVEFrame, sessionFrameAchor[core.DB.options.anchor].relativePoint, core.DB.options.xOffset, core.DB.options.yOffset)
end

function Counter:checkAccountAnchor()
    if core.DB.accountLife.show then
        local x, y = findPadDirection()
        accFrame:ClearAllPoints()
        if core.DB.charLife.show then
            accFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, charFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
        else
            accFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, sessionFrame, frameOrientation[core.DB.options.orientation].relativePoint, x, y)
        end
    end
end

function Counter:Setscaling()
    sessionFrame.ApplyText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale)
    charFrame.ApplyText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale)
    accFrame.ApplyText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale)
    
    sessionFrame.DeclineText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale)
    charFrame.DeclineText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale)
    accFrame.DeclineText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale)
    

	sessionFrame.Title:SetPoint("TOP", sessionFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale)
	charFrame.Title:SetPoint("TOP", charFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale)
	accFrame.Title:SetPoint("TOP", accFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale)
    
	sessionFrame.Title:SetFont("Fonts\\FRIZQT__.TTF", TEXT_TITLE_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.Title:SetFont("Fonts\\FRIZQT__.TTF", TEXT_TITLE_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.Title:SetFont("Fonts\\FRIZQT__.TTF", TEXT_TITLE_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.ApplyText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.ApplyText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.ApplyText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.DeclineText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.DeclineText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.DeclineText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.CancelText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.CancelText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.CancelText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.DelistText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.DelistText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.DelistText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.InviteText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.InviteText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.InviteText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
    
	sessionFrame.AcceptText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	charFrame.AcceptText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")
	accFrame.AcceptText:SetFont("Fonts\\FRIZQT__.TTF", TEXT_SIZE * core.DB.options.scale, "OUTLINE")

    Counter:updateTextPoints()
end
----------------------------------
-- Get functions
----------------------------------

function Counter:GetcharFrame()
    return charFrame or Counter:createCharacterFrame()
end

function Counter:GetaccFrame()
    return accFrame or Counter:createAccFrame()
end

----------------------------------
-- Count function
----------------------------------

function Counter:newCount(newStatus)
    if (newStatus == "applied") then
        core.DB.session.applyCount = core.DB.session.applyCount + 1
        core.DB.charLife.applyCount = core.DB.charLife.applyCount  + 1
        core.DB.accountLife.applyCount = core.DB.accountLife.applyCount + 1
        applyTextUpdate()
    elseif (newStatus == "declined") or (newStatus == "declined_full") or (newStatus == "timedout") then
        core.DB.session.declineCount = core.DB.session.declineCount + 1
        core.DB.charLife.declineCount = core.DB.charLife.declineCount + 1
        core.DB.accountLife.declineCount = core.DB.accountLife.declineCount + 1
        declineTextUpdate()
    elseif (newStatus == "cancelled") then
        core.DB.session.cancelCount = core.DB.session.cancelCount + 1
        core.DB.charLife.cancelCount = core.DB.charLife.cancelCount + 1
        core.DB.accountLife.cancelCount = core.DB.accountLife.cancelCount + 1
        cancelTextUpdate()
    elseif (newStatus == "declined_delisted") then
        core.DB.session.delistCount = core.DB.session.delistCount + 1
        core.DB.charLife.delistCount = core.DB.charLife.delistCount + 1
        core.DB.accountLife.delistCount = core.DB.accountLife.delistCount + 1
        delistTextUpdate()
    elseif (newStatus == "invited") then
        core.DB.session.inviteCount = core.DB.session.inviteCount + 1
        core.DB.charLife.inviteCount = core.DB.charLife.inviteCount + 1
        core.DB.accountLife.inviteCount = core.DB.accountLife.inviteCount + 1
        inviteTextUpdate()
    elseif (newStatus == "inviteaccepted") then
        core.DB.session.acceptCount = core.DB.session.acceptCount + 1
        core.DB.charLife.acceptCount = core.DB.charLife.acceptCount + 1
        core.DB.accountLife.acceptCount = core.DB.accountLife.acceptCount + 1
        acceptTextUpdate()
    end
end

----------------------------------
-- Main functions
----------------------------------

function Counter:createSessionFrame()
    sessionFrame = CreateFrame("Frame", "sessionCountFrame", PVEFrame)
    sessionFrame:ClearAllPoints()
    sessionFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
    sessionFrame:SetPoint(sessionFrameAchor[core.DB.options.anchor].point, PVEFrame, sessionFrameAchor[core.DB.options.anchor].relativePoint, core.DB.options.xOffset, core.DB.options.yOffset)
    sessionFrame.tex = sessionFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    sessionFrame.tex:SetAllPoints(sessionFrame)
    sessionFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    sessionFrame.Title = createText("TOP", sessionFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale, "Current Session", TEXT_TITLE_SIZE * core.DB.options.scale, nil)
    
    sessionFrame.ApplyText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale, "Apply Count: " .. core.DB.session.applyCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame.DeclineText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale, "Decline Count: " .. core.DB.session.declineCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame.CancelText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[3].x * core.DB.options.scale, textPositions[3].y * core.DB.options.scale, "Cancel Count: " .. core.DB.session.cancelCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame.DelistText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[4].x * core.DB.options.scale, textPositions[4].y * core.DB.options.scale, "Delist Count: " .. core.DB.session.delistCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame.InviteText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[5].x * core.DB.options.scale, textPositions[5].y * core.DB.options.scale, "Invite Count: " .. core.DB.session.inviteCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame.AcceptText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[6].x * core.DB.options.scale, textPositions[6].y * core.DB.options.scale, "Accept Count: " .. core.DB.session.acceptCount, TEXT_SIZE * core.DB.options.scale, nil)
    sessionFrame:Show()
    return sessionFrame
end

function Counter:createCharacterFrame()
    charFrame = CreateFrame("Frame", "CharCountFrame", PVEFrame)
    charFrame:ClearAllPoints()
    charFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
    charFrame:SetPoint(frameOrientation[core.DB.options.orientation].point, sessionFrame, frameOrientation[core.DB.options.orientation].relativePoint, 0, 0)
    charFrame.tex = charFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    charFrame.tex:SetAllPoints(charFrame)
    charFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    charFrame.Title = createText("TOP", charFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale, "Character Lifetime", TEXT_TITLE_SIZE * core.DB.options.scale, nil)

    charFrame.ApplyText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale, "Apply Count: " .. core.DB.charLife.applyCount, TEXT_SIZE * core.DB.options.scale, nil)
    charFrame.DeclineText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale, "Decline Count: " .. core.DB.charLife.declineCount, TEXT_SIZE * core.DB.options.scale, nil)
    charFrame.CancelText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[3].x * core.DB.options.scale, textPositions[3].y * core.DB.options.scale, "Cancel Count: " .. core.DB.charLife.cancelCount, TEXT_SIZE * core.DB.options.scale, nil)
    charFrame.DelistText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[4].x * core.DB.options.scale, textPositions[4].y * core.DB.options.scale, "Delist Count: " .. core.DB.charLife.delistCount, TEXT_SIZE * core.DB.options.scale, nil)
    charFrame.InviteText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[5].x * core.DB.options.scale, textPositions[5].y * core.DB.options.scale, "Invite Count: " .. core.DB.charLife.inviteCount, TEXT_SIZE * core.DB.options.scale, nil)
    charFrame.AcceptText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[6].x * core.DB.options.scale, textPositions[6].y * core.DB.options.scale, "Accept Count: " .. core.DB.charLife.acceptCount, TEXT_SIZE * core.DB.options.scale, nil)
    
    charFrame:SetShown(core.DB.charLife.show)
    
    return charFrame
end

function Counter:createAccFrame()
    accFrame = CreateFrame("Frame", "CharCountFrame", PVEFrame)
    accFrame:ClearAllPoints()
    accFrame:SetSize(COUNT_FRAME_WIDTH * core.DB.options.scale, COUNT_FRAME_HEIGHT * core.DB.options.scale)
    Counter:checkAccountAnchor()
    accFrame.tex = accFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    accFrame.tex:SetAllPoints(accFrame)
    accFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    accFrame.Title = createText("TOP", accFrame, "TOP", 0, TEXT_TITLE_OFFSET * core.DB.options.scale, "Account Lifetime", TEXT_TITLE_SIZE * core.DB.options.scale, nil)

    accFrame.ApplyText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[1].x * core.DB.options.scale, textPositions[1].y * core.DB.options.scale, "Apply Count: " .. core.DB.accountLife.applyCount, TEXT_SIZE * core.DB.options.scale, nil)
    accFrame.DeclineText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[2].x * core.DB.options.scale, textPositions[2].y * core.DB.options.scale, "Decline Count: " .. core.DB.accountLife.declineCount, TEXT_SIZE * core.DB.options.scale, nil)
    accFrame.CancelText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[3].x * core.DB.options.scale, textPositions[3].y * core.DB.options.scale, "Cancel Count: " .. core.DB.accountLife.cancelCount, TEXT_SIZE * core.DB.options.scale, nil)
    accFrame.DelistText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[4].x * core.DB.options.scale, textPositions[4].y * core.DB.options.scale, "Delist Count: " .. core.DB.accountLife.delistCount, TEXT_SIZE * core.DB.options.scale, nil)
    accFrame.InviteText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[5].x * core.DB.options.scale, textPositions[5].y * core.DB.options.scale, "Invite Count: " .. core.DB.accountLife.inviteCount, TEXT_SIZE * core.DB.options.scale, nil)
    accFrame.AcceptText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[6].x * core.DB.options.scale, textPositions[6].y * core.DB.options.scale, "Accept Count: " .. core.DB.accountLife.acceptCount, TEXT_SIZE * core.DB.options.scale, nil)
    
    accFrame:SetShown(core.DB.accountLife.show)
    
    return charFrame
end