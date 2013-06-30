local Mind = require 'src.beings.minds.Mind'

local FollowerMind = class(..., Mind)

function FollowerMind:initialize(subject)
  Mind.initialize(self)
  self.subject = subject
end

function FollowerMind:update(senses, dt)
  self.wishes = {}
  if senses.sight[self.subject] then
    local subjectPos = senses.sight[self.subject]
    local tx, ty = subjectPos.x, subjectPos.y
    local dx, dy = senses.x-tx, senses.y-ty

    if dx >  2 then self.wishes.left  = true end
    if dx < -2 then self.wishes.right = true end
    if dy >  2 then self.wishes.up    = true end
    if dy < -2 then self.wishes.down  = true end
  end
end

return FollowerMind
