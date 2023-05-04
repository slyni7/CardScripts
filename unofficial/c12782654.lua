--종언룡의 부활
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.cfil1(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfil1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cfil1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tfil11(c)
	return c:IsAbleToHand() and (c:IsCode(4538826)
		or c:IsCode(12782649)
		or c:IsCode(12782650)
		or c:IsCode(12782651)
		or c:IsCode(12782652)
		or c:IsCode(12782655)
		)
end
function s.tfil12(c,e,tp)
	return c:IsAbleToHand() and (c:IsCode(4538826)
		or c:IsCode(12782649)
		or c:IsCode(12782650)
		or c:IsCode(12782651)
		or c:IsCode(12782652)
		or c:IsCode(82301904)
		) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsFaceup()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.tfil11,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.tfil12,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local b1=#g1>0
	local b2=#g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		return b1 or b2
	end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.tfil11,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.tfil12,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)>0 then
				local tc=g:GetFirst()
			end
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then
		return #g>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end