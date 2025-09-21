---- [1] 스크립트 파일이 실행되는지 확인
--print("1.Start Script")

--local RunService = game:GetService("RunService")
--local Players = game:GetService("Players")

--local Camera = workspace.CurrentCamera
--Camera.CameraType = Enum.CameraType.Scriptable

--local localPlayer = Players.LocalPlayer
--local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

---- [2] 캐릭터를 성공적으로 찾았는지 확인
--if character then
    --print("2. Successed finding character: " .. character.Name)
--else
    --print("2.Failed finding character")
--end

---- 캐릭터 리스폰 처리
--local function onCharacterAdded(newCharacter)
    --character = newCharacter
    --print("New character spawned: " .. newCharacter.Name)
--end

--localPlayer.CharacterAdded:Connect(onCharacterAdded)

---- 디버그 카운터 추가
--local debugCounter = 0

---- 매 프레임 실행되는 RenderStepped
--RunService.RenderStepped:Connect(function()
    --debugCounter = debugCounter + 1
    
    ---- 5초마다 디버그 정보 출력 (약 300프레임마다)
    --if debugCounter % 300 == 1 then
        --print("3. RenderStepped running... Frame:", debugCounter)
    --end
    
    ---- 캐릭터가 존재하고, 게임 세계(Workspace) 안에 있는지 확인
    --if character and character.Parent then
        --local rootPart = character:FindFirstChild("HumanoidRootPart")
        --if rootPart then
            --if debugCounter % 300 == 1 then
                --print("4. HumanoidRootPart found at:", rootPart.Position)
                --print("5. Camera type:", Camera.CameraType)
            --end
            
            ---- [3] 카메라 위치 계산 및 적용 (lookAt 방식 사용)
            --local offset = Vector3.new(0, 5, 10)
            --local cameraPos = rootPart.Position + offset
            
            ---- CFrame.lookAt을 사용하여 캐릭터를 바라보도록 설정
            --Camera.CFrame = CFrame.lookAt(cameraPos, rootPart.Position)
            
            --if debugCounter % 300 == 1 then
                --print("6. Camera moved to:", Camera.CFrame.Position)
            --end
        --else
            --if debugCounter % 300 == 1 then
                --print("HumanoidRootPart not found in character:", character.Name)
            --end
        --end
    --else
        --if debugCounter % 300 == 1 then
            --print("4. Character lost or not in workspace")
        --end
        ---- 현재 캐릭터 상태 업데이트
        --character = localPlayer.Character
    --end
--end)	