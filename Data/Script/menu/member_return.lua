function CreateMemberReturnMenu()
    -- equivalent to defining a class
  local MemberReturnMenu = Class('MemberReturnMenu')

  function MemberReturnMenu:initialize()
    assert(self, "MemberReturnMenu:initialize(): Error, self is nil!")
    local player_count = GAME:GetPlayerPartyCount()

    self.members = {}
    -- todo this a bit badly coded...
    self.slots = {}
    self.spacer = 12
    self.total_items = 0
    for i = 0, player_count - 1, 1 do 
      local player = GAME:GetPlayerPartyMember(i)
      if not player.IsPartner then 
        self.members[self.total_items] = player
        self.slots[self.total_items] = i
        self.total_items = self.total_items + 1
      end
    end

    local height = 16 + 8 + self.total_items * self.spacer + 8 + 12

    self.menu = RogueEssence.Menu.ScriptableMenu(24, 24, 164, height, function(input) self:Update(input) end)
    self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
    self.menu.MenuElements:Add(self.cursor)


    self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(GAME:GetTeamName(), RogueElements.Loc(16, 8)))
    self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + 12), self.menu.Bounds.Width - 12 * 2));


    -- Offset from menu divider and team name
    local offset = 16 + 8 

    for i = 0, player_count - 1, 1 do 
      local player = GAME:GetPlayerPartyMember(i)
      if not player.IsPartner then 
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(player:GetDisplayName(true), RogueElements.Loc(16 + 8, offset)))
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(STRINGS:FormatKey("MENU_TEAM_LEVEL_SHORT"), RogueElements.Loc(16 + 8 + 100, offset), RogueElements.DirH.Right))
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(tostring(player.Level), RogueElements.Loc(16 + 8 + 100 + 18, offset), RogueElements.DirH.Right))
        offset = offset + self.spacer
      end
    end

    self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, offset), self.menu.Bounds.Width - 12 * 2));
    self.current_item = 0
    --self.cursor.Loc = RogueElements.Loc(offset +)
    self.cursor.Loc = RogueElements.Loc(16, 24 + self.spacer * self.current_item)
  end

  function MemberReturnMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
    -- default does nothing
    if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
      _GAME:SE("Menu/Confirm")
      _MENU:RemoveMenu()
    end
    moved = false
    if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
      moved = true
      self.current_item = (self.current_item + 1) % self.total_items
    elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
      moved = true
      self.current_item = (self.current_item + self.total_items - 1) % self.total_items
    end
    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(16, 24 + self.spacer * self.current_item)
    end
  end

  return MemberReturnMenu
end