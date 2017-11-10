jump_lua = class({})
local targetPos
local diff
local totalDist
local totalTime=0
local startingPt
local maxTime = 0.4
local interval = 0.03
local z = 350

function jump_lua:OnSpellStart()
	local caster = self:GetCaster()
	startingPt = caster:GetAbsOrigin()
	diff = targetPos - caster:GetAbsOrigin()
	totalDist = diff:Length2D()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 1.5)
	self:SetContextThink("JumpThink", function() return self:JumpThink() end, 0.03)
end


function jump_lua:SetJump(pos, height, jumpTime)
	targetPos = pos
	z = height
	maxTime = jumpTime
end

--jump takes high prioirty when moving the caster
function jump_lua:JumpThink()
	totalTime = totalTime + interval
	local caster = self:GetCaster()
	
	--local totalDist = diff:Length2D()
	local percent = totalTime/maxTime
	print("percent:" .. tostring(percent))
	local step = diff * Vector(percent,percent,percent)
	
	--calculate height z-axis for curve on jump
	local zWeight
	--value from 0-0.5
	if percent > 0.5 then
		zWeight = 0.5 - (percent-0.5) 
	else 
		zWeight = percent
	end
	step = step + Vector(0, 0, zWeight*z)
	
	local nextPos = startingPt + step
	caster:SetAbsOrigin(nextPos)
	
	local vToTarget = targetPos - nextPos
	local distToTarget = vToTarget:Length2D()
	if distToTarget > 50 and totalTime < 1 then
		return interval
	end
	
	--reset values
	caster:RemoveGesture(ACT_DOTA_FLAIL)
	caster:Stop()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	totalTime = 0
	return
end