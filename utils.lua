local utils = {}

function utils.fusionTable(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        for k, v in pairs(b) do
          a[k] = v
        end
    end
    return a
end

local function unTable(t)
   if type(t) == 'table' then
      local s = '{\n'
      for k,v in pairs(t) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '     ['..k..'] = ' .. unTable(v) .. ',\n'
      end
      return s .. '} '
   else
      return tostring(t)
   end
end

function table.removeByValue( t, value )
  for k, v in pairs(t) do
    if v == value then
      t[k] = nil
    end
  end
  return t
end

function PrintTable(t)
  print( unTable(t) )
end

function CurTime()
  return os.clock()
end

return utils
