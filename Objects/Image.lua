local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  filename = "nis/Resources/Pictures/love_logo.png",
  r = 0,
  px = 0.5, py = 0.5,
  sx = 1, sy = 1,
}
local PANEL = DerivePanel( "Panel", DERIVED )

PANEL.image = love.graphics.newImage( PANEL.filename )
PANEL.w = PANEL.image:getPixelWidth()
PANEL.h = PANEL.image:getPixelHeight()

function PANEL:SetImage( filename )
  filename = filename or "nis/Resources/Pictures/love_logo.png"
  self.filename = filename
  self.image = love.graphics.newImage( self.filename )
  self.w = self.image:getPixelWidth()
  self.h = self.image:getPixelHeight()
end

function PANEL:GetImage()
  return self.filename
end

function PANEL:SetRotation( r )
  self.r = r
end

function PANEL:GetRotation()
  return self.r
end

function PANEL:SetPos( x, y )
    self.x = math.floor( self.parent.x + x )
    self.y = math.floor( self.parent.y + y )

    self.relativex = self.x - self.parent.x
    self.relativey = self.y - self.parent.y
end

function PANEL:SetPivot( x, y )
    self.px = x
    self.py = y
end

function PANEL:SetScale( x, y )
  self.sx = x
  self.sy = y
end

function PANEL:GetScale()
  return self.sx, self.sy
end

function PANEL:GetSize()
  return self.w*self.sx, self.h*self.sy
end

function PANEL:InternalThink( dt )
  local mx, my = love.mouse.getPosition()
  self.hovered = (mx > self.x and mx < self.x+self.w*self.sx) and (my > self.y and my < self.y+self.h*self.sy)
  self:Think( dt )
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.draw( self.image, self.x+self.w*self.px, self.y+self.h*self.py, math.rad(self.r), self.sx, self.sy, self.w*self.px, self.h*self.py )
end

return PANEL
