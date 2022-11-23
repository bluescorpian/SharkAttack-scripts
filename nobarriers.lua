for _, parent in pairs(workspace:GetChildren()) do
    for _, child in pairs(parent:GetChildren()) do
        if child.Name == "Barrier" then
            child.CanCollide = false
        end
    end
end