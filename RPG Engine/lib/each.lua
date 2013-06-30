local Each = { static = {} }

local function clone(t)
  local result = {}
  for k,v in pairs(t) do result[k] = v end
  return result
end

local function add(klass, instance)
  if klass ~= Object then
    add(klass.super, instance)
    klass._instances = klass._instances or {}
    klass._instances[instance] = 1
  end
end

local function remove(klass, instance)
  if klass ~= Object then
    klass._instances[instance] = nil
    remove(klass.super, instance)
  end
end

local function each(collection, method, ...)
  for instance,_ in pairs(collection) do
    instance[method](instance, ...)
  end
end

-- public interface

function Each.static:each(method, ...)
  each(self._instances, method, ...)
end

function Each.static:safeEach(method, ...)
  each(clone(self._instances), method, ...)
end

Each.static.add    = add
Each.static.remove = remove

return Each
