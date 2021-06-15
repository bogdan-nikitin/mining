local digConfig = require("/mining/digConfig")
local shared = require("/mining/shared")
local forceMove = require("/mining/forceMove")


function isSuitable(data, config)
    config = config or digConfig
    for _, name in ipairs(config.names) do
        if data.name == name then
            return true
        end
    end
    for _, tag in ipairs(config.tags) do
        if data.tags[tag] then
            return true
        end
    end
    return false
end


function digVein(config)
    config = config or digConfig
    if not (shared.hasFreeSpace() and shared.hasFuel()) then
        return
    end
    local success, data
    -- Sides
    for i = 1, 4 do
        success, data = turtle.inspect()
        if success and isSuitable(data, config) then
            forceMove.forward()
            digVein(config)
            forceMove.back()
        end
        turtle.turnLeft()
    end
    -- Up
    success, data = turtle.inspectUp()
    if success and isSuitable(data, config) then
        forceMove.up()
        digVein(config)
        forceMove.down()
    end
    -- Down
    success, data = turtle.inspectDown()
    if success and isSuitable(data, config) then
        forceMove.down()
        digVein(config)
        forceMove.up()
    end
end

return {isSuitable = isSuitable, digVein = digVein}
