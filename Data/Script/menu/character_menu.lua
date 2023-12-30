--[[
    character_menu.lua
    Implements the character menu used in New Leaf's character selection sequence
]]--
require 'common'
require 'menu.ChooseAmountMenu'

function CharacterSelectionMenu()
    Graphics = {
        Manager = RogueEssence.Content.GraphicsManager,
        VERT_SPACE = 14,
        LINE_HEIGHT = 12,
        DIVIDER_HEIGHT = 4
    }

    --modulo operation with a base different from zero. 'shift' defaults to 1.
    function math.shifted_mod(value, mod, shift)
        if shift == nil then shift = 1 end
        return ((value-shift) % mod) + shift
    end

    function table.index_of(table, object, default)
        if default==nil then default = -1 end
        for index, element in pairs(table) do
            if element == object then return index end
        end
        return default
    end


    local CharacterSelectionMenu = Class('CharacterSelectionMenu')

    -- sub-menu initializations
    local CharacterChoiceListMenu =          Class('CharacterChoiceListMenu')
    local CharacterEggMoveMenu =             Class('CharacterEggMoveMenu')
    local CharacterEggMovePositionSelector = Class('CharacterEggMovePositionSelector')
    local CharacterSpeciesMenu =             Class('CharacterSpeciesMenu')
    local CharacterConfirmMenu =             Class('CharacterConfirmMenu')

    -------------------------------------------------------
    --region Initialization
    -------------------------------------------------------
    function CharacterSelectionMenu:initialize(title, species_list)
        assert(self, "SingleItemDealMenu:initialize(): self is nil!")
        self.title = title
        self.species_list = species_list
        self.menu_spacing = 20
        self.data = {
            species = "bulbasaur",
            form = 0,
            skin = 'normal',
            gender = 2, -- 0 male, 1 female, 2 genderless
            intrinsic = "overgrow",
            egg_move = "",
            egg_move_index = -1,
            has_animations = true
        }
        self.selected = {1, 1}  -- selected field, as {window, index} values
        self.focused = 1        -- currently focused window. 1 is left. 2 is right
        self.confirmed = false
        self.options = {
            --window left
            {
                {Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*3)//2 + 4, function() self:openSpeciesMenu() end },
                {Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*5)//2 + 4, function() self:openFormMenu() end },
                {Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*7)//2 + 4, function() self:openGenderMenu() end},
                {Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*9)//2 + 4, function() self:openSheenMenu() end},
            },
            --window right
            {
                {Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE     + 4, function() self:openAbilityMenu() end},
                {Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE * 3,     function() self:openEggMoveMenu() end},
                {Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE * 5 + 4, function() self:signDocument() end}
            }
        }
        self.form_active = false
        self.ability_active = true
        self.egg_move_active = true
        self:setupWindows()
        self:updateWindows(true, true)
    end

    function CharacterSelectionMenu:setupWindows()
        self:setupTitleWindow()
        self:setupPortrait()
        self:setupMoveSummary()
        self:setupAlertWindow()
        self:setupLeftWindow()
        self:setupRightWindow()
        self:registerSubWindows()
    end

    function CharacterSelectionMenu:setupTitleWindow()
        local top_left = RogueElements.Loc(16, 8)
        local bottom_right = RogueElements.Loc(Graphics.Manager.ScreenWidth//2 - 8, 8 + Graphics.LINE_HEIGHT + Graphics.Manager.MenuBG.TileHeight*2)
        self.title_window = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))
        local title = RogueEssence.Menu.MenuText(
                self.title,
                RogueElements.Loc(
                        self.title_window.Bounds.Width//2,
                        Graphics.Manager.MenuBG.TileHeight),
                RogueElements.DirH.None
        )
        self.title_window.Elements:Add(title)
    end

    function CharacterSelectionMenu:setupPortrait()
        local x = 16
        local y = 10 + self.title_window.Bounds.Height
        local w = 38 + Graphics.Manager.MenuBG.TileWidth*2
        local h = 34 + Graphics.Manager.MenuBG.TileHeight*2
        local top_left = RogueElements.Loc(x, y)
        local bottom_right = RogueElements.Loc(x+w, y+h)

        self.portrait_box = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))

        local id = self:toMonsterID()
        local emote = RogueEssence.Content.EmoteStyle(0)
        local loc = RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth-1,Graphics.Manager.MenuBG.TileHeight-3)
        self.portrait = RogueEssence.Menu.SpeakerPortrait(id, emote, loc, false)
        self.portrait_box.Elements:Add(self.portrait)
    end

    function CharacterSelectionMenu:setupMoveSummary()
        local top_left = RogueElements.Loc(Graphics.Manager.ScreenWidth//2 + 8, 8)
        local bottom_right = RogueElements.Loc(Graphics.Manager.ScreenWidth - 16, Graphics.Manager.ScreenHeight//2 - 4)
        self.base_summary = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))

        --Lv   HP
        local level = 5
        self.base_summary.Elements:Add(RogueEssence.Menu.MenuText("Lv."..tostring(level), RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.Left))
        self.summary_hp = RogueEssence.Menu.MenuText("0 HP", RogueElements.Loc(self.base_summary.Bounds.Width - Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.Right)
        self.base_summary.Elements:Add(self.summary_hp)

        -- ------------------------------------
        self.base_summary.Elements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12 + Graphics.DIVIDER_HEIGHT//2, 8 + Graphics.VERT_SPACE), self.base_summary.Bounds.Width - 12 * 2))

        --Moves
        self.base_summary.Elements:Add(RogueEssence.Menu.MenuText("Moves:", RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Left))

        --moves list
        self.move_slots = {}
        for i=1, 4, 1 do
            self.move_slots[i] = {}
            self.move_slots[i].name = RogueEssence.Menu.MenuText("", RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(i+1) + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Left)
            self.move_slots[i].pp = RogueEssence.Menu.MenuText("", RogueElements.Loc(self.base_summary.Bounds.Width - Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(i+1) + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Right)
            self.base_summary.Elements:Add(self.move_slots[i].name)
            self.base_summary.Elements:Add(self.move_slots[i].pp)
        end
    end

    function CharacterSelectionMenu:setupAlertWindow()
        local x = 16
        local w = Graphics.Manager.ScreenWidth//2 - 8 - x
        local h = 10 + Graphics.Manager.MenuBG.TileHeight*2
        local y = Graphics.Manager.ScreenHeight//2 - h - 4
        local top_left = RogueElements.Loc(x, y)
        local bottom_right = RogueElements.Loc(x+w, y+h)

        self.alert_window = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))

        self.alert_window.Elements:Add(RogueEssence.Menu.MenuText("\u{E111} [color=#FFFF00]Incomplete Anims[color] \u{E111}", RogueElements.Loc(self.alert_window.Bounds.Width//2, (self.alert_window.Bounds.Height - Graphics.LINE_HEIGHT)//2), RogueElements.DirH.None))
    end

    function CharacterSelectionMenu:addRight(element) self:addElement(element, self.right, self.right_summary) end
    function CharacterSelectionMenu:addLeft(element) self:addElement(element, self.left, self.left_summary) end
    function CharacterSelectionMenu:addElement(element, menu, menu_summary)
        menu.MenuElements:Add(element)
        menu_summary.Elements:Add(element)
    end

    function CharacterSelectionMenu:setupLeftWindow()
        local x = 16
        local y = Graphics.Manager.ScreenHeight//2 + 4
        local w = Graphics.Manager.ScreenWidth //2 - 8  - x
        local h = Graphics.Manager.ScreenHeight    - 12 - y

        local top_left = RogueElements.Loc(x, y)
        local bottom_right = RogueElements.Loc(x+w, y+h)

        self.left_summary = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))
        self.left  = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)

        self.cursor_l = RogueEssence.Menu.MenuCursor(self.left)

        --populating menus
        self.left.MenuElements:Add(self.cursor_l)

        -- Title
        self:addLeft(RogueEssence.Menu.MenuText("Pokémon Data", RogueElements.Loc(self.left.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.None))
        -- ------------------------------------
        self:addLeft(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + Graphics.VERT_SPACE), self.left.Bounds.Width - 12 * 2))

        -- Species: species
        self:addLeft(RogueEssence.Menu.MenuText("Species:", RogueElements.Loc(self.menu_spacing, self.options[1][1][1])))
        self.species_name = RogueEssence.Menu.MenuText("", RogueElements.Loc((self.left.Bounds.Width*2)//3, self.options[1][1][1]), RogueElements.DirH.None)
        self:addLeft(self.species_name)

        -- Form: form
        self.form_option = RogueEssence.Menu.MenuText("Form:", RogueElements.Loc(self.menu_spacing, self.options[1][2][1]))
        self.form_name = RogueEssence.Menu.MenuText("", RogueElements.Loc((self.left.Bounds.Width*2)//3, self.options[1][2][1]), RogueElements.DirH.None)
        self:addLeft(self.form_option)
        self:addLeft(self.form_name)

        -- Gender: gender
        self:addLeft(RogueEssence.Menu.MenuText("Gender:", RogueElements.Loc(self.menu_spacing, self.options[1][3][1])))
        self.gender_name = RogueEssence.Menu.MenuText("", RogueElements.Loc((self.left.Bounds.Width*2)//3, self.options[1][3][1]), RogueElements.DirH.None)
        self:addLeft(self.gender_name)

        -- Sheen: shinyness
        self:addLeft(RogueEssence.Menu.MenuText("Sheen:", RogueElements.Loc(self.menu_spacing, self.options[1][4][1])))
        self.shiny_name = RogueEssence.Menu.MenuText("", RogueElements.Loc((self.left.Bounds.Width*2)//3, self.options[1][4][1]), RogueElements.DirH.None)
        self:addLeft(self.shiny_name)
    end

    function CharacterSelectionMenu:setupRightWindow()
        local x = Graphics.Manager.ScreenWidth//2 + 8
        local y = Graphics.Manager.ScreenHeight//2 + 4
        local w = Graphics.Manager.ScreenWidth - 16 - x
        local h = Graphics.Manager.ScreenHeight - 12 - y

        local top_left = RogueElements.Loc(x, y)
        local bottom_right = RogueElements.Loc(x+w, y+h)

        self.right_summary = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(top_left, bottom_right))
        self.right = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)

        --populating menus
        self.cursor_r = RogueEssence.Menu.MenuCursor(self.right)

        -- Title
        self:addRight(RogueEssence.Menu.MenuText("Battle Details", RogueElements.Loc(self.right.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.None))
        -- ------------------------------------
        self:addRight(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + Graphics.VERT_SPACE), self.right.Bounds.Width - 12 * 2))

        -- Ability: ability
        self.ability_option = RogueEssence.Menu.MenuText("Ability:", RogueElements.Loc(self.menu_spacing, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE + 4))
        self.ability_name = RogueEssence.Menu.MenuText("", RogueElements.Loc((self.right.Bounds.Width*2)//3, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE + 4), RogueElements.DirH.None)
        self:addRight(self.ability_option)
        self:addRight(self.ability_name)

        -- Egg Move
        self.egg_move_option = RogueEssence.Menu.MenuText("Egg Move", RogueElements.Loc(self.right.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*5)//2), RogueElements.DirH.None)
        self:addRight(self.egg_move_option)

        -- egg_move
        self.egg_move_name = RogueEssence.Menu.MenuText("", RogueElements.Loc(self.right.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*7)//2), RogueElements.DirH.None)
        self:addRight(self.egg_move_name)

        -- ------------------------------------
        self:addRight(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 6 + Graphics.VERT_SPACE*5), self.right.Bounds.Width - 12 * 2))

        -- Confirm
        self:addRight(RogueEssence.Menu.MenuText("Confirm", RogueElements.Loc(self.menu_spacing, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*5 + 4)))
    end

    function CharacterSelectionMenu:registerSubWindows()
        self.left.SummaryMenus:Add(self.title_window)
        self.left.SummaryMenus:Add(self.portrait_box)
        self.left.SummaryMenus:Add(self.base_summary)
        self.left.SummaryMenus:Add(self.alert_window)
        self.left.SummaryMenus:Add(self.right_summary)
        self.right.SummaryMenus:Add(self.title_window)
        self.right.SummaryMenus:Add(self.portrait_box)
        self.right.SummaryMenus:Add(self.base_summary)
        self.right.SummaryMenus:Add(self.alert_window)
        self.right.SummaryMenus:Add(self.left_summary)
    end
    -------------------------------------------------------
    --region VisualUpdating
    -------------------------------------------------------

    function CharacterSelectionMenu:updateWindows(portrait, summary)
        self:updateLeft()
        self:updateRight()
        if portrait then self:updatePortrait() end
        if summary  then
            self:updateSummary()
            self:updateCheckAnimations()
        end
    end

    function CharacterSelectionMenu:updateCurrent()
        if self.focused==1 then
            self:updateLeft()
        else
            self:updateRight()
        end
    end

    function CharacterSelectionMenu:updateLeft()
        self.monster = _DATA:GetMonster(self.data.species)

        --Species
        local species_name = self.monster.Name:ToLocal()
        self.species_name:SetText("[color=#FFC663]"..species_name.."[color]")

        --Form
        local form = self.monster.Forms[self.data.form]
        local form_name = form.FormName:ToLocal()
        if form_name == species_name or not self.form_active then
            form_name = "Normal"
        else
            form_name = form_name:gsub(species_name, "")
            form_name = form_name:gsub('^%s*(.-)%s*$', '%1')
        end
        local form_text_color, form_color = "#FFFFFF", "#FFC663"
        if not self.form_active then form_text_color, form_color = "#888888", "#886A35" end
        form_name = "[color="..form_color.."]".. form_name .."[color]"
        self.form_option:SetText("[color="..form_text_color.."]Form:[color]")
        self.form_name:SetText(form_name)

        --Gender
        local gender_display_table = {"Male", "Female", "Non-Binary"}
        local gender = "[color=#FFC663]"..gender_display_table[self.data.gender+1].."[color]"
        self.gender_name:SetText(gender)

        --Shiny
        local shiny = "[color=#FFC663]Regular[color]"
        if self.data.skin == "shiny" then shiny = "[color=#FFFF00]Shiny\u{E10C}[color]" end
        self.shiny_name:SetText(shiny)

        --move cursor
        local cursor_y = self.options[self.selected[1]][self.selected[2]][1]
        if self.focused == 1 then
            self.cursor_l.Loc = RogueElements.Loc(10, cursor_y)
        else
            self.cursor_l.Loc = RogueElements.Loc(-100, cursor_y)
        end
    end

    function CharacterSelectionMenu:updateRight()
        self.right.MenuElements:Add(self.cursor_r)

        --Ability
        local ability_text_color, ability_color = "#FFFFFF", "#FFC663"
        if not self.ability_active then ability_text_color, ability_color = "#888888", "#886A35" end
        self.ability_option:SetText("[color=".. ability_text_color .."]Ability:[color]")
        self.ability_name:SetText("[color=".. ability_color .."]".._DATA:GetIntrinsic(self.data.intrinsic).Name:ToLocal().."[color]")

        --Egg Move
        local egg_move_text_color, egg_move_color = "#FFFFFF", "#FFC663"
        if not self.egg_move_active then egg_move_text_color, egg_move_color = "#888888", "#886A35" end
        self.egg_move_option:SetText("[color="..egg_move_text_color.."]Egg Move[color]")

        --egg_move
        local egg_move = "-----"
        if self.data.egg_move ~= "" then egg_move = _DATA:GetSkill(self.data.egg_move).Name:ToLocal() end
        self.egg_move_name:SetText("[color="..egg_move_color.."]"..egg_move.."[color]")

        --move cursor
        local cursor_y = self.options[self.selected[1]][self.selected[2]][1]
        if self.focused == 2 then
            self.cursor_r.Loc = RogueElements.Loc(10, cursor_y)
        else
            self.cursor_r.Loc = RogueElements.Loc(-100, cursor_y)
        end
    end

    -------------------------------------------------------

    function CharacterSelectionMenu:updatePortrait()
        self.portrait.Speaker = self:toMonsterID()
    end

    function CharacterSelectionMenu:updateSummary()
        --setting up data
        local level = 5
        local form = self.monster.Forms[self.data.form]
        local hp = form:GetStat(level, RogueEssence.Data.Stat.HP, 0)
        self.moves = {}
        for i = 0, form.LevelSkills.Count - 1, 1 do
            local skill = form.LevelSkills[i].Skill
            if form.LevelSkills[i].Level <= level then
                table.insert(self.moves, skill) --add to end
                if #self.moves>4 then
                    table.remove(self.moves, 1) --emulate base pmdo behavior
                end
            end
        end

        --HP
        self.summary_hp:SetText(tostring(hp).." HP")

        --moves list
        for i=1, 4, 1 do
            local move_id = self.moves[i]
            local move_name, move_pp
            if self.data.egg_move ~="" and i == self.data.egg_move_index+1 then -- override with egg move
                local move = _DATA:GetSkill(self.data.egg_move)
                move_name = utf8.char(_DATA:GetElement(move.Data.Element).Symbol).."\u{2060}[color=#FFFF00]"..move.Name:ToLocal().."[color]"
                move_pp   = tostring(move.BaseCharges).."PP"
            elseif move_id ~= nil then -- basic move
                local move = _DATA:GetSkill(move_id)
                move_name = move:GetIconName()
                move_pp   = tostring(move.BaseCharges).."PP"
            else -- empty slot
                move_name = "-----"
                move_pp   = "-----"
            end
            self.move_slots[i].name:SetText(move_name)
            self.move_slots[i].pp:SetText(move_pp)
        end
    end

    function CharacterSelectionMenu:updateCheckAnimations()
        --Warn the player if starter animations are incomplete for the character.
        --Give them the option of selecting someone else if this is the case.
        local animations = {"EventSleep", "Wake", "Eat", "Tumble", "Pose", "Pull", "Pain", "Float",
                            "DeepBreath", "Nod", "Sit", "LookUp", "Sink", "Trip", "Laying", "LeapForth",
                            "Head", "Cringe", "LostBalance", "TumbleBack", "HitGround", "Faint"}

        --create an offscreen ground clone of the mon we're planning on making to use with the GROUND:CharGetAnimFallback function.
        local temp_monster = RogueEssence.Dungeon.MonsterID(self.data.species, self.data.form, "normal", Gender.Genderless)

        local temp_ground_char = RogueEssence.Ground.GroundChar(temp_monster, RogueElements.Loc(600, 600), Direction.Down, "Dummy", self.data.species)
        temp_ground_char:ReloadEvents()
        GAME:GetCurrentGround():AddTempChar(temp_ground_char)

        --check each animation.
        self.data.has_animations = true
        for i = 1, #animations, 1 do
            if GROUND:CharGetAnimFallback(temp_ground_char, animations[i]) ~= animations[i] then
                self.data.has_animations = false
                --print(animations[i])
            end
        end

        --todo: check for missing portraits
        GAME:GetCurrentGround():RemoveTempChar(temp_ground_char)
        self.alert_window.Visible = not self.data.has_animations
    end
    -------------------------------------------------------
    --region Interaction
    -------------------------------------------------------

    function CharacterSelectionMenu:getFocusedWindow()
        if self.focused == 1 then return self.left else return self.right end
    end

    function CharacterSelectionMenu:Update(input)
        local window = self.selected[1]
        local option = self.selected[2]

        if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
            local callback = self.options[window][option][2]
            _GAME:SE("Menu/Confirm")
            callback()
        elseif not self.dirPressed then
            if input.Direction == RogueElements.Dir8.Right then
                if self.focused == 1 then
                    self:toggleFocus()
                else
                    _GAME:SE("Menu/Cancel")
                end
                self.dirPressed = true
            elseif input.Direction == RogueElements.Dir8.Left then
                if self.focused == 2 then
                    self:toggleFocus()
                else
                    _GAME:SE("Menu/Cancel")
                end
                self.dirPressed = true
            elseif input.Direction == RogueElements.Dir8.Up then
                if option > 1 then
                    self.selected[2] = option - 1
                else
                    self.selected[2] = 1
                end
                self:redirectSelectedOption(window, option)
                self:updateWindows()
                self.dirPressed = true
            elseif input.Direction == RogueElements.Dir8.Down then
                if option<#self.options[window] then
                    self.selected[2] = option + 1
                else
                    self.selected[2] = #self.options[window]
                end
                self:redirectSelectedOption(window, option)
                self:updateWindows()
                self.dirPressed = true
            end
        elseif input.Direction == RogueElements.Dir8.None then
            self.dirPressed = false
        end
    end

    -- skips inactive options. this is not pretty but the alternatives were way worse
    function CharacterSelectionMenu:redirectSelectedOption(start_window, start_option) --start_window and start_option mean which window option pair is the movement starting from
        local window = self.selected[1]
        local option = self.selected[2]
        if window == 1 and option == 2 then
            if not self.form_active then
                if start_window == window and start_option > option then option = 1 --coming from below, go up
                else option = 3 end --coming from right or on top, go down
            end
        elseif window == 2 then
            if option == 1 then
                if not self.ability_active then
                    if not self.egg_move_active then option = 3 --move to option 3 if option 1 and 2 are both inactive
                    else option = 2 end --always move to option 2 otherwise
                end
            elseif option == 2 then --this one's fun
                if not self.egg_move_active then
                    if self.ability_active then -- if 1 is active
                        if start_window ~= window and start_option<3 --move to 1 if coming from the left's 1 or 2
                                or start_window == window and start_option>option then --move to 1 if coming from below
                            option = 1
                        end
                    end
                    if option == 2 then option = 3 end --if not moved to 1 already then always move to 3
                end
            end
        end
        --play correct sound
        if start_window == window and start_option == option then _GAME:SE("Menu/Cancel")
        else _GAME:SE("Menu/Skip") end
        --save new pos
        self.selected[1] = window
        self.selected[2] = option
    end

    function CharacterSelectionMenu:toggleFocus()
        local window = self.selected[1]
        local option = self.selected[2]
        local focusTarget = self.focused%2 + 1
        self.focused = focusTarget
        self.selected[1] = focusTarget

        local targets = {1,2,4}
        if(focusTarget == 2) then
            targets = {1,2,2,3}
        end
        self.selected[2] = targets[self.selected[2]]
        self:redirectSelectedOption(window, option)

        self:updateWindows(true, true)
        _MENU:RemoveMenu()
    end

    function CharacterSelectionMenu:updatePermissions()
        self.monster = _DATA:GetMonster(self.data.species)
        self.form_active = self:monsterFormCount()>1
        local form = self.monster.Forms[self.data.form]
        self.ability_active = form.Intrinsic2 ~= "" or form.Intrinsic3 ~= ""
        self.egg_move_active = #self:getMonsterEggMoves()>0
    end

    -------------------------------------------------------
    --region Data Processing
    -------------------------------------------------------

    function CharacterSelectionMenu:toMonsterID()
        local id = self.data
        local gender = self:toGender()
        return RogueEssence.Dungeon.MonsterID(id.species, id.form, id.skin, gender)
    end

    function CharacterSelectionMenu:toGender()
        local genderTable = {RogueEssence.Data.Gender.Male, RogueEssence.Data.Gender.Female, RogueEssence.Data.Gender.Genderless}
        return genderTable[self.data.gender+1]
    end

    function CharacterSelectionMenu:monsterFormCount()
        local count = 0
        for elem in luanet.each(self.monster.Forms) do
            if elem.Released and not elem.Temporary then
                count=count+1
            end
        end
        return count
    end

    function CharacterSelectionMenu:getMonsterEggMoves()
        local monster_species = self.data.species
        local monster_form = self.data.form
        local monster = _DATA:GetMonster(monster_species)
        while monster.PromoteFrom ~= '' do
            monster_form = monster.Forms[monster_form].PromoteForm
            monster_species = monster.PromoteFrom
            monster = _DATA:GetMonster(monster_species)
        end
        local form = monster.Forms[monster_form]
        local egg_moves = form.SharedSkills
        local moves = {}
        for move_learnable in luanet.each(egg_moves) do
            local move_id = move_learnable.Skill
            local move = _DATA:GetSkill(move_id)
            if move.Released then
                table.insert(moves, move_id)
            end
        end
        return moves
    end
    -------------------------------------------------------
    --region Callbacks
    -------------------------------------------------------

    function CharacterSelectionMenu:openSpeciesMenu()
        local data_id = self.species_list

        local cb = function(ret)
            if self.data.species ~= ret then
                self.data.species = ret
                self.data.form = 0
                self:updatePermissions()
                self.data.intrinsic = self.monster.Forms[self.data.form].Intrinsic1
                self.data.egg_move = ""
                self.data.egg_move_index = -1
            end
            self:updateWindows(true, true)
        end

        local sub_menu = CharacterSpeciesMenu:new(self, data_id, table.index_of(data_id, self.data.species, 1), cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:openFormMenu()
        local forms = self.monster.Forms
        local species_name = self.monster.Name:ToLocal()
        local options = {}
        local data_id = {}

        for i=0, forms.Count-1, 1 do
            local form_name = forms[i].FormName:ToLocal()
            if form_name == species_name then
                form_name = "Normal"
            else
                form_name = form_name:gsub(species_name, "")
                form_name = form_name:gsub('^%s*(.-)%s*$', '%1')
            end
            if forms[i].Released and not forms[i].Temporary then
                table.insert(options, form_name)
                table.insert(data_id, i)
            end
        end

        local cb = function(ret)
            if self.data.form ~= data_id[ret] then
                self.data.form = data_id[ret]
                self:updatePermissions()
                self.data.intrinsic = self.monster.Forms[self.data.form].Intrinsic1
                self.data.egg_move = ""
                self.data.egg_move_index = -1
            end
            self:updateWindows(true, true)
        end
        local offset = self.options[self.selected[1]][self.selected[2]][1]
        local sub_menu = CharacterChoiceListMenu:new(self, "Form:", offset, options, self.data.form+1, cb, -3)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:openGenderMenu()
        local options = {"Male", "Female", "Non-Binary"}
        local cb = function(ret)
            self.data.gender = ret-1
            self:updateWindows(true, false)
        end
        local offset = self.options[self.selected[1]][self.selected[2]][1]
        local sub_menu = CharacterChoiceListMenu:new(self, "Gender:", offset, options, self.data.gender+1, cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:openAbilityMenu()
        local form = self.monster.Forms[self.data.form]
        local options = {}
        local data_id = {}
        table.insert(data_id, form.Intrinsic1)
        if form.Intrinsic2 ~= "none" then table.insert(data_id, form.Intrinsic2) end
        if form.Intrinsic3 ~= "none" then table.insert(data_id, form.Intrinsic3) end

        for _, data in ipairs(data_id) do
            table.insert(options, _DATA:GetIntrinsic(data).Name:ToLocal())
        end
        local cb = function(ret)
            self.data.intrinsic = data_id[ret]
            self:updateWindows(false, false)
        end
        local offset = self.options[self.selected[1]][self.selected[2]][1]
        local sub_menu = CharacterChoiceListMenu:new(self, "Ability:", offset, options, table.index_of(data_id, self.data.intrinsic, 1), cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:openSheenMenu()
        local options = {"Regular", "[color=#FFFF00]Shiny\u{E10C}[color]"}
        local data_id = {"normal", "shiny"}
        local cb = function(ret)
            self.data.skin = data_id[ret]
            self:updateWindows(true, false)
        end
        local offset = self.options[self.selected[1]][self.selected[2]][1]
        local sub_menu = CharacterChoiceListMenu:new(self, "Sheen:", offset, options,  table.index_of(data_id, self.data.skin, 1), cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:openEggMoveMenu()
        local cb = function(move, index)
            self.data.egg_move = move
            self.data.egg_move_index = index-1
            self:updateWindows(false, true, false)
        end
        local sub_menu = CharacterEggMoveMenu:new(self, cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterSelectionMenu:signDocument()
        local cb = function(close_menu)
            self.confirmed = close_menu
            if self.confirmed then _MENU:RemoveMenu() end
        end
        local sub_menu = CharacterConfirmMenu:new(self, cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    -------------------------------------------------------
    --region CharacterChoiceListMenu
    -------------------------------------------------------

    --Menu parent, string window_name, List<string> options, int current, function callback, int pos
    function CharacterChoiceListMenu:initialize(parent, window_name, window_offset, options, current, callback, pos)
        assert(self, "RecruitMainChoice:initialize(): self is nil!")
        self.parent = parent
        self.window_name = window_name
        self.selected = current -- starts from 1
        self.original = self.selected
        self.options = options
        self.callback = callback
        self.MAX_ELEM = 9
        self.ELEMENTS = math.min(#self.options, self.MAX_ELEM)

        self.pos = pos -- preferred starting position. can shift during initialization
        if pos == nil or self.ELEMENTS<self.MAX_ELEM then self.pos = self.selected end --set to selected if list too small or pos not supplied
        if self.pos<0 then self.pos = self.ELEMENTS+1 + self.pos end --count backwards if pos negative
        if self.selected == #self.options then
            self.pos = self.ELEMENTS
        elseif self.pos > self.ELEMENTS then
            self.pos = self.ELEMENTS-1
        end

        self.start_from = math.max(1,math.min(self.selected+1 - self.pos, (#self.options)+1 - self.ELEMENTS)) --cap display starting slot
        self.pos = self.selected+1 - self.start_from --readjust starting position

        -- calculate window position using parent data
        local w = parent:getFocusedWindow().Bounds.Width
        local h = Graphics.VERT_SPACE*self.ELEMENTS + Graphics.Manager.MenuBG.TileHeight*2
        local x = parent:getFocusedWindow().Bounds.Left
        local y = parent:getFocusedWindow().Bounds.Top + window_offset - Graphics.Manager.MenuBG.TileHeight - (Graphics.VERT_SPACE//2)*(self.ELEMENTS-1)

        -- this whole thing just for a goddamn visual adjustment
        local orig_y = y
        local y_min = parent:getFocusedWindow().Bounds.Top
        local y_max = parent:getFocusedWindow().Bounds.Bottom - h
        if y_min>y_max then
            if y_max < Graphics.Manager.ScreenHeight-12 - h then
                y_max = Graphics.Manager.ScreenHeight-12 - h
            end
        end
        if y_min>y_max then --if the previous adjustment was not enough
            if y_max > 8 then y_min=y_max else
                local y_mid = (y_min + y_max)//2
                y_min, y_max = y_mid, y_mid
            end
        end
        if y < y_min then y = y_min end
        if y > y_max then y = y_max end
        self.y_offset = orig_y - y

        self.menu  = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)
        self.cursor = RogueEssence.Menu.MenuCursor(self.menu)

        --Title/Option chosen
        local center_x = (self.menu.Bounds.Width*2)//3
        if self.window_name then self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(self.window_name, RogueElements.Loc(self.parent.menu_spacing, (self.menu.Bounds.Height - Graphics.VERT_SPACE)//2 + self.y_offset)))
        else center_x = self.menu.Bounds.Width//2 end

        --Options
        self.selectables = {}
        for i=1, self.ELEMENTS, 1 do
            self.selectables[i] = RogueEssence.Menu.MenuText("", RogueElements.Loc(center_x, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(i-1)), RogueElements.DirH.None)
            self.menu.MenuElements:Add(self.selectables[i])
        end

        self.menu.MenuElements:Add(self.cursor)
        self:DrawMenu()
    end

    function CharacterChoiceListMenu:DrawMenu()
        --fill options in
        local end_at = self.start_from+self.ELEMENTS - 1
        for i=self.start_from, end_at, 1 do
            local option = self.options[i]
            local slot = i - self.start_from+1
            self.selectables[slot]:SetText("[color=#FFC663]"..option.."[color]")
        end
        --position cursor
        self.cursor.Loc = RogueElements.Loc(10, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(self.pos-1))
    end

    function CharacterChoiceListMenu:Update(input)
        if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
            _GAME:SE("Menu/Confirm")
            self.callback(self.selected)
            _MENU:RemoveMenu()
        elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
               input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
            _GAME:SE("Menu/Cancel")
            self.callback(self.original)
            _MENU:RemoveMenu()
        elseif self:directionHold(input, RogueElements.Dir8.Up) then
            if self.selected > 1 then
                _GAME:SE("Menu/Skip")
                self:updateSelection(-1)
            else
                _GAME:SE("Menu/Cancel")
                self.selected = 1
                self.pos = 1
                self.start_from = 1
            end
            self:DrawMenu()
        elseif self:directionHold(input, RogueElements.Dir8.Down) then
            if self.selected<#self.options then
                _GAME:SE("Menu/Skip")
                self:updateSelection(1)
            else
                _GAME:SE("Menu/Cancel")
                self.selected = #self.options
                self.pos = self.ELEMENTS
                self.start_from = #self.options+1 - self.ELEMENTS
            end
            self:DrawMenu()
        end
    end

    function CharacterChoiceListMenu:directionHold(input, direction)
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

    function CharacterChoiceListMenu:updateSelection(change)
        self.selected = math.max(1,math.min(self.selected + change, #self.options))
        if self.selected == 1 then self.pos = 1
        elseif self.selected == #self.options then self.pos = self.ELEMENTS
        else self.pos = math.max(2,math.min(self.pos + change, self.ELEMENTS-1)) end
        self.start_from = self.selected+1 - self.pos
    end

    -------------------------------------------------------
    --region CharacterEggMoveMenu
    -------------------------------------------------------

    function CharacterEggMoveMenu:initialize(parent, updateCallback)
        assert(self, "RecruitMainChoice:initialize(): self is nil!")
        self.parent = parent
        self.updateCallback = updateCallback
        self.egg_move = self.parent.data.egg_move
        self.egg_move_index = self.parent.data.egg_move_index+1
        self.can_change_slot = (self.egg_move ~= "" and #self.parent.moves>3)
        self.autoOpenEggMovePosition = false
        self.callbacks = {
            function() self:openEggMoveSelection() end,
            function() self:openEggMovePosition() end,
            function() self:closeMenu() end
        }

        self.pos = 1

        local w = parent:getFocusedWindow().Bounds.Width
        local h = (Graphics.VERT_SPACE+Graphics.Manager.MenuBG.TileHeight+1)*3
        local x = parent:getFocusedWindow().Bounds.Left
        local y = parent:getFocusedWindow().Bounds.Top + (Graphics.VERT_SPACE*5)//2

        self.menu  = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)
        self.cursor = RogueEssence.Menu.MenuCursor(self.menu)

        --Egg Move
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Egg Move", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.None))
        --egg_move
        self.egg_move_name = RogueEssence.Menu.MenuText("[color=#FFC663]-----[color]", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE), RogueElements.DirH.None)
        --Change Slot
        self.change_slot_text = RogueEssence.Menu.MenuText("[color=#FFCEFF]Change Slot[color]", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*2), RogueElements.DirH.None)
        --Confirm
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Confirm", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*3), RogueElements.DirH.None))

        self.menu.MenuElements:Add(self.egg_move_name)
        self.menu.MenuElements:Add(self.change_slot_text)

        self.menu.MenuElements:Add(self.cursor)
        self:DrawMenu()
    end

    function CharacterEggMoveMenu:DrawMenu()
        --egg_move
        local egg_move = "-----"
        if self.egg_move ~= "" then egg_move = _DATA:GetSkill(self.egg_move).Name:ToLocal() end
        local change_slot_color = "#FFCEFF"
        if not self.can_change_slot then change_slot_color = "#886D88" end
        self.egg_move_name:SetText("[color=#FFC663]"..egg_move.."[color]")
        --Change Slot
        self.change_slot_text:SetText("[color="..change_slot_color.."]Change Slot[color]")

        --position cursor
        self.cursor.Loc = RogueElements.Loc(10, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(self.pos))
    end

    function CharacterEggMoveMenu:Update(input)
        if self.autoOpenEggMovePosition then --if auto menu opening is requested, grant the request
            self.autoOpenEggMovePosition = false
            self:openEggMovePosition()
        elseif input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
            local callback = self.callbacks[self.pos]
            _GAME:SE("Menu/Confirm")
            callback()
        elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
                input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
            _GAME:SE("Menu/Cancel")
            self:closeMenu()
        elseif not self.dirPressed then
            if input.Direction == RogueElements.Dir8.Up then
                if self.pos > 1 then
                    _GAME:SE("Menu/Confirm")
                    self.pos = self.pos - 1
                    if self.pos == 2 and not self.can_change_slot then self.pos = self.pos - 1 end
                else
                    _GAME:SE("Menu/Cancel")
                    self.pos = 1
                end
                self.dirPressed = true
                self:DrawMenu()
            elseif input.Direction == RogueElements.Dir8.Down then
                if self.pos<3 then
                    _GAME:SE("Menu/Confirm")
                    self.pos = self.pos + 1
                    if self.pos == 2 and not self.can_change_slot then self.pos = self.pos + 1 end
                else
                    _GAME:SE("Menu/Cancel")
                    self.pos = 3
                end
                self.dirPressed = true
                self:DrawMenu()
            end
        elseif input.Direction == RogueElements.Dir8.None then
            self.dirPressed = false
        end
    end

    function CharacterEggMoveMenu:openEggMoveSelection()
        local egg_moves = self.parent:getMonsterEggMoves()
        local options = {}
        local data_id = {}

        table.insert(options, "-----")
        table.insert(data_id, "")
        for _, move_id in pairs(egg_moves) do
            local move = _DATA:GetSkill(move_id)
            local move_name = move.Name:ToLocal()
            if move.Released then
                table.insert(options, move_name)
                table.insert(data_id, move_id)
            end
        end

        -- this is where the fun is handled
        local cb = function(ret)
            local update = true
            self.egg_move = data_id[ret]
            if self.egg_move == "" then self.egg_move_index = -1 end         --remove swapped index if selection empty
            self.can_change_slot = (self.egg_move ~= "" and #self.parent.moves>3)
            self:DrawMenu()
            if self.can_change_slot then                                   --if set and move list is filled
                if self.egg_move_index < 1 or self.egg_move_index > 4 then  --if the old index is invalid
                    self.autoOpenEggMovePosition = true                      --call other menu automatically
                    update = false
                end
            elseif self.egg_move ~= "" then                               --if set but move list is not filled
                self.egg_move_index = #self.parent.moves+1                  --visually append
            end
            if update then
                self.updateCallback(self.egg_move, self.egg_move_index)    --update parent variables
            end
        end

        local offset = self.pos*Graphics.VERT_SPACE
        local sub_menu = CharacterChoiceListMenu:new(self, nil, offset, options, table.index_of(data_id, self.egg_move, 1), cb, 5)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterEggMoveMenu:openEggMovePosition()
        local cb = function(index)
            self.egg_move_index = index or -1
            if self.egg_move_index > 4 or self.egg_move_index<1 then
                self.egg_move = ""
                self.egg_move_index = -1
            end
            self.can_change_slot = (self.egg_move ~= "" and #self.parent.moves>3)
            self:DrawMenu()
            self.updateCallback(self.egg_move, self.egg_move_index)    --update parent variables
        end

        local sub_menu = CharacterEggMovePositionSelector:new(self, cb)
        _MENU:AddMenu(sub_menu.menu, true)
    end

    function CharacterEggMoveMenu:closeMenu()
        self.updateCallback(self.egg_move, self.egg_move_index)
        _MENU:RemoveMenu()
    end

    function CharacterEggMoveMenu:getFocusedWindow() return self.menu end

    -------------------------------------------------------
    --region CharacterEggMovePositionSelector
    -------------------------------------------------------

    function CharacterEggMovePositionSelector:initialize(parent, callback)
        self.parent = parent
        self.callback = callback

        self.pos = self.parent.egg_move_index
        self.original = self.pos
        if self.pos<0 or self.pos>4 then self.pos = 4 end

        local x = Graphics.Manager.ScreenWidth//2 + 8
        local y = 8
        local w = Graphics.Manager.ScreenWidth - 16 - x
        local h = Graphics.Manager.ScreenHeight//2 - 4 - y

        self.menu = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)
        self.cursor = RogueEssence.Menu.MenuCursor(self.menu)

        --Replacing what?
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Replacing what?", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.None))
        -- ------------------------------------
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12 + Graphics.DIVIDER_HEIGHT//2, 8 + Graphics.VERT_SPACE), self.menu.Bounds.Width - 12 * 2))

        self.moves_text = RogueEssence.Menu.MenuText("Moves:", RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Left)
        self.menu.MenuElements:Add(self.moves_text)

        --moves list
        self.move_slots = {}
        for i=1, 4, 1 do
            self.move_slots[i] = {}
            self.move_slots[i].name = RogueEssence.Menu.MenuText("", RogueElements.Loc(Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(i+1) + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Left)
            self.move_slots[i].pp = RogueEssence.Menu.MenuText("", RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth*2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(i+1) + Graphics.DIVIDER_HEIGHT*2), RogueElements.DirH.Right)
            self.menu.MenuElements:Add(self.move_slots[i].name)
            self.menu.MenuElements:Add(self.move_slots[i].pp)
        end

        self.menu.MenuElements:Add(self.cursor)
        self:DrawMenu()
    end

    function CharacterEggMovePositionSelector:DrawMenu()
        self.moves = self.parent.parent.moves
        -- parent is CharacterEggMoveMenu, parent.parent is CharacterSelectionMenu

        --Moves:
        local move_text = "Moves:"
        if self.pos == 0 then move_text = "[color=#FFFF00]Cancel[color]" end
        self.moves_text:SetText(move_text)

        --moves list
        for i=1, 4, 1 do
            local move_id = self.moves[i]
            local move_name, move_pp
            if i == self.pos then -- override with egg move
                local move = _DATA:GetSkill(self.parent.egg_move)
                move_name = utf8.char(_DATA:GetElement(move.Data.Element).Symbol).."\u{2060}[color=#FFFF00]"..move.Name:ToLocal().."[color]"
                move_pp   = tostring(move.BaseCharges).."PP"
            elseif move_id ~= nil then -- basic move
                local move = _DATA:GetSkill(move_id)
                move_name = move:GetIconName()
                move_pp   = tostring(move.BaseCharges).."PP"
            else -- empty slot. Should never be hit but we keep it anyway for safety reasons
                move_name = "-----"
                move_pp   = "-----"
            end
            self.move_slots[i].name:SetText(move_name)
            self.move_slots[i].pp:SetText(move_pp)
        end

        --position cursor
        self.cursor.Loc = RogueElements.Loc(10, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*(self.pos+1) + Graphics.DIVIDER_HEIGHT*2)
    end

    function CharacterEggMovePositionSelector:Update(input)
        if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
            _GAME:SE("Menu/Confirm")
            self.callback(self.pos)
            _MENU:RemoveMenu()
        elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
               input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
            _GAME:SE("Menu/Cancel")
            self.callback(self.original)
            _MENU:RemoveMenu()
        elseif not self.dirPressed then
            if input.Direction == RogueElements.Dir8.Up then
                if self.pos > 0 then
                    _GAME:SE("Menu/Confirm")
                    self.pos = self.pos - 1
                else
                    _GAME:SE("Menu/Cancel")
                    self.pos = 0
                end
                self.dirPressed = true
                self:DrawMenu()
            elseif input.Direction == RogueElements.Dir8.Down then
                if self.pos<4 then
                    _GAME:SE("Menu/Confirm")
                    self.pos = self.pos + 1
                else
                    _GAME:SE("Menu/Cancel")
                    self.pos = 4
                end
                self.dirPressed = true
                self:DrawMenu()
            end
        elseif input.Direction == RogueElements.Dir8.None then
            self.dirPressed = false
        end
    end

    -------------------------------------------------------
    --region CharacterSpeciesMenu
    -------------------------------------------------------

    function CharacterSpeciesMenu:initialize(parent, list, current, callback)
        self.parent = parent
        self.original_list = list -- to remove filter
        self.list = list          -- display list, edited by filters
        self.original = list[current]
        self.selected = current
        self.callback = callback
        self.pos = 1

        self.filter = "" --only show mons that fit this filter
        self.menu_mode = 0 --0 = scroll, 1 = search id, 2 = search species
        self.monster = false

        local w = Graphics.Manager.ScreenWidth//2 + Graphics.Manager.MenuBG.TileWidth*2
        local h = Graphics.VERT_SPACE*6+Graphics.Manager.MenuBG.TileHeight*2
        local x = (Graphics.Manager.ScreenWidth -w)//2
        local y = (Graphics.Manager.ScreenHeight-h)//2
        h=h+Graphics.VERT_SPACE --adjust for extra description line. Gotta do it here or the menu shifts up

        self.menu = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)
        self.cursor = RogueEssence.Menu.MenuCursor(self.menu)

        --Title
        self.title_text = RogueEssence.Menu.MenuText("Choose your species", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.None)
        self.menu.MenuElements:Add(self.title_text)
        -- ------------------------------------
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*3)//2-Graphics.DIVIDER_HEIGHT), self.menu.Bounds.Width - 12 * 2))

        --Index   Species
        local num_x = 20
        local text_x = self.menu.Bounds.Width//2
        self.indexes = {}
        self.choosables = {}
        for i=1, 3, 1 do
            self.indexes[i] = RogueEssence.Menu.MenuText("", RogueElements.Loc(num_x, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*((2*i)+1)//2)))
            self.choosables[i] = RogueEssence.Menu.MenuText("", RogueElements.Loc(text_x, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*((2*i)+1)//2)), RogueElements.DirH.None)
            self.menu.MenuElements:Add(self.indexes[i])
            self.menu.MenuElements:Add(self.choosables[i])
        end

        -- ------------------------------------
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*9)//2), self.menu.Bounds.Width - 12 * 2))

        -- Description 1
        self.descr1 = RogueEssence.Menu.MenuText("Press left/right to scroll faster", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*5), RogueElements.DirH.None)
        self.menu.MenuElements:Add(self.descr1)

        -- Description 2
        self.descr2 = RogueEssence.Menu.MenuText("Press ".. STRINGS:LocalKeyString(9) .." to search", RogueElements.Loc(self.menu.Bounds.Width//2, Graphics.Manager.MenuBG.TileHeight + Graphics.VERT_SPACE*6), RogueElements.DirH.None)
        self.menu.MenuElements:Add(self.descr2)

        self.menu.MenuElements:Add(self.cursor)
        self:DrawMenu()
    end

    function CharacterSpeciesMenu:DrawMenu()
        --Title
        local title = "Choose your species"
        if self.filter~="" then title = "Filter: [color=#FFFF00]"..self.filter.."[color]"
        elseif self.menu_mode~=0 then title = "[color=#FFFF00]How will you search?[color]" end
        self.title_text:SetText(title)

        --Index   Species
        for i=1, 3, 1 do
            local index = ""
            local mon= ""
            local index_text = ""
            local mon_text= ""

            local len = #self.list
            if len>1 or len>0 and i==2 then
                local index_color, choosable_color = "#888888", "#886A35"
                if i == 2 then index_color, choosable_color = "#FFFFFF", "#FFC663" end
                local shift = i-2
                index = math.shifted_mod(self.selected+shift, #self.list, 1)
                mon = _DATA:GetMonster(self.list[index])
                index_text = "[color="..index_color.."]"..tostring(mon.IndexNum).."[color]"
                mon_text = "[color="..choosable_color.."]"..mon.Name:ToLocal().."[color]"
            elseif i==2 then
                mon_text = "[color=#FFFFFF]No results found[color]"
            end

            self.indexes[i]:SetText(index_text)
            self.choosables[i]:SetText(mon_text)
        end

        --Description 1
        local bottom_message = "Press left/right to scroll faster"
        if self.menu_mode~=0 then
            if self.menu_mode == 1 then bottom_message = "Jump to index"
            else bottom_message = "Filter by species" end
            bottom_message = "[color=#FFFF00]"..bottom_message.."[color]"
        end
        self.descr1:SetText(bottom_message)

        --Description 2
        local menu_key = STRINGS:LocalKeyString(9)
        local final_message = "Press "..menu_key.." to search"
        if self.filter~="" then final_message = "[color=#FFFF00]"..menu_key.." to remove the filter[color]"
        elseif self.menu_mode~=0 then final_message = "[color=#FFFF00]Press "..menu_key.." to cancel[color]" end
        self.descr2:SetText(final_message)

        --position cursor
        if self.menu_mode == 2 then
            self.cursor.Loc = RogueElements.Loc(42, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*5//2))
        else
            self.cursor.Loc = RogueElements.Loc(10, Graphics.Manager.MenuBG.TileHeight + (Graphics.VERT_SPACE*5//2))
        end
    end

    function CharacterSpeciesMenu:Update(input)
        if self.menu_mode==0 then -- if scroll mode
            if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
                if #self.list>0 then
                    _GAME:SE("Menu/Confirm")
                    self.callback(self.list[self.selected])
                    _MENU:RemoveMenu()
                else
                    _GAME:SE("Menu/Cancel")
                end
            elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
                if self.filter~="" then
                    self:apply_filter()
                else
                    self.callback(self.original)
                    _MENU:RemoveMenu()
                end
                _GAME:SE("Menu/Cancel")
            elseif input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
                if self.filter~="" then
                    self:apply_filter()
                    _GAME:SE("Menu/Cancel")
                else
                    _GAME:SE("Menu/Confirm")
                    self.menu_mode=1
                    self:DrawMenu()
                end
            elseif self:directionHold(input, RogueElements.Dir8.Up) then
                if #self.list>1 then
                    _GAME:SE("Menu/Skip")
                    self.selected = math.shifted_mod(self.selected-1, #self.list, 1)
                    self:DrawMenu()
                else
                    _GAME:SE("Menu/Cancel")
                end
            elseif self:directionHold(input, RogueElements.Dir8.Down) then
                if #self.list>1 then
                    _GAME:SE("Menu/Skip")
                    self.selected = math.shifted_mod(self.selected+1, #self.list, 1)
                    self:DrawMenu()
                else
                    _GAME:SE("Menu/Cancel")
                end
            elseif self:directionHold(input, RogueElements.Dir8.Left) then
                if #self.list>1 then
                    _GAME:SE("Menu/Skip")
                    self.selected = math.shifted_mod(self.selected-3, #self.list, 1)
                    self:DrawMenu()
                else
                    _GAME:SE("Menu/Cancel")
                end
            elseif self:directionHold(input, RogueElements.Dir8.Right) then
                if #self.list>1 then
                    _GAME:SE("Menu/Skip")
                    self.selected = math.shifted_mod(self.selected+3, #self.list, 1)
                    self:DrawMenu()
                else
                    _GAME:SE("Menu/Cancel")
                end
            end
        -- if search mode
        else
            if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
                _GAME:SE("Menu/Confirm")
                if self.menu_mode==1 then
                    self:openIndexSelectionMenu()
                else
                    self:openSpeciesFilterMenu()
                end
            elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
                   input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
                _GAME:SE("Menu/Confirm")
                self.menu_mode = 0
                self:DrawMenu()
            elseif self:directionHold(input, RogueElements.Dir8.Up) or
                   self:directionHold(input, RogueElements.Dir8.Down) then
                _GAME:SE("Menu/Cancel")
            elseif self:directionHold(input, RogueElements.Dir8.Left) or
                   self:directionHold(input, RogueElements.Dir8.Right) then
                _GAME:SE("Menu/Skip")
                self.menu_mode = math.shifted_mod(self.menu_mode+1, 2)
                self:DrawMenu()
            end
        end
    end

    function CharacterSpeciesMenu:directionHold(input, direction)
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

    function CharacterSpeciesMenu:apply_filter(filter)
        if filter == nil then filter = "" end
        self.filter = filter          --save for display
        filter = string.lower(filter) --edit for actual filtering
        if self.filter == "" then
            self.list = self.original_list
        else
            self.list = {}
            for i = 1, #self.original_list, 1 do
                local monster = self.original_list[i]
                if string.find(string.lower(_DATA:GetMonster(monster).Name:ToLocal()), filter) then
                    table.insert(self.list, monster)
                end
            end
        end
        self.selected = 1
        self:DrawMenu()
    end

    function CharacterSpeciesMenu:go_to(index)
        local len = #self.list
        local highest = _DATA:GetMonster(self.list[len]).IndexNum
        local current_entry = math.max(1,math.min((index * len) // highest, len))
        local found_index = _DATA:GetMonster(self.list[current_entry]).IndexNum
        if index < found_index then
            while index < found_index do
                current_entry = current_entry-1
                found_index = _DATA:GetMonster(self.list[current_entry]).IndexNum
            end
        elseif index > found_index then
            while index > found_index do
                current_entry = current_entry+1
                found_index = _DATA:GetMonster(self.list[current_entry]).IndexNum
            end
            if index~= found_index then current_entry = current_entry-1 end
        end
        if current_entry ~= self.selected then self.menu_mode = 0 end
        self.selected = current_entry
        self:DrawMenu()
    end

    -------------------------------------------------------
    -- Index Search Menu
    -------------------------------------------------------
    function CharacterSpeciesMenu:openIndexSelectionMenu()
        local w, h = 80, 64
        local x, y = (Graphics.Manager.ScreenWidth-w)//2, (Graphics.Manager.ScreenHeight-h)//2
        local current = _DATA:GetMonster(self.list[self.selected]).IndexNum
        local lowest =  _DATA:GetMonster(self.list[1]).IndexNum
        local highest = _DATA:GetMonster(self.list[#self.list]).IndexNum
        local choose = function(number) self:go_to(number) end

        local menu = ChooseAmountMenu:new(x, y, w, h, "Jump to?", current, lowest, highest, choose)
        _MENU:AddMenu(menu.menu, true)
    end

    -------------------------------------------------------
    -- Species Search Menu
    -------------------------------------------------------
    function CharacterSpeciesMenu:openSpeciesFilterMenu()
        local confirm = function(ret)
            self.menu_mode = 0
            self:apply_filter(ret)
        end
        local cancel = function(_)
            self:apply_filter()
        end
        local sub_menu = RogueEssence.Menu.NicknameMenu(confirm, cancel)
        sub_menu.Title:SetText("What species are you looking for?")
        sub_menu.Notes:SetText("You can also write only part of the name")
        _MENU:AddMenu(sub_menu, true)
    end
    
    -------------------------------------------------------
    --region CharacterSignDocumentMenu
    -------------------------------------------------------

    function CharacterConfirmMenu:initialize(parent, callback)
        self.parent = parent
        self.callback = callback

        self.answer = false

        local w = parent:getFocusedWindow().Bounds.Width
        local h = Graphics.VERT_SPACE+Graphics.Manager.MenuBG.TileHeight*2
        local x = parent:getFocusedWindow().Bounds.Left
        local y = parent:getFocusedWindow().Bounds.Top + parent.options[2][3][1] - Graphics.Manager.MenuBG.TileHeight

        self.menu = RogueEssence.Menu.ScriptableMenu(x, y, w, h, function(input) self:Update(input) end)
        self.cursor = RogueEssence.Menu.MenuCursor(self.menu)

        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Are you sure?", RogueElements.Loc(parent.menu_spacing, Graphics.Manager.MenuBG.TileHeight)))
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("\u{E10A}", RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth - 3, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.Right))
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("\u{E10B}", RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth - 20, Graphics.Manager.MenuBG.TileHeight), RogueElements.DirH.Right))
        self.menu.MenuElements:Add(self.cursor)
        self.cursor.Loc = RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth - 34, Graphics.Manager.MenuBG.TileHeight)
    end

    function CharacterConfirmMenu:Update(input)
        if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
            _GAME:SE("Menu/Confirm")
            self.callback(self.pos)
            _MENU:RemoveMenu()
        elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or
                input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
            _GAME:SE("Menu/Cancel")
            self.callback(false)
            _MENU:RemoveMenu()
        elseif not self.dirPressed then
            if input.Direction == RogueElements.Dir8.Right then
                if not self.pos then _GAME:SE("Menu/Confirm")
                else _GAME:SE("Menu/Cancel") end
                self.pos = true
                self.dirPressed = true
                self.cursor.Loc = RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth - 16, Graphics.Manager.MenuBG.TileHeight)
            elseif input.Direction == RogueElements.Dir8.Left then
                if self.pos then _GAME:SE("Menu/Confirm")
                else _GAME:SE("Menu/Cancel") end
                self.pos = false
                self.dirPressed = true
                self.cursor.Loc = RogueElements.Loc(self.menu.Bounds.Width - Graphics.Manager.MenuBG.TileWidth - 34, Graphics.Manager.MenuBG.TileHeight)
            end
        elseif input.Direction == RogueElements.Dir8.None then
            self.dirPressed = false
        end
    end

    return CharacterSelectionMenu
end

--[[
--copy paste this for quick implementation

local CharacterMenu = CharacterSelectionMenu()
local menu = CharacterMenu:new()
while not menu.confirmed do
    UI:SetCustomMenu(menu:getFocusedWindow())
    UI:WaitForChoice()
end
]]