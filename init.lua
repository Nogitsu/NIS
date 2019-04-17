local nis = { _version = "0.1" }
local utils = require "nis.utils"

nis.active = {}
nis.screen = {
  w = love.graphics.getPixelWidth(),
  h = love.graphics.getPixelHeight(),
  lastw = love.graphics.getPixelWidth(),
  lasth = love.graphics.getPixelHeight(),
}

function nis.Create( type, parent )
    local loader, error = love.filesystem.load( "nis/Objects/"..type..".lua" )
    if error then
      love.errhand( error )
    else
      local this = loader( type, parent )
      table.insert( nis.active, this )
      if parent then
        parent.children[this.id] = this
      end
      return nis.active[this.id]
    end
end

function nis.draw()
  for k, v in pairs( nis.active ) do
      v:Draw()
  end
end

function nis.update( dt )
  for k, v in pairs( nis.active ) do
    v:InternalThink( dt )
  end
end

function nis.resize( w, h )
  nis.screen.lastw = nis.screen.w
  nis.screen.lasth = nis.screen.h

  nis.screen.w = w
  nis.screen.h = h

  for k, v in pairs( nis.active ) do
        v:Resize( w, h, nis.screen.lastw, nis.screen.lasth )
  end
end

function nis.mousepressed( x, y, button )
  for k, v in pairs( nis.active ) do
    if v.hovered then
      v:OnPressed( button )
    end
  end
  if button == 1 then
    for k, v in pairs( nis.active ) do
      if v:IsHovered() and v:IsEnabled() then
        v.pressed = true
      end
    end
  end
end

function nis.mousereleased( x, y, button )
  for k, v in pairs( nis.active ) do
    if v.hovered then
      v:OnReleased( button )
    end
  end
  if button == 1 then
    for k, v in pairs( nis.active ) do
      if v:IsHovered() and v:IsPressed() and v:IsEnabled() then
        v.pressed = false
        v:DoClick()
      end
    end
  end
end

function nis.mousemoved( x, y, dx, dy )
  for k, v in pairs( nis.active ) do
        v:MouseMoved( x, y, dx, dy )
  end
end

local function PopUpType(type)
  local types = {
    ["error"] = {
      bg = { r = 150, g = 58, b = 58 },
      title = { r = 58, g = 58, b = 58 },
      bar = { r = 150, g = 150, b = 150 },
    },
    ["info"] = {
      bg = { r = 58, g = 150, b = 150 },
      title = { r = 58, g = 58, b = 58 },
      bar = { r = 150, g = 150, b = 150 },
    },
  }
  return types[type] or types["error"]
end

function nis.PopUp(title, message, type)
  local colors = PopUpType(type)
  local popup = nis.Create("Frame")
  popup:SetSize(250,100)
  popup:SetTitle(title or "Error")
  popup:SetColor( colors.bg.r, colors.bg.g, colors.bg.b )
  popup:SetBarColor( colors.bar.r, colors.bar.g, colors.bar.b )
  popup:SetTitleColor( colors.title.r, colors.title.g, colors.title.b )
  popup:Center()

  local popup_text = nis.Create("MultilineLabel", popup)
  popup_text:SetText(message or "nil")
  popup_text:SetAlign("left")
  popup_text:Center()

  return popup
end

function DerivePanel( parent, child )
  local PANEL = love.filesystem.load( "nis/Objects/"..parent..".lua" )( parent, child.parent )
  return utils.fusionTable( PANEL, child )
end

return nis
