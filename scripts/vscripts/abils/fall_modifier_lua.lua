fall_modifier_lua = class({})

function fall_modifier_lua:OnCreated(kv)
	print("fall_modifier created")
end

function fall_modifier_lua:OnRefresh()
	print("fall_modifier refreshed")
end