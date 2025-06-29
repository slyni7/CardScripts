--No.54 反骨の闘士ライオンハート
Duel.LoadCardScript("c54366836.lua")
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	--ind
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_BOTH_BATTLE_DAMAGE)
	e3:SetCondition(function(e) return Duel.GetBattleDamage(e:GetHandlerPlayer())>0 end)
	c:RegisterEffect(e3)
	--If your LP would become 0 from battle damage, make your LP 100
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(54366836,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(function(e,tp) return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp) end)
	e4:SetCost(Cost.Detach(1))
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=54
function s.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep then
		Duel.ChangeBattleDamage(1-ep,ev,false)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.surop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(s.damopx)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	Duel.SetLP(tp,100,REASON_EFFECT)
end
