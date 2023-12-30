--[[
    ChooseAmountMenu
    lua port by MistressNebula

    Opens a menu that allows the player to choose a number.
    It contains a run method for quick instantiation.
    This equivalent is NOT SAFE FOR REPLAYS. Do not use in dungeons until further notice.
]]
require 'common'
--- Menu for choosing a number.
ChooseAmountMenu = Class("ChooseAmountMenu")

--- Creates a new ChooseAmountMenu instance using the provided data and callbacks.
--- @param x number the x coordinate of this window's origin
--- @param y number the y coordinate of this window's origin
--- @param width number the width of this window. Minimum width depends on the maximum digits the menu can hold
--- @param height number the height of this window. Cannot be lower than 80
--- @param title string the title this window will have.
--- @param start_number number the number that this menu will start with.
--- @param min number the minimum number that can be inserted.
--- @param max number the maximum number that can be inserted.
--- @param callback function the function called when the player presses the confirm, cancel or menu button. It must accept a parameter.
function ChooseAmountMenu:initialize(x, y, width, height, title, start_number, min, max, callback)
    -- loading parameters
    self.title = title
    self.min = math.min(min, max)
    self.max = max
    self.start_number = math.min(math.max(min, start_number), max)
    self.number = self.start_number
    self.callback = callback
    self.selected = 0

    -- calculating digits
    self.digits = 0 -- = number of digits minus one
    if max~=0 then self.digits = math.max(0, math.floor(math.log(math.abs(max),10))) end
    if min~=0 then self.digits = math.max(self.digits, math.floor(math.log(math.abs(min),10))) end

    -- apply minimum
    width  = math.max((9*self.digits+2)+16, width)
    height = math.max(64, height)

    -- create and draw menu
    self.menu = RogueEssence.Menu.ScriptableMenu(x, y, width, height, function(input) self:Update(input) end)

    local sign = ""
    if self.number<0 then sign = "-" end
    self.sign_text = RogueEssence.Menu.MenuText(sign, RogueElements.Loc(self.menu.Bounds.Width//2 - (9 * (self.digits+1))//2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight + 12 * 2), RogueElements.DirH.None)
    self.number_box = RogueEssence.Menu.MenuDigits(self.number, self.digits+1, RogueElements.Loc(self.menu.Bounds.Width//2 - (9 * (self.digits+1))//2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight + 13 * 2))

    self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.title, RogueElements.Loc(self.menu.Bounds.Width//2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), RogueElements.DirH.None))
    self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, Graphics.VERT_SPACE + RogueEssence.Content.GraphicsManager.MenuBG.TileHeight), self.menu.Bounds.Width - 12 * 2))
    self.menu.MenuElements:Add(self.sign_text)
    self.menu.MenuElements:Add(self.number_box)
    for i=0, self.digits, 1 do
        local digit_pos = self.number_box:GetDigitLoc(i)
        digit_pos.X = digit_pos.X -1
        digit_pos.Y = digit_pos.Y +12
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(digit_pos, 8))
    end
    self.cursors = {}
    self.cursors[1] = RogueEssence.Menu.MenuCursor(self.menu, RogueElements.Dir4.Up)
    self.cursors[2] = RogueEssence.Menu.MenuCursor(self.menu, RogueElements.Dir4.Down)
    self.menu.MenuElements:Add(self.cursors[1])
    self.menu.MenuElements:Add(self.cursors[2])
    self:DrawMenu()
end

function ChooseAmountMenu:DrawMenu()
    if self.number>=0 then self.sign_text:SetText("") else self.sign_text:SetText("-") end
    self.number_box.Amount = self.number
    local delta_y = 14
    local index = self.digits - self.selected
    local pos  = self.number_box:GetDigitLoc(index) + RogueElements.Loc(-3, 2);
    self.cursors[1].Loc = RogueElements.Loc(pos.X, pos.Y - delta_y) -- up
    self.cursors[2].Loc = RogueElements.Loc(pos.X, pos.Y + delta_y) -- down
end

function ChooseAmountMenu:Update(input)
    if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
        _GAME:SE("Menu/Confirm")
        self.callback(self.number)
        _MENU:RemoveMenu()
    elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
           input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
        _GAME:SE("Menu/Confirm")
        self.callback(self.start_number)
        _MENU:RemoveMenu()
    elseif self:directionHold(input, RogueElements.Dir8.Up) then
        self:change_number( 1)
    elseif self:directionHold(input, RogueElements.Dir8.Down) then
        self:change_number(-1)
    elseif self:directionHold(input, RogueElements.Dir8.Left) then
        if self.selected<self.digits then
            _GAME:SE("Menu/Skip")
            self.selected = self.selected+1
            self:DrawMenu()
        else
            self.selected = self.digits
            _GAME:SE("Menu/Cancel")
        end
    elseif self:directionHold(input, RogueElements.Dir8.Right) then
        if self.selected>0 then
            _GAME:SE("Menu/Skip")
            self.selected = self.selected-1
            self:DrawMenu()
        else
            self.selected = 0
            _GAME:SE("Menu/Cancel")
        end
    end
end

function ChooseAmountMenu:directionHold(input, direction)
    local INPUT_WAIT = 30
    local INPUT_GAP = 6

    local new_dir = false
    local old_dir = false
    if input.Direction == direction then new_dir = true end
    if input.PrevDirection == direction then old_dir = true end

    local repeat_time = false
    if input.InputTime >= INPUT_WAIT and input.InputTime % INPUT_GAP == 0 then
        repeat_time = true
    end
    return new_dir and (not old_dir or repeat_time)
end

function ChooseAmountMenu:change_number(vector)
    local num = self.number
    local change = vector*(10^self.selected)
    num = math.min(math.max(self.min,num + change), self.max)
    if self.number == num then
        _GAME:SE("Menu/Cancel")
    else
        _GAME:SE("Menu/Skip")
        self.number = num
        self:DrawMenu()
    end
end



function ChooseAmountMenu.run(x, y, width, height, title, start_number, min, max)
    local ret = start_number
    local choose = function(number) ret = number end
    local menu = ChooseAmountMenu:new(x, y, width, height, title, start_number, min, max, choose)
    UI:SetCustomMenu(menu.menu)
    UI:WaitForChoice()
    return ret
end

function ChooseAmountMenu.add(x, y, width, height, title, start_number, min, max, display_over)
    local ret = start_number
    local choose = function(number) ret = number end
    local menu = ChooseAmountMenu:new(x, y, width, height, title, start_number, min, max, choose)
    _MENU:AddMenu(menu.menu, display_over)
    return ret
end