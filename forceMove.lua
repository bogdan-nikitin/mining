local forceMove = {}


function forceMove.forward()
    while not turtle.forward() do
        turtle.dig()
    end
end

function forceMove.back()
    if turtle.back() then
        return
    end
    turtle.turnLeft()
    turtle.turnLeft()
    forceMove.forward()
    turtle.turnLeft()
    turtle.turnLeft()
end

function forceMove.up()
    while not turtle.up() do
        turtle.digUp()
    end
end

function forceMove.down()
    while not turtle.down() do
        turtle.digDown()
    end
end

return forceMove
