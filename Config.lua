local _, core = ...
core.Config = {}

local Config = core.Config
local UIConfig

local CONFIG_FRAME_WIDTH = 460
local CONFIG_FRAME_HEIGHT = 275
local anchorOptions = {
    "top left",
    "top right",
    "bottom left",
    "bottom right",
    "top",
    "bottom",
    "left",
    "right",
    "center"
}

local oreientationOptions = {
    "up",
    "down",
    "left",
    "right"
}



----------------------------------
-- GUI functions
----------------------------------

function Config:Toggle()
    local menu = UIConfig or Config:CreateMenu()
    menu:SetShown(not menu:IsShown())
end

function Config:GetThemeColor()
    local c = LFGDeclineCounterDB.theme
    return c.r, c.g, c.b, c.hex
end

local function createButton(point, relativeFrame, relativePoint, xOffset, yOffset, width, height, input, func)
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

local function createCheckButton(point, relativeFrame, relativePoint, xOffset, yOffset, input, checked, func, name)
    local btn = CreateFrame("CheckButton", name, relativeFrame, "UICheckButtonTemplate")
    btn:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	_G[name .. "Text"]:SetText(input)
    btn:SetChecked(checked)
	btn:SetScript("OnClick", func)
    return btn
end

local function createDropdown(point, relativeFrame, relativePoint, xOffset, yOffset, title, items, defaultVal, changeFunc, name)
	local menu_items = items or {}
	local title_text = title or ''
	local dropdown_width = 0
	local default_val = defaultVal or ''
	local change_func = changeFunc or function (dropdown_val) end

	local dropdown = CreateFrame("Frame", name, relativeFrame, "UIDropDownMenuTemplate")
	dropdown:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
	
	local dd_title = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dd_title:SetPoint("TOPLEFT", 20, 10)

	for _, item in pairs(menu_items) do -- Sets the dropdown width to the largest item string width.
		dd_title:SetText(item)
		local text_width = dd_title:GetStringWidth() + 20
		if text_width > dropdown_width then
			dropdown_width = text_width
		end
	end

	dd_title:SetText(title_text)
    local text_width = dd_title:GetStringWidth() + 20
    if text_width > dropdown_width then
        dropdown_width = text_width
    end
	UIDropDownMenu_SetWidth(dropdown, dropdown_width)
	UIDropDownMenu_SetText(dropdown, default_val)

	UIDropDownMenu_Initialize(dropdown, function(self, level, _)
		local info = UIDropDownMenu_CreateInfo()
		for key, val in pairs(menu_items) do
			info.text = val
			info.checked = false
			info.menuList= key
			info.hasArrow = false
			info.func = function(b)
				UIDropDownMenu_SetSelectedValue(dropdown, b.value, b.value)
				UIDropDownMenu_SetText(dropdown, b.value)
				b.checked = true
				change_func(b.value)
			end
			UIDropDownMenu_AddButton(info)
		end
	end)
	UIDropDownMenu_SetSelectedName(dropdown, default_val, default_val)
	UIDropDownMenu_SetText(dropdown, default_val)
	return dropdown
end

local function createSlider(point, relativeFrame, relativePoint, xOffset, yOffset, title, minVal, maxVal, valStep, width, height, initval, func, name)
    local slider = CreateFrame("Slider", name, relativeFrame, "OptionsSliderTemplate")
    local editbox = CreateFrame("EditBox", nil, slider, "InputBoxTemplate")
	slider:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(valStep)
    slider:SetValue(initval)
    slider:SetWidth(width)
    slider:SetHeight(height)
    --slider:SetOrientation("VERTICAL")

    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(minVal)
    slider.textHigh:SetText(maxVal)
    slider.textLow:SetTextColor(0.4,0.4,0.4)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)

    editbox:SetSize(50,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("TOP", slider, "BOTTOM", 0, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)

    slider:SetScript("OnValueChanged", function(self,value)
        local val = floor(value/valStep) * valStep
        self.editbox:SetText(val)
    end)
    editbox:SetScript("OnTextChanged", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
        end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
        local val = self:GetText()
        if tonumber(val) then
            self:GetParent():SetValue(val)
            self:ClearFocus()
        end
    end)
    slider:HookScript("OnValueChanged", func)

    slider.editbox = editbox
    return slider

end

local function ScrollBarChange()
	if UIConfig.ScrollFrame:GetVerticalScrollRange() == 0 then
		UIConfig.ScrollFrame.ScrollBar:ClearAllPoints()
		UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", 10, 0)
		UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", 10, 0)
	else
		UIConfig.ScrollFrame.ScrollBar:ClearAllPoints()
		UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18)
		UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18)
	end
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20)
	
	if (newValue < 0) then
		newValue = 0
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange()
	end
	
	self:SetVerticalScroll(newValue)
