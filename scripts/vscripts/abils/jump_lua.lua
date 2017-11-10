jump_lua = class({})
local targetPos
local diff
local totalDist
local caster
local totalTime=0
local startingPt

function jump_lua:OnSpellStart()
	local caster = self:GetCaster()
	print("spell cast")
	print(targetPos)
	startingPt = caster:GetAbsOrigin()
	diff = targetPos - caster:GetAbsOrigin()
	totalDist = diff:Length2D()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	self:SetContextThink("JumpThink", function() return self:JumpThink() end, 0.03)
end


function jump_lua:SetTarget(pos)
	targetPos = pos
end

function jump_lua:JumpThink()
	local interval = 0.03
	local maxTime = 0.4
	local z = 350
	totalTime = totalTime + interval
	local unit = self:GetCaster()
	
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
	print("zWeigth:" .. tostring(zWeight))
	step = step + Vector(0, 0, zWeight*z)
	
	local nextPos = startingPt + step
	unit:SetAbsOrigin(nextPos)
	
	local vToTarget = targetPos - nextPos
	local distToTarget = vToTarget:Length2D()
	if distToTarget > 50 and totalTime < 1 then
		return interval
	end
	
	unit:Stop()
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	totalTime = 0
	return
end