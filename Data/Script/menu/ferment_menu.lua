function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function table.tostring(tbl, indent)
  indent = indent or 0
  local indentStr = string.rep(" ", indent)

  if not tbl or type(tbl) ~= "table" then
      return tostring(tbl)
  end

  local str = "{\n"
  local count = 0

  for key, value in pairs(tbl) do
      count = count + 1
      str = str .. indentStr .. "  [" .. table.tostring(key) .. "] = " .. table.tostring(value, indent + 2) .. ",\n"
  end

  if count > 0 then
      str = str .. indentStr
  end

  str = str .. "}"
  return str
end

function table.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[table.copy(k, s)] = table.copy(v, s) end
  return res
end

function CreateFermentMenu()
  local CreateFermentMenu = Class('CreateFermentMenu')
  function CreateFermentMenu:initialize(items, MapStrings)
    assert(self, "CreateFermentMenu:initialize(): Error, self is nil!")
    self.materials = {}
    self.updateMaterialCount(self, items)

    self.items = items
    self.MapStrings = MapStrings

    self.item_list_index = -1
    self.total_items = #items
    self.total_items_per_page = 8
    self.pages = self.sortIntoPages(self, table.copy(items), self.total_items_per_page)
    self.total_pages = #self.pages
    self.current_item = 0
    self.current_page = 0
    self.choices = self.pages[self.current_page + 1]
    self.width = 160
    local VERT_SPACE = 14
    local height = self.total_items_per_page * 16 + RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2
    self.menu = RogueEssence.Menu.ScriptableMenu(16, 16, self.width, height, function(input) self:Update(input) end)
    self.setMenuList(self)
    self.descriptions_menu = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
      RogueElements.Loc(16, RogueEssence.Content.GraphicsManager.ScreenHeight - 8 - 4 * VERT_SPACE - RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2),
      RogueElements.Loc(RogueEssence.Content.GraphicsManager.ScreenWidth - 16, RogueEssence.Content.GraphicsManager.ScreenHeight - 8)
    ))
    self.requirements_menu = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
      RogueElements.Loc(16 + self.width, self.menu.Bounds.Top + 40),
      RogueElements.Loc(RogueEssence.Content.GraphicsManager.ScreenWidth - 16,  self.descriptions_menu.Bounds.Top)
    ))

    local current_item = self.pages[self.current_page + 1][self.current_item + 1]

    -- DESCRIPTION --
    self.description_text = RogueEssence.Menu.DialogueText(
      STRINGS:Format(MapStrings[current_item.description_key]),
      RogueElements.Rect(
        RogueElements.Loc(RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight),
        RogueElements.Loc(self.descriptions_menu.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 4, self.descriptions_menu.Bounds.Height -  RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 4)
      ),
      12
    )
    self.setIngredients(self)
    self.descriptions_menu.Elements:Add(self.description_text)
    self.servings_text = RogueEssence.Menu.MenuText("Servings: [color=#00FFFF]" ..  current_item.servings .. "[color]",  RogueElements.Loc(self.descriptions_menu.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight + 4 * 12), RogueElements.DirH.Right);
    self.descriptions_menu.Elements:Add(self.servings_text);
    self.menu.SummaryMenus:Add(self.requirements_menu)
    self.menu.SummaryMenus:Add(self.descriptions_menu)
  end

  function CreateFermentMenu:setPage(page)
    self.current_page = page
    self.page_text:SetText("(" .. self.current_page + 1 .. "/" .. self.total_pages .. ")")
    self.choices = self.pages[page + 1]
    self.current_item = math.min(self.current_item, #self.choices - 1)
    self.onChange(self, true)
  end

  function CreateFermentMenu:setMenuList()
    self.menu.MenuElements:Clear()
    self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
    self.menu.MenuElements:Add(self.cursor)
    -- self.menu.MenuElements:Add(self.test)

    self.menu.MenuElements:Add(RogueEssence.Menu.MenuText("Café Menu", RogueElements.Loc(16, 8)))
    local page_len = RogueEssence.Content.GraphicsManager.TextFont:SubstringWidth("(1/1)")
    self.page_text = RogueEssence.Menu.MenuText("(" .. self.current_page + 1 .. "/" .. self.total_pages .. ")", RogueElements.Loc(self.width - page_len - 10, 8))
    self.menu.MenuElements:Add(self.page_text)
    self.menu.MenuElements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + 12), self.menu.Bounds.Width - 12 * 2))

    local menu_offset = 16 + 8
    for _, cafe_item in ipairs(self.choices) do
      -- local recipe_list = cafe_item.recipe_list
      local inv_item = RogueEssence.Dungeon.InvItem(cafe_item.item_to_ferment)


      local item_entry = RogueEssence.Data.DataManager.Instance:GetItem(inv_item.ID)
      local old_stack = item_entry.MaxStack
      item_entry.MaxStack = -1

      local display = inv_item:GetDisplayName()
      if cafe_item.can_ferment then
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(display, RogueElements.Loc(16, menu_offset)))
      else
        self.menu.MenuElements:Add(RogueEssence.Menu.MenuText(display, RogueElements.Loc(16, menu_offset), Color.Red))
      end
      menu_offset = menu_offset + 14
      item_entry.MaxStack = old_stack
    end
    self.cursor.Loc = RogueElements.Loc(10, 24 + 12 * self.current_item)
  end

  function CreateFermentMenu:setIngredients()
    self.requirements_menu.Elements:Clear()
    self.requirements_menu.Elements:Add(RogueEssence.Menu.MenuText("Ingredients", RogueElements.Loc(16, 8)))
    self.requirements_menu.Elements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + 12), self.requirements_menu.Bounds.Width - 12 * 2))
    local item = self.pages[self.current_page + 1][self.current_item + 1]
    local recipe_list = item.recipe_list
    local offset = 16 + 8

    for _, recipe in ipairs(recipe_list) do
      local ingredient = recipe[1]
      local amount = recipe[2]
      local inv_item = RogueEssence.Dungeon.InvItem(ingredient)
      inv_item.Amount = amount
      local item_entry = RogueEssence.Data.DataManager.Instance:GetItem(inv_item.ID)
      local old_stack = item_entry.MaxStack
      if amount ~= 1 then
        item_entry.MaxStack = amount
      end
      if recipe.has_ingredient then
        self.requirements_menu.Elements:Add(RogueEssence.Menu.MenuText(inv_item:GetDisplayName(), RogueElements.Loc(16, offset)))
      else
        self.requirements_menu.Elements:Add(RogueEssence.Menu.MenuText(inv_item:GetDisplayName(), RogueElements.Loc(16, offset), Color.Red))
      end
      item_entry.MaxStack = old_stack
      offset = offset + 14
    end
  end

  function CreateFermentMenu:setDescription()
    --print(table.tostring(self.pages))
    local item = self.pages[self.current_page + 1][self.current_item + 1]
    self.description_text:SetAndFormatText(STRINGS:Format(self.MapStrings[item.description_key]))
    self.servings_text:SetText("Servings: [color=#00FFFF]" ..  item.servings .. "[color]")
  end

  function CreateFermentMenu:onChange(changeMenu)
    self.setDescription(self)
    self.setIngredients(self)
    if changeMenu then
      self.setMenuList(self)
    end
  end

  function CreateFermentMenu:sortIntoPages(array, maxPerPage)
    local pages = {}
    local currentPage = {}
    
    for i = 1, #array do
        table.insert(currentPage, array[i])
        
        if #currentPage == maxPerPage then
            table.insert(pages, currentPage)
            currentPage = {}
        end
    end
    
    -- Add the remaining items if any
    if #currentPage > 0 then
        table.insert(pages, currentPage)
    end

    return pages
  end



  function CreateFermentMenu:Update(input)
    assert(self, "BaseState:Begin(): Error, self is nil!")
    -- default does nothing
    if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
      if (self.pages[self.current_page + 1][self.current_item + 1].can_ferment) then
      self.item_list_index = self.current_page * self.total_items_per_page + self.current_item
      _GAME:SE("Menu/Confirm")
      _MENU:RemoveMenu()
	  else
	  	--play a sfx if you try to make something you can't
	    _GAME:SE("Menu/Cancel")
      end
    end

    if input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
      _GAME:SE("Menu/Cancel")
      _MENU:RemoveMenu()
    end

    local moved = false
    if #self.pages[self.current_page + 1] > 1 then
      if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
        moved = true
        self.current_item = ((self.current_item + 1) % #self.pages[self.current_page + 1])
        self.onChange(self)
      elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
        moved = true
        self.current_item = (self.current_item + #self.pages[self.current_page + 1] - 1) % #self.pages[self.current_page + 1]
        self.onChange(self)
      end
    end

    if #self.pages > 1 then
      if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Left })) then
        self.setPage(self, (self.current_page + #self.pages - 1) % #self.pages)
        moved = true
      elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Right })) then
        self.setPage(self, (self.current_page + 1) % #self.pages)
        moved = true
      end
    end

    if moved then
      _GAME:SE("Menu/Select")
      self.cursor:ResetTimeOffset()
      self.cursor.Loc = RogueElements.Loc(10, 24 + 14 * self.current_item)
    end
  end

  function CreateFermentMenu:updateMaterialCount(items)
    local bag_count = GAME:GetPlayerBagCount()
    for i = 0, bag_count - 1, 1 do
      local item = GAME:GetPlayerBagItem(i)
      local amount = item.Amount
      if item.Amount == 0 then
        amount = 1
      end
      if self.materials[item.ID] then
        self.materials[item.ID] = self.materials[item.ID] + amount
      else
        self.materials[item.ID] = amount
      end
    end

    for i, cafe_item in ipairs(items) do
      local recipe_list = cafe_item.recipe_list
      items[i].can_ferment = true
      for j, recipe in ipairs(recipe_list) do
        local ingredient = recipe[1]
        local amount = recipe[2]

        if self.materials[ingredient] ~= nil and self.materials[ingredient] >= amount then
          recipe_list[j].has_ingredient = true
        else
          recipe_list[j].has_ingredient = false
          items[i].can_ferment = false
        end
      end
    end

    local function canFerment(first, second)
      return first.can_ferment and not second.can_ferment
    end
    
    table.sort(items, canFerment)

    for _, cafe_item in ipairs(items) do
      local recipe_list = cafe_item.recipe_list
      -- print("Required for " .. cafe_item.item_to_ferment)
      for j, recipe in ipairs(recipe_list) do
        local ingredient = recipe[1]
        local amount = recipe[2]
        -- print("Recipe: " .. ingredient .. " " .. amount)
        -- print("Good to go? " .. tostring(recipe_list[j].has_ingredient))
        -- print("Has: " .. (self.materials[ingredient] or 0))
      end
    end
  end

  return CreateFermentMenu
end