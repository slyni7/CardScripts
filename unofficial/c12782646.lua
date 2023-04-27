--싱크로스의 야화 린
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0xad1),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tar3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tfil1(c)
	return c:IsSetCard(0xad1) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	aux.ToHandOrElse(tc,tp)
end
function s.cfil3(c,tp)
	local atk=c:GetAttack()
	return atk>=0 and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(s.tfil3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
			,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,atk)
end
function s.tfil3(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfil3,tp,LOCATION_EXTRA,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil3,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local atk=g:GetFirst():GetAttack()
	e:SetLabel(atk)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.tfil3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
		,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfil3,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
		,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,e:GetLabel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local rg=g:Select(tp,1,1,nil)
	if #rg>0 then
		Duel.HintSelection(rg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
