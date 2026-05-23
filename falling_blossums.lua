require "math"
local class = require "middleclass"

local FallingBlossums = class("FallingBlossums")


local images = {
    { resource = resource.load_image "img_petal_1.png", w = 91, h = 68 },
    { resource = resource.load_image "img_petal_2.png", w = 91, h = 71 },
    { resource = resource.load_image "img_petal_3.png", w = 85, h = 79 },
    { resource = resource.load_image "img_petal_4.png", w = 84, h = 75 },
}

function FallingBlossums:initialize(x, y, w, h)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.blossums = {}
    self:spawn_blossum()
    self.t = 0
end

function FallingBlossums:spawn_blossum()
    self.blossums[#self.blossums + 1] = {
        x0 = self.w * math.random(),
        x = 0,
        y = 0,
        w = 91 / 3,
        h = 68 / 3,
        phase = math.random() * 2 * math.pi,
        image = images[math.random(1, 4)].resource,
    }
end

function FallingBlossums:draw(dt)
    if math.random() < (1 / 30 * dt) then
        self:spawn_blossum()
    end

    for i, blossum in ipairs(self.blossums) do
        self:draw_blossum(blossum)
    end

    self:clear_fallen_blossums()

    self.t = self.t + dt
end

function FallingBlossums:draw_blossum(blossum)
    draw_image_xywh(blossum["image"], blossum.x, blossum.y, blossum.w, blossum.h)
    blossum.x = 100 * math.sin(2 * math.pi * 0.1 * self.t + blossum.phase) + blossum.x0
    blossum.y = blossum.y + math.cos(2 * math.pi * 0.1 * self.t + blossum.phase) ^ 2 + 0.5
end

function FallingBlossums:clear_fallen_blossums()
    filter_inplace(self.blossums, function(x) return not (x.y > self.h + 100) end)
end

return FallingBlossums
