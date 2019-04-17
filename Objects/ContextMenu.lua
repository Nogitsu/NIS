local type, parent = ...
parent = parent or { x = 0, y = 0, type = "None", layer = -1 }

local DERIVED = {
  parent = parent,
  type = type,
  options = {},
  unit = 20,
  textColor = { 1, 1, 1 },
  textHoverColor = { 0, 0, 0 },
  HoverColor = { 1, 1, 1 },
  noresize = true,
  font = love.graphics.newFont( "/nis/Resources/Fonts/disposabledroid-bb.regular.ttf", 20 ),
}
local PANEL = DerivePanel( "Panel", DERIVED )

function PANEL:AddOption( text, pos )
  pos = pos or #self.options + 1
  self.options[pos] = {
    separator = false,
    label = love.graphics.newText( self.font, text ),
    hovered = false,
    DoClick = function() end
  }
  self.w = math.max(self.w, self.options[pos].label:getWidth())
  self.h = self:GetOptionsNum() * self.unit
  return self.options[pos]
end

function PANEL:AddSeparator( pos )
  pos = pos or #self.options + 1
  self.options[pos] = { separator = true }
end

function PANEL:SetCreator(panel)
  self.creator = panel
  self:SetPos( panel.x, panel.y+panel.h-1 )
end

function PANEL:SetTextColor( r, g, b, a )
  a = a or 255
  self.textColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:SetHoverTextColor( r, g, b, a )
  a = a or 255
  self.textHoverColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:SetHoverColor( r, g, b, a )
  a = a or 255
  self.HoverColor = { r/255, g/255, b/255, a/255 }
end

function PANEL:GetOptionsNum()
  local count = 0
  for _ in pairs(self.options) do count = count + 1 end
  return count
end

function PANEL:GetHoveredOption()
  for k, v in pairs(self.options) do
    if v.hovered then
      return v
    end
  end
  return nil
end

function PANEL:DoClick()
  if self:GetHoveredOption() then
    self:GetHoveredOption():DoClick()
  end
end

function PANEL:InternalThink( dt )
  local mx, my = love.mouse.getPosition()
  self.hovered = (mx > self.x and mx < self.x+self.w) and (my > self.y and my < self.y+self.h)
  for k, v in pairs(self.options) do
    if not v.separator then
      v.hovered = (mx > self.x and mx < self.x+self.w) and (my > self.y+(k-1)*self.unit and my < self.y+(k)*self.unit)
    end
  end

  self:Think( dt )

  if not (self.hovered or self.creator.hovered) then
    self:Remove()
  end
end

function PANEL:Draw()
  if not self.visible then return end

  for k, v in pairs(self.options) do
    k = k-1
    if v.separator then
      love.graphics.setColor( self.color )
      love.graphics.rectangle( "fill", self.x, self.y + k*self.unit, self.w, self.unit )
      love.graphics.setColor( self.textColor )
      love.graphics.rectangle( "fill", self.x+5, self.y + k*self.unit + self.unit/2-1, self.w-10, 2 )
    else
      if v.hovered then
        love.graphics.setColor( self.HoverColor )
      else
        love.graphics.setColor( self.color )
      end
      love.graphics.rectangle( "fill", self.x, self.y + k*self.unit, self.w, self.unit )
      if v.hovered then
        love.graphics.setColor( self.textHoverColor )
      else
        love.graphics.setColor( self.textColor )
      end
      love.graphics.draw( v.label, math.floor(self.x + 5), math.floor(self.y + k*self.unit) )
    end
  end
end

return PANEL
