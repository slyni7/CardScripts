function Auxiliary.PassTurnOperation1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if ep==turnp and (not re or e:GetCode()==EVENT_CHAINING or e:GetCode()==EVENT_SPSUMMON_SUCCESS) then
		if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
			if eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
				or eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_ADVANCE)
				or re:IsHasType(EFFECT_TYPE_ACTIONS) then
				return
			end
		end
		local a=Duel.GetAttacker()
		if not a then
			Duel.PassTurn()
			Duel.Draw(1-turnp,1,REASON_RULE)
			Duel.ProcessIdleCommand(1-turnp)
		else
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(turnp)
			e1:SetOperation(Auxiliary.PassTurnOperation2)
			Duel.RegisterEffect(e1,0)
			local e2=e1:Clone()
			e2:SetCode(EVENT_DAMAGE_STEP_END)
			Duel.RegisterEffect(e2,0)
		end
	end
end
function Auxiliary.PassTurnOperation2(e,tp,eg,ep,ev,re,r,rp)
	local turnp=e:GetLabel()
	local a=Duel.GetAttacker()
	if turnp==Duel.GetTurnPlayer() and a==nil then
		e:Reset()
		Duel.PassTurn()
		Duel.Draw(1-turnp,1,REASON_RULE)
		Duel.ProcessIdleCommand(1-turnp)
	end
end

local ge1=Effect.GlobalEffect()
ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
ge1:SetCode(EVENT_SUMMON_SUCCESS)
ge1:SetOperation(Auxiliary.PassTurnOperation1)
Duel.RegisterEffect(ge1,0)
local ge2=ge1:Clone()
ge2:SetCode(EVENT_MSET)
Duel.RegisterEffect(ge2,0)
local ge3=ge1:Clone()
ge3:SetCode(EVENT_SSET)
Duel.RegisterEffect(ge3,0)
local ge4=ge1:Clone()
ge4:SetCode(EVENT_CHAINING)
Duel.RegisterEffect(ge4,0)
local ge5=ge1:Clone()
ge5:SetCode(EVENT_ATTACK_ANNOUNCE)
Duel.RegisterEffect(ge5,0)
local ge6=ge1:Clone()
ge6:SetCode(EVENT_SPSUMMON_SUCCESS)
Duel.RegisterEffect(ge6,0)