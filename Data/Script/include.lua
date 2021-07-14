--[[
  include.lua
  
  This file is loaded persistently.
  Its main purpose is to include dot net namespaces.
]]--


FNA = import 'FNA'
Microsoft = luanet.namespace('Microsoft')
Microsoft.Xna = luanet.namespace('Microsoft.Xna')
Microsoft.Xna.Framework = luanet.namespace('Microsoft.Xna.Framework')
RogueElements = import 'RogueElements'
RogueEssence = import 'RogueEssence'
RogueEssence.Content = luanet.namespace('RogueEssence.Content')
RogueEssence.Data = luanet.namespace('RogueEssence.Data')
RogueEssence.Dungeon = luanet.namespace('RogueEssence.Dungeon')
RogueEssence.Ground = luanet.namespace('RogueEssence.Ground')
RogueEssence.Script = luanet.namespace('RogueEssence.Script')
RogueEssence.Menu = luanet.namespace('RogueEssence.Menu')
RogueEssence.LevelGen = luanet.namespace('RogueEssence.LevelGen')
RogueEssence.Resources = luanet.namespace('RogueEssence.Resources')
RogueEssence.Network = luanet.namespace('RogueEssence.Network')
PMDC = import 'PMDC'
PMDC.Data = luanet.namespace('PMDC.Data')
PMDC.Dungeon = luanet.namespace('PMDC.Dungeon')
PMDC.LevelGen = luanet.namespace('PMDC.LevelGen')