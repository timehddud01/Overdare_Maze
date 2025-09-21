-- 최종 완성 스크립트 (점프 감지 + 이탈 감지 모두 포함)

local soundZone = script.Parent
local floorSound = soundZone.FloorSound
local RunService = game:GetService("RunService")

-- 존 안에 있는 플레이어와 움직이는 플레이어 수를 관리
local playersInZone = {}
local movingPlayerCount = 0

print("Final Sound Script (Jump + Exit Detection). Started for:", soundZone.Name)

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
		humanoid = humanoid,
		isMoving = false,
		lastPosition = character.PrimaryPart.Position
	}

	-- 해당 플레이어의 움직임을 감지하는 별도의 코루틴 시작
	task.spawn(function()
		while playersInZone[player] do
			local playerData = playersInZone[player]
			if not playerData.character or not playerData.character.PrimaryPart or not playerData.humanoid then break end
			
			-- 캐릭터의 현재 상태(점프, 자유낙하 등)를 확인
			local state = playerData.humanoid:GetState()
			local isInTheAir = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)

			-- 현재 위치와 이전 위치를 비교하여 수평 움직임 감지
			local currentPosition = playerData.character.PrimaryPart.Position
			local distanceMoved = (currentPosition - playerData.lastPosition).Magnitude
			local isMovingHorizontally = distanceMoved > 0.05
			
			-- 최종 조건: 수평으로 움직이고 있으며, 공중에 떠 있지 않아야 함
			local canPlayFootsteps = isMovingHorizontally and not isInTheAir

			if canPlayFootsteps and not playerData.isMoving then
				playerData.isMoving = true
				movingPlayerCount = movingPlayerCount + 1
				updateSoundState()
			elseif (not canPlayFootsteps) and playerData.isMoving then
				playerData.isMoving = false
				movingPlayerCount = movingPlayerCount - 1
				updateSoundState()
			end

			playerData.lastPosition = currentPosition
			task.wait(0.1)
		end
	end)
end)

-- 매 프레임마다 존을 벗어난 플레이어가 있는지 확인
RunService.Heartbeat:Connect(function(dt)
	for player, data in pairs(playersInZone) do
		local character = player.Character
		if character and character.PrimaryPart then
			local rootPart = character.PrimaryPart
			local distance = (rootPart.Position - soundZone.Position).Magnitude
			local partSize = math.max(soundZone.Size.X, soundZone.Size.Z) / 2
			
			if distance > partSize + 5 then
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