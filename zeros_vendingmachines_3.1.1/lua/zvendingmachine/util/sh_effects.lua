

zclib.NetEvent.AddDefinition("zvm_machine_output", {
    [1] = {
        type = "entity"
    }
}, function(received)
    local ent = received[1]
    if not IsValid(ent) then return end
    zclib.Animation.Play(ent, "output", 1)
    ent:EmitSound("zvm_output_product")
end)
