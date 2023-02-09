local _, core = ...
core.Config = {}

local Config = core.Config
local UIConfig
local sessionFrame
local charFrame
local accFrame

local CONFIG_FRAME_WIDTH = 460
local CONFIG_FRAME_HEIGHT = 250

local COUNT_FRAME_WIDTH = 300
local COUNT_FRAME_HEIGHT = 100


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

----------------------------------
-- GUI functions
----------------------------------

function Config:Toggle()
    local menu = UIConfig or Config:CreateMenu()
    menu:SetShown(not menu:IsShown())
end

function Config:initSession()
    core.DB.timer.time = GetTime()
    if (core.DB.timer.expiration < core.DB.timer.time) or (not (Config:compareCharacterNames()) and not (core.DB.session.crossCharacter)) then
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

function Config:initCountFrames()
    Config:createSessionFrame()
    Config:createCharacterFrame()
    Config:createAccFrame()
    Config:updateTextPoints()
end

function Config:GetThemeColor()
    local c = LFGDeclineCounterDB.theme
    return c.r, c.g, c.b, c.hex
end

----------------------------------
-- Create functions
----------------------------------

local function CreateButton(point, relativeFrame, relativePoint, xOffset, yOffset, width, height, input, func)
    local btn = CreateFrame("Button", nil, relativeFrame)
	btn:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	btn:SetSize(width, height)
	btn:SetText(input)
	btn:SetNormalFontObject("GameFontNormal")
	btn:SetHighlightFontObject("GameFontHighlight")
	btn:SetScript("OnClick", func)
    btn.tex = btn:CreateTexture(nil, "BACKGROUND", nil, -7)
    btn.tex:SetAllPoints(btn)
    local r, g, b, hex = Config:GetThemeColor()
    btn.tex:SetColorTexture(r, g, b, 0.75)
	return btn
end

local function CreateCheckButton(point, relativeFrame, relativePoint, xOffset, yOffset, input, checked, func, name)
    local btn = CreateFrame("CheckButton", name, relativeFrame, "UICheckButtonTemplate")
    btn:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	_G[name .. "Text"]:SetText(input)
    btn:SetChecked(checked)
	btn:SetScript("OnClick", func)
    return btn
end

local function createText(point, relativeFrame, relativePoint, xOffset, yOffset, input, size, parent)
	local text = relativeFrame:CreateFontString(parent, "OVERLAY", "GameFontHighlightLarge")
	text:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
	text:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	text:SetText(input)
	return text
end

----------------------------------
-- Show/Hide functions
----------------------------------

local function showCancelCount()
    core.DB.showCounters.cancel = not core.DB.showCounters.cancel
    Config:updateTextPoints()
end

local function showDelistCount()
    core.DB.showCounters.delist = not core.DB.showCounters.delist
    Config:updateTextPoints()
end

local function showInviteCount()
    core.DB.showCounters.invite = not core.DB.showCounters.invite
    Config:updateTextPoints()
end

local function showAcceptCount()
    core.DB.showCounters.accept = not core.DB.showCounters.accept
    Config:updateTextPoints()
end

----------------------------------
-- Update text functions
----------------------------------

