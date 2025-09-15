-- Roblox 서비스를 변수로 가져오기
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- 로컬 플레이어와 카메라 객체를 변수에 저장
local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 스크립트가 시작될 때 캐릭터를 즉시 가져오거나, 없다면 생성될 때까지 기다림
local Character = player.Character or player.CharacterAdded:Wait()

-- 플레이어가 죽었다가 부활할 경우를 대비해 캐릭터 변수를 업데이트
player.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
end)

-- 카메라 렌더링은 매 프레임 실행되어야 하므로 RenderStepped에 연결
RunService.RenderStepped:Connect(function()
	-- 캐릭터와 HumanoidRootPart가 존재하는지 항상 확인 (오류 방지)
	if Character and Character:FindFirstChild("HumanoidRootPart") then
		
		-- 💡 여기에서 카메라 위치를 원하는 대로 조절하세요!
		-- Vector3.new(X, Y, Z)
		-- X: 좌우 (+: 오른쪽, -: 왼쪽)
		-- Y: 상하 (+: 위, -: 아래)
		-- Z: 앞뒤 (+: 뒤쪽, -: 앞쪽)
		local cameraOffset = Vector3.new(0, 10, 25)
		
		-- 캐릭터의 위치와 오프셋을 더해 최종 카메라 위치를 계산
		local rootPart = Character.HumanoidRootPart
		local cameraPosition = rootPart.Position + cameraOffset
		
		-- [핵심] 카메라가 계산된 위치(cameraPosition)에 있으면서,
		-- 항상 캐릭터의 중심(rootPart.Position)을 바라보도록 설정
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CFrame = CFrame.new(cameraPosition, rootPart.Position)
	end
end)