local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  color = { 0, 0, 0, 0 },
  font = love.graphics.newFont( "/nis/Resources/Fonts/disposabledroid-bb.regular.ttf", 20 ),
  text = "Text Label",
  textColor = { 1, 1, 1, 1 },
  align = "center",
}
local PANEL = DerivePanel( "Panel", DERIVED )

PANEL.label = love.graphics.newText( PANEL.font, PANEL.text )

function PANEL:SetTextColor( r, g, b, a )
  a = a or 255
  self.textColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetTextColor()
  return self.textColor
end

function PANEL:SetText( text )
  self.text = tostring( text )
  self.label:set( text )

  local tw, th = self:GetTextSize()

  if self.w < tw then
    self.w = tw + 20
  end
  if self.h < th then
    self.h = th + 20
  end
end

function PANEL:GetText()
  return self.text
end

function PANEL:GetTextSize()
  return self.label:getDimensions()
end

function PANEL:SetAlign(align)
  self.align = align
end

function PANEL:SetFont( font )
  self.font = font
  self.label:setFont( font )
end

function PANEL:GetFont()
  return self.font
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )

  love.graphics.setColor( self.textColor )

  local tw, th = self:GetTextSize()
  if align == "left" then
    love.graphics.draw( self.label, math.floor(self.x), math.floor(self.y + self.h/2 - th/2) )
  elseif align == "right" then
    love.graphics.draw( self.label, math.floor(self.x + self.w - tw), math.floor(self.y + self.h/2 - th/2) )
  else
    love.graphics.draw( self.label, math.floor(self.x + self.w/2 - tw/2), math.floor(self.y + self.h/2 - th/2) )
  end
end

return PANEL
