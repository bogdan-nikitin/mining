local constants = require("constants")

function hasFreeSpace()
    return turtle.getItemSpace(constants.LAST_FREE_SLOT) == 64
end

function hasFuel()
    return turtle.getFuelLevel() >= constants.MIN_FUEL
end

return { hasFreeSpace = hasFreeSpace, hasFuel = hasFuel }
