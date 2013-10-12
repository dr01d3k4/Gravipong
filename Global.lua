do
  local oldType = type
  type = function(v)
    if oldType(v) == "table" and v.__class then
      return v.__class
    else
      return oldType(v)
    end
  end
  typeName = function(v)
    if oldType(v) == "table" and v.__class and v.__class.__name then
      return v.__class.__name
    else
      return oldType(v)
    end
  end
end
