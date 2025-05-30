--レベルアップ！
--Level Up!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_LV}
function s.costfilter(c,e,tp)
	if not c:IsSetCard(SET_LV) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
	return c.listed_names and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,c,e,tp)
end
function s.spfilter(c,class,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and class.listed_names and c:IsCode(table.unpack(class.listed_names))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local code=g:GetFirst():GetOriginalCode()
	Duel.SetTargetParam(code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local class=Duel.GetMetatable(code)
	if class==nil or class.listed_names==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	end
end