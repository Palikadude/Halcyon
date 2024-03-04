require 'common'

function SingleItemDealMenu()
    local SingleItemDealMenu = Class('MerchantMenu')

    -- Parameters:
    -- title: the string that will be used as the menu's title
    -- item: the InvItem instance that is being sold
    -- cost: the cost that will be displayed next to the item
    function SingleItemDealMenu:initialize(title, item, cost)
        assert(self, "SingleItemDealMenu:initialize(): self is nil!")
        self.item = item.ID

        self.result = false -- output variable

        local MENU_WIDTH = 160
        local TITLE_HEIGHT = 16
        local LINE_HEIGHT = 12
        local VERT_SPACE = 14
        local itemdata = _DATA:GetItem(item.ID)
        local options = {
            {STRINGS:FormatKey("MENU_SHOP_BUY"), cost <= GAME:GetPlayerMoney(), function() self:Choose(true)  end}, -- locked if not enough money
            {STRINGS:FormatKey("MENU_CANCEL"),   true,                          function() self:Choose(false) end}
        }
        if itemdata.UsageType == RogueEssence.Data.ItemData.UseType.Learn then
            table.insert(options, 2, {STRINGS:FormatKey("MENU_INFO"), true, function() self:OpenInfo() end})
        end
        local default = 0 -- normally default to buy
        if cost > GAME:GetPlayerMoney() then default = 1 end -- default to refuse if not enough money

        -- setup windows
        self.display_item_box = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
                RogueElements.Loc(16, 8),
                RogueElements.Loc(16 + MENU_WIDTH, 8 + TITLE_HEIGHT + VERT_SPACE + RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2)
        ))
        self.description_box = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
                RogueElements.Loc(16, RogueEssence.Content.GraphicsManager.ScreenHeight - 8 - 4 * VERT_SPACE - RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2),
                RogueElements.Loc(RogueEssence.Content.GraphicsManager.ScreenWidth - 16, RogueEssence.Content.GraphicsManager.ScreenHeight - 8)
        ))
        self.money_box = RogueEssence.Menu.MoneySummary(RogueElements.Rect.FromPoints(
                RogueElements.Loc(16 + self.display_item_box.Bounds.Right, self.description_box.Bounds.Top - LINE_HEIGHT * 2 - RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2),
                RogueElements.Loc(RogueEssence.Content.GraphicsManager.ScreenWidth - 16, self.description_box.Bounds.Top)
        ))
        self.menu = RogueEssence.Menu.ScriptableSingleStripMenu(
                16, self.description_box.Bounds.Top - VERT_SPACE*#options - RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2,
                1, options, default, function() self:Choose() end
        )

        --create and apply text
        self.menu_title = RogueEssence.Menu.DialogueText(
                title,
                RogueElements.Rect(
                        RogueElements.Loc(RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight),
                        RogueElements.Loc(self.display_item_box.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 4, self.display_item_box.Bounds.Height -  RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 4)
                ),
                12
        )
        self.item_text = RogueEssence.Menu.DialogueText(
                item:GetDisplayName(),
                RogueElements.Rect(
                        RogueElements.Loc(RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight + TITLE_HEIGHT+2),
                        RogueElements.Loc(self.display_item_box.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 4, self.display_item_box.Bounds.Height -  RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 4)
                ),
                12
        )
        self.description_text = RogueEssence.Menu.DialogueText(
                _DATA:GetItem(item.ID).Desc:ToLocal(),
                RogueElements.Rect(
                        RogueElements.Loc(RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight),
                        RogueElements.Loc(self.description_box.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 4, self.description_box.Bounds.Height -  RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 4)
                ),
                12
        )

        -- apply elements and finishing touches
        self.display_item_box.Elements:Add(self.menu_title)
        self.display_item_box.Elements:Add(RogueEssence.Menu.MenuDivider(RogueElements.Loc(12, 8 + 12), self.display_item_box.Bounds.Width - 12 * 2))
        self.display_item_box.Elements:Add(self.item_text)
        self.price_text = RogueEssence.Menu.MenuText("[color=#00FF00]" .. tostring(cost) .. "[color]",  RogueElements.Loc(self.display_item_box.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight+ TITLE_HEIGHT+2), RogueElements.DirH.Right)
        self.display_item_box.Elements:Add(self.price_text)

        self.description_box.Elements:Add(self.description_text)
        self.value_text = RogueEssence.Menu.MenuText("Value: [color=#00FFFF]" ..  tostring(item:GetSellValue()) .. "[color]\u{E024}",  RogueElements.Loc(self.description_box.Bounds.Width - RogueEssence.Content.GraphicsManager.MenuBG.TileWidth * 2, RogueEssence.Content.GraphicsManager.MenuBG.TileHeight + 4 * 12), RogueElements.DirH.Right)
        self.description_box.Elements:Add(self.value_text)

        -- add summary windows to menu
        self.menu.SummaryMenus:Add(self.display_item_box)
        self.menu.SummaryMenus:Add(self.description_box)
        self.menu.SummaryMenus:Add(self.money_box)
    end


    function SingleItemDealMenu:Choose(buy)
        -- different SE when pressing escape
        if buy==nil then
            _GAME:SE("Menu/Cancel")
        else
            _GAME:SE("Menu/Confirm")
        end
        -- return false if nil
        self.result = buy or false
        _MENU:RemoveMenu()
    end

    function SingleItemDealMenu:OpenInfo()
        _MENU:AddMenu(RogueEssence.Menu.TeachInfoMenu(self.item), false)
    end


    return SingleItemDealMenu
end

--[[
copypasta for quick implementation idk

local SingleItemDealMenu = SingleItemDealMenu()
local menu = SingleItemDealMenu:new(title, item, price)
UI:SetCustomMenu(menu.menu)
UI:WaitForChoice()
]]