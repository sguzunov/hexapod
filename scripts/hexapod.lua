setStepMode = function(stepVelocity, stepAmplitude, stepHeight, movementDirection, rotationMode, movementStrength)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepVelocity", stepVelocity)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepAmplitude", stepAmplitude)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepHeight", stepHeight)
    sim.setScriptSimulationParameter(sim.handle_tree, "movementDirection", movementDirection)
    sim.setScriptSimulationParameter(sim.handle_tree, "rotationMode", rotationMode)
    sim.setScriptSimulationParameter(sim.handle_tree, "movementStrength", movementStrength)
end

liftBody = function(initialP, initialO, vel, accel)
    sim.moveToPosition(legBase, antBase, initialP, initialO, vel, accel)
end

turnLeft = function()
    currentDirection = currentDirection + 90
end

turnRight = function()
    currentDirection = currentDirection - 90
end

moveInDiraction = function()
    setStepMode(walkingVel, maxWalkingStepSize, stepHeight, currentDirection, 0, 1)
end

stopWalking = function()
    setStepMode(walkingVel, maxWalkingStepSize, stepHeight, currentDirection, 0, 0)
end

function sysCall_threadmain()
    timeWait = 10
    currentDirection = 0
    antBase = sim.getObjectHandle("hexa_base")
    legBase = sim.getObjectHandle("hexa_legBase")
    sizeFactor = sim.getObjectSizeFactor(antBase)

    vel = 0.05
    accel = 0.05
    initialP = {0, 0, 0}
    initialO = {0, 0, 0}

    -- Lift body
    initialP[3] = initialP[3] - 0.03 * sizeFactor
    liftBody(initialP, initialO, vel, accel)

    stepHeight = 0.02 * sizeFactor
    maxWalkingStepSize = 0.11 * sizeFactor
    walkingVel = 0.9

    -- Forward walk while keeping a fixed body posture:
    moveInDiraction()
    sim.wait(timeWait)

    while true do
        turnLeft()
        moveInDiraction()
        sim.wait(timeWait)
    end
end
