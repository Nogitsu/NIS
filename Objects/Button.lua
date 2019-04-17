local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  color = { 1, 1, 1, 1 },
  textColor = { 0, 0, 0, 1 },
  hoverColor = { 0, 0, 0, 1 },
  hoverTextColor = { 1, 1, 1, 1 },
  align = "left",
}
local PANEL = DerivePanel( "Label", DERIVED )

function PANEL:SetHoverColor( r, g, b, a )
  a = a or 255
  self.hoverColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetHoverColor()
  return self.hoverColor
end

function PANEL:SetHoverTextColor( r, g, b, a )
  a = a or 255
  self.hoverTextColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetHoverTextColor()
  return self.hoverTextColor
end

function PANEL:Draw()
  if not self.visible then return end
  if self.hovered then
    love.graphics.setColor( self.hoverColor )
  else
    love.graphics.setColor( self.color )
  end
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )

  local tw, th = self:GetTextSize()

  if self.hovered then
    love.graphics.setColor( self.hoverTextColor )
  else
    love.graphics.setColor( self.textColor )
  end
  if align == "left" then
    love.graphics.draw( self.label, math.floor(self.x), math.floor(self.y + self.h/2 - th/2) )
  elseif align == "right" then
    love.graphics.draw( self.label, math.floor(self.x + self.w - tw), math.floor(self.y + self.h/2 - th/2) )
  else
    love.graphics.draw( self.label, math.floor(self.x + self.w/2 - tw/2), math.floor(self.y + self.h/2 - th/2) )
  end
end

return PANEL
