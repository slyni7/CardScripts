--シャイニング・アブソーブ
--Leeching the Light
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_ATTACK)
	if #g>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sc=g:GetFirst()
		local atk=tc:GetAttack()
		for sc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			e1:SetValue(atk)
			sc:RegisterEffect(e1)
		end
	end
end