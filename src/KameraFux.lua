-- KameraFux 0.2.0.0
-- Adds a world-space offset to the active exterior VehicleCamera.

KameraFux = {}
KameraFux.MOD_NAME = g_currentModName or "FS25_KameraFux"
KameraFux.MOVE_SPEED = 12 -- metres per second while a key is held
KameraFux.MAX_FRAME_TIME = 100 -- avoid jumps after pauses/loading

local function getExteriorCamera(camera)
    if camera == nil or camera.cameraNode == nil or camera.isInside then
        return nil
    end

    camera.kameraFuxOffsetX = camera.kameraFuxOffsetX or 0
    camera.kameraFuxOffsetY = camera.kameraFuxOffsetY or 0
    camera.kameraFuxOffsetZ = camera.kameraFuxOffsetZ or 0
    return camera
end

local function addWorldOffset(camera, x, y, z)
    camera.kameraFuxOffsetX = camera.kameraFuxOffsetX + x
    camera.kameraFuxOffsetY = camera.kameraFuxOffsetY + y
    camera.kameraFuxOffsetZ = camera.kameraFuxOffsetZ + z
end

local function movementDistance(inputValue)
    local dt = math.min(g_currentDt or 16, KameraFux.MAX_FRAME_TIME)
    return inputValue * KameraFux.MOVE_SPEED * dt * 0.001
end

local function reportFirstInput(camera)
    if not camera.kameraFuxInputReported then
        camera.kameraFuxInputReported = true
        Logging.info("[%s] Numeric keypad input reached exterior camera", KameraFux.MOD_NAME)
    end
end

function KameraFux.onMoveForwardBack(camera, _, inputValue)
    camera = getExteriorCamera(camera)
    if camera == nil or inputValue == 0 then
        return
    end

    reportFirstInput(camera)

    -- A GIANTS camera looks along its negative local Z axis. Keep movement
    -- horizontal so looking down does not turn "forward" into "down".
    local x, _, z = localDirectionToWorld(camera.cameraNode, 0, 0, -1)
    local length = math.sqrt(x * x + z * z)
    if length > 0.0001 then
        local distance = movementDistance(inputValue)
        addWorldOffset(camera, x / length * distance, 0, z / length * distance)
    end
end

function KameraFux.onMoveLeftRight(camera, _, inputValue)
    camera = getExteriorCamera(camera)
    if camera == nil or inputValue == 0 then
        return
    end

    reportFirstInput(camera)

    local x, _, z = localDirectionToWorld(camera.cameraNode, 1, 0, 0)
    local length = math.sqrt(x * x + z * z)
    if length > 0.0001 then
        local distance = movementDistance(inputValue)
        addWorldOffset(camera, x / length * distance, 0, z / length * distance)
    end
end

function KameraFux.onMoveUpDown(camera, _, inputValue)
    camera = getExteriorCamera(camera)
    if camera ~= nil and inputValue ~= 0 then
        reportFirstInput(camera)
        addWorldOffset(camera, 0, movementDistance(inputValue), 0)
    end
end

function KameraFux.onReset(camera, _, inputValue)
    if inputValue <= 0 then
        return
    end

    camera = getExteriorCamera(camera)
    if camera ~= nil then
        reportFirstInput(camera)
        camera.kameraFuxOffsetX = 0
        camera.kameraFuxOffsetY = 0
        camera.kameraFuxOffsetZ = 0
    end
end

local function registerCameraActions(camera)
    local function addAction(inputAction, callback)
        local success, actionEventId = g_inputBinding:registerActionEvent(
            inputAction,
            camera,
            callback,
            false,
            false,
            true,
            true,
            nil
        )

        if success and actionEventId ~= nil then
            g_inputBinding:setActionEventTextVisibility(actionEventId, false)
        end
    end

    g_inputBinding:beginActionEventsModification(Vehicle.INPUT_CONTEXT_NAME)
    addAction(InputAction.KameraFuxMoveForwardBack, KameraFux.onMoveForwardBack)
    addAction(InputAction.KameraFuxMoveLeftRight, KameraFux.onMoveLeftRight)
    addAction(InputAction.KameraFuxMoveUpDown, KameraFux.onMoveUpDown)
    addAction(InputAction.KameraFuxReset, KameraFux.onReset)
    g_inputBinding:endActionEventsModification()

    if not camera.kameraFuxRegistrationReported then
        camera.kameraFuxRegistrationReported = true
        Logging.info(
            "[%s] Numeric keypad actions registered for %s camera",
            KameraFux.MOD_NAME,
            camera.isInside and "interior" or "exterior"
        )
    end
end

-- The normal camera update runs first. We then add our world-space displacement
-- to the calculated camera position, preserving the game's mouse look and zoom.
VehicleCamera.update = Utils.appendedFunction(VehicleCamera.update, function(camera, _)
    if camera.isInside or camera.cameraNode == nil then
        return
    end

    local xOffset = camera.kameraFuxOffsetX or 0
    local yOffset = camera.kameraFuxOffsetY or 0
    local zOffset = camera.kameraFuxOffsetZ or 0

    if xOffset ~= 0 or yOffset ~= 0 or zOffset ~= 0 then
        local x, y, z = getWorldTranslation(camera.cameraNode)
        setWorldTranslation(camera.cameraNode, x + xOffset, y + yOffset, z + zOffset)
    end
end)

VehicleCamera.onActivate = Utils.appendedFunction(VehicleCamera.onActivate, registerCameraActions)

Logging.info("[%s] KameraFux 0.2.0.0 loaded", KameraFux.MOD_NAME)
