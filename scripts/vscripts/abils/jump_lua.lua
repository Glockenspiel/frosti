jump_lua = class{}
LinkLuaModifier( "modifier_jump_lua", "abils/modifier_jump_lua", LUA_MODIFIER_MOTION_NONE )


function jump_lua:OnSpellStart()
	local caster = self:GetCaster()
	self.startingPt = caster:GetAbsOrigin()
	self.diff = self.targetPos - caster:GetAbsOrigin()
	self.totalDist = self.diff:Length2D()
	self.interval = 0.03
	self.totalTime = 0
	caster:SetForwardVector(self.diff)
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 1.5)
	
	caster:AddNewModifier( self:GetCaster(), self, "modifier_jump_lua", { duration = self.maxTime } )
	self:SetContextThink("JumpThink", function() return self:JumpThink() end, 0.03)
end

--set parameters for this jump
function jump_lua:SetJump(pos, height, jumpTime)
	self.targetPos = pos
	self.z = height
	self.maxTime = jumpTime
end

--jump takes high prioirty when moving the caster
function jump_lua:JumpThink()
	self.totalTime = self.totalTime + self.interval
	local caster = self:GetCaster()
	
	local percent = self.totalTime/self.maxTime
	local step = self.diff * Vector(percent,percent,percent)
	
	--calculate height z-axis for curve on jump
	local zWeight
	--value from 0-0.5
	if percent > 0.5 then
		zWeight = 0.5 - (percent-0.5) 
	else 
		zWeight = percent
	end
	step = step + Vector(0, 0, zWeight*self.z)
	
	local nextPos = self.startingPt + step
	caster:SetAbsOrigin(nextPos)
	
	local vToTarget = self.targetPos - nextPos
	local distToTarget = vToTarget:Length2D()
	if distToTarget > 50 and self.totalTime < 1 then
		return self.interval
	end
	
	--reset values
	FindClearSpaceForUnit(caster, self.targetPos, true)
	caster:RemoveGesture(ACT_DOTA_FLAIL)
	caster:Stop()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	self.totalTime = 0
	return
end