function Config:updateTextPoints()
    local count = 3
    if core.DB.showCounters.cancel then
        sessionFrame.CancelText:Show()
        charFrame.CancelText:Show()
        accFrame.CancelText:Show()
        sessionFrame.CancelText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        charFrame.CancelText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        accFrame.CancelText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        count = count + 1
    else
        sessionFrame.CancelText:Hide()
        charFrame.CancelText:Hide()
        accFrame.CancelText:Hide()
    end

    if core.DB.showCounters.delist then
        sessionFrame.DelistText:Show()
        charFrame.DelistText:Show()
        accFrame.DelistText:Show()
        sessionFrame.DelistText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        charFrame.DelistText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        accFrame.DelistText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        count = count + 1
    else
        sessionFrame.DelistText:Hide()
        charFrame.DelistText:Hide()
        accFrame.DelistText:Hide()
    end

    if core.DB.showCounters.invite then
        sessionFrame.InviteText:Show()
        charFrame.InviteText:Show()
        accFrame.InviteText:Show()
        sessionFrame.InviteText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        charFrame.InviteText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        accFrame.InviteText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        count = count + 1
    else
        sessionFrame.InviteText:Hide()
        charFrame.InviteText:Hide()
        accFrame.InviteText:Hide()
    end
    
    if core.DB.showCounters.accept then
        sessionFrame.AcceptText:Show()
        charFrame.AcceptText:Show()
        accFrame.AcceptText:Show()
        sessionFrame.AcceptText:SetPoint("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        charFrame.AcceptText:SetPoint("TOPLEFT", charFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        accFrame.AcceptText:SetPoint("TOPLEFT", accFrame, "TOPLEFT", textPositions[count].x, textPositions[count].y)
        count = count + 1
    else
        sessionFrame.AcceptText:Hide()
        charFrame.AcceptText:Hide()
        accFrame.AcceptText:Hide()
    end

    if count < 4 then
        sessionFrame:SetSize(COUNT_FRAME_WIDTH, 60)
        charFrame:SetSize(COUNT_FRAME_WIDTH, 60)
        accFrame:SetSize(COUNT_FRAME_WIDTH, 60)
    elseif count < 6 then
        sessionFrame:SetSize(COUNT_FRAME_WIDTH, 80)
        charFrame:SetSize(COUNT_FRAME_WIDTH, 80)
        accFrame:SetSize(COUNT_FRAME_WIDTH, 80)
    else 
        sessionFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
        charFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
        accFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
    end
end

function Config:allTextUpdate()
    Config:applyTextUpdate()
    Config:declineTextUpdate()
    Config:cancelTextUpdate()
    Config:delistTextUpdate()
    Config:inviteTextUpdate()
    Config:acceptTextUpdate()
end

function Config:applyTextUpdate()
    sessionFrame.ApplyText:SetText("Apply Count: " .. core.DB.session.applyCount)
    charFrame.ApplyText:SetText("Apply Count: " .. core.DB.charLife.applyCount)
    accFrame.ApplyText:SetText("Apply Count: " .. core.DB.accountLife.applyCount)
end

function Config:declineTextUpdate()
    sessionFrame.DeclineText:SetText("Decline Count: " .. core.DB.session.declineCount)
    charFrame.DeclineText:SetText("Decline Count: " .. core.DB.charLife.declineCount)
    accFrame.DeclineText:SetText("Decline Count: " .. core.DB.accountLife.declineCount)
end

function Config:cancelTextUpdate()
    sessionFrame.CancelText:SetText("Cancel Count: " .. core.DB.session.cancelCount)
    charFrame.CancelText:SetText("Cancel Count: " .. core.DB.charLife.cancelCount)
    accFrame.CancelText:SetText("Cancel Count: " .. core.DB.accountLife.cancelCount)
end

function Config:delistTextUpdate()
    sessionFrame.DelistText:SetText("Delist Count: " .. core.DB.session.delistCount)
    charFrame.DelistText:SetText("Delist Count: " .. core.DB.charLife.delistCount)
    accFrame.DelistText:SetText("Delist Count: " .. core.DB.accountLife.delistCount)
end

function Config:inviteTextUpdate()
    sessionFrame.InviteText:SetText("Invite Count: " .. core.DB.session.inviteCount)
    charFrame.InviteText:SetText("Invite Count: " .. core.DB.charLife.inviteCount)
    accFrame.InviteText:SetText("Invite Count: " .. core.DB.accountLife.inviteCount)
end

function Config:acceptTextUpdate()
    sessionFrame.AcceptText:SetText("Accept Count: " .. core.DB.session.acceptCount)
    charFrame.AcceptText:SetText("Accept Count: " .. core.DB.charLife.acceptCount)
    accFrame.AcceptText:SetText("Accept Count: " .. core.DB.accountLife.acceptCount)
end



----------------------------------
-- Anchor functions
----------------------------------
local function checkAnchor()
    if core.DB.accountLife.show then
        if core.DB.charLife.show then
            accFrame:SetPoint("TOPLEFT", charFrame, "TOPRIGHT", 2, 0)
        else
            accFrame:SetPoint("TOPLEFT", sessionFrame, "TOPRIGHT", 2, 0)
        end
    end

end
----------------------------------
-- Character functions
----------------------------------

local function showCharacterLife()
    local menu = charFrame or Config:createCharacterFrame()
    core.DB.charLife.show = not core.DB.charLife.show
    menu:SetShown(core.DB.charLife.show)
    checkAnchor()
end

local function resetCharacterLife()
    core.DB.charLife.applyCount = 0
    core.DB.charLife.declineCount = 0
    core.DB.charLife.cancelCount = 0
    core.DB.charLife.delistCount = 0
    core.DB.charLife.inviteCount = 0
    core.DB.charLife.acceptCount = 0

    Config:allTextUpdate()
end

local function crossCharacterChange()
    core.DB.session.crossCharacter = not core.DB.session.crossCharacter
end

function Config:compareCharacterNames()
    local characterName = {UnitFullName("player")}
    return core.DB.session.currentCharacter[1] == characterName[1] and core.DB.session.currentCharacter[2] == characterName[2]
end
----------------------------------
-- Account functions
----------------------------------

local function showAccountLife()
    local menu = accFrame or Config:createAccountFrame()
    core.DB.accountLife.show = not core.DB.accountLife.show
    menu:SetShown(core.DB.accountLife.show)
    checkAnchor()
end

local function resetAccountLife()
    core.DB.accountLife.applyCount = 0
    core.DB.accountLife.declineCount = 0
    core.DB.accountLife.cancelCount = 0
    core.DB.accountLife.delistCount = 0
    core.DB.accountLife.inviteCount = 0
    core.DB.accountLife.acceptCount = 0
    
    Config:allTextUpdate()
end
----------------------------------
-- Main functions
----------------------------------

function Config:createSessionFrame()
    sessionFrame = CreateFrame("Frame", "sessionCountFrame", PVEFrame)
    sessionFrame:ClearAllPoints()
    sessionFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
    sessionFrame:SetPoint("BOTTOMLEFT", PVEFrame, "TOPLEFT", 0, 5)
    sessionFrame.tex = sessionFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    sessionFrame.tex:SetAllPoints(sessionFrame)
    sessionFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    sessionFrame.SessionText = createText("TOP", sessionFrame, "TOP", 0, -10, "Current Session", 20, nil)
    
    sessionFrame.ApplyText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[1].x, textPositions[1].y, "Apply Count: " .. core.DB.session.applyCount, 12, nil)
    sessionFrame.DeclineText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[2].x, textPositions[2].y, "Decline Count: " .. core.DB.session.declineCount, 12, nil)
    sessionFrame.CancelText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[3].x, textPositions[3].y, "Cancel Count: " .. core.DB.session.cancelCount, 12, nil)
    sessionFrame.DelistText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[4].x, textPositions[4].y, "Delist Count: " .. core.DB.session.delistCount, 12, nil)
    sessionFrame.InviteText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[5].x, textPositions[5].y, "Invite Count: " .. core.DB.session.inviteCount, 12, nil)
    sessionFrame.AcceptText = createText("TOPLEFT", sessionFrame, "TOPLEFT", textPositions[6].x, textPositions[6].y, "Accept Count: " .. core.DB.session.acceptCount, 12, nil)
    sessionFrame:Show()
    return sessionFrame
