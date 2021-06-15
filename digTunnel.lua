-- There must be free space around turtle so it can place chest and torch!

local constants = require("constants")
local shared = require("shared")
local digVein = require("digVein").digVein
local forceMove = require("forceMove")

function log(msg)
    local time = os.time()
    local formattedTime = textutils.formatTime(time, false)
    print("[" .. formattedTime .. "] " .. msg)
end

function err(msg)
    print("Error. " .. msg)
end

function dropAllDown()
    for i = 1, constants.LAST_FREE_SLOT do
        turtle.select(i)
        turtle.dropDown()
    end
end

function placeChestBackAndDrop()
    if turtle.getItemCount(constants.CHEST_SLOT) < 2 then
        return false
    end
    forceMove.up()
    forceMove.back()
    turtle.select(constants.CHEST_SLOT)
    if not turtle.placeDown() then
        return false
    end
    dropAllDown()
    turtle.forward()
    turtle.down()
    turtle.select(1)
    return true
end

function placeTorchRight()
    if turtle.getItemCount(constants.TORCH_SLOT) < 2 then
        return false
    end
    forceMove.up()
    turtle.turnRight()
    forceMove.forward()
    turtle.select(constants.TORCH_SLOT)
    turtle.placeDown()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.down()
    turtle.turnRight()
    return true
end


function digFor(distance)
    for i = 1, distance do
        digVein()
        forceMove.forward()
    end
end

function digLeft(width)
    turtle.turnLeft()
    digFor(width - 1)
    turtle.turnRight()
end

function digRight(width)
    turtle.turnRight()
    digFor(width - 1)
    turtle.turnLeft()
end

function digLayer(width, height)
    forceMove.forward()
    digRight(width)
    for i = 1, (height - 1) / 2 do
        forceMove.up()
        digLeft(width)
        forceMove.up()
        digRight(width)
    end
    if height % 2 == 0 then
        forceMove.up()
        digLeft(width)
    else
        turtle.turnLeft()
        for i = 1, width - 1 do
            forceMove.forward()
        end
        turtle.turnRight()
    end
    for i = 1, height - 1 do
        forceMove.down()
    end
end

function digTunnel(width, height, maxLayers)
    maxLayers = maxLayers or 1e10
    local layersN = 0
    local placedChestN = 0
    while layersN < maxLayers do
        if not shared.hasFuel() then
            err("Not enough fuel! Min level is " .. constants.MIN_FUEL)
            return false
        end
        if layersN % constants.TORCH_DISTANCE == 0 then
            if not placeTorchRight() then
                err("Not enough torches!")
                return false
            end
        end
        if not shared.hasFreeSpace() then 
            placedChestN = placedChestN + 1
            log("Placing chest and dropping items " .. placedChestN)
            if not placeChestBackAndDrop() then
                err("Cannot place chest")
                return false
            end
        end
        layersN = layersN + 1
        log("Digging layer " .. layersN)
        digLayer(width, height)
    end
end

function main()
    log("Refueling")
    turtle.select(1)
    turtle.refuel()
    log("Starting diggin tunnel")
    digTunnel(3, 3)
end

main()
