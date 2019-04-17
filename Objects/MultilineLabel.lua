local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
}
local PANEL = DerivePanel( "Label", DERIVED )

function PANEL:SetText( text )
  self.text = tostring( text )
  self.label:setf( text, self.parent.w-10 or self.w-10,  self.align)

  local tw, th = self:GetTextSize()

  if self.w < tw then
    self.w = tw
  end
  if self.h < th then
    self.h = th
  end
end

function PANEL:SetAlign(align)
  self.align = align
  self.label:setf( self.text, self.parent.w-10 or self.w-10,  self.align)
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )

  love.graphics.setColor( self.textColor )

  local tw, th = self:GetTextSize()
  love.graphics.draw( self.label, math.floor(self.x), math.floor(self.y + self.h/2 - th/2) )
end

return PANEL