end

function Config:createCharacterFrame()
    charFrame = CreateFrame("Frame", "CharCountFrame", PVEFrame)
    charFrame:ClearAllPoints()
    charFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
    charFrame:SetPoint("TOPLEFT", sessionFrame, "TOPRIGHT", 2, 0)
    charFrame.tex = charFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    charFrame.tex:SetAllPoints(charFrame)
    charFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    charFrame.SessionText = createText("TOP", charFrame, "TOP", 0, -10, "Character Lifetime", 20, nil)

    charFrame.ApplyText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[1].x, textPositions[1].y, "Apply Count: " .. core.DB.charLife.applyCount, 12, nil)
    charFrame.DeclineText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[2].x, textPositions[2].y, "Decline Count: " .. core.DB.charLife.declineCount, 12, nil)
    charFrame.CancelText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[3].x, textPositions[3].y, "Cancel Count: " .. core.DB.charLife.cancelCount, 12, nil)
    charFrame.DelistText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[4].x, textPositions[4].y, "Delist Count: " .. core.DB.charLife.delistCount, 12, nil)
    charFrame.InviteText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[5].x, textPositions[5].y, "Invite Count: " .. core.DB.charLife.inviteCount, 12, nil)
    charFrame.AcceptText = createText("TOPLEFT", charFrame, "TOPLEFT", textPositions[6].x, textPositions[6].y, "Accept Count: " .. core.DB.charLife.acceptCount, 12, nil)
    
    charFrame:SetShown(core.DB.charLife.show)
    
    return charFrame
end

