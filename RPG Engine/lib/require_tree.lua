local function toFSPath(requirePath)
  return requirePath:gsub("%.", "/")
end

local function toRequirePath(fsPath)
  return fsPath:gsub('/','.')
end

local function noExtension(entry)
  return entry:gsub('%.lua$', '')
end

local lfs   = love.filesystem
local cache = {}


local require_tree
require_tree = function(requirePath)

  if not cache[requirePath] then
    local result = {}

    local fsPath = toFSPath(requirePath)
    local entries = lfs.enumerate(fsPath)

    for _,entry in ipairs(entries) do
      fsPath = toFSPath(requirePath .. '.' .. entry)
      if lfs.isDirectory(fsPath) then
        result[entry] = require_tree(toRequirePath(fsPath))
      else
        entry = noExtension(entry)
        result[entry] = require(toRequirePath(requirePath .. '/' .. entry))
      end
    end

    cache[requirePath] = result
  end

  return cache[requirePath]
end

return require_tree
