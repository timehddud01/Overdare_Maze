-- 최종 스크립트: 'Sound_Zone'이라는 이름의 투명 파트 바로 아래에 넣으세요.

local soundZone = script.Parent
local floorSound = soundZone.FloorSound
local RunService = game:GetService("RunService")

-- 존 안에 있는 플레이어와 움직이는 플레이어 수를 관리
local playersInZone = {}
local movingPlayerCount = 0

print("Final Sound Script (Magnitude Fix). Started for:", soundZone.Name)

-- 사운드 재생 상태를 중앙에서 관리하는 함수
local function updateSoundState()
	if movingPlayerCount > 0 and not floorSound.IsPlaying then
		floorSound:Play()
	elseif movingPlayerCount <= 0 and floorSound.IsPlaying then
		movingPlayerCount = 0
		floorSound:Stop()
	end
end

-- 캐릭터가 사운드 존에 들어왔을 때
soundZone.Touched:Connect(function(hit)
	local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if not player or playersInZone[player] then return end

	local character = hit.Parent
	if not character.PrimaryPart then return end

	playersInZone[player] = {
		character = character,
		isMoving = false,
		lastPosition = character.PrimaryPart.Position
	}

	task.spawn(function()
		while playersInZone[player] do
			local playerData = playersInZone[player]
			if not playerData.character or not playerData.character.PrimaryPart then break end
			
			local currentPosition = playerData.character.PrimaryPart.Position
			-- [수정] MagnitudeSqr 대신 원래의 Magnitude 사용
			local distanceMoved = (currentPosition - playerData.lastPosition).Magnitude
			local isCurrentlyMoving = distanceMoved > 0.05

			if isCurrentlyMoving and not playerData.isMoving then
				playerData.isMoving = true
				movingPlayerCount = movingPlayerCount + 1
				updateSoundState()
			elseif not isCurrentlyMoving and playerData.isMoving then
				playerData.isMoving = false
				movingPlayerCount = movingPlayerCount - 1
				updateSoundState()
			end

			playerData.lastPosition = currentPosition
			task.wait(0.1)
		end
	end)
end)

local heartbeatTimer = 0
local HEARTBEAT_INTERVAL = 0.25

RunService.Heartbeat:Connect(function(dt)
	heartbeatTimer = heartbeatTimer + dt
	if heartbeatTimer < HEARTBEAT_INTERVAL then return end
	heartbeatTimer = 0

	for player, data in pairs(playersInZone) do
		local character = player.Character
		if character and character.PrimaryPart then
			local rootPart = character.PrimaryPart
			-- [수정] MagnitudeSqr 대신 원래의 Magnitude 사용
			local distance = (rootPart.Position - soundZone.Position).Magnitude
			local partRadius = math.max(soundZone.Size.X, soundZone.Size.Z) / 2
			
			if distance > partRadius + 5 then
				if data.isMoving then
					movingPlayerCount = movingPlayerCount - 1
				end
				playersInZone[player] = nil
				updateSoundState()
			end
		else
			if data.isMoving then
				movingPlayerCount = movingPlayerCount - 1
			end
			playersInZone[player] = nil
			updateSoundState()
		end
	end
end)