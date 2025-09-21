local ImageLabel = script.Parent


ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
ImageLabel.Position    = UDim2.new(0.5, 0, 0, 20+60+10)


ImageLabel.Size = UDim2.new(0, 600, 0, 60)


local ar = Instance.new("UIAspectRatioConstraint")
ar.AspectRatio  = 600/60--비율 유지, 가로/세로
ar.AspectType   = Enum.AspectType.FitWithinMaxSize
ar.DominantAxis = Enum.DominantAxis.Width
ar.Parent       = ImageLabel