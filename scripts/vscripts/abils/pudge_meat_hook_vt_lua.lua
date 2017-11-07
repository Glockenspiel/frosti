pudge_meat_hook_vt_lua = class ({})

function pudge_meat_hook_vt_lua:OnSpellStart()
	print("used spell vector targeting")
	local point = self:GetCursorPosition()
	--local targetPt  = self:GetCursorTarget()
	print(point)
end

function pudge_meat_hook_vt_lua:OnAbilityPhaseStart()
	print("ability phase start")
	local point = self:GetCursorPosition()
	print(point)
end