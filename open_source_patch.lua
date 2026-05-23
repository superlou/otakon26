if sys.PLATFORM == "desktop" then
    print("Info-beamer is running open-source. Patching behavior!")

    local original_load_video = resource.load_video
    resource.load_video = function(opt)
        -- Desktop version only handles a single file argument, while RPi recommends
        -- using an option table instead (not the curly braces):
        local file = opt.file
        local looped = opt.looped or false

        local video = original_load_video(file)
        local fps = video:fps()
        local dt = 1 / 60

        return {
            frame_time = 0,
            playback_time = 0,

            draw = function(self, x1, y1, x2, y2, alpha)
                -- implement looping, advancing to next frame and then
                -- finally call the original :draw method
                if self.playback_time > self.frame_time then
                    local has_next_frame = video:next()
                    if has_next_frame then
                        self.frame_time = self.frame_time + 1 / fps
                    else
                        -- todo Do we have to manually dispose of videos?
                        -- video:dispose()
                        -- return
                    end
                end

                video:draw(x1, y1, x2, y2, alpha)
                self.playback_time = self.playback_time + dt
            end,
        }
    end
end
