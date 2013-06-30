local Mind = require 'src.beings.minds.Mind'

local ScaredMind = class(..., Mind)

function ScaredMind:initialize(subject)
  Mind.initialize(self)
  self.subject = subject
end

function ScaredMind:update(senses, dt)
  self.wishes = {}
  if senses.sight[self.subject] then
    local subjectPos = senses.sight[self.subject]
    local tx, ty = subjectPos.x, subjectPos.y
    local dx, dy = senses.x-tx, senses.y-ty

    if dx > 0 then self.wishes.right  = true end
    if dx < 0 then self.wishes.left   = true end
    if dy > 0 then self.wishes.down   = true end
    if dy < 0 then self.wishes.up     = true end
  end
end

return ScaredMind
