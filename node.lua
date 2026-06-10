gl.setup(1920, 1080)
require "open_source_patch"
require "resource_patch"
-- require("test_runner")()
local Heading = require "heading"
require "color_util"
require "json_util"
local Ticker = require "ticker"
local Clock = require "clock"
local offset = require "offset"
local json = require "json"
local TopicPlayer = require "topic_player"
local tw = require "tween"
local ServiceIndicator = require "service_indicator"
local FallingBlossums = require "falling_blossums"

local sidebar_bg = resource.load_image "img_sidebar_bg.png"
local main_bg = resource.load_image "img_main_bg.png"
local inset_bg = resource.load_image "img_inset_bg.png"
local inset_overlay = resource.load_image "img_inset_overlay.png"
local get_guidebook = resource.load_image "img_get_guidebook.png"
local ticker_bg = resource.load_image "img_ticker_bg.png"
local ticker_overlay = resource.load_image "img_ticker_overlay.png"

local ticker_height = 116
local ticker = Ticker:new(0, HEIGHT - ticker_height - 2, WIDTH, ticker_height - 2)
local clock = Clock:new(200, 96)
local service_indicator = ServiceIndicator()

local style = require "style"
local topic_main = TopicPlayer(1280, 964, style["main_style"])
local topic_sidebar = TopicPlayer(640, 964, style["sidebar_style"])
local topic_inset = TopicPlayer(400, 300, style["inset_style"])

util.data_mapper {
    ["clock/update"] = function(data)
        data = json.decode(data)
        clock:update(data.hh_mm, data.am_pm, data.month, data.date)
    end,
    ["guidebook/update"] = function(data)
        data = json.decode(data)
        service_indicator:update(data.updating, data.checks, data.desc)
    end,
}

json_watch("config.json", function(config)
    ticker:set_speed(config.ticker_speed)
    ticker:set_msgs_from_config(config)
    topic_sidebar:set_topics_from_config(config["sidebar_topic_player"])
    topic_main:set_topics_from_config(config["main_topic_player"])
    topic_inset:set_topics_from_config(config["inset_topic_player"])
end)

local t = 0

function node.render()
    dt = 1 / 60
    t = t + dt
    tw:update(dt)

    gl.clear(1, 1, 1, 1)

    offset(1280, 0, function()
        sidebar_bg:draw(0, 0, 640, 946)
        topic_sidebar:draw()
    end)

    main_bg:draw(0, 0, 1280, 964)

    offset(0, 0, function()
        topic_main:draw()
    end)

    ticker_bg:draw_xywh(0, 964, 1920, 116)
    ticker:draw()
    ticker_overlay:draw_xywh(0, 964, 1920, 116)

    get_guidebook:draw_xywh(1287, 740, 190, 209)

    offset(1444 + 56, 729 + 11, function()
        topic_inset:draw()
    end)

    offset(1710, 972, function()
        clock:draw()
    end)

    offset(10, 978, function()
        service_indicator:draw()
    end)
end