end

local function Tab_OnClick(self)
	PanelTemplates_SetTab(self:GetParent(), self:GetID())
	
	local scrollChild = UIConfig.ScrollFrame:GetScrollChild()
	if (scrollChild) then
		scrollChild:Hide()
	end
	
	UIConfig.ScrollFrame:SetScrollChild(self.content)
	self.content:Show()
	C_Timer.After(0, function() ScrollBarChange() end)
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs
	
	local contents = {}
	local frameName = frame:GetName()
	
	for i = 1, numTabs do	
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "PanelTabButtonTemplate")
		tab:SetID(i)
		tab:SetText(select(i, ...))
		tab:SetScript("OnClick", Tab_OnClick)
		
		tab.content = CreateFrame("Frame", nil, UIConfig.ScrollFrame)
		tab.content:SetSize(CONFIG_FRAME_WIDTH - 42, CONFIG_FRAME_HEIGHT- 50)
		tab.content:Hide()
		
		
		table.insert(contents, tab.content)
		
		if (i == 1) then
			tab:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", 5, 7)
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", 0, 0)
		end	
	end
	
	Tab_OnClick(_G[frameName.."Tab1"])
	
	return unpack(contents)
end

----------------------------------
-- Show/Hide functions
----------------------------------

local function showCancelCount()
    core.DB.showCounters.cancel = not core.DB.showCounters.cancel
    core.Counter.showHideCancel()
    core.Counter.updateTextPoints()
end

local function showDelistCount()
    core.DB.showCounters.delist = not core.DB.showCounters.delist
    core.Counter.showHideDelist()
    core.Counter.updateTextPoints()
end

local function showInviteCount()
    core.DB.showCounters.invite = not core.DB.showCounters.invite
    core.Counter.showHideInvite()
    core.Counter.updateTextPoints()
end

local function showAcceptCount()
    core.DB.showCounters.accept = not core.DB.showCounters.accept
    core.Counter.showHideAccept()
    core.Counter.updateTextPoints()
end


----------------------------------
-- Anchor functions
----------------------------------

local function changeAnchor(anchorPosition)
    core.DB.options.anchor = anchorPosition
    core.Counter.updateAnchorPosition()
end

local function changeOrientation(orientationPosition)
    core.DB.options.orientation = orientationPosition
    core.Counter.updateOrientation()
end

local function changePad(self)
    core.DB.options.padding = floor(self:GetValue() / self:GetValueStep()) * self:GetValueStep()
    core.Counter.setPadding()
end

local function moveX(self)
    core.DB.options.xOffset = floor(self:GetValue() / self:GetValueStep()) * self:GetValueStep()
    core.Counter.setOffset()
end

local function moveY(self)
    core.DB.options.yOffset = floor(self:GetValue() / self:GetValueStep()) * self:GetValueStep()
    core.Counter.setOffset()
end

local function scaleFrames(self)
    core.DB.options.scale = floor(self:GetValue() / self:GetValueStep()) * self:GetValueStep()
    core.Counter.Setscaling()
end
----------------------------------
-- Character functions
----------------------------------

local function showCharacterLife()
    local menu = core.Counter.GetcharFrame()
    core.DB.charLife.show = not core.DB.charLife.show
    menu:SetShown(core.DB.charLife.show)
    core.Counter.checkAccountAnchor()
end

local function resetCharacterLife()
    core.DB.charLife.applyCount = 0
    core.DB.charLife.declineCount = 0
    core.DB.charLife.cancelCount = 0
    core.DB.charLife.delistCount = 0
    core.DB.charLife.inviteCount = 0
    core.DB.charLife.acceptCount = 0
    core.Counter.allTextUpdate()
end

local function crossCharacterChange()
    core.DB.session.crossCharacter = not core.DB.session.crossCharacter
end

----------------------------------
-- Account functions
----------------------------------

local function showAccountLife()
    local menu = core.Counter.GetaccFrame()
    core.DB.accountLife.show = not core.DB.accountLife.show
    menu:SetShown(core.DB.accountLife.show)
    core.Counter.checkAccountAnchor()
end

