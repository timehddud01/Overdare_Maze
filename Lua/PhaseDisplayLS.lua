local ImageLabel = script.Parent


ImageLabel.AnchorPoint = Vector2.new(1, 0)
ImageLabel.Position    = UDim2.new(1, -30, 0, 30)


ImageLabel.Size = UDim2.new(0.2, 0, 0.2, 0)


local ar = Instance.new("UIAspectRatioConstraint")
ar.AspectRatio  = 1  --비율 유지, 가로/세로
ar.AspectType   = Enum.AspectType.FitWithinMaxSize
ar.DominantAxis = Enum.DominantAxis.Width
ar.Parent       = ImageLabel