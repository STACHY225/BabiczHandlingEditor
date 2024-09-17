RegisterCommand("handling", function(source, args)
    -- if IsPlayerAceAllowed(source, "BabiczHandlingEditor") then
        TriggerClientEvent("BabiczHandlingEditor", source, args)
    -- end
end, true)