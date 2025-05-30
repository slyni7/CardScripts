--星遺物へ誘う悪夢
--World Legacy's Nightmare
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.mvtg)
	e3:SetOperation(s.mvop)
	c:RegisterEffect(e3)
end
s.listed_series={SET_KNIGHTMARE}
function s.efilter(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function s.mvfilter1(c)
	return c:IsFaceup() and c:IsSetCard(SET_KNIGHTMARE)
end
function s.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(SET_KNIGHTMARE) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(s.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function s.mvfilter3(c)
	return c:IsFaceup() and c:IsSetCard(SET_KNIGHTMARE) and c:GetSequence()<5
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	local b2=Duel.IsExistingMatchingCard(s.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else op=Duel.SelectOption(tp,aux.Stringid(id,2))+1 end
	e:SetLabel(op)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local g=Duel.SelectMatchingCard(tp,s.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 and not g:GetFirst():IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(g:GetFirst(),nseq)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g1=Duel.SelectMatchingCard(tp,s.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g2=Duel.SelectMatchingCard(tp,s.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
	end
end