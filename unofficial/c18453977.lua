--버닝 브레이브
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTR("M","M")
	e2:SetValue(500)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","F")
	e3:SetCode(EFFECT_UPDATE_BRAVE)
	e3:SetTR("M","M")
	e3:SetValue(500)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCustomType,CUSTOMTYPE_BRAVE))
	c:RegisterEffect(e3)
end