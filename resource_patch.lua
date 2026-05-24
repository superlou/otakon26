local original_load_image = resource.load_image

resource.load_image = function(opt)
    local image = original_load_image(opt)

    return {
        draw = function(self, x1, y1, x2, y2, alpha)
            image:draw(x1, y1, x2, y2, alpha)
        end,

        draw_xywh = function(self, x, y, w, h, alpha, mirror_x)
            if mirror_x then
                image:draw(x + w, y, x, y + h)
            else
                image:draw(x, y, x + w, y + h, alpha)
            end
        end
    }
end
