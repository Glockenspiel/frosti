modifier_center_camera_lua = class ({})

function modifier_center_camera_lua:OnCreated()
	local target = self:GetParent()
	if IsServer() and target:IsHero() then
		local playerID = target:GetPlayerOwnerID()
		if playerID ~= nil then
			PlayerResource:SetCameraTarget(playerID, target)
		end	
	end
end

function modifier_center_camera_lua:OnDestroy()
	if IsServer() then
		local target = self:GetParent()
		local playerID = target:GetPlayerID()
		PlayerResource:SetCameraTarget(playerID, nil)
	end
end