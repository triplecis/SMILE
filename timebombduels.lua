--[[ Timebomb Duels

Pathfinding + Teleport
Will run tests sometime

]]--

--[[ Path ]]--
local DESTINATION = Vector3.new(0, 0, 0) 

local path = _PathfindingService:CreatePath()
local waypoints
local nextWaypointIndex
local reachedConnection
local blockedConnection

local function followPath(destination)
	-- Clear old connections
	if reachedConnection then
		reachedConnection:Disconnect()
	end
	if blockedConnection then
		blockedConnection:Disconnect()
	end

	-- Compute path from where you are now
	local success, err = pcall(function()
		path:ComputeAsync(rootPart.Position, destination)
	end)

	if success and path.Status == Enum.PathStatus.Success then
		waypoints = path:GetWaypoints()
		nextWaypointIndex = 2  -- skip first (start) waypoint

		-- Re‑compute path if it gets blocked
		blockedConnection = path.Blocked:Connect(function(blockedIndex)
			if blockedIndex >= nextWaypointIndex then
				blockedConnection:Disconnect()
				followPath(destination)
			end
		end)

		-- Move to next waypoint when current one is reached
		reachedConnection = _LocalHumanoid.MoveToFinished:Connect(function(reached)
			if not reached or nextWaypointIndex >= #waypoints then
				if reachedConnection then
					reachedConnection:Disconnect()
				end
				if blockedConnection then
					blockedConnection:Disconnect()
				end
				return
			end

			nextWaypointIndex = nextWaypointIndex + 1
			_LocalHumanoid:MoveTo(waypoints[nextWaypointIndex].Position)
		end)

		_LocalHumanoid:MoveTo(waypoints[nextWaypointIndex].Position)
	else
		warn("Path not computed!", err)
	end
end

-- TEST: start following to DESTINATION when script runs
followPath(DESTINATION)