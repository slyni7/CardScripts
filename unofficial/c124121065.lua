--신벌의 대천사 발키리
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCondition(s.con4)
	e4:SetValue(s.val4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCondition(s.con4)
	e5:SetValue(s.val5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(Duel.IsMainPhase)
	e6:SetCost(s.cost6)
	e6:SetTarget(s.tar6)
	e6:SetOperation(s.op6)
	c:RegisterEffect(e6)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.clim1)
	else
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.clim1(e,rp,tp)
	return tp==rp
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.clim1)
	end
	c:ResetFlagEffect(id)
end
function s.con4(e)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,id-4)
end
function s.val4(e,te)
	return te:IsMonsterEffect() and te:GetOwnerPlayer()==1-e:GetHandlerPlayer()
end
function s.val5(e)
	local c=e:GetHandler()
	return c:GetAttack()*2
end
function s.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			or Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil))
			and Duel.CheckLPCost(tp,1000)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local ct=1
	if c:CheckRemoveOverlayCard(tp,1,REASON_COST) then
		ct=0
	end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,ct,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tfil6(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToRemove()
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil6,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfil6,tp,LOCATION_DECK,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,5,aux.dncheck,1,tp,HINTMSG_REMOVE,nil,nil,false)
	if sg and #sg>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end