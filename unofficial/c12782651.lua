--종언룡 "버서커" 레이지
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetTarget(s.tar3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.cfil1(c)
	return c:IsAbleToGraveAsCost() and (c:IsCode(4538826)
		or c:IsCode(12782649)
		or c:IsCode(12782650)
		or c:IsCode(12782651)
		or c:IsCode(12782652)
		or c:IsCode(12782654)
		or c:IsCode(12782655)
		)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(s.otar11)
	Duel.RegisterEffect(e1,tp)
end
function s.otar11(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DRAGON)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then
		return #g>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.tfil3(c)
	return (c:IsCode(4538826)
		or c:IsCode(12782649)
		or c:IsCode(12782650)
		or c:IsCode(12782651)
		or c:IsCode(12782652)
		or c:IsCode(12782654)
		or c:IsCode(12782655)
		) and c:IsAbleToGrave()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil3,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tfil3,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end