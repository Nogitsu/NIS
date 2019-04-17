local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  hoverColor = { 1, 1, 1, 0.2 }
}
local PANEL = DerivePanel( "Image", DERIVED )

function PANEL:SetHoverColor( r, g, b, a )
  a = a or 255
  self.hoverColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetHoverColor()
  return self.hoverColor
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.draw( self.image, self.x+self.w*self.px*self.sx, self.y+self.h*self.py*self.sy, math.rad(self.r), self.sx, self.sy, self.w*self.px, self.h*self.py )

  if self.hovered then
    love.graphics.setColor( self.hoverColor )
    love.graphics.rectangle( "fill", self.x, self.y, self.w*self.sx, self.h*self.sy )
  end
end

return PANEL
