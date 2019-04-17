local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  color = { 0, 0, 0, 1 },
  barColor = { .2, .2, 1, 1},
  draggable = true,
  showCloseButton = true,
  title = "New frame",
  titleColor = { 1, 1, 1, 1 },
  font = love.graphics.newFont( "/nis/Resources/Fonts/disposabledroid-bb.regular.ttf", 20 ),
  closefont = love.graphics.newFont( "/nis/Resources/Fonts/disposabledroid-bb.regular.ttf", 30 ),
}
local PANEL = DerivePanel( "Panel", DERIVED )

PANEL.label = love.graphics.newText( PANEL.font, PANEL.title )

function PANEL:InternalThink( dt )
  local mx, my = love.mouse.getPosition()
  self.hovered = (mx > self.x and mx < self.x+self.w) and (my > self.y and my < self.y+self.h)
  self.dragBar = self.w - 30
  self.dragging = (mx > self.x and mx < self.x+self.dragBar) and (my > self.y and my < self.y+30) and self.pressed and self.draggable

  self:Think( dt )
end

function PANEL:MouseMoved( x, y, dx, dy )
  if self.dragging then
    local maxx, maxy = love.graphics.getDimensions()
    self:Move( dx, dy, maxx, maxy )
  end
end

function PANEL:DoClick()
  local mx, my = love.mouse.getPosition()
  if (mx > self.x+self.dragBar and mx < self.x+self.w) and (my > self.y and my < self.y+30) then
    self = self:Remove()
  end
end

function PANEL:SetTitle(text)
  self.title = text
  self.label:set( text )
end

function PANEL:SetTitleColor( r, g, b, a ) -- Values in 255 :D
  a = a or 255
  self.titleColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:SetFont( font )
  self.font = font
  self.label:setFont( font )
end

function PANEL:GetFont()
  return self.font
end

function PANEL:SetDraggable(bool)
  self.draggable = bool
end

function PANEL:ShowCloseButton(bool)
  self.showCloseButton = bool
end

function PANEL:SetBarColor( r, g, b, a ) -- Values in 255 :D
  a = a or 255
  self.barColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
  love.graphics.setColor( self.barColor )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, 30 )

  love.graphics.setColor( self.titleColor )
  love.graphics.draw( self.label, math.floor(self.x + 5), math.floor(self.y + 5) )

  if not self.showCloseButton then return end
  love.graphics.setFont( self.closefont )
  love.graphics.setColor( self.titleColor )
  love.graphics.print( "X", math.floor(self.x + self.dragBar + 5), math.floor(self.y) )
end

return PANEL
