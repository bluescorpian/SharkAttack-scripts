for _, descendent in pairs(workspace:GetDescendants()) do
    if descendent.Name == "Barrier" then
        descendent.CanCollide = false
    end
end