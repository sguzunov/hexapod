setStepMode = function(stepVelocity, stepAmplitude, stepHeight, movementDirection, rotationMode, movementStrength)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepVelocity", stepVelocity)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepAmplitude", stepAmplitude)
    sim.setScriptSimulationParameter(sim.handle_tree, "stepHeight", stepHeight)
    sim.setScriptSimulationParameter(sim.handle_tree, "movementDirection", movementDirection)
    sim.setScriptSimulationParameter(sim.handle_tree, "rotationMode", rotationMode)
    sim.setScriptSimulationParameter(sim.handle_tree, "movementStrength", movementStrength)
end

function speedChange_callback(ui, id, newValue)
    newVelocity = newValue / 10
    walkingVel = newVelocity
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

rotateOnSpot = function(direction)
    setStepMode(walkingVel, maxWalkingStepSize * 0.5, stepHeight, direction, 1, 1)
end

rotateLeft = function()
    stopWalking()
    rotateOnSpot(currentDirection + 90)
    sim.wait(4.35)
end

rotateRight = function()
    stopWalking()
    rotateOnSpot(currentDirection - 90)
    sim.wait(4.35)
end

moveInDiraction = function()
    setStepMode(walkingVel, maxWalkingStepSize, stepHeight, currentDirection, 0, 1)
end

stopWalking = function()
    setStepMode(walkingVel, maxWalkingStepSize, stepHeight, currentDirection, 0, 0)
end

function on_turnleft_click()
    rotLeft = true
end

function on_turnright_click()
    rotRight = true
end

createUi = function(speedMinValue, speedMaxValue, initialSpeedValue)
    sliderId = 1

    uiXml =
        '<ui title="Hexapod" closeable="false" resizeable="false" activate="false">' ..
        [[
            <label text="Walking velocity" style="* {margin-left: 300px;}"/>
            <hslider minimum="1" maximum="20" onchange="speedChange_callback" id="1"/>

            <button text="Turn Left" on-click="on_turnleft_click" id="2"></button>
            <button text="Turn Right" on-click="on_turnright_click" id="3"></button>
        </ui>
        ]]

    ui = simUI.create(uiXml)
    simUI.setSliderValue(ui, sliderId, initialSpeedValue)
end

function sysCall_threadmain()
    rotating = false
    rotLeft = false
    rotRight = false

    speedMinValue = 1
    speedMaxValue = 20
    initialSpeedValue = 9

    createUi(speedMinValue, speedMaxValue, initialSpeedValue)

    timeWait = 10
    currentDirection = 90
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
    walkingVel = initialSpeedValue / 10

    while true do
        

        noseSensor = sim.getObjectHandle("hexapod_senseNose") -- Handle of the proximity sensor
        proximitySensorValue = sim.readProximitySensor(noseSensor)

        if (0 < proximitySensorValue) then
            stopWalking()

            sim.wait(4.35)

            if (rotLeft == true) then
                rotateLeft()
                rotLeft = false
            else
                if (rotRight == true) then
                    rotateRight()
                    rotRight = false
                end
            end
        else
            if (rotLeft == true) then
                rotateLeft()
                rotLeft = false
            else
                if (rotRight == true) then
                    rotateRight()
                    rotRight = false
                else
                    moveInDiraction()
                end
            end
        end
    end
end
