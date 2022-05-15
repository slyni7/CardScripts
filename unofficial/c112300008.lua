--이리스 유마(분노의 해머스톨)
function c112300008.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,112300008)
	e3:SetCost(c112300008.cost)
	e3:SetTarget(c112300008.target)
	e3:SetOperation(c112300008.operation)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PSYCHO))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,1123000080)
	e4:SetCondition(c112300008.con)
	e4:SetTarget(c112300008.tg)
	e4:SetOperation(c112300008.op2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,1123000080)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCost(c112300008.cost2)
	e5:SetTarget(c112300008.tg2)
	e5:SetOperation(c112300008.op3)
	c:RegisterEffect(e5)
end
function c112300008.costfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemoveAsCost()
end
function c112300008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112300008.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c112300008.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c112300008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112300008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c112300008.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_PSYCHO)
end
function c112300008.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHander():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c112300008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c112300008.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c112300008.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
end
function c112300008.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsAbleToHand() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end