local function resetAccountLife()
    core.DB.accountLife.applyCount = 0
    core.DB.accountLife.declineCount = 0
    core.DB.accountLife.cancelCount = 0
    core.DB.accountLife.delistCount = 0
    core.DB.accountLife.inviteCount = 0
    core.DB.accountLife.acceptCount = 0
    
    core.Counter.allTextUpdate()
end

----------------------------------
-- Main function
----------------------------------

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
    UIConfig:SetFrameStrata("HIGH")

    UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY")
    UIConfig.title:ClearAllPoints()
    UIConfig.title:SetFontObject("GameFontHighlight")
    UIConfig.title:SetPoint("LEFT", LFGDeclineCounterConfigTitleBG, "LEFT", 6, 1)
    UIConfig.title:SetText("LFG Decline Counter Options")

    UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate")
    UIConfig.ScrollFrame:SetPoint("TOPLEFT", LFGDeclineCounterConfigDialogBG, "TOPLEFT", 4, -8)
	UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", LFGDeclineCounterConfigDialogBG, "BOTTOMRIGHT", -3, 4)
	UIConfig.ScrollFrame:SetClipsChildren(true)
	UIConfig.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)

    UIConfig.ScrollFrame.ScrollBar:ClearAllPoints()
    UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18)
    UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18)

    local options, position = SetTabs(UIConfig, 2, "Options", "Position")

    --Options tab
    options.showCancel = createCheckButton("TOPLEFT", options, "TOPLEFT", 5, -15, "Show Cancel counter", core.DB.showCounters.cancel, showCancelCount, "showCancel")
    options.showDelist = createCheckButton("TOPLEFT", options.showCancel, "BOTTOMLEFT", 0, 5, "Show Delist counter", core.DB.showCounters.delist, showDelistCount, "showDelist")
    options.showInvite = createCheckButton("TOPLEFT", options.showDelist, "BOTTOMLEFT", 0, 5, "Show Invite counter", core.DB.showCounters.invite, showInviteCount, "showInvite")
    options.showAccept = createCheckButton("TOPLEFT", options.showInvite, "BOTTOMLEFT", 0, 5, "Show Accept counter", core.DB.showCounters.accept, showAcceptCount, "showAccept")

    options.showCharacterLife = createCheckButton("TOPLEFT", options.showCancel, "TOPLEFT", 200, 0, "Show Lifetime for character", core.DB.charLife.show, showCharacterLife, "showCharacterLife")
    options.showAccountLife = createCheckButton("TOPLEFT", options.showCharacterLife, "BOTTOMLEFT", 0, 5, "Show Lifetime for account", core.DB.accountLife.show, showAccountLife, "showAccountLife")
    options.crossCharacter = createCheckButton("TOPLEFT", options.showAccountLife, "BOTTOMLEFT", 0, 5, "Cross Character session", core.DB.session.crossCharacter, crossCharacterChange, "crossCharacter")
    
    options.resetCharacterLife = createButton("TOPLEFT", options.showAccept, "BOTTOMLEFT", 15, -25, 180, 30, "Reset Character stats", resetCharacterLife)
    options.resetAccountLife = createButton("TOPLEFT", options.resetCharacterLife, "TOPRIGHT", 20, 0, 180, 30, "Reset Account stats", resetAccountLife)

    --Position tab
    position.anchorOption = createDropdown("TOPLEFT", position, "TOPLEFT", 0, -35, "Anchor", anchorOptions, core.DB.options.anchor, changeAnchor, nil)
    position.orientationOption = createDropdown("TOPLEFT", position.anchorOption, "BOTTOMLEFT", 0, -30, "Orientation", oreientationOptions, core.DB.options.orientation, changeOrientation, nil)
    position.padOption = createSlider("TOPLEFT", position.orientationOption, "BOTTOMLEFT", 15, -30, "Padding", 0, 50, 1, 125, 15, core.DB.options.padding, changePad, "padSlider")

    position.xSlider = createSlider("TOPLEFT", position.anchorOption, "TOPRIGHT", 10, 0, "Offset x", -1000, 1000, 1, 250, 15, core.DB.options.xOffset, moveX, "xSlider")
    position.ySlider = createSlider("TOP", position.xSlider, "BOTTOM", 0, -50, "Offset y", -1000, 1000, 1, 250, 15, core.DB.options.yOffset, moveY, "ySlider")
    position.scaleSlider = createSlider("TOP", position.ySlider, "BOTTOM", 0, -50, "Scale", 0.5, 2, 0.01, 125, 15, 1, scaleFrames, "scaleSlider")
    UIConfig:Hide()
    return UIConfig
end