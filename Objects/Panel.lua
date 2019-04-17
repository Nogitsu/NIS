local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local nis = require "nis"

local PANEL = {
  parent = parent,
  children = {},
  type = type,
  id = #nis.active+1,
  layer = 0,
  x = 0, y = 0,
  relativex = 0, relativey = 0,
  w = 100, h = 25,
  color = { 1, 1, 1, 1 },
  visible = true,
  pressed = false,
  hovered = false,
  enabled = true,
  onBorders = {x = false, y = false},
  noresize = false,
}

function PANEL:Init( ... )
end

function PANEL:InternalThink( dt )
  local mx, my = love.mouse.getPosition()
  self.hovered = (mx > self.x and mx < self.x+self.w) and (my > self.y and my < self.y+self.h)
  self:Think( dt )
end

function PANEL:MouseMoved( x, y, dx, dy )
end

function PANEL:Think( dt )
end

function PANEL:OnResize( w, h, lw, lh )
end

function PANEL:Resize( w, h, lw, lh )
  if self.noresize or self.parent.type ~= "None" then return end
  self:OnResize( w, h, lw, lh )
  print(self.type)
  print("Old: "..self:GetPos())
  print(self.parent.x, (w/lw), self.relativex)
  self.relativex = self.relativex * (w/lw)
  self.relativey = self.relativey * (h/lh)

  self.x = math.floor( self.parent.x + self.relativex )
  self.y = math.floor( self.parent.y + self.relativey )
  print("New: "..self:GetPos().."\n")

  for k, v in pairs(self.children) do
    v:SetPos(v.relativex, v.relativey)
  end
end

function PANEL:EnableResize( bool )
  self.noresize = not bool
end

function PANEL:OnReleased( button )
end

function PANEL:OnPressed( button )
end

function PANEL:DoClick()
end

function PANEL:GetChildren()
  return self.children
end

function PANEL:Move( dx, dy, maxx, maxy )
  local fc = {x = self.x + dx, y = self.y + dy}

  self.onBorders.x = (fc.x + self.w > maxx or  fc.x < 0)
  self.parent.onBorders = self.parent.onBorders or {x=false,y=false}
  if not (self.onBorders.x or self.parent.onBorders.x) then
    self.x = fc.x
  end

  self.onBorders.y = (fc.y + self.h > maxy or  fc.y < 0)
  if not (self.onBorders.y or self.parent.onBorders.y) then
    self.y = fc.y
  end

  for k, v in pairs(self.children) do
    v:Move( dx, dy, maxx, maxy )
  end

  self.relativex = self.x - self.parent.x
  self.relativey = self.y - self.parent.y
end

function PANEL:Center()
  if self.parent.type == "None" then
    local sw, sh = love.graphics.getDimensions()
    self.x = sw/2 - self.w/2
    self.y = sh/2 - self.h/2
  elseif self.parent.type == "Frame" then
    self.x = self.parent.x + self.parent.w/2 - self.w/2
    self.y = self.parent.y + self.parent.h/2 + 15 - self.h/2
  else
    self.x = self.parent.x + self.parent.w/2 - self.w/2
    self.y = self.parent.y + self.parent.h/2 - self.h/2
  end
  self.relativex = self.x - self.parent.x
  self.relativey = self.y - self.parent.y
end

function PANEL:CenterX()
  if self.parent.type == "None" then
    local sw, sh = love.graphics.getDimensions()
    self.x = sw/2 - self.w/2
  elseif self.parent.type == "Frame" then
    self.x = self.parent.x + self.parent.w/2 - self.w/2
  else
    self.x = self.parent.x + self.parent.w/2 - self.w/2
  end
  self.relativex = self.x - self.parent.x
  self.relativey = self.y - self.parent.y
end

function PANEL:CenterY()
  if self.parent.type == "None" then
    local sw, sh = love.graphics.getDimensions()
    self.y = sh/2 - self.h/2
  elseif self.parent.type == "Frame" then
    self.y = self.parent.y + self.parent.h/2 + 15 - self.h/2
  else
    self.y = self.parent.y + self.parent.h/2 - self.h/2
  end
  self.relativex = self.x - self.parent.x
  self.relativey = self.y - self.parent.y
end

function PANEL:SetPos( x, y )
    self.x = math.floor( self.parent.x + x )
    self.y = math.floor( self.parent.y + y )

    self.relativex = self.x - self.parent.x
    self.relativey = self.y - self.parent.y
end

function PANEL:GetPos()
  return self.relativex, self.relativey
end

function PANEL:SetSize( w, h )
  self.w = w
  self.h = h
end

function PANEL:SizeToContent( bool )
  if bool and self.children then
    local bw = 0
    local bh = 0
    for k, v in pairs(self.children) do
      bw = math.max(bw, v.w)
      bh = math.max(bh, v.h)
    end

    self.w = bw
    self.h = bh
  end
end

function PANEL:SizeToHContent( bool )
  if bool == nil then bool = true end
  if bool and self.children then
    local bh = 0
    for k, v in pairs(self.children) do
      bh = math.max(bh, v.h)
    end

    self.h = bh
  end
end

function PANEL:SizeToWContent( bool )
  if bool == nil then bool = true end
  if bool and self.children then
    local bw = 0
    for k, v in pairs(self.children) do
      bw = math.max(bw, v.w)
    end

    self.w = bw
  end
end

function PANEL:GetSize()
  return self.w, self.h
end

function PANEL:SetColor( r, g, b, a ) -- Values in 255 :D
  a = a or 255
  self.color = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetColor()
  return self.color
end

function PANEL:SetVisible( bool )
  self.visible = bool
end

function PANEL:IsVisible()
  return self.visible
end

function PANEL:SetEnabled( bool )
  self.enabled = bool
end

function PANEL:IsEnabled()
  return self.enabled
end

function PANEL:IsHovered()
  return self.hovered
end

function PANEL:IsPressed()
  return self.pressed
end

function PANEL:OnRemove()
end

function PANEL:IsValid()
  return self.type and self.type ~= "None"
end

function PANEL:Remove()
  self:OnRemove()

  nis.active[self.id] = nil
  if self.parent.children then
    self.parent.children[self.id] = nil
  end
  for k, v in pairs( self.children ) do
    v:Remove()
  end
  for k in pairs(self) do self[k] = nil end
  function self:IsValid()
    return false
  end
end

function PANEL:Draw()
  if not self.visible then return end
  love.graphics.setColor( self.color )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end

return PANEL