function Config:createAccFrame()
    accFrame = CreateFrame("Frame", "CharCountFrame", PVEFrame)
    accFrame:ClearAllPoints()
    accFrame:SetSize(COUNT_FRAME_WIDTH, COUNT_FRAME_HEIGHT)
    checkAnchor()
    accFrame.tex = accFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    accFrame.tex:SetAllPoints(accFrame)
    accFrame.tex:SetColorTexture(0, 0, 0, 0.75)
    
    accFrame.SessionText = createText("TOP", accFrame, "TOP", 0, -10, "Account Lifetime", 20, nil)

    accFrame.ApplyText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[1].x, textPositions[1].y, "Apply Count: " .. core.DB.accountLife.applyCount, 12, nil)
    accFrame.DeclineText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[2].x, textPositions[2].y, "Decline Count: " .. core.DB.accountLife.declineCount, 12, nil)
    accFrame.CancelText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[3].x, textPositions[3].y, "Cancel Count: " .. core.DB.accountLife.cancelCount, 12, nil)
    accFrame.DelistText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[4].x, textPositions[4].y, "Delist Count: " .. core.DB.accountLife.delistCount, 12, nil)
    accFrame.InviteText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[5].x, textPositions[5].y, "Invite Count: " .. core.DB.accountLife.inviteCount, 12, nil)
    accFrame.AcceptText = createText("TOPLEFT", accFrame, "TOPLEFT", textPositions[6].x, textPositions[6].y, "Accept Count: " .. core.DB.accountLife.acceptCount, 12, nil)
    
    accFrame:SetShown(core.DB.accountLife.show)
    
    return charFrame
end


function Config:CreateMenu()
    UIConfig = CreateFrame("Frame", "LFGDeclineCounterConfig", UIParent, "UIPanelDialogTemplate")
	table.insert(UISpecialFrames, UIConfig:GetName())
	UIConfig:SetMovable(true)
    UIConfig:EnableMouse(true)
    UIConfig:RegisterForDrag("LeftButton")
	UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
	UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)
    UIConfig:SetSize(CONFIG_FRAME_WIDTH, CONFIG_FRAME_HEIGHT)
    UIConfig:SetPoint("CENTER")

    UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY")
    UIConfig.title:ClearAllPoints()
    UIConfig.title:SetFontObject("GameFontHighlight")
    UIConfig.title:SetPoint("LEFT", LFGDeclineCounterConfigTitleBG, "LEFT", 6, 1)
    UIConfig.title:SetText("LFG Decline Counter Options")

    UIConfig.showCancel = CreateCheckButton("TOPLEFT", UIConfig, "TOPLEFT", 25, -35, "Show Cancel counter", core.DB.showCounters.cancel, showCancelCount, "showCancel")
    UIConfig.showDelist = CreateCheckButton("TOPLEFT", UIConfig.showCancel, "BOTTOMLEFT", 0, 5, "Show Delist counter", core.DB.showCounters.delist, showDelistCount, "showDelist")
    UIConfig.showInvite = CreateCheckButton("TOPLEFT", UIConfig.showDelist, "BOTTOMLEFT", 0, 5, "Show Invite counter", core.DB.showCounters.invite, showInviteCount, "showInvite")
    UIConfig.showAccept = CreateCheckButton("TOPLEFT", UIConfig.showInvite, "BOTTOMLEFT", 0, 5, "Show Accept counter", core.DB.showCounters.accept, showAcceptCount, "showAccept")

    UIConfig.showCharacterLife = CreateCheckButton("TOPLEFT", UIConfig.showCancel, "TOPLEFT", 200, 0, "Show Lifetime for character", core.DB.charLife.show, showCharacterLife, "showCharacterLife")
    UIConfig.showAccountLife = CreateCheckButton("TOPLEFT", UIConfig.showCharacterLife, "BOTTOMLEFT", 0, 5, "Show Lifetime for account", core.DB.accountLife.show, showAccountLife, "showAccountLife")
    UIConfig.crossCharacter = CreateCheckButton("TOPLEFT", UIConfig.showAccountLife, "BOTTOMLEFT", 0, 5, "Cross Character session", core.DB.session.crossCharacter, crossCharacterChange, "crossCharacter")
    
    UIConfig.resetCharacterLife = CreateButton("TOPLEFT", UIConfig.showAccept, "BOTTOMLEFT", 15, -25, 180, 30, "Reset Character stats", resetCharacterLife)
    UIConfig.resetAccountLife = CreateButton("TOPLEFT", UIConfig.resetCharacterLife, "TOPRIGHT", 20, 0, 180, 30, "Reset Account stats", resetAccountLife)

    UIConfig:Hide()
    return UIConfig
end