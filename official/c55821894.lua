--アマゾネスの格闘戦士
--Amazoness Fighter
local s,id=GetID()
function s.initial_effect(c)
	--battle dam 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end